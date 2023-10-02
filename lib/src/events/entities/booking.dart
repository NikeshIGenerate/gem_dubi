import 'package:flutter/material.dart';
import 'package:gem_dubi/common/converter/converter.dart';

enum BookingStatus {
  waiting,
  confirmed,
  paid,
  cancelled,
  deleted,
  expired;

  Color get color {
    switch (this) {
      case BookingStatus.waiting:
        return Colors.black26;
      case BookingStatus.confirmed:
        return Colors.greenAccent;
      case BookingStatus.paid:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.deleted:
        return Colors.red;
      case BookingStatus.expired:
        return Colors.black54;
    }
  }

  String get displayName {
    switch (this) {
      case BookingStatus.waiting:
        return 'Pending';
      case BookingStatus.confirmed:
      case BookingStatus.paid:
        return 'Approved';
      case BookingStatus.cancelled:
      case BookingStatus.deleted:
        return 'Canceled';
      case BookingStatus.expired:
        return 'Expired';
    }
  }
}

class Booking {
  final int id;
  final String author;
  final String image;
  final double price;
  final String title;
  final int tickets;
  final String? message;

  final String customFirstName;
  final String customLastName;
  final String customEmail;
  final String? customPhone;
  final String? instagram;

  final DateTime startDate;
  final DateTime endDate;

  final BookingStatus status;

  String get customerName => '$customFirstName $customLastName';

  bool get canCancel {
    return [
      BookingStatus.waiting,
      BookingStatus.confirmed,
      BookingStatus.paid,
    ].contains(status);
  }

//<editor-fold desc="Data Methods">

  const Booking({
    required this.id,
    required this.author,
    required this.image,
    required this.price,
    required this.title,
    required this.tickets,
    required this.message,
    required this.customFirstName,
    required this.customLastName,
    required this.customEmail,
    required this.customPhone,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.instagram,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author == other.author &&
          image == other.image &&
          price == other.price &&
          title == other.title &&
          tickets == other.tickets &&
          message == other.message &&
          customFirstName == other.customFirstName &&
          customLastName == other.customLastName &&
          customEmail == other.customEmail &&
          instagram == other.instagram &&
          customPhone == other.customPhone &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      author.hashCode ^
      image.hashCode ^
      price.hashCode ^
      title.hashCode ^
      tickets.hashCode ^
      message.hashCode ^
      customFirstName.hashCode ^
      customLastName.hashCode ^
      customEmail.hashCode ^
      customPhone.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      instagram.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'Booking{ id: $id, author: $author, image: $image, price: $price, title: $title, tickets: $tickets, message: $message, customFirstName: $customFirstName, customLastName: $customLastName, customEmail: $customEmail, customPhone: $customPhone,  startDate: $startDate, endDate: $endDate, status: $status,}';
  }

  Booking copyWith({
    int? id,
    String? author,
    String? image,
    double? price,
    String? title,
    int? tickets,
    String? message,
    String? customFirstName,
    String? customLastName,
    String? customEmail,
    String? customPhone,
    String? instagram,
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      author: author ?? this.author,
      image: image ?? this.image,
      price: price ?? this.price,
      title: title ?? this.title,
      tickets: tickets ?? this.tickets,
      message: message ?? this.message,
      customFirstName: customFirstName ?? this.customFirstName,
      customLastName: customLastName ?? this.customLastName,
      customEmail: customEmail ?? this.customEmail,
      customPhone: customPhone ?? this.customPhone,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      instagram: instagram ?? this.instagram,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'image': image,
      'price': price,
      'title': title,
      'tickets': tickets,
      'message': message,
      'customFirstName': customFirstName,
      'customLastName': customLastName,
      'customEmail': customEmail,
      'customPhone': customPhone,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'instagram': instagram,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    BookingStatus bookingStatus = BookingStatus.expired;
    switch (map['status']) {
      case 'waiting':
        bookingStatus = BookingStatus.waiting;
        break;
      case 'confirmed':
        bookingStatus = BookingStatus.confirmed;
        break;
      case 'paid':
        bookingStatus = BookingStatus.paid;
      case 'cancelled':
        bookingStatus = BookingStatus.cancelled;
      case 'expired':
        bookingStatus = BookingStatus.expired;
      case 'deleted':
        bookingStatus = BookingStatus.deleted;
        break;
    }
    return Booking(
      id: map.from('ID'),
      author: map.from('bookings_author'),
      image: map.from('featured_image'),
      price: map.from('price'),
      title: map['title'],
      tickets: map.from('comment.tickets'),
      message: map.from('comment.message'),
      customFirstName: map.from('comment.first_name'),
      customLastName: map.from('comment.last_name'),
      customEmail: map.from('comment.email'),
      customPhone: map.from('comment.phone') ?? '',
      startDate: map.from('date_start'),
      endDate: map.from('date_end'),
      status: bookingStatus,
      instagram: map.from('instagram'),
    );
  }

//</editor-fold>
}
