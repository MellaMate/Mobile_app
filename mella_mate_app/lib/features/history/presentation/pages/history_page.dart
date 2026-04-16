import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _loadHistory();
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
          (_filterStatus == 'Income' && item.direction == 'IN') ||
          (_filterStatus == 'Expense' && item.direction == 'OUT');

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

  @override
  Widget build(BuildContext context) {
    final paginatedItems = _paginatedTransactions;
    final totalPages = _totalPages;

    return Scaffold(
      backgroundColor: Colors.white,
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
                              hintText: 'Search for anything...',
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
                            const PopupMenuItem(value: 'Income', child: Text('Income')),
                            const PopupMenuItem(value: 'Expense', child: Text('Expense')),
                          ],
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _filterStatus != 'All' ? const Color(0xFF0FA71A).withOpacity(0.1) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: _filterStatus != 'All' ? const Color(0xFF0FA71A) : Colors.grey.shade300),
                              boxShadow: [
                                 BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
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
                                              color: isIncome ? const Color(0xFF0FA71A).withOpacity(0.1) : Colors.red.withOpacity(0.1),
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
                                            size: 20,
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
