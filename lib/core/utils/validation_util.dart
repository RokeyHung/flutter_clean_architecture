bool isEmailValid(String email) {
  final emailValidation = RegExp(
    r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)',
  );
  return emailValidation.allMatches(email).isNotEmpty;
}

bool isPasswordValid(String password) {
  final passwordValidation = RegExp(
    r'^[0-9a-zA-Z!@#<>?":_`~;[\]\\|=+)(*&^%-]{8,}$',
  );
  return passwordValidation.allMatches(password).isNotEmpty;
}

bool isUserLinkUserNameValid(String userName, {bool allowEmpty = false}) {
  if (userName.isEmpty) {
    return allowEmpty;
  }

  final userNameValidation = RegExp(
    r'^[ -~]+$',
  );
  return userNameValidation.allMatches(userName).isNotEmpty;
}
