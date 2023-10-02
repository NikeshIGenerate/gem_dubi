class ParticipantModel {
  final String id;
  final String email;
  final String displayName;
  final String? phone;
  final String? image;
  final int? tagTypeId;
  final String? tagTypeName;

  ParticipantModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.phone,
    required this.image,
    required this.tagTypeId,
    required this.tagTypeName,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      phone: json['phone'],
      image: json['image'],
      tagTypeId: json['tagTypeId'],
      tagTypeName: json['tagTypeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'image': image,
      'tagTypeId': tagTypeId,
      'tagTypeName': tagTypeName,
    };
  }
}
