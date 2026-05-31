import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/auth/presentation/pages/login_page.dart';
import 'package:mella_mate_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';
import 'package:mella_mate_app/core/validators.dart';
import 'package:mella_mate_app/features/legal/presentation/pages/privacy_policy_page.dart';
import 'package:mella_mate_app/features/legal/presentation/pages/terms_of_service_page.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  Color get _accentGreen => const Color(0xFF0FA71A);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signup(
        username: fullName,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        if (!mounted) return;

        AppModal.showDialog(
          context: context,
          barrierDismissible: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Check your email!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  children: [
                    const TextSpan(
                      text: 'We\'ve sent a secure verification link to\n',
                    ),
                    TextSpan(
                      text: _emailController.text.trim(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        AppModal.showMessage(
          context: context,
          title: 'Signup failed',
          message: authProvider.error ?? 'Signup failed',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          actionText: 'Try again',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth < 500 ? screenWidth : 420,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.jpg',
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 18),

                      // Title
                      Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // First name field
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'Abebe',
                        focusedColor: _accentGreen,
                        validator: AppValidators.validateName,
                      ),
                      const SizedBox(height: 14),

                      // Last name field
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Kebede',
                        focusedColor: _accentGreen,
                        validator: AppValidators.validateName,
                      ),
                      const SizedBox(height: 14),

                      // Email field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'abebekebede@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        focusedColor: _accentGreen,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: 14),

                      // Password field
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••••••',
                        isPassword: true,
                        focusedColor: _accentGreen,
                        validator: AppValidators.validatePassword,
                      ),
                      const SizedBox(height: 12),

                      // Terms text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: _accentGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const TermsOfServicePage()),
                                      );
                                    },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: _accentGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                                      );
                                    },
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              if (auth.isLoading) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const SizedBox(height: 8),

                      // Bottom sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }, // Go to Login
                            child: Text(
                              'Sign in Here',
                              style: TextStyle(
                                color: _accentGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    required Color focusedColor,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? _obscure : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDFE3E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
