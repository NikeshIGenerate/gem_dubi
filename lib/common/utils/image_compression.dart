import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompression {
  static Future<File> compress(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 60,
      );

      return result != null ? File(result.path) : file;
    } catch (e, stack) {
      debugPrintStack(label: e.toString(), stackTrace: stack);
      return file;
    }
  }
}

extension ImageCompressionExtenstion on File {
  Future<File> compress() {
    return ImageCompression.compress(this);
  }
}
