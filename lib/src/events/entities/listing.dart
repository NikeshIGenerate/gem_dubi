import 'package:flutter/material.dart';
import 'package:gem_dubi/common/converter/converter.dart';

class Listing {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final String? privileges;
  final String? deliverables;
  final String? instagram;
  final double lat;
  final double lng;
  final int tickets;
  final String bookingStatus;
  final List<String> images;
  final bool alreadyBooked;

  bool get isPast => endDate?.isBefore(DateTime.now()) ?? startDate.isBefore(DateTime.now());

  ///
  bool get multiDayEvent {
    return endDate != null && !DateUtils.isSameDay(startDate, endDate!);
  }

  bool get multiHourEvent {
    return endDate != null && endDate!.hour != startDate.hour;
  }

//<editor-fold desc="Data Methods">

  const Listing({
    required this.id,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.privileges,
    required this.deliverables,
    required this.instagram,
    required this.lat,
    required this.lng,
    required this.tickets,
    required this.bookingStatus,
    required this.images,
    required this.alreadyBooked,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Listing &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          description == other.description &&
          privileges == other.privileges &&
          deliverables == other.deliverables &&
          instagram == other.instagram &&
          lat == other.lat &&
          lng == other.lng &&
          tickets == other.tickets &&
          images == other.images &&
          bookingStatus == other.bookingStatus &&
          alreadyBooked == other.alreadyBooked);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      description.hashCode ^
      privileges.hashCode ^
      deliverables.hashCode ^
      instagram.hashCode ^
      images.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      tickets.hashCode ^
      bookingStatus.hashCode ^
      alreadyBooked.hashCode;

  @override
  String toString() {
    return 'Listing{ id: $id, title: $title, startDate: $startDate, endDate: $endDate, description: $description, privileges: $privileges, deliverables: $deliverables, instagram: $instagram, lat: $lat, lng: $lng, tickets: $tickets, bookingStatus: $bookingStatus, alreadyBooked: $alreadyBooked,}';
  }

  Listing copyWith({
    int? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? privileges,
    String? deliverables,
    String? instagram,
    double? lat,
    double? lng,
    int? tickets,
    String? bookingStatus,
    List<String>? images,
    bool? alreadyBooked,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      images: images ?? this.images,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      privileges: privileges ?? this.privileges,
      deliverables: deliverables ?? this.deliverables,
      instagram: instagram ?? this.instagram,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      tickets: tickets ?? this.tickets,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      alreadyBooked: alreadyBooked ?? this.alreadyBooked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'privileges': privileges,
      'deliverables': deliverables,
      'instagram': instagram,
      'lat': lat,
      'lng': lng,
      'images': images,
      'tickets': tickets,
      'bookingStatus': bookingStatus,
      'alreadyBooked': alreadyBooked,
    };
  }

  factory Listing.fromMap(Map<String, dynamic> map) {
    List<String> images = (map['all_gallery_image_src'] as List)
        .map<String>((e) => e[0])
        .toList();
    print('Already Booked : ${map['already_booked']}');
    return Listing(
      id: map.from('id'),
      title: map.from('listing_title'),
      startDate: map.from('_event_date'),
      endDate: map.from('_event_date_end'),
      description: map.from('listing_description'),
      privileges: map['listing_data'].containsKey('listing_privileges') ? map['listing_data']['listing_privileges'] : '',
      deliverables: map['listing_data'].containsKey('listing_toc') ? map['listing_data']['listing_toc'] : '',
      instagram: map['listing_data'].containsKey('_instagram') ? map['listing_data']['_instagram'] : '',
      lat: map.from('_geolocation_lat', defaultValue: 0),
      lng: map.from('_geolocation_long', defaultValue: 0),
      tickets: map.from('_event_tickets', defaultValue: 0),
      // 0
      bookingStatus: map.from('_booking_status', defaultValue: ''),
      images: images,
      alreadyBooked: map['already_booked'],
    );
  }

//</editor-fold>
}
