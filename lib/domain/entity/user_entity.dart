class UserEntity {
  final String id;
  final String email;
  final String provider;
  final String socialId;
  final String firstName;
  final String lastName;
  final FileTypeEntity photo;
  final RoleEntity role;
  final StatusEntity status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.provider,
    required this.socialId,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  String get fullName => '$firstName $lastName';
}

class FileTypeEntity {
  final String id;
  final String path;

  const FileTypeEntity({
    required this.id,
    required this.path,
  });
}

class RoleEntity {
  final int id;
  final String name;

  const RoleEntity({
    required this.id,
    required this.name,
  });
}

class StatusEntity {
  final int id;
  final String name;

  const StatusEntity({
    required this.id,
    required this.name,
  });
}
