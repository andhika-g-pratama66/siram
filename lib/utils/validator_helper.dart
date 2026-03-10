class ValidatorHelper {
  String? validateRequired(String? value, {String? fieldname}) {
    if (value!.isEmpty) {
      return '$fieldname is required';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your full name';
    }
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    final nameRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final nameRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$',
    );
    if (!nameRegExp.hasMatch(value)) {
      return 'Password must contain at least 1 capital and symbol (e.g !, @)';
    }

    return null;
  }

  String? validateWatering(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }

    // Matches exactly one character that is a digit from 1 to 7
    final rangeRegExp = RegExp(r'^[0-9]{1,3}$');

    if (!rangeRegExp.hasMatch(value)) {
      return 'Please enter a number between 1 and 7';
    }

    return null;
  }

  String? validateAnyNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }

    // Matches exactly one character that is a digit from 1 to 7
    final rangeRegExp = RegExp(r'^[0-9]{1,3}$');

    if (!rangeRegExp.hasMatch(value)) {
      return 'Please enter numeric alphabet';
    }

    return null;
  }
}
