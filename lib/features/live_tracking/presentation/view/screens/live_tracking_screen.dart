import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_tracker/core/utils/app_colors.dart';
import 'package:live_tracker/core/utils/app_text_styles.dart';

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
  DateTime? whenArrived;
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

              },
                whenArrived: (timeArrived) {
                setState(() {
                  whenArrived = timeArrived;

                });

                },),

              Positioned.fill(
                child: SafeArea(
                  child: Stack(
                    children: [

                      // TOP BAR
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                                // Center title
                                Text(
                                  "Live Tracking",
                                  style: AppTextStyles.appBar,
                                ),

                                // Left arrow
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.background,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // BOTTOM CARD
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: BottomCard(
                          roadInfo: roadInfo,
                          hasArrived: hasArrived,
                          whenArrived: whenArrived,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ));
  }
}
