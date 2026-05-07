import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:live_tracker/core/utils/location_utils.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../di/tracking_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  final Function(RoadInfo) onLocationUpdate;
  final Function(bool) hasArrived;
  final Function(DateTime) whenArrived;



  const MapScreen({super.key, required this.onLocationUpdate, required this.hasArrived, required this.whenArrived});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends ConsumerState<MapScreen> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectSub;
  bool hasInternet = false;
  late MapController controller;
  GeoPoint? end;
  GeoPoint? previousPoint;
  bool isUpdating = false;
  bool hasArrivedTriggered = false;
  //late Timer arrivalTimer;
  int counter = 0;

  Future<void> handleConnectivity(List<ConnectivityResult> result) async {
    Fluttertoast.showToast(msg: "Listening for network");

    final hasNetwork =
    result.any((r) => r != ConnectivityResult.none);

    final hasRealInternet =
    await InternetConnectionChecker().hasConnection;

    final isOnline = hasNetwork && hasRealInternet;

    setState(() {
      hasInternet = isOnline;
    });

    if (!isOnline && isUpdating) {
      showNetworkDropToast();
     //drawRoadPickUpToDrop();
    }
  }
  void showNoInternetDialog(BuildContext context, VoidCallback onRetry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("No Internet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // 👈 important
            children: [
              const Text(
                "Please check your connection and try again.",
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.containerColor,
                  ),
                  onPressed: () {
                   // Navigator.pop(context);
                    if(hasInternet){
                      onRetry();
                      Navigator.pop(context);
                    }else {
                      Fluttertoast.showToast(
                        msg: "Please check your internet connection",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
        );      },
    );
  }
  void showDeliveredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Package Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Your package has arrived, thanks for your patronage",
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.containerColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
        );      },
    );
  }
  void showNetworkDropToast(){
    Fluttertoast.showToast(
      msg: "Your network is disabled result might be in accurate",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _connectSub = _connectivity.onConnectivityChanged.listen((result) async {
      Fluttertoast.showToast(msg: "Listening for network");

      handleConnectivity(result);
    });
    controller = MapController(
      initPosition: GeoPoint(latitude: 9.0579, longitude: 7.4951),
    );


  }


  @override
  Widget build(BuildContext context) {


    ref.listen<GeoPoint?>(trackingControllerProvider, (prev, currentPoint) async {
      if (currentPoint == null) return;

      if (isUpdating) return;

      isUpdating = true;

      try {
        // move marker
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
        counter++;

       if(counter % 4 == 0){
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

         widget.onLocationUpdate(newRoad);

         print("ETA: ${newRoad.duration}");
       }

        // arrivalTimer = Timer.periodic(Duration(seconds: 2), (_) async {
        //   if (hasArrivedTriggered) {
        //     arrivalTimer.cancel();
        //     return;
        //   }

          if (isNear(currentPoint, end!, 50) && !hasArrivedTriggered) {
            hasArrivedTriggered = true;
            Fluttertoast.showToast(
              msg: "Has arrived",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            print("Has arrived");

            //hasArrivedTriggered = true;

           // arrivalTimer.cancel();

            await controller.moveTo(end!, animate: true);

           if (!context.mounted) return;
            showDeliveredDialog(context);
            widget.hasArrived(true);
            widget.whenArrived(DateTime.now());
          }
      //  });

      } catch (e) {
        print("TRACKING ERROR: $e");
      } finally {
        isUpdating = false;
      }
    });



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

      final  newRoad = await controller.drawRoad(
        start,
        end!,
        roadType: RoadType.bike,
        roadOption: RoadOption(
          zoomInto: false,
          roadColor: Colors.red,
          roadWidth: 10,
        ),
      );


      final fullPath = newRoad.route + [end!];
      if (fullPath.isEmpty) return;

      print("RAW ROUTE LENGTH: ${newRoad.route.length}");
      print("FULL PATH BEFORE TRACKING: $fullPath");

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
          Fluttertoast.showToast(
            msg: "Map Initialized...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          //drawRoadPickUpToDrop();



          if (hasInternet) {
            drawRoadPickUpToDrop();

            Fluttertoast.showToast(
              msg: "has internet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            showNoInternetDialog(
                context,
                    (){
                  drawRoadPickUpToDrop();
                }
            );
            Fluttertoast.showToast(
              msg: "no internet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            //showNoInternetUI();
          }
        }
        else{
          Fluttertoast.showToast(
            msg: "Initializing map...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

        }
      },



    );
  }

  @override
  void dispose() {
    controller.dispose();
    _connectSub?.cancel();
    super.dispose();
  }
}