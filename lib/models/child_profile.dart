import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_profile.g.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null) return null;
    final parts = json.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String? toJson(TimeOfDay? object) {
    if (object == null) return null;
    return '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}';
  }
}

enum Gender {
  male,
  female,
}

enum MedicationFrequency {
  onceDaily,
  twiceDaily,
  threeTimesDaily,
  fourTimesDaily,
  asNeeded,
}

enum AllergySeverity {
  mild,
  moderate,
  severe,
}

@JsonSerializable()
class Allergy {
  final String id;
  final String name;
  final AllergySeverity severity;
  final String? description;
  final DateTime createdAt;

  Allergy({
    required this.id,
    required this.name,
    required this.severity,
    this.description,
    required this.createdAt,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) =>
      _$AllergyFromJson(json);

  Map<String, dynamic> toJson() => _$AllergyToJson(this);
}

@JsonSerializable()
class Vaccination {
  final String id;
  final String name;
  final DateTime scheduledDate;
  final DateTime? givenDate;
  final bool isCompleted;
  final String? notes;

  Vaccination({
    required this.id,
    required this.name,
    required this.scheduledDate,
    this.givenDate,
    this.isCompleted = false,
    this.notes,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) =>
      _$VaccinationFromJson(json);

  Map<String, dynamic> toJson() => _$VaccinationToJson(this);
}

@JsonSerializable()
class MedicalHistoryEntry {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? doctorName;
  final String? treatment;

  MedicalHistoryEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.doctorName,
    this.treatment,
  });

  factory MedicalHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalHistoryEntryToJson(this);
}

@JsonSerializable()
class ChildProfile {
  final String id;
  final String name;
  final DateTime birthDate;
  final Gender gender;
  final double? weight; // in kg
  final double? height; // in cm
  final String? bloodType;
  final List<Allergy> allergies;
  final List<Medication> medications;
  final List<VaccinationRecord> vaccinations;
  final List<MedicalHistoryEntry> medicalHistory;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.weight,
    this.height,
    this.bloodType,
    this.allergies = const [],
    this.medications = const [],
    this.vaccinations = const [],
    this.medicalHistory = const [],
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate age in months
  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    return (difference.inDays / 30.44).round(); // Average days per month
  }

  // Calculate age in years
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Get age display string
  String get ageDisplay {
    final years = ageInYears;
    final months = ageInMonths % 12;
    
    if (years == 0) {
      return '$months شهر';
    } else if (months == 0) {
      return '$years سنة';
    } else {
      return '$years سنة و $months شهر';
    }
  }

  // Copy with method for updates
  ChildProfile copyWith({
    String? name,
    DateTime? birthDate,
    Gender? gender,
    double? weight,
    double? height,
    String? bloodType,
    List<Allergy>? allergies,
    List<Medication>? medications,
    List<VaccinationRecord>? vaccinations,
    List<MedicalHistoryEntry>? medicalHistory,
    String? notes,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      vaccinations: vaccinations ?? this.vaccinations,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // JSON serialization
  factory ChildProfile.fromJson(Map<String, dynamic> json) => 
      _$ChildProfileFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChildProfileToJson(this);
}

@JsonSerializable()
class Medication {
  final String id;
  final String name;
  final String dosage;
  final String form;
  final MedicationFrequency frequency;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final int? duration;
  final int? totalDoses;
  @TimeOfDayConverter()
  final TimeOfDay? preferredTime;
  final bool isActive;
  final DateTime? nextDoseTime;
  final DateTime? lastDoseTime;
  final int? dosesRemaining;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.frequency,
    required this.instructions,
    required this.startDate,
    this.endDate,
    this.duration,
    this.totalDoses,
    this.preferredTime,
    this.isActive = true,
    this.nextDoseTime,
    this.lastDoseTime,
    this.dosesRemaining,
  });

  Medication copyWith({
    String? name,
    String? dosage,
    String? form,
    MedicationFrequency? frequency,
    String? instructions,
    DateTime? startDate,
    DateTime? endDate,
    int? duration,
    int? totalDoses,
    TimeOfDay? preferredTime,
    bool? isActive,
    DateTime? nextDoseTime,
    DateTime? lastDoseTime,
    int? dosesRemaining,
  }) {
    return Medication(
      id: id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      totalDoses: totalDoses ?? this.totalDoses,
      preferredTime: preferredTime ?? this.preferredTime,
      isActive: isActive ?? this.isActive,
      nextDoseTime: nextDoseTime ?? this.nextDoseTime,
      lastDoseTime: lastDoseTime ?? this.lastDoseTime,
      dosesRemaining: dosesRemaining ?? this.dosesRemaining,
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}

@JsonSerializable()
class VaccinationRecord {
  final String id;
  final String vaccineName;
  final DateTime dateGiven;
  final String? batchNumber;
  final String? location;
  final String? notes;

  VaccinationRecord({
    required this.id,
    required this.vaccineName,
    required this.dateGiven,
    this.batchNumber,
    this.location,
    this.notes,
  });

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) => 
      _$VaccinationRecordFromJson(json);
  
  Map<String, dynamic> toJson() => _$VaccinationRecordToJson(this);
}
