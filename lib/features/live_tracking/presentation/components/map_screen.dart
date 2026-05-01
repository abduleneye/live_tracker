import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  Timer? timer;
  List<GeoPoint> routePoints = [];

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(latitude: 9.0579, longitude: 7.4951)
    );
  }
  @override
  Widget build(BuildContext context) {

    Future<void> startMovingManual() async {
      final List<GeoPoint> fullPath = [
        GeoPoint(latitude: 9.0600, longitude: 7.4950),
        GeoPoint(latitude: 9.0602, longitude: 7.4956),
        GeoPoint(latitude: 9.0606, longitude: 7.4956),
        GeoPoint(latitude: 9.0606, longitude: 7.4962),
        GeoPoint(latitude: 9.0612, longitude: 7.4962),
        GeoPoint(latitude: 9.0612, longitude: 7.4968),
        GeoPoint(latitude: 9.0618, longitude: 7.4968),
        GeoPoint(latitude: 9.0622, longitude: 7.4972),
        GeoPoint(latitude: 9.0625, longitude: 7.4975),
      ];

      await controller.clearAllRoads();
     // await controller.removeMarkers();

      GeoPoint start = fullPath.first;
      GeoPoint end = fullPath.last;

      int currentIndex = 0;

      GeoPoint previousPoint = start;

      // Add end marker ONCE
      await controller.addMarker(
        end,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 80),
        ),
      );

      // // Add bike marker ONCE
      // await controller.addMarker(
      //   start,
      //   markerIcon: MarkerIcon(
      //     icon: Icon(Icons.bike_scooter, color: Colors.green, size: 80),
      //   ),
      // );

      // Draw full route once (optional)
      await controller.drawRoadManually(
        fullPath,
        RoadOption(
          roadColor: Colors.red,
          roadWidth: 20,
        ),
      );

      timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
        currentIndex++;

        // STOP FIRST (important)
        if (currentIndex >= fullPath.length) {
          timer.cancel();
          return;
        }

        final currentPoint = fullPath[currentIndex];

        // Move bike marker
        await controller.removeMarker(previousPoint);

        await controller.addMarker(
          currentPoint,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.bike_scooter, color: Colors.green, size: 80),
          ),
        );

        previousPoint = currentPoint;

        // Remaining path
        final remainingPath = fullPath.sublist(currentIndex);

        // ❗ CRITICAL FIX: DO NOT DRAW IF < 2 POINTS
        if (remainingPath.length < 2) {
          timer.cancel();
          await controller.clearAllRoads(); // optional cleanup
          return;
        }

        await controller.clearAllRoads();

        await controller.drawRoadManually(
          remainingPath,
          RoadOption(
            zoomInto: false,
            roadColor: Colors.red,
            roadWidth: 20,
          ),
        );
      });    }
    Future<void> startMovingAuto() async {
      Timer? timer;
      int currentIndex = 0;

      final List<GeoPoint> fullPath = [
        GeoPoint(latitude: 9.0600, longitude: 7.4950),
        GeoPoint(latitude: 9.0602, longitude: 7.4956),
        GeoPoint(latitude: 9.0606, longitude: 7.4956),
        GeoPoint(latitude: 9.0606, longitude: 7.4962),
        GeoPoint(latitude: 9.0612, longitude: 7.4962),
        GeoPoint(latitude: 9.0612, longitude: 7.4968),
        GeoPoint(latitude: 9.0618, longitude: 7.4968),
        GeoPoint(latitude: 9.0622, longitude: 7.4972),
        GeoPoint(latitude: 9.0625, longitude: 7.4975),
      ];

      GeoPoint previousPoint = fullPath.first;

      GeoPoint start = GeoPoint(latitude: 9.0765, longitude: 7.3986);
      GeoPoint end   = GeoPoint(latitude: 9.0579, longitude: 7.4951);
      // final start = fullPath.first;
      // final end = fullPath.last;

      // Clear map
      await controller.clearAllRoads();
     // await controller.removeMarkers();

      // Add destination marker (once)
      await controller.addMarker(
        end,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 80),
        ),
      );

      // Add driver marker (start)
      await controller.addMarker(
        start,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.bike_scooter, color: Colors.green, size: 80),
        ),
      );

      // Draw initial route
      await controller.drawRoad(
        start,
        end,
        roadType: RoadType.car,
        roadOption: RoadOption(
          roadColor: Colors.red,
          roadWidth: 20,
        ),
      );

      // Start movement simulation
      timer = Timer.periodic(const Duration(seconds: 2), (t) async {
        currentIndex++;

        if (currentIndex >= fullPath.length) {
          t.cancel();
          return;
        }

        final currentPoint = fullPath[currentIndex];

        // Move driver marker
        await controller.removeMarker(previousPoint);

        await controller.addMarker(
          currentPoint,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.bike_scooter, color: Colors.green, size: 80),
          ),
        );

        previousPoint = currentPoint;

        // 🔥 Recalculate route from new position
        await controller.clearAllRoads();

        await controller.drawRoad(
          currentPoint,
          end,
          roadType: RoadType.car,
          roadOption: RoadOption(
            roadColor: Colors.red,
            roadWidth: 20,
          ),
        );
      });
    }
    Future<void> drawRoadPickUpToDrop() async {
      int currentIndex = 0;
      bool isUpdating = false;

      GeoPoint start = GeoPoint(latitude: 9.0765, longitude: 7.3986);
      GeoPoint end   = GeoPoint(latitude: 9.0579, longitude: 7.4951);

      await controller.clearAllRoads();
      //await controller.removeMarkers();

      // Add destination marker
      await controller.addMarker(
        end,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 80),
        ),
      );

      // Add driver marker once
      // await controller.addMarker(
      //   start,
      //   markerIcon: MarkerIcon(
      //     icon: Icon(Icons.directions_bike_rounded, color: Colors.red, size: 80),
      //   ),
      // );

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

      final List<GeoPoint> fullPath = road.route + [end];
      if (fullPath.isEmpty) return;

      GeoPoint previousPoint = fullPath.first;

      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 800), (t) async {
        // prevent overlapping async calls
        if (isUpdating) return;
        isUpdating = true;

        currentIndex++;

        if (currentIndex >= fullPath.length) {
          t.cancel();
          isUpdating = false;
          return;
        }

        final currentPoint = fullPath[currentIndex];

        // 🚗 Move marker (still using remove/add since plugin limitation)
        await controller.clearAllRoads();
        await controller.removeMarker(previousPoint);
        await controller.addMarker(
          currentPoint,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.directions_bike_rounded, color: Colors.red, size: 80),
          ),
        );
       // await controller.centerMap;

        previousPoint = currentPoint;

        // Update route LESS frequently (every 5 steps)
       // if (currentIndex % 3 == 0) {
       // if (currentIndex % 4 == 0) {
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
       print("MAP ETA Time:${road.duration}");
       // }

        isUpdating = false;
     // }
      });
    }
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        zoomOption: ZoomOption(initZoom: 16),
        showDefaultInfoWindow: true
      ),
      onMapIsReady: (isReady){
        if(isReady){
          drawRoadPickUpToDrop();
        }
         // drawRoute();
      },


    );
  }
}
