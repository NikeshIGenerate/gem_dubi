import 'package:flutter/cupertino.dart';

import 'converter.dart';

class ListConverter<T> implements CustomConverter<List<T>> {
  @override
  final List<Type> types = [List];

  @override
  List<T> handle(
    value, {
    List<T>? defaultValue,
    bool skipInvalid = false,
  }) {
    if (value is! List) {
      return [CustomConverter.to<T>(value)];
    }

    List<T> response = [];

    for (var e in value) {
      try {
        response.add(CustomConverter.to<T>(e));
      } catch (e, stack) {
        if (skipInvalid) {
          /// print it in console to fix
          debugPrintStack(stackTrace: stack);
        } else {
          rethrow;
        }
      }
    }

    return response;
  }
}
