import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_router.dart';

showConfirmBottomSheet({
  String? title,
  String? message,
  void Function()? onDelete,
  void Function()? onConfirm,
  void Function()? onCancel,

  /// if dialog has draft button
  void Function()? onDraft,

  /// getting from draft
  final bool fromDraft = false,
}) {
  final BuildContext context = AppRouter.instance.key.currentContext!;

  return showModalBottomSheet(
    backgroundColor: (Theme.of(context).brightness == Brightness.dark)
        ? CupertinoColors.darkBackgroundGray
        : CupertinoColors.systemGroupedBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        if (title != null)
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (message != null)
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (message != null) const SizedBox(height: 10),
        if (onDelete != null)
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            onTap: () {
              Navigator.pop(context);
              onDelete.call();
            },
            leading: const FaIcon(
              FontAwesomeIcons.trashCan,
              color: CupertinoColors.destructiveRed,
            ),
            title: const Text(
              'Delete',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          child: Container(
            height: 45,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.systemGrey,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'cancel',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
