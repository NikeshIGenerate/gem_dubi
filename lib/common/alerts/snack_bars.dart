import 'package:flutter/material.dart';

import '../utils/app_router.dart';

void showSnackBarMessage(
  String message, {
  String? body,
  SnackBarAction? action,
}) {
  final context = AppRouter.instance.key.currentContext!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Card(
        color: Theme.of(context).backgroundColor,
        child: ListTile(
          dense: true,
          title: Text(message, style: Theme.of(context).textTheme.bodySmall),
          subtitle: body == null ? null : Text(body),
          trailing: action == null
              ? null
              : TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(
                      reason: SnackBarClosedReason.action,
                    );
                    action.onPressed();
                  },
                  child: Text(action.label),
                ),
        ),
      ),
    ),
  );
}
