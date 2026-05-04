import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    final status = await Permission.photos.request();
    return status.isGranted || status.isLimited;
  }

  Future<File?> captureFromCamera() async {
    final granted = await requestCameraPermission();
    if (!granted) return null;

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<File?> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<String> saveImageToAppDirectory(File image, String billId) async {
    final docs = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(docs.path, 'receipts'));
    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }
    final ext = p.extension(image.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = p.join(receiptsDir.path, 'receipt_${billId}_$timestamp$ext');
    final saved = await image.copy(newPath);
    return saved.path;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
    }
  }
}

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});
