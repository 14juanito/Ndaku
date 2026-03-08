import 'package:google_maps_flutter/google_maps_flutter.dart';

class KinshasaBounds {
  const KinshasaBounds._();

  static const LatLng center = LatLng(-4.4419, 15.2663);

  static const double minLat = -4.75;
  static const double maxLat = -4.20;
  static const double minLng = 14.95;
  static const double maxLng = 15.55;

  static final LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(minLat, minLng),
    northeast: const LatLng(maxLat, maxLng),
  );

  static bool contains(LatLng position) {
    return position.latitude >= minLat &&
        position.latitude <= maxLat &&
        position.longitude >= minLng &&
        position.longitude <= maxLng;
  }
}
