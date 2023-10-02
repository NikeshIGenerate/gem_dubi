import 'dart:io';

class BlurHashParams {
  BlurHashParams({
    required this.imageFile,
    required this.width,
    required this.height,
  });

  final File imageFile;
  final int width;
  final int height;
}
