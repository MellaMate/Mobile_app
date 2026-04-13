import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';
import 'package:mella_mate_app/features/send/presentation/pages/payment_success_page.dart';

class PaymentDetailsPage extends StatefulWidget {
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
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  bool _isLoading = false;

  Future<void> _sendPayment() async {
    setState(() => _isLoading = true);
    
    try {
      final repository = context.read<SendRepository>();
      final request = SendPaymentRequest(
        destination: widget.address,
        amount: widget.amount,
        assetCode: widget.currency,
        memo: 'Payment from MellaMate App',
      );

      final result = await repository.sendPayment(request);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessPage(
              total: '${widget.amount} ${widget.currency}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF0FA71A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Confirm Payment'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Recipient Address', widget.address),
              const SizedBox(height: 16),
              _buildDetailItem('Amount', widget.amount),
              const SizedBox(height: 16),
              _buildDetailItem('Asset', widget.currency),
              const SizedBox(height: 16),
              _buildDetailItem('Network Fee', '0.00001 XLM (Stellar)'),
              const Spacer(),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text('Total to Send', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   Text('${widget.amount} ${widget.currency}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm & Send', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
