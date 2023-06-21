import 'package:gem_dubi/common/converter/converter.dart';

enum UserState { pending, approved, denied }

class User {
  final String id;
  final String email;
  final String displayName;
  final String userLogin;
  final String token;
  final String? phone;
  final UserState status;
  final String? instagramId;
  final String? image;
  final int? tagTypeId;
  final String? tagTypeName;

  String get firstName => displayName.split(' ').first;

  String get lastName => displayName.replaceAll(firstName, '');

  bool get isPending {
    return status != UserState.approved;
  }

//<editor-fold desc="Data Methods">

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.userLogin,
    required this.token,
    required this.phone,
    required this.image,
    required this.status,
    required this.tagTypeId,
    required this.tagTypeName,
    this.instagramId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          displayName == other.displayName &&
          userLogin == other.userLogin &&
          token == other.token &&
          instagramId == other.instagramId &&
          image == other.image &&
          status == other.status &&
          phone == other.phone &&
          tagTypeId == other.tagTypeId &&
          tagTypeName == other.tagTypeName);

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ displayName.hashCode ^ userLogin.hashCode ^ token.hashCode ^ image.hashCode ^ instagramId.hashCode ^ status.hashCode ^ phone.hashCode;

  @override
  String toString() {
    return 'User{ id: $id, email: $email, displayName: $displayName, userLogin: $userLogin, token: $token, phone: $phone,}';
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? userLogin,
    String? token,
    String? phone,
    String? instagramId,
    String? image,
    int? tagTypeId,
    String? tagTypeName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      userLogin: userLogin ?? this.userLogin,
      token: token ?? this.token,
      phone: phone ?? this.phone,
      instagramId: instagramId ?? this.instagramId,
      image: image ?? this.image,
      status: status,
      tagTypeId: tagTypeId ?? this.tagTypeId,
      tagTypeName: tagTypeName ?? this.tagTypeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'userLogin': userLogin,
      'token': token,
      'phone': phone,
      'profile_avatar': image,
      'instagramId': instagramId,
      'tagTypeId': tagTypeId,
      'tagTypeName': tagTypeName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map.from('ID') ?? map.from('user_id'),
      email: map.from('user_email'),
      userLogin: map.from<String?>('user_login') ?? '',
      displayName: map.from('display_name', defaultValue: ' '),
      token: map.from('jwt', defaultValue: ''),
      phone: map.from('phone') ?? map.from('telephone'),
      status: map.from('user_status'),
      instagramId: map.from('instagram'),
      image: map.from('profile_avatar'),
      tagTypeId: map.from('tag_type_id'),
      tagTypeName: map.from('tag_type_name'),
    );
  }

//</editor-fold>
}
