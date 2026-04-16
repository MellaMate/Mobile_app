import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/history/presentation/pages/history_page.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/providers/wallet_provider.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  List<Transaction> _history = [];
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadWalletData();
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final history = await context.read<SendRepository>().getHistory();
      if (mounted) {
        setState(() {
          _history = history.take(5).toList(); // Show only last 5 on dashboard
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
      }
    }
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
                            const CircleAvatar(
                              radius: 26,
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
                                    Consumer<AuthProvider>(
                                      builder: (context, auth, _) => Text(
                                        'Welcome, ${auth.user?.username ?? 'User'}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
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
                                  "Your decentralized wallet is ready.",
                                  style: TextStyle(
                                    fontSize: 14,
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
                              Consumer<WalletProvider>(
                                builder: (context, walletProv, _) {
                                  if (walletProv.isLoading) {
                                    return const Text('Loading...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                                  }
                                  final amount = walletProv.usdcBalance?.amount ?? "0.0";
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "\$ $amount",
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Wallet Balance (USDC)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                              Consumer<WalletProvider>(
                                builder: (context, walletProv, _) {
                                  final address = walletProv.wallet?.publicKey ?? 'Not available';
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
                                          Clipboard.setData(ClipboardData(text: address));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Address copied to clipboard'), duration: Duration(seconds: 1)),
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

                    if (_isLoadingHistory)
                      const Center(child: CircularProgressIndicator())
                    else if (_history.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No transactions yet."),
                      ))
                    else
                      ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final tx = _history[index];
                          final isIncome = tx.direction == 'IN';
                          final statusColor = tx.status == 'completed' ? Colors.green : (tx.status == 'pending' ? Colors.orange : Colors.red);

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('dd/MM/yy').format(tx.createdAt),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    tx.counterparty.length > 10 ? _truncateAddress(tx.counterparty) : tx.counterparty,
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
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
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
                                  flex: 3,
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
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      tx.status == 'completed'
                                          ? Icons.check_circle_outline
                                          : (tx.status == 'pending'
                                                ? Icons.wb_sunny_outlined
                                                : Icons.highlight_off),
                                      size: 18,
                                      color: statusColor,
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
