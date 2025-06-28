// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consultation _$ConsultationFromJson(Map<String, dynamic> json) => Consultation(
  id: json['id'] as String,
  childId: json['childId'] as String,
  doctorId: json['doctorId'] as String,
  specialty: json['specialty'] as String,
  type: $enumDecode(_$ConsultationTypeEnumMap, json['type']),
  status: $enumDecode(_$ConsultationStatusEnumMap, json['status']),
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  notes: json['notes'] as String?,
  prescription: json['prescription'] as String?,
  cost: (json['cost'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ConsultationToJson(Consultation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'doctorId': instance.doctorId,
      'specialty': instance.specialty,
      'type': _$ConsultationTypeEnumMap[instance.type]!,
      'status': _$ConsultationStatusEnumMap[instance.status]!,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'notes': instance.notes,
      'prescription': instance.prescription,
      'cost': instance.cost,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ConsultationTypeEnumMap = {
  ConsultationType.chat: 'chat',
  ConsultationType.video: 'video',
  ConsultationType.voice: 'voice',
};

const _$ConsultationStatusEnumMap = {
  ConsultationStatus.scheduled: 'scheduled',
  ConsultationStatus.inProgress: 'in_progress',
  ConsultationStatus.completed: 'completed',
  ConsultationStatus.cancelled: 'cancelled',
  ConsultationStatus.noShow: 'no_show',
};

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
  id: json['id'] as String,
  name: json['name'] as String,
  specialty: json['specialty'] as String,
  specialtyArabic: json['specialtyArabic'] as String,
  languages: (json['languages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  profileImage: json['profileImage'] as String?,
  bio: json['bio'] as String?,
  qualifications: (json['qualifications'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isAvailable: json['isAvailable'] as bool,
  availableSlots: (json['availableSlots'] as List<dynamic>)
      .map((e) => AvailableSlot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'specialty': instance.specialty,
  'specialtyArabic': instance.specialtyArabic,
  'languages': instance.languages,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'profileImage': instance.profileImage,
  'bio': instance.bio,
  'qualifications': instance.qualifications,
  'isAvailable': instance.isAvailable,
  'availableSlots': instance.availableSlots,
};

AvailableSlot _$AvailableSlotFromJson(Map<String, dynamic> json) =>
    AvailableSlot(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isBooked: json['isBooked'] as bool,
    );

Map<String, dynamic> _$AvailableSlotToJson(AvailableSlot instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isBooked': instance.isBooked,
    };
