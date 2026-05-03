import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class  TrackingService {
  Stream<GeoPoint> simulateMovement(List<GeoPoint> path) async* {
    for (final point in path) {
      await Future.delayed(const Duration(milliseconds: 800));
      yield point;
    }
  }
}