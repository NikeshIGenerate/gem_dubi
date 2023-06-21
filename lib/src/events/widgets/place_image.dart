import 'package:flutter/material.dart';
import 'package:gem_dubi/common/utils/map_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceImage extends StatelessWidget {
  const PlaceImage({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  final double lat;
  final double lng;

  openMap() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    String appleUrl = 'http://maps.apple.com/?ll=$lat,$lng&dirflg=d';

    // String url = Platform.isAndroid ? googleUrl : appleUrl;
    String url = googleUrl;

    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openMap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 480 / 260,
              child: Image.network(
                buildMapImageUrl(lat, lng, 14),
                fit: BoxFit.cover,
              ),
            ),
            // const CircleAvatar(
            //   backgroundColor: Colors.white,
            //   radius: 14,
            //   child: CircleAvatar(
            //     radius: 12,
            //     backgroundColor: Color(0xff212121),
            //     child: CircleAvatar(
            //       radius: 5,
            //       backgroundColor: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
