import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last updated: April 9, 2026',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              _callout(
                'By accessing or using MellaMate, you agree to be bound by these Terms of Service. Please read them carefully before using our platform.',
              ),
              const SizedBox(height: 24),

              _sectionTitle('1. Acceptance of Terms'),
              _bodyText(
                'By creating an account or using any MellaMate service, you confirm that you are at least 18 years old, have the legal authority to enter into this agreement, and agree to comply with all applicable laws and regulations in Ethiopia and internationally.',
              ),
              const SizedBox(height: 20),

              _sectionTitle('2. Payment Services'),
              _bodyText('MellaMate provides a crypto-powered payment gateway built on the Stellar blockchain. By using our services:'),
              const SizedBox(height: 8),
              _bullet('You acknowledge that all transactions are final once confirmed on-chain'),
              _bullet('Exchange rates are standardized at 156.12 ETB / 1 USD for all system conversions'),
              _bullet('Transaction fees, if any, will be clearly displayed before confirmation'),
              _bullet('You are responsible for providing accurate wallet and payment information'),
              const SizedBox(height: 20),

              _sectionTitle('3. Merchant Responsibilities'),
              _bodyText('Merchants using the MellaMate API and SDK agree to:'),
              const SizedBox(height: 8),
              _bullet('Keep API keys and secrets confidential — never expose them client-side'),
              _bullet('Use HMAC-SHA256 request signing as documented'),
              _bullet('Only integrate MellaMate for lawful commerce purposes'),
              _bullet('Maintain accurate business information on their merchant profile'),
              _bullet('Promptly report any suspected unauthorized access to their credentials'),
              const SizedBox(height: 10),
              _noteText('Security note: Rotate your API secret immediately if you suspect a compromise. MellaMate will never ask for your secret key via email or support.'),
              const SizedBox(height: 20),

              _sectionTitle('4. Prohibited Activities'),
              _bodyText('You may not use MellaMate to:'),
              const SizedBox(height: 8),
              _bullet('Process payments for illegal goods or services'),
              _bullet('Engage in money laundering or terrorist financing'),
              _bullet('Circumvent Ethiopian National Bank regulations'),
              _bullet('Reverse-engineer, scrape, or abuse the platform APIs'),
              _bullet('Create fake merchant accounts or fraudulent transactions'),
              const SizedBox(height: 8),
              _bodyText('Violations will result in immediate account suspension and may be reported to the relevant authorities.'),
              const SizedBox(height: 20),

              _sectionTitle('5. Refunds & Disputes'),
              _bodyText('Due to the immutable nature of blockchain transactions, payments confirmed on the Stellar network cannot be automatically reversed. In the event of a dispute:'),
              const SizedBox(height: 8),
              _bullet('Contact our support team within 48 hours of the transaction'),
              _bullet('Merchants are responsible for their own refund policies with end customers'),
              _bullet('MellaMate may mediate disputes at its sole discretion'),
              const SizedBox(height: 20),

              _sectionTitle('6. Limitation of Liability'),
              _bodyText('MellaMate provides services "as is" without warranty of any kind. We are not liable for losses arising from blockchain network congestion, smart contract bugs, market volatility, or force majeure events beyond our control. Our total liability is limited to the fees you paid us in the 30 days preceding the claim.'),
              const SizedBox(height: 20),

              _sectionTitle('7. Changes to Terms'),
              _bodyText('We may update these Terms at any time. We will notify registered users by email before material changes take effect. Continued use of MellaMate after changes constitutes acceptance of the new terms.'),
              const SizedBox(height: 20),

              _sectionTitle('8. Contact'),
              _bodyText('For questions about these Terms, please contact our legal team:'),
              const SizedBox(height: 6),
              _linkText('mellamate.support@gmail.com'),
              const SizedBox(height: 32),

              const Divider(height: 1),
              const SizedBox(height: 16),
              const Text('© 2026 MellaMate Inc. All rights reserved.', style: TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _bodyText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 14, height: 1.5)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callout(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF0FA71A).withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
      ),
    );
  }

  Widget _noteText(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
      ),
    );
  }

  Widget _linkText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0FA71A), fontWeight: FontWeight.w600),
    );
  }
}
