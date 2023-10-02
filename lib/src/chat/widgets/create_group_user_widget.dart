import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gem_dubi/common/utils/string_extension.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';

class CreateGroupUserWidget extends StatelessWidget {
  final ApprovedUsers user;
  final List<ApprovedUsers> selectedUserList;
  final void Function(ApprovedUsers user, bool? value)? onUserSelect;
  final void Function(ApprovedUsers user, bool? value)? onUserTap;

  const CreateGroupUserWidget({
    super.key,
    required this.user,
    required this.selectedUserList,
    required this.onUserSelect,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    String tagType = '';
    final tagTypeArr = user.tagTypeName != null ? user.tagTypeName!.split('-') : <String>[];
    if (user.tagTypeName != null) {
      tagType = '${tagTypeArr[0].capitalize()} ${tagTypeArr[1].capitalize()}';
    }
    return ListTile(
      key: ValueKey(user.id),
      onTap: () => onUserTap!(user, selectedUserList.any((element) => element.id == user.id)),
      leading: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(9),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: user.image ?? '',
            fit: BoxFit.cover,
            width: 36,
            height: 36,
            errorWidget: (context, url, error) {
              return Container(
                decoration: BoxDecoration(
                  color: tagType == 'Girl A'
                      ? Colors.green
                      : tagType == 'Girl B'
                          ? Colors.blue
                          : Colors.red,
                ),
                alignment: Alignment.center,
                child: Text(
                  user.displayName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        user.displayName,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        tagType,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade400,
        ),
      ),
      trailing: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.white,
          value: selectedUserList.any((element) => element.id == user.id),
          onChanged: (value) => onUserSelect!(user, value),
        ),
      ),
    );
  }
}
