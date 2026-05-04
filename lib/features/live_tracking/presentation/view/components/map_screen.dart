import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/tracking_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  final Function(RoadInfo) onLocationUpdate;

  const MapScreen({super.key, required this.onLocationUpdate});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late MapController controller;
  GeoPoint? end;
  GeoPoint? previousPoint;
  bool isUpdating = false;
  int counter = 0;

  @override
  void initState() {
    super.initState();

    controller = MapController(
      initPosition: GeoPoint(latitude: 9.0579, longitude: 7.4951),
    );
  }

  @override
  Widget build(BuildContext context) {


    ref.listen<GeoPoint?>(trackingControllerProvider, (prev, currentPoint) async {
      if (currentPoint == null) return;
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
        await controller.moveTo(currentPoint, animate: true);

      } else {
        await controller.addMarker(
          currentPoint,
          markerIcon: MarkerIcon(
            icon: Icon(Icons.directions_bike_rounded,
                color: Colors.red, size: 80),
          ),
        );
      }

      previousPoint = currentPoint;

      // 🔥 IMPORTANT: control frequency (avoid lag)
      counter++;

    //  if (counter % 4 == 0) {
        final newRoad = await controller.drawRoad(
          currentPoint,
          end!,
          roadType: RoadType.bike,
          roadOption: RoadOption(
            zoomInto: false,
            roadColor: Colors.red,
            roadWidth: 10,
          ),
        );

        // 👇 THIS IS WHAT YOU LOST — ADD IT BACK
        widget.onLocationUpdate(newRoad);

        print("MAP ETA Time: ${newRoad.duration}");
      isUpdating = false;

      //}
    }



    );


    Future<void> drawRoadPickUpToDrop() async {
      GeoPoint start = GeoPoint(latitude: 9.0765, longitude: 7.3986);
       end  = GeoPoint(latitude: 9.0579, longitude: 7.4951);
// GeoPoint(latitude: 9.0048642, longitude: 7.6922897);

      await controller.clearAllRoads();

      await controller.addMarker(
        end!,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 80),
        ),
      );

      final road = await controller.drawRoad(
        start,
        end!,
        roadType: RoadType.bike,
        roadOption: RoadOption(
          zoomInto: false,
          roadColor: Colors.red,
          roadWidth: 10,
        ),
      );

      final fullPath = road.route;
      if (fullPath.isEmpty) return;

      // 🔥 ONLY start tracking here
      ref.read(trackingControllerProvider.notifier).startTracking(fullPath);
    }

    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        zoomOption: ZoomOption(initZoom: 15.h),
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
    controller.dispose();
    super.dispose();
  }
}