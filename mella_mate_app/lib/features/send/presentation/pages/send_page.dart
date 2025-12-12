import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/history/presentation/pages/history_page.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:mella_mate_app/features/send/presentation/pages/payment_details_page.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final _currencyController = TextEditingController(text: 'Stella Lumens');
  final _addressController = TextEditingController();
  final _amountController = TextEditingController(text: '100.00');
  int _currentIndex = 1;

  @override
  void dispose() {
    _currencyController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Brand color match
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
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Send Payment',
                        style: TextStyle(
                          color: accent,
                          fontSize: 24, // 20 -> 24
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    const Text(
                      'Currency',
                      style: TextStyle(
                        fontSize: 16, // 14 -> 16
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _currencyController,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: accent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      "Recipient's Address",
                      style: TextStyle(
                        fontSize: 16, // 14 -> 16
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'GJKF......',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: accent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 16, // 14 -> 16
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: accent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      height: 60, // 56 -> 60
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to payment details with the entered values
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PaymentDetailsPage(
                                currency: _currencyController.text,
                                address: _addressController.text.isEmpty
                                    ? 'GJKF......'
                                    : _addressController.text,
                                amount: _amountController.text,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18, // 16 -> 18
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            BottomNavigationCustom(
              currentIndex: _currentIndex,
              onTap: (i) {
                setState(() => _currentIndex = i);
                if (i == 0) {
                  Navigator.of(context).pop();
                } else if (i == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RecievePage()),
                  );
                } else if (i == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
