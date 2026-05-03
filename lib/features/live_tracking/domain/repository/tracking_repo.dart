import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:live_tracker/features/live_tracking/presentation/state/tracking_state.dart';

abstract class TrackingRepo{
Stream<GeoPoint> startTracking(List<GeoPoint> path);

}