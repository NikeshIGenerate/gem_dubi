import 'package:flutter/cupertino.dart';
import 'package:gem_dubi/common/converter/converter.dart';

class EnumConverter<T> extends CustomConverter<T> {
  EnumConverter(
    this.values, {
    this.toName = _convertName,
    this.defaultItem,
  });

  final List<T> values;
  final String Function(T value) toName;
  final T? defaultItem;

  static String _convertName(dynamic v) {
    try {
      return v.displayName.toString().toLowerCase();
    } catch (e) {
      return v.toString().split('.').last;
    }
  }

  @override
  T handle(value, {T? defaultValue}) {
    try {
      for (var item in values) {
        if (toName(item) == value.toString().toLowerCase()) {
          return item;
        }
      }

      return defaultValue ?? values.first;

      // return item;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  @override
  List<Type> get types => [T, NullAble<T>, Future<T>, Future<NullAble<T>>];
}
