import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gem_dubi/common/converter/converter.dart';
import 'package:gem_dubi/src/events/entities/booking.dart';
import 'package:gem_dubi/src/events/entities/category.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/login/user.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/dio_client.dart';

class EventsRepository {
  EventsRepository._();

  static EventsRepository? _instance;

  factory EventsRepository.instance() {
    _instance ??= EventsRepository._();

    return _instance!;
  }

  Future<List<Listing>> fetchListing({
    required User user,
    int? category,
    String? search,
    int? page,
    int? perPage = 50,
  }) async {
    try {
      final response = await dio.get<List>('/wp/v2/listing?order=desc&orderby=date&tags=${user.tagTypeId}&user_id=${user.id}', queryParameters: {
        if (search != null) 'search': search,
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
      });
      log(jsonEncode(response.data));
      return response.data.toListOf<Listing>(skipInvalid: true);
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Listing>> fetchFavouritesListing({
    required User user,
    int? category,
  }) async {
    try {
      final response = await dio.get<List>('/wp/v2/bookmarked-posts/${user.id}');
      log(jsonEncode(response.data));
      return response.data.toListOf<Listing>(skipInvalid: true);
    } on DioException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await dio.get<List>('/wp/v2/event_category?order=desc');

      return response.data.toListOf<Category>();
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> addRemoveFavourite({
    required String postId,
    required String userId,
    required bool status,
  }) async {
    try {
      final response = await dio.post(
        '/wp/v2/bookmark',
        data: ({
          'post_id': postId.to<int>(),
          'user_id': userId.to<int>(),
          'status': status,
        }),
      );
      log(jsonEncode(response.data));
      if (response.data['message'] == 'Listing was bookmarked' || response.data['message'] == 'Removed Bookmark') {
        return true;
      }
      return false;
      // return response.data.toListOf<Listing>();
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Booking>> getMyBookings({
    int count = 100,
    int page = 0,
    bool pastEvents = true,
    required User user,
  }) async {
    try {
      final response = await dio.get<List>(
        '/wp/v2/get-bookings',
        queryParameters: pastEvents
            ? {
                'bookingperiod': pastEvents ? 'past' : 'new',
                'per_page': count,
                'page': page,
              }
            : {
                'per_page': count,
                'page': page,
              },
      );
      log(jsonEncode(response.data));
      return response.data.toListOf<Booking>();
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> requestBooking({
    required String userId,
    required Listing listing,
    required int tickets,
    required DateTime eventDate,
  }) async {
    try {
      final response = await dio.post(
        '/wp/v2/booking',
        data: ({
          'user_id': userId.to<int>(),
          'value': {
            'listing_id': listing.id,
            'tickets': tickets,
            'adults': tickets,
            'date_start': listing.startDate.toIso8601String(),
            'date_end': listing.endDate?.toIso8601String(),
          },
          'message': '',
          'booking_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(eventDate),
        }),
      );

      print(response.data);

      // return response.data.toListOf<Listing>();
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.requestOptions.headers);
      rethrow;
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    try {
      final response = await dio.post(
        '/custom-plugin/cancelbooking',
        data: ({'booking_id': bookingId}),
      );

      print(response.data);
      return response.data['success'] as bool;
      // return response.data.toListOf<Listing>();
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.requestOptions.headers);
      return false;
    }
  }
}
