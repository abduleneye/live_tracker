import 'package:flutter_osm_interface/src/types/geo_point.dart';
import 'package:live_tracker/core/services/tracking_service.dart';
import 'package:live_tracker/features/live_tracking/domain/repository/tracking_repo.dart';
class TrackingRepoImplementation implements TrackingRepo{
  final TrackingService trackingService;
  TrackingRepoImplementation({required this.trackingService});
  @override
  Stream<GeoPoint> startTracking(List<GeoPoint> path) {
    return trackingService.simulateMovement(path);
  }

}