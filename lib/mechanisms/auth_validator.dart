// Small, shared format checks for the signup and login forms.

class AuthValidator {
  // A practical email check: text before and after `@`, plus a domain suffix.
  static final RegExp _emailPattern =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

  // Names may contain letters, spaces, apostrophes, dots, and hyphens.
  static final RegExp _namePattern =
      RegExp(r"^[A-Za-z]+(?:[ .'-][A-Za-z]+)*$");

  // Student IDs contain digits only. Their exact length is left flexible.
  static final RegExp _studentIdPattern = RegExp(r'^\d+$');

  // Bangladesh mobile numbers: local 01XXXXXXXXX or country-coded 8801XXXXXXXXX.
  // The optional separators are removed before this pattern is checked.
  static final RegExp _phonePattern =
      RegExp(r'^(?:01[3-9]\d{8}|(?:\+?880)1[3-9]\d{8})$');

  // Require a minimum length plus upper/lowercase letters, a digit, and a symbol.
  static final RegExp _passwordPattern = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9\s]).{8,}$',
  );

  static String? name(String value) {
    final name = value.trim();
    if (name.isEmpty) return 'Please enter your full name';
    if (!_namePattern.hasMatch(name)) {
      return 'Use letters, spaces, apostrophes, dots, or hyphens in your name';
    }
    return null;
  }

  static String? email(String value) {
    if (!_emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String value) {
    // Users may type common separators, but the actual number must be valid.
    final phone = value.trim().replaceAll(RegExp(r'[ ()-]'), '');
    if (!_phonePattern.hasMatch(phone)) {
      return 'Enter a valid Bangladesh mobile number';
    }
    return null;
  }

  static String? studentId(String value) {
    final id = value.trim();
    if (!_studentIdPattern.hasMatch(id)) {
      return 'Student ID must contain numbers only';
    }
    return null;
  }

  static String? password(String value) {
    if (!_passwordPattern.hasMatch(value)) {
      return 'Use at least 8 characters with uppercase, lowercase, a number, and a symbol';
    }
    return null;
  }
}
