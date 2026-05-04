import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressionService {
  static const int _quality = 80;

  static const int _minWidth = 1280;
  static const int _minHeight = 1920;

  Future<File> compressImage(File originalFile) async {
    try {
      if (!await originalFile.exists()) return originalFile;

      final tempDir = await getTemporaryDirectory();
      final fileName = p.basenameWithoutExtension(originalFile.path);
      final targetPath = p.join(
        tempDir.path,
        '${fileName}_compressed.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: _quality,
        minWidth: _minWidth,
        minHeight: _minHeight,
        format: CompressFormat.jpeg,
      );

      if (result == null) return originalFile;
      return File(result.path);
    } catch (_) {
      return originalFile;
    }
  }
}

final imageCompressionServiceProvider =
    Provider<ImageCompressionService>((ref) {
  return ImageCompressionService();
});
