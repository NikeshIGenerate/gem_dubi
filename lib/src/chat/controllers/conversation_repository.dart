import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/chat/entities/message_model.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/login/guest_user.dart';
import 'package:http/http.dart' as http;

class ConversationRepository {
  ConversationRepository._();

  static ConversationRepository? _instance;

  factory ConversationRepository.instance() {
    _instance ??= ConversationRepository._();

    return _instance!;
  }

  Future<void> updateAvailabilityStatus(String userId, bool status) {
    return FirebaseFirestore.instance.collection('users-availability').doc(userId).collection('availability').doc('status').update({'status': status});
  }

  Future<List<ConversationModel>> fetchGroupsByGirlType(int tagTypeId) async {
    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .where(
          'girlTypesIds',
          arrayContainsAny: [tagTypeId],
        )
        .where(
          'conversationType',
          isEqualTo: ConversationType.group.name,
        )
        .withConverter<ConversationModel>(
          fromFirestore: (o, _) => ConversationModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    final snapshot = await docRef.get();
    final list = snapshot.docs.map((e) => e.data()).toList();
    print('Group Conversation by Girl type :: list length : ${list.length}');
    return list;
  }

  Future<List<ConversationModel>> fetchGroupsByUserId(String participantsId) async {
    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .where(
          'participantsIds',
          arrayContainsAny: [participantsId],
        )
        .where(
          'conversationType',
          isEqualTo: ConversationType.group.name,
        )
        .withConverter<ConversationModel>(
          fromFirestore: (o, _) => ConversationModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    final snapshot = await docRef.get();
    final list = snapshot.docs.map((e) => e.data()).toList();
    print('Group Conversation by UserId :: list length : ${list.length}');
    return list;
  }

  Future<String> isConversationsExits(List<String> participantsIds) async {
    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .where(
          'participantsIds',
          arrayContainsAny: participantsIds,
        )
        .where(
          'conversationType',
          isEqualTo: ConversationType.private.name,
        )
        .withConverter<ConversationModel>(
          fromFirestore: (o, _) => ConversationModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    final snapshot = await docRef.get();
    final list = snapshot.docs.map((e) => e.data()).toList();
    var conversationId = '';
    print('conversation list length : ${list.length}');
    for (var conversation in list) {
      bool isExists = false;
      for (var element in conversation.participantsIds) {
        isExists = participantsIds.any((e) => e == element);
        print('isNotExists : $isExists');
        if (!isExists) break;
      }
      if (isExists) {
        conversationId = conversation.id;
        log('::: Conversation Found : $conversationId');
        break;
      }
    }
    return conversationId;
  }

  Future<String> createConversations({
    String? title,
    required List<ParticipantModel> participants,
    ConversationType conversationType = ConversationType.private,
    required GuestUser user,
    List<int>? girlTypesIds,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .withConverter<ConversationModel>(
          fromFirestore: (snapshot, options) => ConversationModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .doc();

    await docRef.set(
      ConversationModel(
        id: docRef.id,
        title: title,
        conversationType: conversationType,
        lastMessageSummary: conversationType == ConversationType.group ? 'Group created' : 'Chat created',
        lastMessageSender: ParticipantModel(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
          phone: user.phone,
          image: user.image,
          tagTypeId: user.tagTypeId,
          tagTypeName: user.tagTypeName,
        ),
        girlTypesIds: girlTypesIds ?? [],
        participantsIds: participants.map((e) => e.id).toList(),
        participantList: participants,
        deleted: {for (var item in participants) item.id: false},
        deletedTimeStamp: {for (var item in participants) item.id: Timestamp.now()},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return docRef.id;
  }

  Future<void> addNewUserToGroup({
    required String conversationId,
    required ParticipantModel newUser,
  }) async {
    final conversationItem = await getConversation(conversationId: conversationId);
    final temp = {for (var item in conversationItem!.participantList) item.id: false};
    temp[newUser.id] = false;

    final participantList = conversationItem.participantList;
    participantList.add(newUser);

    final participantIds = conversationItem.participantsIds;
    participantIds.add(newUser.id);

    final tempTimeStamp = Map<String, Timestamp>.from(conversationItem.deletedTimeStamp!);
    tempTimeStamp[newUser.id] = Timestamp.now();

    await FirebaseFirestore.instance.collection('chats').doc(conversationId).update({
      'participantList': participantList.map((e) => e.toJson()).toList(),
      'participantsIds': participantIds,
      'deletedTimeStamp': tempTimeStamp,
      'deleted': temp,
    });
  }

  Future<void> sendMessage({
    required String conversationId,
    required String message,
    required ParticipantModel sender,
    String? replyId,
  }) async {
    final conversationItem = await getConversation(conversationId: conversationId);

    final temp = {for (var item in conversationItem!.participantList) item.id: false};

    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .withConverter<MessageModel>(
          fromFirestore: (snapshot, options) => MessageModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .doc();

    await docRef.set(
      MessageModel(
        id: docRef.id,
        sender: sender,
        message: message,
        deleted: temp,
        replyId: replyId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (conversationItem.conversationType == ConversationType.private) {
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).update({
        'lastMessageSummary': message,
        'lastMessageSender': sender.toJson(),
        'deleted': temp,
        'updatedAt': DateTime.now(),
      });
    } else if (conversationItem.conversationType == ConversationType.group && sender.email == kAdminEmail) {
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).update({
        'lastMessageSummary': message,
        'lastMessageSender': sender.toJson(),
        'deleted': temp,
        'updatedAt': DateTime.now(),
      });
    } else {
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).update({
        'deleted': temp,
        'updatedAt': DateTime.now(),
      });
    }

    if (conversationItem.conversationType == ConversationType.private) {
      List<String> deviceTokenList = [];

      for (var id in conversationItem.participantsIds) {
        if (id == sender.id) continue;
        final snapshot = await FirebaseFirestore.instance.collection('users-availability').doc(id).get();
        if (snapshot.exists) {
          final data = snapshot.data();
          final token = (data?['deviceToken'] as String?) ?? '';
          if (token != '') deviceTokenList.add(token);
        }
      }

      unawaited(sendNotification(
        title: sender.displayName,
        body: message,
        deviceTokens: deviceTokenList,
      ));
    } else if (conversationItem.conversationType == ConversationType.group) {
      unawaited(sendNotificationByTopic(
        conversationID: conversationItem.id,
        title: conversationItem.title ?? '',
        body: message,
        isUser: sender.email == kAdminEmail,
      ));
    }
  }

  Query<ConversationModel> fetchConversations({required String participantId}) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where(
          'participantsIds',
          arrayContainsAny: [participantId],
        )
        .orderBy(
          'updatedAt',
          descending: true,
        )
        .withConverter<ConversationModel>(
          fromFirestore: (o, _) => ConversationModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  Future<Query<MessageModel>> fetchMessagesStream({required String conversationId, required String currentUserId}) async {
    final conversationItem = await getConversation(conversationId: conversationId);

    final deletedAt = conversationItem?.deletedTimeStamp?[currentUserId]! as Timestamp;

    log('deletedAt = $deletedAt');
    if (conversationItem!.conversationType == ConversationType.private) {
      return FirebaseFirestore.instance
          .collection('chats')
          .doc(conversationId)
          .collection('messages')
          .where('createdAt', isGreaterThan: deletedAt)
          .orderBy('createdAt', descending: true)
          .withConverter<MessageModel>(
            fromFirestore: (o, _) => MessageModel.fromJson(o.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
    } else if (conversationItem.conversationType == ConversationType.group && currentUserId != kAdminId) {
      return FirebaseFirestore.instance
          .collection('chats')
          .doc(conversationId)
          .collection('messages')
          .where('sender.id', whereIn: [kAdminId, currentUserId])
          .where('createdAt', isGreaterThan: deletedAt)
          .orderBy('createdAt', descending: true)
          .withConverter<MessageModel>(
            fromFirestore: (o, _) => MessageModel.fromJson(o.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
    } else  {
      return FirebaseFirestore.instance
          .collection('chats')
          .doc(conversationId)
          .collection('messages')
          .where('createdAt', isGreaterThan: deletedAt)
          .orderBy('createdAt', descending: true)
          .withConverter<MessageModel>(
            fromFirestore: (o, _) => MessageModel.fromJson(o.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
    }
  }

  Future<ConversationModel?> getConversation({required String conversationId}) async {
    final query = FirebaseFirestore.instance.collection('chats').doc(conversationId).withConverter<ConversationModel>(
          fromFirestore: (o, _) => ConversationModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

    final documents = await query.get();
    return documents.data();
  }

  Future<void> sendMediaMessage({
    required String conversationId,
    required String message,
    required List<MessageMediaModel> mediaList,
    required ParticipantModel sender,
    required MessageMediaType mediaType,
    String? replyId,
  }) async {
    final conversationItem = await getConversation(conversationId: conversationId);
    final temp = {for (var item in conversationItem!.participantList) item.id: false};

    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .withConverter<MessageModel>(
          fromFirestore: (snapshot, options) => MessageModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .doc();
    await docRef.set(
      MessageModel(
        id: docRef.id,
        sender: sender,
        message: message,
        mediaList: mediaList,
        deleted: temp,
        replyId: replyId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    var mediaMsg = '';
    if (mediaType == MessageMediaType.image) {
      mediaMsg = 'shared ${mediaList.length > 1 ? ' ${mediaList.length} images' : 'a image'}';
    } else if (mediaType == MessageMediaType.video) {
      mediaMsg = 'shared a video';
    } else if (mediaType == MessageMediaType.audio) {
      mediaMsg = 'shared a audio';
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationId)
        .withConverter<ConversationModel>(
          fromFirestore: (snapshot, options) => ConversationModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .update({
      'lastMessageSummary': mediaMsg,
      'lastMessageSender': sender.toJson(),
      'deleted': temp,
      'updatedAt': DateTime.now(),
    });

    if (conversationItem.conversationType == ConversationType.private) {
      List<String> deviceTokenList = [];
      for (var id in conversationItem.participantsIds) {
        if (id == sender.id) continue;
        final snapshot = await FirebaseFirestore.instance.collection('users-availability').doc(id).get();
        if (snapshot.exists) {
          final data = snapshot.data();
          final token = (data?['deviceToken'] as String?) ?? '';
          if (token != '') deviceTokenList.add(token);
        }
      }
      unawaited(sendNotification(
        title: sender.displayName,
        body: mediaMsg,
        deviceTokens: deviceTokenList,
      ));
    } else if (conversationItem.conversationType == ConversationType.group) {
      unawaited(sendNotificationByTopic(
        conversationID: conversationItem.id,
        title: conversationItem.title ?? '',
        body: mediaMsg,
        isUser: sender.email == kAdminEmail,
      ));
    }
  }

  Future<void> deletePrivateConversations({
    required ConversationModel conversationItem,
    required String userId,
    required Map<String, bool> deletedMapData,
    required Map<String, dynamic> deletedTimestampData,
  }) async {
    final temp = Map<String, bool>.from(deletedMapData);
    temp[userId] = true;
    final tempTimeStamp = Map<String, Timestamp>.from(deletedTimestampData);
    tempTimeStamp[userId] = Timestamp.now();
    await FirebaseFirestore.instance.collection('chats').doc(conversationItem.id).update({
      'deleted': temp,
      'deletedTimeStamp': tempTimeStamp,
    });
  }

  Future<void> deleteGroupConversations({required String conversationId}) async {
    await FirebaseFirestore.instance.collection('chats').doc(conversationId).delete();
  }

  Future<MessageModel?> getMessage({required String conversationId, required String messageId}) async {
    final query = FirebaseFirestore.instance.collection('chats').doc(conversationId).collection('messages').doc(messageId).withConverter<MessageModel>(
          fromFirestore: (o, _) => MessageModel.fromJson(o.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

    final documents = await query.get();
    return documents.data();
  }

  Future<void> deleteMessage({required ParticipantModel sender, required String conversationId, required String messageId}) async {
    final messageItem = await getMessage(conversationId: conversationId, messageId: messageId);
    final temp = Map<String, bool>.from(messageItem!.deleted!);
    messageItem.deleted!.forEach((key, value) {
      temp[key] = key != sender.id ? value : true;
    });
    final docRef = FirebaseFirestore.instance.collection('chats').doc(conversationId).collection('messages').doc(messageId).withConverter<MessageModel>(
          fromFirestore: (snapshot, options) => MessageModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    await docRef.update({
      'deleted': temp,
    });
  }

  Future<void> sendNotification({required String title, required String body, required List<String> deviceTokens}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(pushNotificationUrl));
      request.body = json.encode({
        'title': title,
        'body': body,
        'device_token_list': deviceTokens,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> sendNotificationByTopic({required String conversationID, required String title, required String body, required bool isUser}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(pushNotificationByTopicUrl));
      request.body = json.encode({
        'conversationID': conversationID,
        'title': title,
        'body': body,
        'isUser': isUser,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (err) {
      print(err);
    }
  }
}
