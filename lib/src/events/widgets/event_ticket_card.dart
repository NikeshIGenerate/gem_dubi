import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/entities/booking.dart';
import 'package:gem_dubi/src/events/widgets/booking_status_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EventTicketCard extends HookConsumerWidget {
  const EventTicketCard({
    Key? key,
    required this.booking,
    this.onCancelBooking,
  }) : super(key: key);

  final Booking booking;
  final Function? onCancelBooking;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final animation = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    final animationValue = useAnimation(
      CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn,
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          if (animation.isCompleted) {
            animation.reverse();
          } else {
            animation.forward();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(booking.image),
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            color: Colors.black26,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_outlined),
                              const SizedBox(width: 10),
                              Text(DateFormat('hh a').format(booking.startDate)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(width: 10),
                              Text(DateFormat.yMMMEd().format(booking.startDate)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          if (booking.price > 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.attach_money),
                                const SizedBox(width: 10),
                                Text(
                                  booking.price.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    BookingStatusWidget(status: booking.status),
                  ],
                ),
                const SizedBox(height: 5),
                Text(booking.message ?? ''),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    booking.title,
                    style: theme.textTheme.headlineMedium!.copyWith(fontSize: 25),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRect(
                  clipBehavior: Clip.antiAlias,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: animationValue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Reference No'),
                                  Text(booking.id.toString()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Name'),
                                  Text(booking.customerName),
                                ],
                              ),
                              if (booking.instagram != null) ...[
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Instagram'),
                                    Text(booking.instagram!),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Email'),
                                  Text(booking.customEmail),
                                ],
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (booking.canCancel)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900]?.withOpacity(.7),
                            ),
                            onPressed: () {
                              animation.reverse();
                              onCancelBooking!();
                            },
                            child: const Text('Cancel'),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
