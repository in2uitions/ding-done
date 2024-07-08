class AppValidation {
  String? isEmailValid(String val) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (val.isNotEmpty && emailRegExp.hasMatch(val)) {
      return null;
    } else {
      return "Enter a valid email";
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
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

    if (val.isNotEmpty && passwordRegExp.hasMatch(val)) {
      return null;
    } else {
      return "Enter a valid password";
    }
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
