class AppValidators {
  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your name';
    }
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    final nameRegex = RegExp(r"^[A-Za-z][A-Za-z\-' ]*[A-Za-z]$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Use letters, spaces, hyphens, or apostrophes only';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must include an uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must include a number';
    }
    if (!RegExp(r'[!@#\$%\^&*(),.?":{}|<>/_+=\-\[\]\\]').hasMatch(password)) {
      return 'Password must include a special character';
    }
    return null;
  }
}
