import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
abstract class TrackingRepo{
Stream<GeoPoint> startTracking(List<GeoPoint> path);

}