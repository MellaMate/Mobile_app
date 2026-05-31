import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/history/presentation/pages/history_page.dart';
import 'package:mella_mate_app/features/recieve/presentation/pages/recieve_page.dart';
import 'package:mella_mate_app/widgets/bottom_navigation.dart';
import 'package:mella_mate_app/features/send/presentation/pages/payment_details_page.dart';

class SendPage extends StatefulWidget {
  final String defaultCurrency;

  const SendPage({super.key, this.defaultCurrency = 'USDC'});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late String _selectedCurrency;
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.defaultCurrency;
    _amountController.addListener(_onInputChanged);
    _addressController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {}); // Trigger rebuild for live summary updates
  }

  @override
  void dispose() {
    _addressController.removeListener(_onInputChanged);
    _amountController.removeListener(_onInputChanged);
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Brand color match
    final accent = const Color(0xFF0FA71A);
    final isETB = _selectedCurrency == 'ETB';
    final amountVal = double.tryParse(_amountController.text) ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Lighter background to make white cards pop
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isETB ? 'Withdrawal to M-Pesa' : 'Send Payment',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isETB 
                           ? 'Securely withdraw funds to your M-Pesa mobile wallet in Kenya or Ethiopia.'
                           : 'Send crypto securely to friends, family, or other wallets on the network.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Main Form Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transfer Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              'Currency',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                  isExpanded: true,
                                  isDense: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  items: <String>['USDC', 'ETB'].map((String value) {
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
                            const SizedBox(height: 20),

                            Text(
                              isETB ? 'Recipient Phone Number' : "Recipient's Address",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _addressController,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isETB ? 'Please enter phone number' : 'Please enter an address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: isETB ? 'e.g. 2517... or 2547...' : 'G...',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: accent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            if (isETB) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Regional prefix (251/254) detected automatically.',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                              ),
                            ],

                            const SizedBox(height: 20),
                            Text(
                              isETB ? 'Withdrawal Amount (ETB)' : 'Amount',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                final number = double.tryParse(value);
                                if (number == null) {
                                  return 'Please enter a valid number';
                                }
                                if (number <= 0) {
                                  return 'Amount must be positive';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: isETB ? '0.00' : '100.00',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                suffixIcon: isETB 
                                  ? const Padding(
                                      padding: EdgeInsets.all(14.0),
                                      child: Text('ETB', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                    ) 
                                  : null,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: accent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Navigate to payment details with the entered values
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PaymentDetailsPage(
                                          currency: _selectedCurrency,
                                          address: _addressController.text,
                                          amount: _amountController.text,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  isETB ? 'Confirm ETB Withdrawal' : 'Send Payment',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Summary Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isETB ? 'WITHDRAWAL SUMMARY' : 'Payment Summary',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            if (isETB) ...[
                               _buildSummaryRow('Available Balance', '156.28 ETB', true), // Mock matched to web
                               const SizedBox(height: 16),
                               _buildSummaryRow('Recipient Phone', _addressController.text.isEmpty ? '-' : _addressController.text, false),
                               const SizedBox(height: 16),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                    Text('Exchange Rate', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                      child: const Text('1 USD ≈ 156.12 ETB', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    ),
                                 ],
                               ),
                               const SizedBox(height: 24),
                               const Divider(),
                               const SizedBox(height: 16),
                               _buildSummaryRow(
                                 'Estimated USDC Cost', 
                                 '${(amountVal / 156.12).toStringAsFixed(6)} USDC\nExcl. network fees', 
                                 true,
                                 valueSubtext: true,
                               ),
                            ] else ...[
                               _buildSummaryRow('Currency', 'USDC', true),
                               const SizedBox(height: 16),
                               _buildSummaryRow("Recipient's Address", _addressController.text.isEmpty ? '-' : _addressController.text, false),
                               const SizedBox(height: 16),
                               _buildSummaryRow('Amount', amountVal.toStringAsFixed(2), true),
                               const SizedBox(height: 16),
                               _buildSummaryRow('Network Fee', '0.00', false),
                               const SizedBox(height: 16),
                               _buildSummaryRow('Platform Fee', '0.00', false),
                               const SizedBox(height: 24),
                               const Divider(),
                               const SizedBox(height: 16),
                               _buildSummaryRow('Total Amount', '${amountVal.toStringAsFixed(2)} USDC', true),
                            ],
                            
                            if (isETB) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Notice: Funds will be sent directly to the M-Pesa wallet linked to the provided phone number. Supports Safaricom M-Pesa in both Kenya (2547...) and Ethiopia (2517...). Please verify the number before confirming.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade800,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
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

  Widget _buildSummaryRow(String title, String value, bool isBold, {bool valueSubtext = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        SizedBox(width: 8),
        if (valueSubtext)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                height: 1.5,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          )
        else
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
