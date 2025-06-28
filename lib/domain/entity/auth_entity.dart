import 'user_entity.dart';

class AuthEntity {
  final String token;
  final String refreshToken;
  final int tokenExpires;
  final UserEntity user;

  const AuthEntity({
    required this.token,
    required this.refreshToken,
    required this.tokenExpires,
    required this.user,
  });
}
