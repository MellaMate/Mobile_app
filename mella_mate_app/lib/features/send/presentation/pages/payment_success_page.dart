import 'package:flutter/material.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String total;

  const PaymentSuccessPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF0FA71A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 36,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9), // Light green ring
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 32, // 28 -> 32
                              backgroundColor: accent,
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Payment Success!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24, // 20 -> 22
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your payment has been successfully done.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16, // 13 -> 15
                            ),
                          ),
                          const SizedBox(height: 36),
                          const Text(
                            'Total Payment',
                            style: TextStyle(
                              fontSize: 14, // 12 -> 14
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            total,
                            style: const TextStyle(
                              fontSize: 28, // 24 -> 28
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 36),

                          Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              final userName = auth.user?.username ?? 'User';
                              final now = DateTime.now();
                              final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(now);
                              
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 2.5,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                children: [
                                  _infoCard('Ref Number', 'TX-${now.millisecondsSinceEpoch.toString().substring(7)}'),
                                  _infoCard('Payment Time', formattedDate),
                                  _infoCard('Payment Method', 'Stellar Network'),
                                  _infoCard('Sender Name', userName),
                                ],
                              );
                            },
                          ),

                          // Removed zigzag effect as per request
                          const SizedBox(height: 32),

                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                            ),
                            icon: const Icon(
                              Icons.file_download_outlined,
                              size: 24,
                            ),
                            label: const Text(
                              'Get PDF Receipt',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 60, // 56 -> 60
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF039C05,
                          ), // Vibrant green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        },
                        child: const Text(
                          'Back Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // 16 -> 18
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomNavigationCustom(
              currentIndex: 1,
              onTap: (i) {
                if (i == 0) Navigator.of(context).popUntil((r) => r.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
