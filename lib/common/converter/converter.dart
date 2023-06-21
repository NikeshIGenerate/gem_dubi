import 'dart:convert';

import 'package:gem_dubi/common/converter/enum_converter.dart';
import 'package:gem_dubi/src/events/entities/booking.dart';
import 'package:gem_dubi/src/events/entities/category.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/login/user.dart';

import 'base_converters.dart';
import 'convert_exceptions.dart';
import 'list_converter.dart';

typedef NullAble<T> = T?;

abstract class CustomConverter<T> {
  static List<CustomConverter> converters = [
    StringConverter(),
    IntConverter(),
    DoubleConverter(),
    DateTimeConverter(),
    TimeOfDayConverter(),
    FromMapConverter<Listing>(Listing.fromMap),
    FromMapConverter<Category>(Category.fromMap),
    FromMapConverter<User>(User.fromMap),
    FromMapConverter<Booking>(Booking.fromMap),
    EnumConverter<BookingStatus>(
      BookingStatus.values,
      defaultItem: BookingStatus.waiting,
      // toName: (value) => value.name,
    ),
    EnumConverter<UserState>(
      UserState.values,
      defaultItem: UserState.denied,
    ),
    ConverterBuilder((value, {defaultValue}) => value ?? defaultValue),
  ];

  static T to<T>(dynamic value, {T? defaultValue}) {
    for (var converter in converters) {
      if (converter.types.contains(T)) {
        final r = converter.handle(value, defaultValue: defaultValue);

        if (r is T) {
          return r;
        } else {
          return defaultValue as T;
        }
      }
    }

    throw UnKnownConverter(T);
  }

  static List<O> toListOf<O>(
    dynamic value, {
    List<O>? defaultValue,
    bool skipInvalid = false,
  }) {
    return ListConverter<O>().handle(
      value,
      defaultValue: defaultValue,
      skipInvalid: skipInvalid,
    );
  }

  T handle(dynamic value, {T? defaultValue});

  List<Type> get types;
}

extension ConverterUtils on dynamic {
  T to<T>({T? defaultValue}) =>
      CustomConverter.to(this, defaultValue: defaultValue);

  List<T> toListOf<T>({
    List<T>? defaultValue,
    bool skipInvalid = false,
  }) =>
      CustomConverter.toListOf(
        this,
        defaultValue: defaultValue,
        skipInvalid: skipInvalid,
      );
}

extension MapConverter on Map {
  T from<T>(dynamic key, {T? defaultValue}) {
    var subKeys = key.toString().split('.');
    dynamic data = this;

    while (subKeys.isNotEmpty) {
      final key = subKeys.first;
      subKeys.removeAt(0);

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map) {
        data = data[key];
      } else if (data is List) {
        data = data[key.to<int>()];
      } else {
        throw Exception('invalid key $key ${data.runtimeType} Data$data');
      }
    }

    return CustomConverter.to(data, defaultValue: defaultValue);
  }
}
