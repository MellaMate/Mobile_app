import 'package:flutter/material.dart';
import 'package:mella_mate_app/core/validators.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppModal.showMessage(
          context: context,
          title: 'Message sent',
          message: 'Thanks for reaching out. We will get back to you shortly.',
          icon: Icons.check_circle,
          iconColor: const Color(0xFF0FA71A),
          actionText: 'Done',
          barrierDismissible: false,
          onAction: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We\'d love to hear from you! Send us a message and we\'ll get back to you shortly.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  _buildLabeledField(
                    label: 'First Name',
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: _inputDecoration(
                        hintText: 'Abebe',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: AppValidators.validateName,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'Last Name',
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: _inputDecoration(
                        hintText: 'Kebede',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: AppValidators.validateName,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'Email Address',
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        hintText: 'abebe@gmail.com',
                        prefixIcon: Icons.email_outlined,
                      ),
                      validator: AppValidators.validateEmail,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'Subject',
                    child: TextFormField(
                      controller: _subjectController,
                      decoration: _inputDecoration(
                        hintText: 'App feedback',
                        prefixIcon: Icons.subject_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'Message',
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: _inputDecoration(
                        hintText: 'Tell us how we can help...',
                        prefixIcon: Icons.message_outlined,
                        isMultiline: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0FA71A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Send Message',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    bool isMultiline = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: EdgeInsets.fromLTRB(14, isMultiline ? 14 : 12, 14, 14),
      isDense: true,
      prefixIcon: isMultiline
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Icon(prefixIcon, size: 20),
            )
          : Icon(prefixIcon, size: 20),
      prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDFE3E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0FA71A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
