import 'dart:io';

import 'package:gem_dubi/src/chat/entities/message_model.dart';

abstract class CloudPhotosRepository {
  static String get chatsBucket => 'gem-dubai-chats';

  Future<MessageMediaModel> saveImage(File image, [String? filename]);
  Future<MessageMediaModel> saveVideo(File video, [String? filename]);
  Future<MessageMediaModel> saveAudio(File audio, [String? filename]);
  Future<void> deleteMedia(List<MessageMediaModel> mediaToDelete);
}