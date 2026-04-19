// CORE - storage_service.dart (firebase_storage + image_picker + image_cropper)
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage;
  final ImagePicker _picker;

  StorageService(this._storage, this._picker);

  /// Pick + crop image, then upload to Firebase Storage.
  /// Returns the download URL or null if user cancelled.
  Future<String?> pickAndUploadImage({
    required String storagePath,
    ImageSource source = ImageSource.gallery,
    double? cropAspectRatioX,
    double? cropAspectRatioY,
  }) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: (cropAspectRatioX != null && cropAspectRatioY != null)
          ? CropAspectRatio(ratioX: cropAspectRatioX, ratioY: cropAspectRatioY)
          : null,
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop image'),
        IOSUiSettings(title: 'Crop image'),
      ],
    );
    if (cropped == null) return null;

    return uploadFile(File(cropped.path), storagePath: storagePath);
  }

  Future<String> uploadFile(File file, {required String storagePath}) async {
    final ref = _storage.ref().child(storagePath);
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteFile(String storagePath) =>
      _storage.ref().child(storagePath).delete();
}
