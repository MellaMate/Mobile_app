import 'package:flutter/material.dart';
import '../../../../widgets/bottom_navigation.dart';
import '../../../../features/send/presentation/pages/send_page.dart';
import '../../../../features/recieve/presentation/pages/recieve_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 3; // History tab index

  // Mock data matching the design
  final List<Map<String, dynamic>> _transactions = [
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'pending'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'pending'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'completed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'expense', 'amount': '-1200.00 USD', 'status': 'failed'},
    {'date': '21/10/25', 'name': 'Adam Smith', 'type': 'income', 'amount': '-1200.00 USD', 'status': 'completed'},
  ];

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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                               BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.filter_list, color: Color(0xFF0FA71A), size: 20),
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
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: _transactions.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _transactions[index];
                          final isIncome = item['type'] == 'income';
                          final status = item['status'];
                          
                          Color statusColor;
                          IconData statusIcon;
                          if (status == 'completed') {
                            statusColor = const Color(0xFF0FA71A);
                            statusIcon = Icons.check_circle_outline;
                          } else if (status == 'pending') {
                            statusColor = Colors.orange;
                            statusIcon = Icons.access_time; // Using generic warning/pending icon look
                          } else {
                            statusColor = Colors.red;
                            statusIcon = Icons.cancel_outlined;
                          }

                          // Override for the sun icon in design (pending?)
                          if (status == 'pending') {
                             statusIcon = Icons.wb_sunny_outlined; // Trying to match design's sun/spinner
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white, // No borders/shadows in list per design, clean rows?
                              // Actually design has alternate stripes looks like just white rows.
                              // Let's keep it simple.
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item['date'],
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item['name'],
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
                                    item['amount'],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
                          label: const Text('Previous', style: TextStyle(color: Colors.black87)),
                        ),
                        Row(
                          children: [
                            _dot(true),
                            _dot(false),
                            _dot(false),
                          ],
                        ),
                         TextButton.icon(
                          onPressed: () {},
                           // reverse icon for next
                          icon: const SizedBox(), 
                          label: Row(
                            children: const [
                              Text('Next', style: TextStyle(color: Colors.black87)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black87), // Green maybe? Design uses black
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
