import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/common/widgets/refresh_widget.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/widgets/event_ticket_card.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpComingBookingsScreen extends HookConsumerWidget {
  const UpComingBookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final eventController = ref.watch(eventControllerRef);
    final loginController = ref.watch(loginProviderRef);
    useEffect(() {
      if (!loginController.isLoggedIn) return;

      Future.delayed(const Duration(milliseconds: 80), () {
        eventController.getUpComingBooking(user: loginController.user);
      });
    }, [loginController.isLoggedIn]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: SafeArea(
        child: !loginController.isLoggedIn
            ? const Center(
                child: Text('Login to show your bookings'),
              )
            : Visibility(
                visible: !eventController.loadingBookings,
                replacement: const LoadingWidget(
                  color: Colors.white,
                ),
                child: RefreshWidget(
                  onRefresh: () async {
                    await eventController.getUpComingBooking(user: loginController.user);
                  },
                  child: eventController.upComingBookings.isEmpty
                      ? const Center(
                          child: Text(
                            'empty\nThere are no upcoming tickets',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView(
                          children: [
                            const SizedBox(height: 10),
                            for (var item in eventController.upComingBookings)
                              EventTicketCard(
                                booking: item,
                                onCancelBooking: () {
                                  ref.read(eventControllerRef).cancelBooking(item.id, pastEvents: false);
                                },
                              ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
