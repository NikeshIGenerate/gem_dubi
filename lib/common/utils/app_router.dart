import 'package:flutter/material.dart';

AppRouter get router => AppRouter.instance;

/// used for navigation inside the app
class AppRouter {
  static final instance = AppRouter._();

  AppRouter._();

  final key = GlobalKey<NavigatorState>();

  BuildContext get context => key.currentContext!;

  /// get navigator based on [context] or main navigator if no [context]
  NavigatorState _navigator([BuildContext? context]) =>
      context == null ? key.currentState! : Navigator.of(context);

  /// param [context] used for nested navigators if exists
  Future<T?> push<T>(
    Widget widget, {
    BuildContext? context,
    Route<T>? customRoute,
  }) =>
      _navigator(context).push(customRoute ?? _buildRouter(widget));

  /// param [context] used for nested navigators if exists
  Future<T?> pushReplacement<T>(Widget widget, {BuildContext? context}) =>
      _navigator(context).pushReplacement(_buildRouter(widget));

  /// param [context] used for nested navigators if exists
  void pop<T>({BuildContext? context, T? results}) =>
      _navigator(context).pop<T>(results);

  void popCount(int count) {
    int i = 0;
    Navigator.of(context).popUntil((route) {
      i++;
      return i == count + 1;
    });
  }

  /// param [context] used for nested navigators if exists
  /// remove all routes and push [widget] as a new route
  Future<void> replaceAllWith<T>(
    Widget widget, {
    BuildContext? context,
  }) async {
    final navigator = _navigator(context);

    while (navigator.canPop()) {
      navigator.pop();
    }

    navigator.pushReplacement(_buildRouter(widget));
  }

  /// build custom router if needed
  Route<T> _buildRouter<T>(Widget widget) => MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(
          name: widget.toStringShort(),
        ),
      );
}

Route<T> noAnimationRoute<T>(Widget widget) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      settings: RouteSettings(name: widget.toStringShort()),
      transitionDuration: Duration.zero,
    );
