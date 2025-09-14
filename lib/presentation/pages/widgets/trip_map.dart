import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../entities/stopover.dart';
import '../../../l10n/app_localizations.dart';

/// A widget that displays a Google Map showing a list of stopovers.
///
/// This widget automatically places markers for each stopover and draws a
/// polyline connecting them in the order they appear in the list. It also
/// adjusts the map's camera to fit all markers on the screen.
class TripMap extends StatefulWidget {
  /// The list of stopovers to be displayed on the map.
  final List<Stopover> stopovers;

  /// A callback function that is called when the map is ready.
  ///
  /// The [controller] of the GoogleMap is passed to this function,
  /// allowing the parent widget to interact with the map.
  final Function(GoogleMapController controller) onMapReady;

  /// The constructor method
  const TripMap({super.key, required this.stopovers, required this.onMapReady});

  @override
  State<TripMap> createState() => _TripMapState();
}

class _TripMapState extends State<TripMap> {
  /// A set to store the markers for each stopover.
  final Set<Marker> markers = {};

  /// A set to store the polyline representing the trip route
  final Set<Polyline> polylines = {};

  /// A completer to handle the async creation of the [GoogleMapController]
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _createMapElements();
  }

  /// Creates markers and polylines from the list of stopovers.
  ///
  /// This method iterates through the [stopovers] list, creates a [Marker] for
  /// each one, and adds their positions to a list for creating the [Polyline].
  /// The markers and polyline are then added to their respective sets.
  void _createMapElements() {
    final polylinePoints = <LatLng>[];

    for (var stopover in widget.stopovers) {
      final position = LatLng(stopover.latitude, stopover.longitude);

      final marker = Marker(
        markerId: MarkerId(stopover.id.toString()),
        position: position,
        infoWindow: InfoWindow(title: stopover.cityName),
      );
      markers.add(marker);

      polylinePoints.add(position);
    }

    if (polylinePoints.length > 1) {
      final polyline = Polyline(
        polylineId: PolylineId('trip_route'),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
        jointType: JointType.round,
        patterns: [PatternItem.dash(10), PatternItem.gap(10)],
      );
      polylines.add(polyline);
    }
  }

  /// Moves the map camera to show all markers at once.
  ///
  /// This method calculates the geographic bounds that encompass all markers
  /// and animates the camera to fit those bounds with a specified padding.
  Future<void> _moveCameraToAllMarkers() async {
    final controller = await _controllerCompleter.future;

    if (markers.isEmpty) {
      return;
    }

    var minLat = markers.first.position.latitude;
    var maxLat = markers.first.position.latitude;
    var minLon = markers.first.position.longitude;
    var maxLon = markers.first.position.longitude;

    for (var marker in markers) {
      minLat = min(minLat, marker.position.latitude);
      maxLat = max(maxLat, marker.position.latitude);
      minLon = min(minLon, marker.position.longitude);
      maxLon = max(maxLon, marker.position.longitude);
    }

    var bounds = LatLngBounds(
      southwest: LatLng(minLat, minLon),
      northeast: LatLng(maxLat, maxLon),
    );

    final padding = 50.0;
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (markers.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noStopovers));
    }

    final initialCameraPosition = markers.first.position;

    return SizedBox(
      height: 300,
      child: GoogleMap(
        rotateGesturesEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          _controllerCompleter.complete(controller);
          _moveCameraToAllMarkers();
        },
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 10,
        ),
        markers: markers,
        polylines: polylines,
      ),
    );
  }
}
