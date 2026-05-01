import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:live_tracker/core/utils/app_colors.dart';
import 'package:live_tracker/features/live_tracking/presentation/components/bottom_card.dart';
import 'package:live_tracker/features/live_tracking/presentation/components/map_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  RoadInfo? roadInfo;
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
              },),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BottomCard(
                    roadInfo: roadInfo,
                  ),
                  SizedBox(height: 20,)
                ],
              )
            ],
          ),
        ));
  }
}
