import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

double _degToRad(double deg) => deg * (pi / 180);

double distanceInMeters(GeoPoint a, GeoPoint b) {
  const earthRadius = 6371000; // meters

  final dLat = _degToRad(b.latitude - a.latitude);
  final dLon = _degToRad(b.longitude - a.longitude);

  final lat1 = _degToRad(a.latitude);
  final lat2 = _degToRad(b.latitude);

  final h = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) *
          sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(h), sqrt(1 - h));

  return earthRadius * c;
}

bool isNear(GeoPoint a, GeoPoint b, double thresholdMeters) {
  return distanceInMeters(a, b) <= thresholdMeters;
}