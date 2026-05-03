import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_tracker/features/live_tracking/presentation/viewmodel/tracking_viewmodel.dart';

import '../../../core/services/tracking_service.dart';
import '../data/repo_implementation/tracking_repo_implementation.dart';
import '../domain/repository/tracking_repo.dart';

final trackingServiceProvider = Provider<TrackingService>((ref) {
  return TrackingService();
});

final trackingRepoProvider = Provider<TrackingRepo>((ref) {
  return TrackingRepoImplementation(
    trackingService: ref.read(trackingServiceProvider),
  );
});


final trackingControllerProvider =
NotifierProvider<TrackingViewmodel, GeoPoint?>(
  TrackingViewmodel.new,
);