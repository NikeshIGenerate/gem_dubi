import 'package:flutter/material.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/local_girl_type_group.dart';
import 'package:gem_dubi/src/chat/widgets/create_group_user_widget.dart';

class CreateGroupGirlTypeWidget extends StatefulWidget {
  final LocalGirlTypeGroup girlTypeGroup;
  final bool isGroupExists;
  final List<ApprovedUsers> selectedUserList;
  final void Function(bool? value)? onGroupSelect;
  final void Function(ApprovedUsers user, bool? value)? onUserSelect;
  final void Function(ApprovedUsers user, bool? value)? onUserTap;

  const CreateGroupGirlTypeWidget({
    super.key,
    required this.girlTypeGroup,
    required this.isGroupExists,
    required this.selectedUserList,
    required this.onGroupSelect,
    required this.onUserSelect,
    required this.onUserTap,
  });

  @override
  State<CreateGroupGirlTypeWidget> createState() => _CreateGroupGirlTypeWidgetState();
}

class _CreateGroupGirlTypeWidgetState extends State<CreateGroupGirlTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.girlTypeGroup.girlTypeCategory.name,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      initiallyExpanded: widget.girlTypeGroup.userList.isNotEmpty,
      trailing: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.white,
          value: widget.isGroupExists,
          onChanged: widget.girlTypeGroup.userList.isNotEmpty ? widget.onGroupSelect : null,
        ),
      ),
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CreateGroupUserWidget(
              user: widget.girlTypeGroup.userList[index],
              selectedUserList: widget.selectedUserList,
              onUserSelect: (user, value) {
                widget.onUserSelect!(user, value);
                setState(() {});
              },
              onUserTap: (user, value) {
                widget.onUserTap!(user, value);
                setState(() {});
              },
            );
          },
          itemCount: widget.girlTypeGroup.userList.length,
        ),
      ],
    );
  }
}
