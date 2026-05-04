import 'dart:io';

import 'package:image/image.dart' as img;

Future<void> main() async {
  const srcPath = 'assets/icons/splash_logo.png';
  const dstPath = 'assets/icons/splash_logo_padded.png';

  final srcFile = File(srcPath);
  if (!srcFile.existsSync()) {
    stderr.writeln('Source not found: $srcPath');
    exit(1);
  }

  final src = img.decodePng(srcFile.readAsBytesSync());
  if (src == null) {
    stderr.writeln('Failed to decode PNG: $srcPath');
    exit(1);
  }

  final maxSide = src.width > src.height ? src.width : src.height;
  final canvasSide = maxSide * 2;

  final canvas = img.Image(
    width: canvasSide,
    height: canvasSide,
    numChannels: 4,
  );
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  final dx = (canvasSide - src.width) ~/ 2;
  final dy = (canvasSide - src.height) ~/ 2;
  img.compositeImage(canvas, src, dstX: dx, dstY: dy);

  File(dstPath).writeAsBytesSync(img.encodePng(canvas));
  stdout.writeln(
    'Original: ${src.width}x${src.height} -> Padded: ${canvas.width}x${canvas.height}',
  );
  stdout.writeln('Wrote: $dstPath');
}
