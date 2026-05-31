import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/features/auth/presentation/pages/login_page.dart';
import 'package:mella_mate_app/features/settings/presentation/pages/contact_us_page.dart';
import 'package:mella_mate_app/features/legal/presentation/pages/privacy_policy_page.dart';
import 'package:mella_mate_app/features/legal/presentation/pages/terms_of_service_page.dart';
import 'package:mella_mate_app/core/widgets/app_modal.dart';
import 'package:mella_mate_app/core/validators.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _showEditProfileDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isSubmitting = false;

    AppModal.showSheet(
      context: context,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Change your password to keep your account secure.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  _buildLabeledField(
                    label: 'Current Password',
                    child: TextFormField(
                      controller: oldPasswordController,
                      obscureText: obscureOld,
                      decoration: _inputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setModalState(() => obscureOld = !obscureOld),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'New Password',
                    child: TextFormField(
                      controller: newPasswordController,
                      obscureText: obscureNew,
                      decoration: _inputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_reset_outlined,
                        suffix: IconButton(
                          icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setModalState(() => obscureNew = !obscureNew),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        return AppValidators.validatePassword(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledField(
                    label: 'Confirm New Password',
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirm,
                      decoration: _inputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_reset_outlined,
                        suffix: IconButton(
                          icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setModalState(() => obscureConfirm = !obscureConfirm),
                        ),
                      ),
                      validator: (value) {
                        if (newPasswordController.text.isNotEmpty && value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                setModalState(() => isSubmitting = true);

                                await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  AppModal.showMessage(
                                    context: context,
                                    title: 'Profile updated',
                                    message: 'Your profile has been updated successfully.',
                                    icon: Icons.check_circle,
                                    iconColor: const Color(0xFF0FA71A),
                                    actionText: 'Done',
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0FA71A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Save Changes',
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final username = auth.user?.username ?? 'User';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 780;
            final verticalPadding = isCompact ? 8.0 : 28.0;
            final sectionGap = isCompact ? 12.0 : 28.0;
            final headerGap = isCompact ? 12.0 : 40.0;
            final avatarRadius = isCompact ? 28.0 : 44.0;
            final nameSize = isCompact ? 16.0 : 22.0;
            final subtitleSize = isCompact ? 11.0 : 13.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.green.shade100,
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: avatarRadius,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        SizedBox(height: isCompact ? 6 : 14),
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: nameSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isCompact) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Manage your account settings',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: headerGap),

                  // Settings Options
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: isCompact ? 8 : 14),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildSettingsTile(
                      compact: isCompact,
                      icon: Icons.lock_outline,
                      iconColor: Colors.blue,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () => _showEditProfileDialog(context),
                    ),
                  ),
                  SizedBox(height: sectionGap),

                  Text(
                    'Support',
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: isCompact ? 8 : 14),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          compact: isCompact,
                          icon: Icons.help_outline,
                          iconColor: const Color(0xFF0FA71A),
                          title: 'Contact Us / Help',
                          subtitle: 'Get support or send feedback',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ContactUsPage()),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        _buildSettingsTile(
                          compact: isCompact,
                          icon: Icons.description_outlined,
                          iconColor: Colors.blueGrey,
                          title: 'Terms of Service',
                          subtitle: 'Read the terms and conditions',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const TermsOfServicePage()),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        _buildSettingsTile(
                          compact: isCompact,
                          icon: Icons.privacy_tip_outlined,
                          iconColor: Colors.blueGrey,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sectionGap),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildSettingsTile(
                      compact: isCompact,
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      title: 'Log Out',
                      subtitle: 'Sign out of this device',
                      showArrow: false,
                      onTap: () async {
                        await auth.logout();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool compact = false,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 20,
        vertical: compact ? 4 : 8,
      ),
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      leading: Container(
        padding: EdgeInsets.all(compact ? 8 : 10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: compact ? 14 : 16,
        ),
      ),
      subtitle: compact
          ? null
          : Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
      trailing: showArrow
          ? const Icon(Icons.chevron_right, color: Colors.black54)
          : null,
      onTap: onTap,
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
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      prefixIcon: Icon(prefixIcon, size: 20),
      suffixIcon: suffix,
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
