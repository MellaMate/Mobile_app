import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mella_mate_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _keepSignedIn = false;

  Color get _accentGreen => const Color(0xFF0FA71A);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      if (!mounted) return;
      AppModal.showMessage(
        context: context,
        title: 'Welcome back!',
        message: 'Login successful. Let\'s continue.',
        icon: Icons.check_circle,
        iconColor: _accentGreen,
        actionText: 'Continue',
        barrierDismissible: false,
        onAction: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        },
      );
    } else {
      if (!mounted) return;
      AppModal.showMessage(
        context: context,
        title: 'Login failed',
        message: authProvider.error ?? 'Login failed',
        icon: Icons.error_outline,
        iconColor: Colors.red,
        actionText: 'Try again',
      );
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
                      Text(
                        'Login to account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Email
                      _buildLabeledField(
                        label: 'Email Address',
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'abebekebede@gmail.com',
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDFE3E6),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: _accentGreen,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password with forgot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                              );
                              },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: _accentGreen, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFDFE3E6),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _accentGreen,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                            ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Keep me signed in
                      Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: _keepSignedIn,
                              activeColor: _accentGreen,
                              onChanged: (v) =>
                                  setState(() => _keepSignedIn = v ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Keep me signed in',
                            style: TextStyle(color: Colors.grey[800],fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _login,
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
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                );
                              }
                              return const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),

                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      ),
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          color: _accentGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      )
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
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
        child,
      ],
    );
  }
}
