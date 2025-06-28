// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hospital _$HospitalFromJson(Map<String, dynamic> json) => Hospital(
  id: json['id'] as String,
  name: json['name'] as String,
  nameArabic: json['nameArabic'] as String,
  type: json['type'] as String,
  specialties: (json['specialties'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  hasPediatric: json['hasPediatric'] as bool,
  hasEmergency: json['hasEmergency'] as bool,
  address: json['address'] as String,
  phone: json['phone'] as String,
  emergencyPhone: json['emergencyPhone'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  workingHours: WorkingHours.fromJson(
    json['workingHours'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HospitalToJson(Hospital instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nameArabic': instance.nameArabic,
  'type': instance.type,
  'specialties': instance.specialties,
  'hasPediatric': instance.hasPediatric,
  'hasEmergency': instance.hasEmergency,
  'address': instance.address,
  'phone': instance.phone,
  'emergencyPhone': instance.emergencyPhone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'workingHours': instance.workingHours,
};

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) => Pharmacy(
  id: json['id'] as String,
  name: json['name'] as String,
  nameArabic: json['nameArabic'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  workingHours: Map<String, String>.from(json['workingHours'] as Map),
  nightService: json['nightService'] as bool,
  emergencyService: json['emergencyService'] as bool,
  weekendOnly: json['weekendOnly'] as bool?,
);

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nameArabic': instance.nameArabic,
  'address': instance.address,
  'phone': instance.phone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'workingHours': instance.workingHours,
  'nightService': instance.nightService,
  'emergencyService': instance.emergencyService,
  'weekendOnly': instance.weekendOnly,
};

WorkingHours _$WorkingHoursFromJson(Map<String, dynamic> json) => WorkingHours(
  emergency: json['emergency'] as String?,
  general: json['general'] as String?,
);

Map<String, dynamic> _$WorkingHoursToJson(WorkingHours instance) =>
    <String, dynamic>{
      'emergency': instance.emergency,
      'general': instance.general,
    };

EmergencyNumbers _$EmergencyNumbersFromJson(Map<String, dynamic> json) =>
    EmergencyNumbers(
      generalEmergency: json['generalEmergency'] as String,
      redCrescent: json['redCrescent'] as String,
      civilProtection: json['civilProtection'] as String,
      police: json['police'] as String,
    );

Map<String, dynamic> _$EmergencyNumbersToJson(EmergencyNumbers instance) =>
    <String, dynamic>{
      'generalEmergency': instance.generalEmergency,
      'redCrescent': instance.redCrescent,
      'civilProtection': instance.civilProtection,
      'police': instance.police,
    };

HospitalData _$HospitalDataFromJson(Map<String, dynamic> json) => HospitalData(
  city: json['city'] as String,
  country: json['country'] as String,
  hospitals: (json['hospitals'] as List<dynamic>)
      .map((e) => Hospital.fromJson(e as Map<String, dynamic>))
      .toList(),
  emergencyNumbers: EmergencyNumbers.fromJson(
    json['emergencyNumbers'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HospitalDataToJson(HospitalData instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'hospitals': instance.hospitals,
      'emergencyNumbers': instance.emergencyNumbers,
    };

PharmacyData _$PharmacyDataFromJson(Map<String, dynamic> json) => PharmacyData(
  city: json['city'] as String,
  country: json['country'] as String,
  pharmacies: (json['pharmacies'] as List<dynamic>)
      .map((e) => Pharmacy.fromJson(e as Map<String, dynamic>))
      .toList(),
  nightServiceSchedule: NightServiceSchedule.fromJson(
    json['nightServiceSchedule'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PharmacyDataToJson(PharmacyData instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'pharmacies': instance.pharmacies,
      'nightServiceSchedule': instance.nightServiceSchedule,
    };

NightServiceSchedule _$NightServiceScheduleFromJson(
  Map<String, dynamic> json,
) => NightServiceSchedule(
  rotation: json['rotation'] as String,
  infoPhone: json['infoPhone'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$NightServiceScheduleToJson(
  NightServiceSchedule instance,
) => <String, dynamic>{
  'rotation': instance.rotation,
  'infoPhone': instance.infoPhone,
  'description': instance.description,
};
