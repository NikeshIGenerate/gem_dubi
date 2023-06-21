import 'package:flutter/material.dart';
import 'package:gem_dubi/src/events/entities/booking.dart';

class BookingStatusWidget extends StatelessWidget {
  const BookingStatusWidget({Key? key, required this.status}) : super(key: key);

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.displayName),
      backgroundColor: status.color,
    );
  }
}
