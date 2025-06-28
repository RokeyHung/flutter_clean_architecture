import 'package:flutter_clean_architecture/domain/entity/auth_entity.dart';

class AuthPresenter {
  final String token;
  final String userFullName;
  final String userEmail;
  final String avatarUrl;

  const AuthPresenter({
    required this.token,
    required this.userFullName,
    required this.userEmail,
    required this.avatarUrl,
  });
}

extension AuthPresenterMapper on AuthEntity {
  AuthPresenter toPresenter() {
    return AuthPresenter(
      token: token,
      userFullName: '${user.firstName} ${user.lastName}',
      userEmail: user.email,
      avatarUrl: user.photo.path,
    );
  }
}
