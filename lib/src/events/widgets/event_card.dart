import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/events/screens/event_screen.dart';
import 'package:gem_dubi/src/events/widgets/images_widget.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';
import 'package:intl/intl.dart';

class ListingCard extends ConsumerWidget {
  ListingCard({
    Key? key,
    required this.listing,
    required this.refreshEventList,
  }) : super(key: key);

  final Listing listing;
  final Function refreshEventList;

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        if (ref.read(loginProviderRef).isLoggedIn) {
          router.push(EventScreen(listing: listing)).then((value) {
            refreshEventList();
          });
        } else {
          router.push(const LoginScreen());
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImagesWidget(images: listing.images, controller: controller),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: IconButton(
              //       style: IconButton.styleFrom(
              //         backgroundColor: Colors.white30,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       icon: const Icon(Icons.favorite, color: Colors.white),
              //       onPressed: () {},
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  // margin: EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0, .3),
                      end: Alignment(0, -1),
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Center(
                      //   child: SmoothPageIndicator(
                      //     controller: controller,
                      //     count: listing.images.length,
                      //     effect: const ScrollingDotsEffect(
                      //       dotHeight: 2,
                      //       dotColor: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      Text(
                        listing.title,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
                      ),
                      Text(
                        DateFormat('dd MMMM, yyyy').format(listing.startDate),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
