class ApprovedUsers {
  final int id;
  final String displayName;
  final String email;
  final String? image;
  final int? tagTypeId;
  final String? tagTypeName;

  ApprovedUsers({
    required this.id,
    required this.displayName,
    required this.email,
    required this.image,
    required this.tagTypeId,
    required this.tagTypeName,
  });

  factory ApprovedUsers.fromJson(Map<String, dynamic> json) {
    return ApprovedUsers(
      id: json['data']['ID'],
      displayName: json['data']['display_name'],
      email: json['data']['user_email'],
      image: json['data']['image'] is String ? json['image'] : null,
      tagTypeId: json['tagTypeId'],
      tagTypeName: json['tagTypeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'user_email': email,
      'image': image,
      'tagTypeId': tagTypeId,
      'tagTypeName': tagTypeName,
    };
  }
}
