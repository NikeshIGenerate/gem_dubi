import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/src/chat/controllers/cloud_photo_repository_impl.dart';
import 'package:gem_dubi/src/chat/controllers/conversation_repository.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/chat/entities/message_model.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:http/http.dart' as http;

final repo = ConversationRepository.instance();
final cloudPhotosRepo = CloudPhotosRepositoryImpl.instance();

final conversationListenerProvider = StreamProvider.autoDispose<List<ConversationModel>>((ref) async* {
  try {
    final userProfile = ref.read(loginProviderRef);
    print('INBOX :: TRY BEFORE fetchConversationsListen()');
    final query = repo.fetchConversations(participantId: userProfile.user.id);
    print('INBOX :: TRY AFTER fetchConversationsListen()');
    yield* query.snapshots().asyncMap((event) {
      return event.docs
          .map((e) => e.data())
          .where(
            (element) => element.deleted![userProfile.user.id] == false,
          )
          .toList();
    });
  } catch (err) {
    print('INBOX :: CATCH Listener Provider');
    print(err);
    yield [];
  }
});

final messageListenerProvider = StreamProvider.autoDispose.family<List<MessageModel>, String>((ref, conversationId) async* {
  final userProfile = ref.read(loginProviderRef);
  final query = await repo.fetchMessagesStream(conversationId: conversationId, currentUserId: userProfile.user.id);

  yield* query.snapshots().asyncMap((event) => event.docs.map((e) => e.data()).toList());
});

class ConversationNotifier extends StateNotifier<List<MessageModel>> {
  ConversationNotifier(super.state);

  Future<ConversationModel?> getConversation(String conversationId) async {
    final conversation = await repo.getConversation(conversationId: conversationId);
    return conversation;
  }

  Future<void> sendMessage({required String conversationId, required String message, required String? replyId, required WidgetRef ref}) async {
    final userProfile = ref.read(loginProviderRef).user;

    await repo.sendMessage(
      conversationId: conversationId,
      message: message,
      sender: ParticipantModel(
        id: userProfile.id,
        email: userProfile.email,
        displayName: userProfile.displayName,
        phone: userProfile.phone,
        image: userProfile.image,
        tagTypeId: userProfile.tagTypeId,
        tagTypeName: userProfile.tagTypeName,
      ),
      replyId: replyId,
    );
  }

  Future<void> sendPhotoMediaMessage({
    required String conversationId,
    required String message,
    required String? replyId,
    required List<File> photosList,
    required WidgetRef ref,
  }) async {
    final userProfile = ref.read(loginProviderRef).user;
    final item = MessageModel(
      id: UniqueKey().hashCode.toString(),
      sender: userProfile.toParticipant(),
      message: message,
      mediaList: photosList.map(
        (e) {
          final pathArr = e.path.split('/');
          final fileName = pathArr[pathArr.length - 1];
          return MessageMediaModel(
            fileName: fileName,
            url: e.path,
            mediaType: MessageMediaType.image,
          );
        },
      ).toList(),
      replyId: replyId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = [item, ...state];
    final mediaList = await _uploadImageMedia(photosList, ref);

    await repo.sendMediaMessage(
      conversationId: conversationId,
      message: message,
      mediaList: mediaList.map((e) {
        return MessageMediaModel(
          fileName: e.fileName,
          url: e.url,
          hash: e.hash,
          height: e.height,
          width: e.width,
          mediaType: MessageMediaType.image,
          size: e.size,
        );
      }).toList(),
      sender: userProfile.toParticipant(),
      mediaType: MessageMediaType.image,
      replyId: replyId,
    );
  }

  Future<List<MessageMediaModel>> _uploadImageMedia(List<File> file, WidgetRef ref) async {
    if (file.isNotEmpty) {
      final uploadedMediaModels = await Future.wait(
        file.map((photo) => cloudPhotosRepo.saveImage(photo)),
      );
      return uploadedMediaModels;
    }
    return [];
  }

  Future<void> sendVideoMediaMessage({
    required String conversationId,
    required String message,
    required String? replyId,
    required File video,
    required WidgetRef ref,
  }) async {
    final userProfile = ref.read(loginProviderRef).user;
    final pathArr = video.path.split('/');
    final fileName = pathArr[pathArr.length - 1];
    final item = MessageModel(
      id: UniqueKey().hashCode.toString(),
      sender: userProfile.toParticipant(),
      message: message,
      mediaList: [
        MessageMediaModel(
          fileName: fileName,
          url: video.path,
          mediaType: MessageMediaType.video,
        )
      ],
      replyId: replyId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = [item, ...state];

    final mediaModel = await _uploadVideoMedia(video, ref);

    await repo.sendMediaMessage(
      conversationId: conversationId,
      message: message,
      mediaList: [
        MessageMediaModel(
          fileName: mediaModel.fileName,
          url: mediaModel.url,
          mediaType: MessageMediaType.video,
          height: mediaModel.height,
          width: mediaModel.width,
          hash: mediaModel.hash,
          size: mediaModel.size,
        ),
      ],
      sender: userProfile.toParticipant(),
      mediaType: MessageMediaType.video,
      replyId: replyId,
    );
  }

  Future<MessageMediaModel> _uploadVideoMedia(File file, WidgetRef ref) async {
    final uploadedMediaModel = await cloudPhotosRepo.saveVideo(file);
    return uploadedMediaModel;
  }

  Future<void> sendAudioMediaMessage({
    required String conversationId,
    required String message,
    required String? replyId,
    required File audio,
    required WidgetRef ref,
  }) async {
    final userProfile = ref.read(loginProviderRef).user;

    final fileName = UniqueKey().hashCode.toString();
    final item = MessageModel(
      id: UniqueKey().hashCode.toString(),
      sender: userProfile.toParticipant(),
      message: message,
      mediaList: [
        MessageMediaModel(
          fileName: fileName,
          url: audio.path,
          mediaType: MessageMediaType.audio,
        )
      ],
      replyId: replyId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = [item, ...state];

    final mediaModel = await _uploadAudioMedia(audio, ref, fileName);

    await repo.sendMediaMessage(
      conversationId: conversationId,
      message: message,
      mediaList: [
        MessageMediaModel(
          fileName: mediaModel.fileName,
          url: mediaModel.url,
          mediaType: MessageMediaType.audio,
          size: mediaModel.size,
        ),
      ],
      sender: userProfile.toParticipant(),
      mediaType: MessageMediaType.audio,
      replyId: replyId,
    );
  }

  Future<MessageMediaModel> _uploadAudioMedia(File file, WidgetRef ref, String fileName) async {
    final uploadedMediaModel = await cloudPhotosRepo.saveAudio(file, fileName);
    return uploadedMediaModel;
  }
}
