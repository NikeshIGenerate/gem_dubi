import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_router.dart';

class Option<T> {
  final T value;
  final String title;
  final Widget? icon;
  final String? subTitle;
  final Color? color;
  final void Function()? onSelect;

  Option({
    required this.value,
    required this.title,
    this.onSelect,
    this.icon,
    this.subTitle,
    this.color,
  });
}

Future<T?> showSelector<T>({
  String? title,
  void Function()? onCancel,
  required List<Option<T>> options,
  T? selectedOption,
}) async {
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
    builder: (ctx) => ConstrainedBox(
      constraints: BoxConstraints.loose(Size(double.infinity, 600)),
      child: ListView(
        shrinkWrap: true,
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          if (title != null)
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          Divider(endIndent: 20, indent: 20),
          for (var option in options)
            ListTile(
              onTap: () {
                AppRouter.instance.pop(results: option.value);
                option.onSelect?.call();
              },
              selected: option.value == selectedOption,
              selectedColor: option.color,
              leading: option.icon,
              title: Text(option.title),
              subtitle:
                  option.subTitle == null ? null : Text(option.subTitle ?? ''),
            ),
          if (onCancel != null)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onCancel.call();
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
                    "Cancel",
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
    ),
  );
}
