import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/emergency_service.dart';

class LocationService {
  static LocationService? _instance;
  Position? _currentPosition;

  LocationService._();

  static LocationService get instance {
    _instance ??= LocationService._();
    return _instance!;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return _currentPosition;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Get cached position
  Position? getCachedPosition() {
    return _currentPosition;
  }

  /// Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Find nearest hospitals
  Future<List<Hospital>> findNearestHospitals(
    List<Hospital> hospitals, {
    int limit = 10,
    double maxDistance = 50000, // 50km in meters
  }) async {
    final position = await getCurrentPosition();
    if (position == null) {
      return hospitals.take(limit).toList();
    }

    // Calculate distances and sort
    final hospitalsWithDistance = hospitals.map((hospital) {
      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        hospital.latitude,
        hospital.longitude,
      );
      return MapEntry(hospital, distance);
    }).where((entry) => entry.value <= maxDistance).toList();

    // Sort by distance
    hospitalsWithDistance.sort((a, b) => a.value.compareTo(b.value));

    return hospitalsWithDistance
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  /// Find nearest pharmacies
  Future<List<Pharmacy>> findNearestPharmacies(
    List<Pharmacy> pharmacies, {
    int limit = 10,
    double maxDistance = 20000, // 20km in meters
  }) async {
    final position = await getCurrentPosition();
    if (position == null) {
      return pharmacies.take(limit).toList();
    }

    // Calculate distances and sort
    final pharmaciesWithDistance = pharmacies.map((pharmacy) {
      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        pharmacy.latitude,
        pharmacy.longitude,
      );
      return MapEntry(pharmacy, distance);
    }).where((entry) => entry.value <= maxDistance).toList();

    // Sort by distance
    pharmaciesWithDistance.sort((a, b) => a.value.compareTo(b.value));

    return pharmaciesWithDistance
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get distance to hospital
  Future<double?> getDistanceToHospital(Hospital hospital) async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    return calculateDistance(
      position.latitude,
      position.longitude,
      hospital.latitude,
      hospital.longitude,
    );
  }

  /// Get distance to pharmacy
  Future<double?> getDistanceToPharmacy(Pharmacy pharmacy) async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    return calculateDistance(
      position.latitude,
      position.longitude,
      pharmacy.latitude,
      pharmacy.longitude,
    );
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} م';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} كم';
    }
  }

  /// Get estimated travel time (rough calculation)
  String getEstimatedTravelTime(double distanceInMeters) {
    // Assuming average speed of 30 km/h in city
    final hours = distanceInMeters / 1000 / 30;
    final minutes = (hours * 60).round();
    
    if (minutes < 60) {
      return '$minutes دقيقة';
    } else {
      final hrs = minutes ~/ 60;
      final mins = minutes % 60;
      return '$hrs ساعة ${mins > 0 ? '$mins دقيقة' : ''}';
    }
  }

  /// Check if location is in Setif area (rough bounds)
  bool isInSetifArea(double latitude, double longitude) {
    // Rough bounds for Setif province
    const double setifLatMin = 35.5;
    const double setifLatMax = 36.5;
    const double setifLonMin = 5.0;
    const double setifLonMax = 6.0;

    return latitude >= setifLatMin &&
           latitude <= setifLatMax &&
           longitude >= setifLonMin &&
           longitude <= setifLonMax;
  }

  /// Open maps app with directions
  Future<void> openMapsWithDirections(double latitude, double longitude) async {
    // This would typically use url_launcher to open maps
    // For now, we'll just show the coordinates
    print('Opening maps to: $latitude, $longitude');
  }

  /// Get location permission status for UI
  Future<String> getLocationPermissionStatus() async {
    final permission = await checkLocationPermission();
    
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return 'مُفعّل';
      case LocationPermission.denied:
        return 'مرفوض';
      case LocationPermission.deniedForever:
        return 'مرفوض نهائياً';
      case LocationPermission.unableToDetermine:
        return 'غير محدد';
    }
  }

  /// Request to enable location services
  Future<bool> requestLocationService() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Open location settings
      await Geolocator.openLocationSettings();
      return await isLocationServiceEnabled();
    }
    return true;
  }

  /// Clear cached position
  void clearCachedPosition() {
    _currentPosition = null;
  }
}
