import 'package:flutter_clean_architecture/data/model/user_model.dart';
import 'package:flutter_clean_architecture/domain/entity/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      provider: provider,
      socialId: socialId,
      firstName: firstName,
      lastName: lastName,
      photo: photo.toEntity(),
      role: role.toEntity(),
      status: status.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension FileTypeModelMapper on FileTypeModel {
  FileTypeEntity toEntity() {
    return FileTypeEntity(
      id: id,
      path: path,
    );
  }
}

extension RoleModelMapper on RoleModel {
  RoleEntity toEntity() {
    return RoleEntity(
      id: id,
      name: name,
    );
  }
}

extension StatusModelMapper on StatusModel {
  StatusEntity toEntity() {
    return StatusEntity(
      id: id,
      name: name,
    );
  }
}
