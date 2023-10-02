import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';

enum ConversationType { private, group }

class ConversationModel {
  final String id;
  final String? title;
  final String? lastMessageSummary;
  final ParticipantModel? lastMessageSender;
  final ConversationType conversationType;
  final List<int> girlTypesIds;
  final List<String> participantsIds;
  final List<ParticipantModel> participantList;
  final Map<String, bool>? deleted;
  final Map<String, dynamic>? deletedTimeStamp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConversationModel({
    required this.id,
    this.title,
    this.lastMessageSummary,
    this.lastMessageSender,
    this.conversationType = ConversationType.private,
    this.girlTypesIds = const [],
    this.participantsIds = const [],
    this.participantList = const [],
    this.deleted,
    this.deletedTimeStamp,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      title: json['title'],
      lastMessageSummary: json['lastMessageSummary'],
      lastMessageSender: json['lastMessageSender'] != null ? ParticipantModel.fromJson(json['lastMessageSender']) : null,
      conversationType: json['conversationType'] == ConversationType.private.name ? ConversationType.private : ConversationType.group,
      girlTypesIds: (json['girlTypesIds'] as List<dynamic>).map((e) => e as int).toList(),
      participantsIds: (json['participantsIds'] as List<dynamic>).map((e) => e as String).toList(),
      participantList: (json['participantList'] as List<dynamic>).map((e) {
        return ParticipantModel.fromJson(e);
      }).toList(),
      deleted: Map<String, bool>.from(json['deleted'] as Map<String, dynamic>),
      deletedTimeStamp: json['deletedTimeStamp'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessageSummary': lastMessageSummary,
      'lastMessageSender': lastMessageSender?.toJson(),
      'conversationType': conversationType.name,
      'girlTypesIds': girlTypesIds,
      'participantsIds': participantsIds,
      'participantList': participantList.map((e) => e.toJson()).toList(),
      'deleted': deleted,
      'deletedTimeStamp': deletedTimeStamp,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
