class AppValidation {
  String? isEmailValid(String val) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[cC][oO][mM]$");
    if (val.isNotEmpty && emailRegExp.hasMatch(val)) {
      return null; // Email is valid
    } else {
      return "Enter a valid email"; // Email is not valid
    }
  }

  String? matchingPasswords(bool val) {


    if (val) {
      return null;
    } else {
      return "Passwords must match";
    }
  }

  String? isValidPassword(String val) {
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&:()-_<>])[A-Za-z\d@$!%*#?&:()-_<>]{8,}$');

    if (val.isNotEmpty && passwordRegExp.hasMatch(val)) {
      return null;
    } else {
      return "Enter a valid password";
    }
  }
  String? cardNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number';
    }
    // Basic card number validation (Luhn algorithm can be added for more accuracy)
    if (!RegExp(r'^[0-9]{16}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid card number';
    }
    return null;
  }

  String? yearAndMonthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number';
    }
    // Basic card number validation (Luhn algorithm can be added for more accuracy)
    if (!RegExp(r'^[0-9]{1,2}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid card number with a maximum of 2 digits';
    }
    return null;
  }

  String? isValidPhoneNumber(String val) {
    // Regular expression for validating phone number (adjust as needed)
    RegExp phoneRegExp = RegExp(r'^\+?[0-9]{6,15}$');

    if (val.isNotEmpty && phoneRegExp.hasMatch(val)) {
      return null;
    } else {
      return "Enter a valid phone number";
    }
  }

  String? isValidLoginPassword(String val) {
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    // RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

    if (val.isNotEmpty) {
      return null;
    } else {
      return "Enter a valid password";
    }
  }

  String? isNotEmpty({required String value, required String index}) {
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isNotEmpty) {
      return null;
    } else {
      return "$index is required";
    }
  }
  String? isNotListEmpty({required List<String> value, required String index}) {
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isNotEmpty) {
      return null;
    } else {
      return "$index is required";
    }
  }
}
