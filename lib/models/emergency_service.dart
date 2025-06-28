import 'package:json_annotation/json_annotation.dart';

part 'emergency_service.g.dart';

@JsonSerializable()
class Hospital {
  final String id;
  final String name;
  final String nameArabic;
  final String type; // public, private
  final List<String> specialties;
  final bool hasPediatric;
  final bool hasEmergency;
  final String address;
  final String phone;
  final String? emergencyPhone;
  final double latitude;
  final double longitude;
  final WorkingHours workingHours;

  Hospital({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.type,
    required this.specialties,
    required this.hasPediatric,
    required this.hasEmergency,
    required this.address,
    required this.phone,
    this.emergencyPhone,
    required this.latitude,
    required this.longitude,
    required this.workingHours,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => 
      _$HospitalFromJson(json);
  
  Map<String, dynamic> toJson() => _$HospitalToJson(this);
}

@JsonSerializable()
class Pharmacy {
  final String id;
  final String name;
  final String nameArabic;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final Map<String, String> workingHours;
  final bool nightService;
  final bool emergencyService;
  final bool? weekendOnly;

  Pharmacy({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.workingHours,
    required this.nightService,
    required this.emergencyService,
    this.weekendOnly,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) => 
      _$PharmacyFromJson(json);
  
  Map<String, dynamic> toJson() => _$PharmacyToJson(this);
}

@JsonSerializable()
class WorkingHours {
  final String? emergency;
  final String? general;

  WorkingHours({
    this.emergency,
    this.general,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) => 
      _$WorkingHoursFromJson(json);
  
  Map<String, dynamic> toJson() => _$WorkingHoursToJson(this);
}

@JsonSerializable()
class EmergencyNumbers {
  final String generalEmergency;
  final String redCrescent;
  final String civilProtection;
  final String police;

  EmergencyNumbers({
    required this.generalEmergency,
    required this.redCrescent,
    required this.civilProtection,
    required this.police,
  });

  factory EmergencyNumbers.fromJson(Map<String, dynamic> json) => 
      _$EmergencyNumbersFromJson(json);
  
  Map<String, dynamic> toJson() => _$EmergencyNumbersToJson(this);
}

@JsonSerializable()
class HospitalData {
  final String city;
  final String country;
  final List<Hospital> hospitals;
  final EmergencyNumbers emergencyNumbers;

  HospitalData({
    required this.city,
    required this.country,
    required this.hospitals,
    required this.emergencyNumbers,
  });

  factory HospitalData.fromJson(Map<String, dynamic> json) => 
      _$HospitalDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$HospitalDataToJson(this);
}

@JsonSerializable()
class PharmacyData {
  final String city;
  final String country;
  final List<Pharmacy> pharmacies;
  final NightServiceSchedule nightServiceSchedule;

  PharmacyData({
    required this.city,
    required this.country,
    required this.pharmacies,
    required this.nightServiceSchedule,
  });

  factory PharmacyData.fromJson(Map<String, dynamic> json) => 
      _$PharmacyDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$PharmacyDataToJson(this);
}

@JsonSerializable()
class NightServiceSchedule {
  final String rotation;
  final String infoPhone;
  final String description;

  NightServiceSchedule({
    required this.rotation,
    required this.infoPhone,
    required this.description,
  });

  factory NightServiceSchedule.fromJson(Map<String, dynamic> json) => 
      _$NightServiceScheduleFromJson(json);
  
  Map<String, dynamic> toJson() => _$NightServiceScheduleToJson(this);
}

// Helper class for location calculations
class LocationHelper {
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    // Simplified distance calculation (Haversine formula would be more accurate)
    const double earthRadius = 6371; // km
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        (dLat / 2) * (dLat / 2) +
        (lat1 * 3.14159 / 180) * (lat2 * 3.14159 / 180) *
        (dLon / 2) * (dLon / 2);
    final double c = 2 * (a < 1 ? (a < 0 ? 0 : a) : 1);
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * 3.14159 / 180;
  }
}
