import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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

    Future<void> startMoving() async {
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
            roadColor: Colors.red,
            roadWidth: 20,
          ),
        );
      });    }    //   height: double.infinity,
    //     width: double.infinity,
    //
    //     "assets/images/map_img.png"
    // );
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        zoomOption: ZoomOption(initZoom: 16)
      ),
      onMapIsReady: (isReady){
        startMoving();
         // drawRoute();
      },


    );
  }
}
