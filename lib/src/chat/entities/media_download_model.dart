import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class MediaDownModel {
  const MediaDownModel({
    required this.fileName,
    required this.taskState,
    required this.downloadProgress,
    required this.file,
  });

  final String fileName;
  final TaskState taskState;
  final double downloadProgress;
  final File file;
}
