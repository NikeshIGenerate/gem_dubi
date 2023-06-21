import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SateTheme<T extends StatefulWidget> on State<T> {
  ThemeData? _theme;

  ThemeData get theme {
    if (_theme == null) throw Exception('Theme used before initState()');

    return _theme!;
  }

  @override
  void initState() {
    _theme = Theme.of(context);
    super.initState();
  }
}

mixin StatelessTheme on StatelessWidget {
  List<ThemeData> _themes = [];

  ThemeData get theme {
    if (_themes.isEmpty) throw Exception('Theme used before build()');

    return _themes.first;
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    _themes.insert(0, Theme.of(context));
    // return super.build(context);
    return const SizedBox();
  }
}

mixin ConsumerTheme on ConsumerWidget {
  final List<ThemeData> _themes = [];

  ThemeData get theme {
    if (_themes.isEmpty) throw Exception('Theme used before build()');

    return _themes.first;
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context, ref) {
    _themes.insert(0, Theme.of(context));
    // return super.build(context);
    return const SizedBox();
  }
}

mixin ConsumerStateTheme<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  ThemeData? _theme;

  ThemeData get theme {
    if (_theme == null) throw Exception('must call super.build');

    return _theme!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return SizedBox();
  }
}
