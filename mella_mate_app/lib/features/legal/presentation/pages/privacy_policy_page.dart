import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                'At MellaMate, your privacy is paramount. This policy explains how we collect, use, and protect your information when you use our payment gateway services.',
              ),
              const SizedBox(height: 24),

              _sectionTitle('Information We Collect'),
              _bodyText('We collect information you provide directly to us when you create an account or use our services:'),
              const SizedBox(height: 8),
              _bullet('Name, email address, and password'),
              _bullet('Business information (for merchant accounts)'),
              _bullet('Stellar wallet public keys (never your secret keys)'),
              _bullet('Transaction history and payment records'),
              const SizedBox(height: 10),
              _noteText('Note: We never store your Stellar secret keys. All cryptographic signing happens client-side or through our secure SDK.'),
              const SizedBox(height: 20),

              _sectionTitle('How We Use Your Information'),
              _bodyText('We use the information we collect to:'),
              const SizedBox(height: 8),
              _bullet('Process payments and manage your account'),
              _bullet('Send transaction confirmations and receipts'),
              _bullet('Provide customer support and resolve disputes'),
              _bullet('Comply with legal and regulatory obligations (AML/KYC)'),
              _bullet('Improve platform security and detect fraud'),
              const SizedBox(height: 20),

              _sectionTitle('Data Security'),
              _bodyText('We implement industry-standard security measures including:'),
              const SizedBox(height: 8),
              _bullet('AES-256 encryption for all data at rest'),
              _bullet('TLS 1.3 for all data in transit'),
              _bullet('HMAC-SHA256 request signing for API authentication'),
              _bullet('Regular security audits and penetration testing'),
              const SizedBox(height: 20),

              _sectionTitle('Blockchain & Stellar Network'),
              _bodyText('Transactions processed through MellaMate are recorded on the Stellar blockchain. Blockchain transactions are public and immutable. Your wallet\'s public key and transaction amounts may be visible on public Stellar explorers. We do not link your personal identity to on-chain data in any public-facing manner.'),
              const SizedBox(height: 20),

              _sectionTitle('Data Sharing'),
              _bodyText('We do not sell your personal information. We may share data with:'),
              const SizedBox(height: 8),
              _bullet('Regulatory authorities when legally required'),
              _bullet('Payment processing partners necessary to complete transactions'),
              _bullet('Cloud infrastructure providers under strict data processing agreements'),
              const SizedBox(height: 20),

              _sectionTitle('Contact Us'),
              _bodyText('If you have questions about this Privacy Policy or how we handle your data, please contact our Data Protection team:'),
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
