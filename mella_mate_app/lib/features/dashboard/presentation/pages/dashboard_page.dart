import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/history/presentation/pages/history_page.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';

import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';
import 'package:mella_mate_app/features/settings/presentation/pages/settings_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/providers/wallet_provider.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gal/gal.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';
import 'package:mella_mate_app/core/history_refresh_notifier.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  bool _isLoadingHistory = false;
  String _selectedCurrency = 'USDC';
  String _historyFilter = 'All';
  List<Transaction> _allHistory = [];

  void _onHistoryRefresh() {
    _loadHistory();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadWalletData();
      _loadHistory();
    });

    HistoryRefreshNotifier.instance.addListener(_onHistoryRefresh);
  }

  @override
  void dispose() {
    HistoryRefreshNotifier.instance.removeListener(_onHistoryRefresh);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final history = await context.read<SendRepository>().getHistory();
      if (mounted) {
        setState(() {
          _allHistory = history;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
      }
    }
  }

  List<Transaction> get _filteredHistory {
    List<Transaction> filtered = _allHistory;
    if (_historyFilter == 'Deposits') {
      filtered = _allHistory.where((tx) => tx.direction == 'IN').toList();
    } else if (_historyFilter == 'Withdrawals') {
      filtered = _allHistory.where((tx) => tx.direction == 'OUT').toList();
    }
    return filtered.take(5).toList();
  }

  String _truncateAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 5)}...${address.substring(address.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    // Brand color (Signature Green from Auth)
    final accent = const Color(0xFF0FA71A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                final username = auth.user?.username ?? 'U';
                                final initial = username.isNotEmpty
                                    ? username[0].toUpperCase()
                                    : 'U';
                                return CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.green.shade100,
                                  child: Text(
                                    initial,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '👋',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Here's what's happening with your wallet today.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Balance Card
                    Container(
                      padding: const EdgeInsets.all(24), // Increased padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.green.shade50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCurrency,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                    isDense: true,
                                    dropdownColor: Colors.white,
                                    items: <String>['USDC', 'ETB'].map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedCurrency = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Consumer<WalletProvider>(
                            builder: (context, walletProv, _) {
                              if (walletProv.isLoading) {
                                return const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              // Calculate balance from native balances to match website behavior
                              double sumAmount = 0.0;
                              for (var b in walletProv.balances) {
                                if (b.assetCode == 'USDC' || b.assetCode == 'USD') {
                                  sumAmount += double.tryParse(b.amount) ?? 0.0;
                                }
                              }
                              final displayAmount = sumAmount > 0 ? sumAmount.toString() : (walletProv.usdcBalance?.amount ?? "0.00");


                              double numericAmount =
                                  double.tryParse(displayAmount) ?? 0.0;
                              String suffix = 'USDC';

                              if (_selectedCurrency == 'ETB') {
                                suffix = 'ETB';
                                numericAmount *=
                                    156.12; // Matched to app exchange rate
                              }

                              String finalDisplayAmount =
                                  _selectedCurrency == 'USDC'
                                  ? numericAmount.toStringAsFixed(6)
                                  : numericAmount.toStringAsFixed(2);

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "$finalDisplayAmount $suffix",
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (_selectedCurrency == 'USDC')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '1 USD ≈ 156.12 ETB',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          '1 USD ≈ 129.25 KES',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Info Rows
                          _buildCardInfoRow(
                            icon: Icons.wifi,
                            label: 'Network Status',
                            value: 'Online',
                            valueColor: accent,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 18,
                                    color: Colors
                                        .redAccent
                                        .shade100, // Match visual
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Wallet Address',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Consumer<WalletProvider>(
                                builder: (context, walletProv, _) {
                                  final address =
                                      walletProv.wallet?.publicKey ??
                                      'Not available';
                                  return Row(
                                    children: [
                                      Text(
                                        _truncateAddress(address),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(text: address),
                                          );
                                          AppModal.showMessage(
                                            context: context,
                                            title: 'Copied',
                                            message: 'Address copied to clipboard.',
                                            icon: Icons.check_circle,
                                            iconColor: const Color(0xFF0FA71A),
                                            actionText: 'OK',
                                          );
                                        },
                                        child: const Icon(
                                          Icons.copy_outlined,
                                          size: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent Transactions Area inside a container to match visual grouping
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildFilterChip('All'),
                                      const SizedBox(width: 8),
                                      _buildFilterChip('Deposits'),
                                      const SizedBox(width: 8),
                                      _buildFilterChip('Withdrawals'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Table Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                              vertical: 8,
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: 14, // 10 -> 12
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Counter Party",
                                    style: TextStyle(
                                      fontSize: 14, // 10 -> 12
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Type",
                                    style: TextStyle(
                                      fontSize: 14, // 10 -> 12
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ), // Type icon column
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Amount",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14, // 10 -> 12
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Status",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Explorer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (_isLoadingHistory)
                            const Center(child: CircularProgressIndicator())
                          else if (_filteredHistory.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No transactions yet."),
                              ),
                            )
                          else
                            ListView.separated(
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _filteredHistory.length,
                              itemBuilder: (context, index) {
                                final tx = _filteredHistory[index];
                                final isIncome = tx.direction == 'IN';
                                final statusColor = tx.status == 'completed'
                                    ? Colors.green
                                    : (tx.status == 'pending'
                                          ? Colors.orange
                                          : Colors.red);

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          DateFormat(
                                            'dd/MM/yy',
                                          ).format(tx.createdAt),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          tx.counterparty.length > 10
                                              ? _truncateAddress(
                                                  tx.counterparty,
                                                )
                                              : tx.counterparty,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: isIncome
                                                  ? Colors.green.withValues(alpha: 
                                                      0.1,
                                                    )
                                                  : Colors.red.withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isIncome
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              size: 12,
                                              color: isIncome
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${isIncome ? '' : '-'}${tx.amount.toStringAsFixed(2)} ${tx.currency}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 
                                                0.1,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              tx.status == 'completed'
                                                  ? Icons.check
                                                  : (tx.status == 'pending'
                                                        ? Icons
                                                              .wb_sunny_outlined
                                                        : Icons.highlight_off),
                                              size: 14,
                                              color: statusColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () => _showTransactionDetails(tx),
                                            child: Icon(
                                              Icons.open_in_new,
                                              size: 18,
                                              color: accent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          if (_allHistory.length > 5) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                                  );
                                },
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomNavigationCustom(
              currentIndex: _currentIndex,
              onTap: (i) {
                if (i == 1) {
                  _showSendMenu();
                } else if (i == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RecievePage()),
                  );
                } else if (i == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  );
                } else {
                  setState(() => _currentIndex = i);
                }
              },
            ),
          ],
        ),
      ),
    );
  }





  void _showSendMenu() {
    AppModal.showSheet(
      context: context,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Funds',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Transfer USDC or send ETB to a mobile money account.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              radius: 24,
              child: const Icon(Icons.send_rounded, color: Colors.green),
            ),
            title: const Text(
              'Send USDC',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Transfer to another Stellar wallet'),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.black54,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SendPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              radius: 24,
              child: const Icon(Icons.phone_android, color: Colors.green),
            ),
            title: const Text(
              'Send ETB via M-Pesa',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Withdraw directly to mobile number'),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.black54,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SendPage(defaultCurrency: 'ETB'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
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
                
                // RepaintBoundary wrapping the actual receipt card
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
                        // Receipt Header
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
                        
                        // Receipt Body
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Message Description
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
                              
                              // Slogan/Footer
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

            // Bottom Close button
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

      final RenderRepaintBoundary? boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("Render object not found");
      }
      
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Failed to convert image to bytes");
      }
      
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
          message: 'Failed to share/download receipt: $e',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          actionText: 'OK',
        );
      }
    }
  }


  Widget _buildFilterChip(String label) {
    final isSelected = _historyFilter == label;
    final accent = const Color(0xFF0FA71A);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _historyFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accent : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? accent : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// TODO: Implement dashboard page
