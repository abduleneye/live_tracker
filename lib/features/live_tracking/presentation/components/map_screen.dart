import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatefulWidget {
  final Function(RoadInfo) onLocationUpdate;

  const MapScreen({super.key, required this.onLocationUpdate});

  @override
  State<MapScreen> createState() => _MapViewState();
}

class _MapViewState extends State<MapScreen> {
  late MapController controller;

  StreamSubscription<GeoPoint>? sub;
  GeoPoint? previousPoint;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(latitude: 9.0579, longitude: 7.4951),
    );
  }

  // 🔥 Stream replaces Timer
  Stream<GeoPoint> _simulateMovement(List<GeoPoint> path) async* {
    for (final point in path) {
      await Future.delayed(const Duration(milliseconds: 800));
      yield point;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> drawRoadPickUpToDrop() async {
      int currentIndex = 0;

      GeoPoint start = GeoPoint(latitude: 9.0765, longitude: 7.3986);
      GeoPoint end   = GeoPoint(latitude: 9.0048642, longitude: 7.6922897);

      await controller.clearAllRoads();

      // Destination marker
      await controller.addMarker(
        end,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 80),
        ),
      );

      // Get route once
      final road = await controller.drawRoad(
        start,
        end,
        roadType: RoadType.bike,
        roadOption: RoadOption(
          zoomInto: false,
          roadColor: Colors.red,
          roadWidth: 10,
        ),
      );

      final List<GeoPoint> fullPath = road.route; // ✅ no + [end]
      if (fullPath.isEmpty) return;

      // 🔥 Cancel previous stream if any
      sub?.cancel();
      // 🔥 Listen to movement stream
      sub = _simulateMovement(fullPath).listen((currentPoint) async {
        if(isUpdating) return; // prevent overlap
        isUpdating = true;

        // Move marker
        if (previousPoint != null) {
          await controller.changeLocationMarker(
            oldLocation: previousPoint!,
            newLocation: currentPoint,
            markerIcon: MarkerIcon(
              icon: Icon(Icons.directions_bike_rounded,
                  color: Colors.red, size: 80),
            ),
          );
        }
        else {
          // First marker
          await controller.addMarker(
            currentPoint,
            markerIcon: MarkerIcon(
              icon: Icon(Icons.directions_bike_rounded,
                  color: Colors.red, size: 80),
            ),
          );
        }

        previousPoint = currentPoint;

        // 🔥 Update route occasionally
        if (currentIndex % 4 == 0) {
          final newRoad = await controller.drawRoad(
            currentPoint,
            end,
            roadType: RoadType.bike,
            roadOption: RoadOption(
              zoomInto: false,
              roadColor: Colors.red,
              roadWidth: 10,
            ),
          );

          widget.onLocationUpdate(newRoad);
          print("MAP ETA Time: ${newRoad.duration}");
        }

        currentIndex++;
        isUpdating = false;
      });
    }

    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        zoomOption: ZoomOption(initZoom: 16),
        showDefaultInfoWindow: true,
      ),
      onMapIsReady: (isReady) {
        if (isReady) {
          drawRoadPickUpToDrop();
        }
      },
    );
  }

  @override
  void dispose() {
    sub?.cancel();
    controller.dispose();
    super.dispose();
  }
}