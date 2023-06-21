import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'converter.dart';

class IntConverter implements CustomConverter<int?> {
  @override
  final List<Type> types = [
    int,
    NullAble<int>,
    Future<int>,
    FutureOr<NullAble<int>>
  ];

  @override
  int? handle(value, {int? defaultValue}) {
    return int.tryParse(value.toString()) ?? defaultValue;
  }
}

class DoubleConverter implements CustomConverter<double?> {
  @override
  final List<Type> types = [
    double,
    NullAble<double>,
    Future<double>,
    FutureOr<NullAble<double>>
  ];

  @override
  double? handle(value, {double? defaultValue}) {
    return double.tryParse(value?.toString() ?? '') ?? defaultValue;
  }
}

class StringConverter implements CustomConverter<String?> {
  @override
  final List<Type> types = [
    String,
    NullAble<String>,
    Future<String>,
    FutureOr<NullAble<String>>
  ];

  @override
  String? handle(value, {String? defaultValue}) {
    if (value == null || value == '') return defaultValue;

    return value.toString();
  }
}

class DateTimeConverter implements CustomConverter<DateTime?> {
  @override
  final List<Type> types = [
    DateTime,
    NullAble<DateTime>,
    Future<DateTime>,
    FutureOr<NullAble<DateTime>>
  ];

  final List<DateFormat> formats = [
    DateFormat('MM/dd/yyyy hh:mm a'),
    DateFormat('yyyy-MM-dd hh:mm a'),
  ];

  @override
  DateTime? handle(value, {DateTime? defaultValue}) {
    if (int.tryParse(value ?? 'a') != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);
    }

    for (var f in formats) {
      try {
        return f.parse(value.toString());
      } catch (e) {}
    }
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }
}

class TimeOfDayConverter implements CustomConverter<TimeOfDay?> {
  @override
  final List<Type> types = [
    TimeOfDay,
    NullAble<TimeOfDay>,
    Future<TimeOfDay>,
    FutureOr<NullAble<TimeOfDay>>
  ];

  @override
  TimeOfDay? handle(value, {TimeOfDay? defaultValue}) {
    return defaultValue;
  }
}

class ConverterBuilder<T> implements CustomConverter<T?> {
  @override
  final List<Type> types = [T, NullAble<T>, Future<T>, FutureOr<NullAble<T>>];

  ConverterBuilder(this.handler);

  final T? Function(dynamic value, {T? defaultValue}) handler;

  @override
  T? handle(value, {T? defaultValue}) =>
      handler(value, defaultValue: defaultValue);
}

class FromMapConverter<T> implements CustomConverter<T?> {
  @override
  final List<Type> types = [T, NullAble<T>, FutureOr<T>, FutureOr<NullAble<T>>];

  FromMapConverter(this.handler);

  final T? Function(Map<String, dynamic> value) handler;

  @override
  T? handle(value, {T? defaultValue}) {
    return handler(value) ?? defaultValue;
  }
}
