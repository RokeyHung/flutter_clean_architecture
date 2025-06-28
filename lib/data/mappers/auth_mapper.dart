import 'package:flutter_clean_architecture/data/mappers/user_mapper.dart';
import 'package:flutter_clean_architecture/data/model/auth_model.dart';
import 'package:flutter_clean_architecture/domain/entity/auth_entity.dart';

extension AuthModelMapper on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      token: token,
      refreshToken: refreshToken,
      tokenExpires: tokenExpires,
      user: user.toEntity(),
    );
  }
}
