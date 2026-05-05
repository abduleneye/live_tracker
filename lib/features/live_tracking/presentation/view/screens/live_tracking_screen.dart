import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:live_tracker/core/utils/app_colors.dart';

import '../components/bottom_card.dart';
import '../components/map_screen.dart';
class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  RoadInfo? roadInfo;
  bool hasArrived = false;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
         backgroundColor: AppColors.temp,
          body: Stack(
            children: [
              MapScreen(onLocationUpdate: (newRoadInfo) {
                setState(() {
                  roadInfo = newRoadInfo;
                  print("LTS ETA Time:${roadInfo?.duration}");

                });
              }, hasArrived: (arrivalStatus) {
                setState(() {
                  hasArrived = arrivalStatus;
                 // print("LTS ETA Time:${roadInfo?.duration}");

                });


              },),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BottomCard(
                    roadInfo: roadInfo,
                    hasArrived: hasArrived,
                  ),
                  SizedBox(height: 20,)
                ],
              )
            ],
          ),
        ));
  }
}
