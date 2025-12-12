import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/history/presentation/pages/history_page.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

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
                            CircleAvatar(
                              radius: 26, // Slightly larger avatar
                              backgroundImage: AssetImage(
                                'assets/images/profile.jpeg',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Welcome Back, Gustavo',
                                      style: TextStyle(
                                        fontSize: 22, // 16 -> 18
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '👋',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Here's what's happening with your store today.",
                                  style: TextStyle(
                                    fontSize: 14, // 12 -> 13
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.black,
                            size: 24, // 20 -> 24
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r"$240,399",
                                    style: TextStyle(
                                      fontSize: 32, // 28 -> 32
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 14, // 12 -> 14
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'USD',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14, // 12 -> 14
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          // Dotted line or Divider
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.constrainWidth() / 10).floor(),
                                  (index) => SizedBox(
                                    width: 5,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Info Rows
                          _buildCardInfoRow(
                            icon: Icons.wifi,
                            label: 'Network Status',
                            value: 'Online',
                            valueColor: accent,
                          ),
                          const SizedBox(height: 16),
                          _buildCardInfoRow(
                            icon: Icons.local_gas_station_outlined,
                            label: 'Base Fee',
                            value: '100 Stroop',
                            valueColor: Colors.black,
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
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Wallet Address',
                                    style: TextStyle(
                                      fontSize: 14, // 12 -> 14
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'G43...J8F',
                                    style: TextStyle(
                                      fontSize: 14, // 12 -> 14
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.copy_outlined,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Recent Transaction',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // 18 -> 20
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Table Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
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
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14, // 10 -> 12
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        // Mock data generation
                        bool isIncome = index % 2 != 0;
                        int statusType =
                            index % 3; // 0 success, 1 pending, 2 failed

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "21/10/25",
                                  style: TextStyle(
                                    fontSize: 14, // 11 -> 13
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Adam Smith",
                                  style: TextStyle(
                                    fontSize: 14, // 11 -> 13
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      6,
                                    ), // Larger padding
                                    decoration: BoxDecoration(
                                      color: isIncome
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isIncome
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      size: 14, // 10 -> 12
                                      color: isIncome
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  isIncome ? "1200.00 USD" : "-1200.00 USD",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14, // 11 -> 13
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    statusType == 0
                                        ? Icons.check_circle_outline
                                        : (statusType == 1
                                              ? Icons.wb_sunny_outlined
                                              : Icons.highlight_off),
                                    size: 18, // 16 -> 18
                                    color: statusType == 0
                                        ? Colors.green
                                        : (statusType == 1
                                              ? Colors.orange
                                              : Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),

            BottomNavigationCustom(
              currentIndex: _currentIndex,
              onTap: (i) {
                setState(() => _currentIndex = i);
                if (i == 1) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SendPage()));
                } else if (i == 2) {
                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecievePage()));
                } else if (i == 3) {
                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryPage()));
                }
              },
            ),
          ],
        ),
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
}

// TODO: Implement dashboard page
