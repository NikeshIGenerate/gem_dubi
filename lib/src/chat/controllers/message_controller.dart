import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/controllers/conversation_repository.dart';
import 'package:gem_dubi/src/chat/controllers/message_repository.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/chat/entities/girl_type_category.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';

final messageControllerRef = ChangeNotifierProvider((ref) => MessageController());

class MessageController extends ChangeNotifier {
  final repo = MessageRepository.instance();
  final convRepo = ConversationRepository.instance();

  bool loading = false;
  List<GirlTypeCategory> girlTypesList = [];
  List<ApprovedUsers> allUsersList = [];
  List<ApprovedUsers> usersGirlTypeList = [];

  Future<void> updateAvailabilityStatus(String userId, bool status) async {
    await convRepo.updateAvailabilityStatus(userId, status);
  }

  Future<String> isConversationExists(List<ParticipantModel> participants) async {
    try {
      String convId = await convRepo.isConversationsExits(participants.map((e) => e.id).toList());
      return convId;
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<void> addNewUserToExistingGroup(String conversationId, GuestUser user) async {
    try {
      await convRepo.addNewUserToGroup(
        conversationId: conversationId,
        newUser: ParticipantModel(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
          phone: user.phone,
          image: user.image,
          tagTypeId: user.tagTypeId,
          tagTypeName: user.tagTypeName,
        ),
      );
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  Future<List<ConversationModel>> getGroupConversationByUserId(String userId) async {
    try {
      final list = await convRepo.fetchGroupsByUserId(userId);
      return list;
    } on FirebaseException catch (err) {
      print(err);
      return [];
    }
  }

  Future<List<ConversationModel>> getGroupConversationByGirlType(int tagTypeId) async {
    try {
      final list = await convRepo.fetchGroupsByGirlType(tagTypeId);
      return list;
    } on FirebaseException catch (err) {
      print(err);
      return [];
    }
  }

  Future<ConversationModel?> getConversation(String convId) async {
    try {
      final convItem = await convRepo.getConversation(conversationId: convId);
      return convItem;
    } on FirebaseException catch (err) {
      print(err);
      return null;
    }
  }

  Future<String> createPrivateConversation(List<ParticipantModel> participants, GuestUser user) async {
    try {
      String convId = await convRepo.createConversations(participants: participants, user: user);
      return convId;
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> createGroupConversations(String title, List<ParticipantModel> participants, GuestUser user, List<GirlTypeCategory> girlTypes) async {
    try {
      String convId =
          await convRepo.createConversations(title: title, participants: participants, conversationType: ConversationType.group, user: user, girlTypesIds: girlTypes.map((e) => e.id).toList());
      return convId;
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<void> deletePrivateConversations({
    required ConversationModel conversationModel,
    required Map<String, bool> deleted,
    required Map<String, dynamic> deletedTimestamp,
    required WidgetRef ref,
  }) async {
    final userProfile = ref.read(loginProviderRef).user;
    await convRepo.deletePrivateConversations(
      conversationItem: conversationModel,
      deletedMapData: deleted,
      deletedTimestampData: deletedTimestamp,
      userId: userProfile.id,
    );
  }

  Future<void> deleteGroupConversations({required String conversationId}) async {
    await convRepo.deleteGroupConversations(conversationId: conversationId);
  }

  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
    required WidgetRef ref,
  }) async {
    final userProfile = ref.read(loginProviderRef).user;
    await convRepo.deleteMessage(
      sender: userProfile.toParticipant(),
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  Future<void> fetchCategories() async {
    try {
      girlTypesList = await repo.fetchCategories();
    } on DioException catch (err) {
      print(err);
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      allUsersList = await repo.fetchAllUsers();
    } on DioException catch (err) {
      print(err);
    }
  }

  Future<void> fetchUsersListByGirlType({required int tagTypeId}) async {
    try {
      usersGirlTypeList = await repo.fetchUsersListByGirlType(tagTypeId: tagTypeId);
    } on DioException catch (err) {
      print(err);
    }
  }
}
