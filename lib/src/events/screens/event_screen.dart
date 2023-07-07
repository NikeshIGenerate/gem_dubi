import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/utils/state_theme.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/events/screens/up_coming_ticket_screen.dart';
import 'package:gem_dubi/src/events/widgets/place_image.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

import '../widgets/images_widget.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({Key? key, required this.listing}) : super(key: key);

  final EventListing listing;

  @override
  ConsumerState createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> with ConsumerStateTheme, SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late TabController _tabController;
  final eventDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    print(widget.listing);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(),
                  ),
                ),
                FlexibleSpaceBar(
                  title: Text(widget.listing.title),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: ImagesWidget(images: widget.listing.images),
                      ),
                      IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.scaffoldBackgroundColor,
                                Colors.transparent,
                              ],
                              begin: const Alignment(0, 1),
                              end: const Alignment(0, 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendarDays,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Event Date'),
                            const SizedBox(height: 3),
                            Text(
                              widget.listing.multiDayEvent
                                  ? '${intl.DateFormat("dd MMM, yyyy").format(widget.listing.startDate)} at ${intl.DateFormat("HH:mm a").format(widget.listing.startDate)}'
                                  : intl.DateFormat('d MMM, yyyy').format(widget.listing.startDate),
                              style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.listing.multiDayEvent) const SizedBox(width: 10),
                if (widget.listing.multiDayEvent)
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.calendarDays,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Event End'),
                              const SizedBox(height: 3),
                              Text(
                                '${intl.DateFormat("dd MMM, yyyy").format(widget.listing.endDate!)} at ${intl.DateFormat("HH:mm a").format(widget.listing.endDate!)}',
                                style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Icon(
            //       FontAwesomeIcons.calendarDays,
            //       color: Colors.white,
            //     ),
            //     const SizedBox(width: 6),
            //     Text(
            //       widget.listing.multiDayEvent
            //           ? '${widget.listing.startDate.day} - ${intl.DateFormat("d MMM, yyyy").format(widget.listing.endDate!)}'
            //           : intl.DateFormat('d MMM, yyyy').format(widget.listing.endDate!),
            //       style: theme.textTheme.titleSmall,
            //     ),
            //     const Spacer(),
            //     const Icon(
            //       FontAwesomeIcons.clock,
            //       color: Colors.white,
            //     ),
            //     const SizedBox(width: 6),
            //     Text(
            //       [
            //         intl.DateFormat('h a').format(widget.listing.startDate),
            //         if (widget.listing.multiHourEvent) intl.DateFormat('h a').format(widget.listing.endDate!),
            //       ].join(' - '),
            //       style: theme.textTheme.titleSmall,
            //     ),
            //     const Spacer(),
            //   ],
            // ),
            const SizedBox(height: 30),
            SizedBox(
              height: 30,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: const BoxDecoration(),
                padding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
                indicatorWeight: 1.0,
                labelPadding: const EdgeInsets.only(right: 10),
                unselectedLabelColor: Colors.grey.shade700,
                labelStyle: const TextStyle(fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Privileges'),
                  Tab(text: 'Deliverables'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: _tabController.index == 0
                  ? Text(widget.listing.description)
                  : _tabController.index == 1
                      ? Text(widget.listing.privileges ?? '')
                      : Text(widget.listing.deliverables ?? ''),
            ),
            if (widget.listing.instagram != '' && widget.listing.instagram != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      try {
                        await launchUrl(Uri.parse(widget.listing.instagram!), mode: LaunchMode.externalApplication);
                      } catch (err) {
                        print(err);
                        showSnackMessage(title: 'Error', text: 'Invalid Instagram Profile', icon: Icons.error);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white)),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ImageIcon(
                            AssetImage('assets/images/instagram.png'),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Instagram',
                            style: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),
            PlaceImage(
              lat: widget.listing.lat,
              lng: widget.listing.lng,
            ),
            const SizedBox(height: 30),
            // AspectRatio(
            //   aspectRatio: 1,
            //   child: MultiImageViewer(
            //     imageUrls: widget.listing.images,
            //   ),
            // ),
            // const SizedBox(height: 60),

            // --------------------

            // Text('Guests', style: theme.textTheme.titleMedium),
            // Row(
            //   children: [
            //     Icon(guests > 1 ? Icons.groups : Icons.person, size: 40),
            //     const SizedBox(width: 10),
            //     IconButton(
            //       onPressed: () {
            //         setState(() {
            //           guests--;
            //
            //           if (guests < 1) guests = 1;
            //         });
            //       },
            //       icon: const Icon(Icons.remove_circle_outline),
            //     ),
            //     Text(guests.toString(), style: theme.textTheme.displaySmall),
            //     IconButton(
            //       onPressed: () {
            //         setState(() => guests++);
            //       },
            //       icon: const Icon(Icons.add_circle_outline),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        style: !widget.listing.isPast
                            ? ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              )
                            : null,
                        onPressed: widget.listing.isPast || widget.listing.alreadyBooked
                            ? null
                            : () async {
                                DateTime? eventDate = widget.listing.endDate;
                                if (widget.listing.multiDayEvent) {
                                  bookTicket();
                                  return;
                                }
                                if (eventDate == null) {
                                  showSnackMessage(title: 'Error', text: 'Please select a booking date', icon: Icons.error);
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                ref
                                    .read(eventControllerRef)
                                    .bookATicket(
                                      listing: widget.listing,
                                      user: ref.read(loginProviderRef).user,
                                      tickets: 1,
                                      eventDate: eventDate,
                                    )
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  router.pushReplacement(const UpComingBookingsScreen());
                                }).catchError((e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSnackMessage(title: 'Error', text: 'Error while booking the event', icon: Icons.error);
                                });
                              },
                        child: Text(
                          widget.listing.isPast
                              ? 'Event has ended'
                              : widget.listing.alreadyBooked
                                  ? 'Already Requested'
                                  : 'Request Invitation',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void bookTicket() async {
    eventDateController.text = '';
    DateTime? selectedDate;
    if (widget.listing.multiDayEvent) {
      var response = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        elevation: 8,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: eventDateController,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: 'Select Booking Date',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      showCursor: false,
                      readOnly: true,
                      onTap: () async {
                        selectedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.listing.startDate,
                          firstDate: widget.listing.startDate,
                          lastDate: widget.listing.endDate!,
                        );
                        if (selectedDate != null) {
                          eventDateController.text = intl.DateFormat('dd-MM-yyyy').format(selectedDate!);
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          if (selectedDate == null) {
                            Navigator.of(ctx).pop();
                            showSnackMessage(title: 'Error', text: 'Please select a booking date', icon: Icons.error);
                            return;
                          }
                          Navigator.of(ctx).pop(true);
                        },
                        child: const Text('Book Now'),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          });
        },
      );
      if (response != null) {
        setState(() {
          _isLoading = true;
        });
        ref
            .read(eventControllerRef)
            .bookATicket(
              listing: widget.listing,
              user: ref.read(loginProviderRef).user,
              tickets: 1,
              eventDate: selectedDate!,
            )
            .then((value) {
          setState(() {
            _isLoading = false;
          });
          router.pushReplacement(const UpComingBookingsScreen());
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          showSnackMessage(title: 'Error', text: 'Error while booking the event', icon: Icons.error);
        });
      }
    }
  }

  void showSnackMessage({required String title, required String text, required IconData icon, Color color = Colors.red, int seconds = 3}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
        backgroundColor: color,
      ),
    );
  }
}
