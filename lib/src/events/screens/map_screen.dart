import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _isInit = true;
  List<EventListing> events = [];
  final _controller = Completer<GoogleMapController>();
  CameraPosition? _currentCameraPosition;
  Map<MarkerId, Marker> markers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final eventController = ref.read(eventControllerRef);
      events = eventController.listings;
      if (events.isNotEmpty) {
        _currentCameraPosition = CameraPosition(
          target: LatLng(events.first.lat, events.first.lng),
          zoom: 12,
        );
        for (var element in events) {
          _addMarker(
            LatLng(element.lat, element.lng),
            element.id.toString(),
            element,
          );
        }
      }
      _isInit = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInit && _currentCameraPosition == null
          ? const LoadingWidget(
              color: Colors.white,
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _currentCameraPosition!,
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 3.0,
                          blurRadius: 4.0
                        )
                      ]
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _addMarker(LatLng position, String id, EventListing eventListing) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      infoWindow: InfoWindow(
        title: eventListing.title,
        snippet: '${DateFormat('dd MMMM yyyy').format(eventListing.startDate)} at ${DateFormat('hh:mm a').format(eventListing.startDate)}'
      ),
      position: position,
    );
    markers[markerId] = marker;
  }
}
