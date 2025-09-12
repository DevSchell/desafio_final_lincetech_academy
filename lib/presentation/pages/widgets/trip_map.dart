// trip_map.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../entities/stopover.dart';

class TripMap extends StatefulWidget {
  final List<Stopover> stopovers;
  final Function(GoogleMapController controller) onMapReady;

  const TripMap({super.key, required this.stopovers, required this.onMapReady});

  @override
  State<TripMap> createState() => _TripMapState();
}

class _TripMapState extends State<TripMap> {
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {
    _controllerCompleter.complete(controller);
    _moveCameraToAllMarkers();
    widget.onMapReady(controller);
  }

  @override
  void initState() {
    super.initState();
    _createMapElements();
  }

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
      return Center(child: Text('There are no stopovers to be shown'));
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
