import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';

class MessageModel {
  final String id;
  final String message;
  final String? replyId;
  final ParticipantModel sender;
  final List<MessageMediaModel> mediaList;
  final Map<String, bool>? deleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    required this.id,
    required this.message,
    this.replyId,
    required this.sender,
    this.mediaList = const [],
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      replyId: json['replyId'],
      mediaList: (json['mediaList'] as List<dynamic>).map((e) => MessageMediaModel.fromJson(e)).toList(),
      sender: ParticipantModel.fromJson(json['sender']),
      deleted: Map<String, bool>.from(json['deleted'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'replyId': replyId,
      'mediaList': mediaList.map((e) => e.toJson()).toList(),
      'sender': sender.toJson(),
      'deleted': deleted,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

enum MessageMediaType { image, video, audio }

class MessageMediaModel {
  final String fileName;
  final String url;
  final String? hash;
  final int? width;
  final int? height;
  final int? size;
  final MessageMediaType mediaType;

  MessageMediaModel({
    required this.fileName,
    required this.url,
    required this.mediaType,
    this.hash,
    this.width,
    this.height,
    this.size,
  });

  factory MessageMediaModel.fromJson(Map<String, dynamic> json) {
    return MessageMediaModel(
      fileName: json['fileName'],
      url: json['url'],
      mediaType: json['mediaType'] == MessageMediaType.image.name
          ? MessageMediaType.image
          : json['mediaType'] == MessageMediaType.video.name
              ? MessageMediaType.video
              : MessageMediaType.audio,
      hash: json['hash'],
      width: json['width'],
      height: json['height'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
      'mediaType': mediaType.name,
      'hash': hash,
      'width': width,
      'height': height,
      'size': size,
    };
  }
}
