import 'package:json_annotation/json_annotation.dart';

part 'consultation.g.dart';

@JsonSerializable()
class Consultation {
  final String id;
  final String childId;
  final String doctorId;
  final String specialty;
  final ConsultationType type;
  final ConsultationStatus status;
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? notes;
  final String? prescription;
  final double? cost;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consultation({
    required this.id,
    required this.childId,
    required this.doctorId,
    required this.specialty,
    required this.type,
    required this.status,
    required this.scheduledTime,
    this.startTime,
    this.endTime,
    this.notes,
    this.prescription,
    this.cost,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) => 
      _$ConsultationFromJson(json);
  
  Map<String, dynamic> toJson() => _$ConsultationToJson(this);
}

@JsonSerializable()
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String specialtyArabic;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final String? profileImage;
  final String? bio;
  final List<String> qualifications;
  final bool isAvailable;
  final List<AvailableSlot> availableSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialtyArabic,
    required this.languages,
    required this.rating,
    required this.reviewCount,
    this.profileImage,
    this.bio,
    required this.qualifications,
    required this.isAvailable,
    required this.availableSlots,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => 
      _$DoctorFromJson(json);
  
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}

@JsonSerializable()
class AvailableSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;

  AvailableSlot({
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) => 
      _$AvailableSlotFromJson(json);
  
  Map<String, dynamic> toJson() => _$AvailableSlotToJson(this);
}

enum ConsultationType {
  @JsonValue('chat')
  chat,
  @JsonValue('video')
  video,
  @JsonValue('voice')
  voice,
}

enum ConsultationStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('no_show')
  noShow,
}

extension ConsultationTypeExtension on ConsultationType {
  String get displayName {
    switch (this) {
      case ConsultationType.chat:
        return 'محادثة نصية';
      case ConsultationType.video:
        return 'مكالمة فيديو';
      case ConsultationType.voice:
        return 'مكالمة صوتية';
    }
  }

  String get icon {
    switch (this) {
      case ConsultationType.chat:
        return 'chat';
      case ConsultationType.video:
        return 'videocam';
      case ConsultationType.voice:
        return 'phone';
    }
  }
}

extension ConsultationStatusExtension on ConsultationStatus {
  String get displayName {
    switch (this) {
      case ConsultationStatus.scheduled:
        return 'مجدولة';
      case ConsultationStatus.inProgress:
        return 'جارية';
      case ConsultationStatus.completed:
        return 'مكتملة';
      case ConsultationStatus.cancelled:
        return 'ملغية';
      case ConsultationStatus.noShow:
        return 'لم يحضر';
    }
  }
}
