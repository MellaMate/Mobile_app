import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mella_mate_app/features/send/presentation/pages/send_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';

import '../../../../features/history/presentation/pages/history_page.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/providers/wallet_provider.dart';

class RecievePage extends StatefulWidget {
  const RecievePage({super.key});

  @override
  State<RecievePage> createState() => _RecievePageState();
}

class _RecievePageState extends State<RecievePage> {
  int _currentIndex = 2; // Receive tab index

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    if (index == 0) {
      // Navigate to Dashboard
       Navigator.of(context).pop();
    } else if (index == 1) {
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SendPage()));
    } else if (index == 3) {
      // Navigate to History
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HistoryPage()));
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Receive Payments',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0FA71A), // Brand Green
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'To receive payments, share your wallet address by scanning the QR code below or by copying and sharing your wallet address.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                           BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/qr_code.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                     const SizedBox(height: 40),
                    // Divider
                    Row(
                      children: List.generate(
                        600 ~/ 10,
                        (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : Colors.green.withOpacity(0.3),
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Wallet Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer<WalletProvider>(
                      builder: (context, walletProv, _) {
                        final address = walletProv.wallet?.publicKey ?? 'Not available';
                        final userName = Provider.of<AuthProvider>(context, listen: false).user?.username ?? 'User';
                        
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.length > 20 ? '${address.substring(0, 10)}...${address.substring(address.length-10)}' : address,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0FA71A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: address));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Address copied to clipboard'), duration: Duration(seconds: 1)),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0FA71A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
}
