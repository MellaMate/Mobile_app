import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  Color get _accentGreen => const Color(0xFF0FA71A);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo text
                    Text(
                      'MELLAMATE.',
                      style: TextStyle(
                        color: _accentGreen,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.8,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Title
                    Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Name field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Tanzir Rahman',
                      focusedColor: _accentGreen,
                    ),
                    const SizedBox(height: 14),

                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'hello@example.com',
                      keyboardType: TextInputType.emailAddress,
                      focusedColor: _accentGreen,
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••••••',
                      isPassword: true,
                      focusedColor: _accentGreen,
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
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'terms of service',
                                style: TextStyle(
                                  color: _accentGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: open terms
                                  },
                              ),
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
                        onPressed: () {
                          // TODO: perform signup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Divider with label
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'or sign up with',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Google sign-in
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Text(
                                'G',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bottom sign in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: Text(
                            'Sign in here',
                            style: TextStyle(
                              color: _accentGreen,
                              fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    required Color focusedColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? _obscure : false,
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
