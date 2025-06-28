import 'package:json_annotation/json_annotation.dart';

part 'vaccination.g.dart';

@JsonSerializable()
class VaccinationSchedule {
  final String country;
  final List<VaccinationPeriod> schedule;
  final ReminderSettings reminders;

  VaccinationSchedule({
    required this.country,
    required this.schedule,
    required this.reminders,
  });

  factory VaccinationSchedule.fromJson(Map<String, dynamic> json) => 
      _$VaccinationScheduleFromJson(json);
  
  Map<String, dynamic> toJson() => _$VaccinationScheduleToJson(this);
}

@JsonSerializable()
class VaccinationPeriod {
  final int ageMonths;
  final String ageDisplay;
  final List<Vaccine> vaccines;

  VaccinationPeriod({
    required this.ageMonths,
    required this.ageDisplay,
    required this.vaccines,
  });

  factory VaccinationPeriod.fromJson(Map<String, dynamic> json) => 
      _$VaccinationPeriodFromJson(json);
  
  Map<String, dynamic> toJson() => _$VaccinationPeriodToJson(this);
}

@JsonSerializable()
class Vaccine {
  final String name;
  final String nameArabic;
  final String description;
  final bool mandatory;

  Vaccine({
    required this.name,
    required this.nameArabic,
    required this.description,
    required this.mandatory,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) => 
      _$VaccineFromJson(json);
  
  Map<String, dynamic> toJson() => _$VaccineToJson(this);
}

@JsonSerializable()
class ReminderSettings {
  final int beforeDays;
  final String message;

  ReminderSettings({
    required this.beforeDays,
    required this.message,
  });

  factory ReminderSettings.fromJson(Map<String, dynamic> json) => 
      _$ReminderSettingsFromJson(json);
  
  Map<String, dynamic> toJson() => _$ReminderSettingsToJson(this);
}

@JsonSerializable()
class VaccinationReminder {
  final String id;
  final String childId;
  final String vaccineName;
  final String vaccineNameArabic;
  final DateTime dueDate;
  final DateTime reminderDate;
  final bool isCompleted;
  final bool isOverdue;
  final DateTime createdAt;

  VaccinationReminder({
    required this.id,
    required this.childId,
    required this.vaccineName,
    required this.vaccineNameArabic,
    required this.dueDate,
    required this.reminderDate,
    required this.isCompleted,
    required this.isOverdue,
    required this.createdAt,
  });

  factory VaccinationReminder.fromJson(Map<String, dynamic> json) => 
      _$VaccinationReminderFromJson(json);
  
  Map<String, dynamic> toJson() => _$VaccinationReminderToJson(this);
}

@JsonSerializable()
class SeasonalHealthTip {
  final String id;
  final String title;
  final String content;
  final String season; // spring, summer, autumn, winter
  final int startMonth;
  final int endMonth;
  final String icon;
  final String color;
  final List<String> ageGroups; // infant, toddler, preschool, school

  SeasonalHealthTip({
    required this.id,
    required this.title,
    required this.content,
    required this.season,
    required this.startMonth,
    required this.endMonth,
    required this.icon,
    required this.color,
    required this.ageGroups,
  });

  factory SeasonalHealthTip.fromJson(Map<String, dynamic> json) => 
      _$SeasonalHealthTipFromJson(json);
  
  Map<String, dynamic> toJson() => _$SeasonalHealthTipToJson(this);
}
