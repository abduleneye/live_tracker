import 'dart:async';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_tracker/features/live_tracking/di/tracking_providers.dart';

import '../../domain/repository/tracking_repo.dart';
class TrackingViewmodel extends Notifier<GeoPoint?>{
  late TrackingRepo repo;
  StreamSubscription? _sub;
  @override
  GeoPoint? build() {
    repo = ref.read(trackingRepoProvider);
    return null;

  }

  void startTracking(List<GeoPoint> path){
    _sub?.cancel();
    
    _sub = repo.startTracking(path).listen((pos){

      state = pos;
    });
  }

  void stop(){
    _sub?.cancel();
  }

}