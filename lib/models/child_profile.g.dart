// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Allergy _$AllergyFromJson(Map<String, dynamic> json) => Allergy(
  id: json['id'] as String,
  name: json['name'] as String,
  severity: $enumDecode(_$AllergySeverityEnumMap, json['severity']),
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AllergyToJson(Allergy instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'severity': _$AllergySeverityEnumMap[instance.severity]!,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$AllergySeverityEnumMap = {
  AllergySeverity.mild: 'mild',
  AllergySeverity.moderate: 'moderate',
  AllergySeverity.severe: 'severe',
};

Vaccination _$VaccinationFromJson(Map<String, dynamic> json) => Vaccination(
  id: json['id'] as String,
  name: json['name'] as String,
  scheduledDate: DateTime.parse(json['scheduledDate'] as String),
  givenDate: json['givenDate'] == null
      ? null
      : DateTime.parse(json['givenDate'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$VaccinationToJson(Vaccination instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'givenDate': instance.givenDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'notes': instance.notes,
    };

MedicalHistoryEntry _$MedicalHistoryEntryFromJson(Map<String, dynamic> json) =>
    MedicalHistoryEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      doctorName: json['doctorName'] as String?,
      treatment: json['treatment'] as String?,
    );

Map<String, dynamic> _$MedicalHistoryEntryToJson(
  MedicalHistoryEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'doctorName': instance.doctorName,
  'treatment': instance.treatment,
};

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) => ChildProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  weight: (json['weight'] as num?)?.toDouble(),
  height: (json['height'] as num?)?.toDouble(),
  bloodType: json['bloodType'] as String?,
  allergies:
      (json['allergies'] as List<dynamic>?)
          ?.map((e) => Allergy.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  medications:
      (json['medications'] as List<dynamic>?)
          ?.map((e) => Medication.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  vaccinations:
      (json['vaccinations'] as List<dynamic>?)
          ?.map((e) => VaccinationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  medicalHistory:
      (json['medicalHistory'] as List<dynamic>?)
          ?.map((e) => MedicalHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ChildProfileToJson(ChildProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender]!,
      'weight': instance.weight,
      'height': instance.height,
      'bloodType': instance.bloodType,
      'allergies': instance.allergies,
      'medications': instance.medications,
      'vaccinations': instance.vaccinations,
      'medicalHistory': instance.medicalHistory,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
  id: json['id'] as String,
  name: json['name'] as String,
  dosage: json['dosage'] as String,
  form: json['form'] as String,
  frequency: $enumDecode(_$MedicationFrequencyEnumMap, json['frequency']),
  instructions: json['instructions'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  duration: (json['duration'] as num?)?.toInt(),
  totalDoses: (json['totalDoses'] as num?)?.toInt(),
  preferredTime: const TimeOfDayConverter().fromJson(
    json['preferredTime'] as String?,
  ),
  isActive: json['isActive'] as bool? ?? true,
  nextDoseTime: json['nextDoseTime'] == null
      ? null
      : DateTime.parse(json['nextDoseTime'] as String),
  lastDoseTime: json['lastDoseTime'] == null
      ? null
      : DateTime.parse(json['lastDoseTime'] as String),
  dosesRemaining: (json['dosesRemaining'] as num?)?.toInt(),
);

Map<String, dynamic> _$MedicationToJson(
  Medication instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dosage': instance.dosage,
  'form': instance.form,
  'frequency': _$MedicationFrequencyEnumMap[instance.frequency]!,
  'instructions': instance.instructions,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'duration': instance.duration,
  'totalDoses': instance.totalDoses,
  'preferredTime': const TimeOfDayConverter().toJson(instance.preferredTime),
  'isActive': instance.isActive,
  'nextDoseTime': instance.nextDoseTime?.toIso8601String(),
  'lastDoseTime': instance.lastDoseTime?.toIso8601String(),
  'dosesRemaining': instance.dosesRemaining,
};

const _$MedicationFrequencyEnumMap = {
  MedicationFrequency.onceDaily: 'onceDaily',
  MedicationFrequency.twiceDaily: 'twiceDaily',
  MedicationFrequency.threeTimesDaily: 'threeTimesDaily',
  MedicationFrequency.fourTimesDaily: 'fourTimesDaily',
  MedicationFrequency.asNeeded: 'asNeeded',
};

VaccinationRecord _$VaccinationRecordFromJson(Map<String, dynamic> json) =>
    VaccinationRecord(
      id: json['id'] as String,
      vaccineName: json['vaccineName'] as String,
      dateGiven: DateTime.parse(json['dateGiven'] as String),
      batchNumber: json['batchNumber'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$VaccinationRecordToJson(VaccinationRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vaccineName': instance.vaccineName,
      'dateGiven': instance.dateGiven.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'location': instance.location,
      'notes': instance.notes,
    };
