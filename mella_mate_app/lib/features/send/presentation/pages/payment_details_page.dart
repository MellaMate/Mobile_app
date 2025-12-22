import 'package:flutter/material.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:mella_mate_app/features/send/presentation/pages/payment_success_page.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String currency;
  final String address;
  final String amount;

  const PaymentDetailsPage({
    super.key,
    required this.currency,
    required this.address,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF0FA71A);
    final textStyleLabel = TextStyle(color: Colors.black54, fontSize: 14);
    final textStyleValue = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: accent.withOpacity(0.1),
                        ),
                        child: Text(
                          'Payment Details',
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // 14 -> 16
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    _rowLabelValue('Currency', currency),
                    const SizedBox(height: 20),
                    _rowLabelValue("Recipient's Address", address),
                    const SizedBox(height: 20),
                    _rowLabelValue('Amount', amount),
                    const SizedBox(height: 20),
                    _rowLabelValue('Network Fee', 'Bank Transfer'),
                    const SizedBox(height: 20),
                    _rowLabelValue('Platform Fee', currency),

                    const SizedBox(height: 32),
                    Divider(color: Colors.grey.shade200, thickness: 1),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // 16 -> 18
                          ),
                        ),
                        Text(
                          '-10000.00 USDT',
                          style: TextStyle(
                            color: const Color(0xFF0C5E3F), // Darker green for total
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // 16 -> 18
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40), // Spacer

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60, // 52 -> 60
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF033323), // Dark green
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                           child: SizedBox(
                            height: 60, // 52 -> 60
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PaymentSuccessPage(
                                      total: 'IDR 1,000,000',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Send',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
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

  Widget _rowLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }
}
