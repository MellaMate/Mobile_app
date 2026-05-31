import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gal/gal.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';
import 'package:mella_mate_app/core/history_refresh_notifier.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 3;
  String _searchQuery = '';
  String _filterStatus = 'All';
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  void _onHistoryRefresh() {
    _loadHistory();
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    HistoryRefreshNotifier.instance.addListener(_onHistoryRefresh);
  }

  @override
  void dispose() {
    HistoryRefreshNotifier.instance.removeListener(_onHistoryRefresh);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await context.read<SendRepository>().getHistory();
      if (mounted) {
        setState(() {
          _transactions = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Transaction> get _filteredTransactions {
    return _transactions.where((item) {
      final matchesSearch = item.counterparty.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          item.hash.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _filterStatus == 'All' || 
          (_filterStatus == 'Deposits' && item.direction == 'IN') ||
          (_filterStatus == 'Withdrawals' && item.direction == 'OUT');

      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<Transaction> get _paginatedTransactions {
    final filtered = _filteredTransactions;
    final startIndex = _currentPage * _itemsPerPage;
    if (startIndex >= filtered.length) return [];
    
    final endIndex = (startIndex + _itemsPerPage < filtered.length) 
        ? startIndex + _itemsPerPage 
        : filtered.length;
    
    return filtered.sublist(startIndex, endIndex);
  }

  int get _totalPages {
    final filtered = _filteredTransactions;
    if (filtered.isEmpty) return 0;
    return (filtered.length / _itemsPerPage).ceil();
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    if (index == 0) {
       Navigator.of(context).pop();
    } else if (index == 1) {
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SendPage()));
    } else if (index == 2) {
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RecievePage()));
    }

    setState(() => _currentIndex = index);
  }

  String _truncateAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 5)}...${address.substring(address.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final paginatedItems = _paginatedTransactions;
    final totalPages = _totalPages;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    // Header
                    Column(
                      children: [
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0FA71A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Here's what's happening with your store today.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _currentPage = 0; // Reset pagination on search
                                });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for transactions',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color(0xFF0FA71A)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              _filterStatus = value;
                              _currentPage = 0;
                            });
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'All', child: Text('All')),
                            const PopupMenuItem(value: 'Deposits', child: Text('Deposits')),
                            const PopupMenuItem(value: 'Withdrawals', child: Text('Withdrawals')),
                          ],
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _filterStatus != 'All' ? const Color(0xFF0FA71A).withValues(alpha: 0.1) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: _filterStatus != 'All' ? const Color(0xFF0FA71A) : Colors.grey.shade300),
                              boxShadow: [
                                 BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.filter_list, color: const Color(0xFF0FA71A), size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Table Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 2, child: _headerText('Date')),
                        Expanded(flex: 3, child: _headerText('Counter Party')),
                        Expanded(flex: 1, child: SizedBox()), // Type icon column
                        Expanded(flex: 2, child: _headerText('Amount', align: TextAlign.right)),
                        Expanded(flex: 1, child: _headerText('Status', align: TextAlign.right)),
                        Expanded(flex: 1, child: _headerText('Exp', align: TextAlign.right)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 12),
                    // List
                    Expanded(
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : paginatedItems.isEmpty
                          ? const Center(child: Text('No transactions found'))
                          : ListView.separated(
                              itemCount: paginatedItems.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final item = paginatedItems[index];
                                final isIncome = item.direction == 'IN';
                                final status = item.status;
                                
                                Color statusColor;
                                IconData statusIcon;
                                if (status == 'completed') {
                                  statusColor = const Color(0xFF0FA71A);
                                  statusIcon = Icons.check_circle_outline;
                                } else if (status == 'pending') {
                                  statusColor = Colors.orange;
                                  statusIcon = Icons.wb_sunny_outlined;
                                } else {
                                  statusColor = Colors.red;
                                  statusIcon = Icons.cancel_outlined;
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          DateFormat('dd/MM/yy').format(item.createdAt),
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          item.counterparty.length > 10 ? '${item.counterparty.substring(0, 5)}...${item.counterparty.substring(item.counterparty.length-4)}' : item.counterparty,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: isIncome ? const Color(0xFF0FA71A).withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                              size: 14,
                                              color: isIncome ? const Color(0xFF0FA71A) : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${isIncome ? '' : '-'}${item.amount.toStringAsFixed(2)} ${item.currency}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            statusIcon,
                                            color: statusColor,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () => _showTransactionDetails(item),
                                            child: const Icon(
                                              Icons.open_in_new,
                                              color: Color(0xFF0FA71A),
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Pagination
                    if (totalPages > 1) 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _currentPage > 0 ? () {
                            setState(() {
                              _currentPage--;
                            });
                          } : null,
                          icon: Icon(Icons.arrow_back_ios, size: 14, color: _currentPage > 0 ? Colors.grey : Colors.grey.shade300),
                          label: Text('Previous', style: TextStyle(color: _currentPage > 0 ? Colors.black87 : Colors.grey.shade400)),
                        ),
                        // Dynamic dots
                        Row(
                          children: List.generate(totalPages > 5 ? 5 : totalPages, (index) {
                             // Simplified logic: just 0..4 or 0..totalPages
                             // If many pages, this logic is naive but sufficient for mock.
                             return _dot(index == _currentPage);
                          }),
                        ),
                         TextButton.icon(
                          onPressed: _currentPage < totalPages - 1 ? () {
                             setState(() {
                               _currentPage++;
                             });
                          } : null,
                           // reverse icon for next
                          icon: const SizedBox(), 
                          label: Row(
                            children: [
                              Text('Next', style: TextStyle(color: _currentPage < totalPages - 1 ? Colors.black87 : Colors.grey.shade400)),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 14, color: _currentPage < totalPages - 1 ? Colors.black87 : Colors.grey.shade300), 
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
             BottomNavigationCustom(
              currentIndex: _currentIndex,
              onTap: _onBottomNavTap,
            ),
          ],
        ),
      ),
    );
  }


  void _showTransactionDetails(Transaction tx) {
    final isIncome = tx.direction == 'IN';
    final accent = const Color(0xFF0FA71A);
    final GlobalKey boundaryKey = GlobalKey();

    final directionWord = isIncome ? 'credited to' : 'debited from';
    final counterpartyLabel = isIncome ? 'from' : 'to';
    final formattedDate = DateFormat('dd-MMM-yyyy • HH:mm').format(tx.createdAt);
    final displayHash = tx.hash.isNotEmpty ? tx.hash : tx.id;
    final shortHash = displayHash.length > 10 ? displayHash.substring(0, 10) : displayHash;
    final String message = "${tx.amount.toStringAsFixed(2)} ${tx.currency} $directionWord My Wallet $counterpartyLabel ${tx.counterparty.length > 15 ? _truncateAddress(tx.counterparty) : tx.counterparty} on $formattedDate with transaction ID: $shortHash...";

    AppModal.showSheet(
      context: context,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                // Top control bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Receipt',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share_outlined, color: Color(0xFF0FA71A)),
                          onPressed: () => _downloadReceipt(boundaryKey, displayHash, isShare: true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_outlined, color: Color(0xFF0FA71A)),
                          onPressed: () => _downloadReceipt(boundaryKey, displayHash),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Receipt card wrapped in RepaintBoundary
                RepaintBoundary(
                  key: boundaryKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Green Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0FA71A),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thank You!',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tx.status.toUpperCase(),
                                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Body
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Message summary
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // QR Code
                              Center(
                                child: QrImageView(
                                  data: 'https://stellar.expert/explorer/testnet/tx/${tx.hash}',
                                  version: QrVersions.auto,
                                  size: 160.0,
                                  eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: Color(0xFF0FA71A),
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Scan to verify on Stellar Expert',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 24),
                              const Divider(height: 1),
                              const SizedBox(height: 20),

                              // Footer branding
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.green.shade50,
                                    child: const Icon(Icons.account_balance_wallet, color: Color(0xFF0FA71A), size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'MellaMate Wallet',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        'Secure & Instant Payments',
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Close Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadReceipt(GlobalKey boundaryKey, String txHash, {bool isShare = false}) async {
    AppModal.showDialog(
      context: context,
      barrierDismissible: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(color: Color(0xFF0FA71A)),
          SizedBox(height: 16),
          Text('Preparing receipt...', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final RenderRepaintBoundary? boundary =
          boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("Render object not found");

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception("Failed to convert image to bytes");

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final safeHash = txHash.length > 8 ? txHash.substring(0, 8) : (txHash.isEmpty ? 'tx' : txHash);
      final file = await File('${tempDir.path}/receipt_$safeHash.png').create();
      await file.writeAsBytes(pngBytes);

      if (mounted) Navigator.pop(context);

      if (isShare) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: 'MellaMate Transaction Receipt - Hash: $txHash',
          ),
        );
      } else {
        await Gal.putImage(file.path);
        if (mounted) {
          AppModal.showDialog(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0FA71A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF0FA71A), size: 56),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Downloaded!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your receipt has been saved to your gallery. You can find it in your Photos app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0FA71A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Great!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppModal.showMessage(
          context: context,
          title: 'Download failed',
          message: 'Failed to download receipt: $e',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          actionText: 'OK',
        );
      }
    }
  }


  Widget _headerText(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0FA71A) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
