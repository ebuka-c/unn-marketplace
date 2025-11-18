String? validateEmail(String? v) {
  if (v == null || v.isEmpty) return 'Enter an email';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
  return null;
}

String? validateRegNumber(String? v) {
  if (v == null || v.isEmpty) return 'Enter registration number';
  final regRegex = RegExp(r'^\d{4}/\d{6}$');
  if (!regRegex.hasMatch(v.trim())) {
    return 'Reg Number must be in format YYYY/######';
  }
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateLoginId(String? v) {
  if (v == null || v.trim().isEmpty) {
    return 'Enter email or registration number';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  final regRegex = RegExp(r'^\d{4}/\d{6}$');
  final input = v.trim();
  if (emailRegex.hasMatch(input) || regRegex.hasMatch(input)) {
    return null;
  }
  return 'Enter a valid email or registration number (YYYY/######)';
}

String? validateUsername(String? v) {
  if (v == null || (v.trim()).isEmpty) return 'Enter a username';
  return null;
}
