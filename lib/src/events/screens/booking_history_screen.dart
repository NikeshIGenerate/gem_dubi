import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gem_dubi/common/widgets/blue_background.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/common/widgets/refresh_widget.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/widgets/event_ticket_card.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookingHistoryScreen extends HookConsumerWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final eventController = ref.watch(eventControllerRef);
    final loginController = ref.watch(loginProviderRef);

    useEffect(() {
      if (!loginController.isLoggedIn) return;

      Future.delayed(const Duration(milliseconds: 0), () {
        eventController.getPreviousBooking(user: loginController.user);
      });
    }, []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My History'),
        flexibleSpace: const BlurBackground(),
      ),
      body: !loginController.isLoggedIn
          ? const Center(
              child: Text('Login to show your bookings'),
            )
          : Visibility(
              visible: !eventController.loadingBookings,
              replacement: const LoadingWidget(color: Colors.white),
              child: RefreshWidget(
                onRefresh: () async {
                  await eventController.getPreviousBooking(user: loginController.user);
                },
                child: eventController.previousBookings.isEmpty
                    ? const Center(
                        child: Text(
                          'empty\nThere are no history tickets',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView(
                        children: [
                          const SizedBox(height: 20),
                          for (var item in eventController.previousBookings)
                            EventTicketCard(
                              booking: item,
                              onCancelBooking: () {
                                ref.read(eventControllerRef).cancelBooking(item.id);
                              },
                            ),
                        ],
                      ),
              ),
            ),
    );
  }
}
