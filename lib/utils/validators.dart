class FieldValidators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'email is required';
    }
    if (!value.contains('@')) {
      return 'A valid email address is required';
    }
    return null;
  }

  static String? string(String? value, [String title = '']) {
    if (value == null || value.isEmpty) {
      return '$title  can not be empty';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'password  can not be empty';
    }
    if (value.length < 6) {
      return 'password must be at least 6 characters';
    }
    return null;
  }
}
