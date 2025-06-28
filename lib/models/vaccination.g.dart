// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaccinationSchedule _$VaccinationScheduleFromJson(Map<String, dynamic> json) =>
    VaccinationSchedule(
      country: json['country'] as String,
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => VaccinationPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminders: ReminderSettings.fromJson(
        json['reminders'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$VaccinationScheduleToJson(
  VaccinationSchedule instance,
) => <String, dynamic>{
  'country': instance.country,
  'schedule': instance.schedule,
  'reminders': instance.reminders,
};

VaccinationPeriod _$VaccinationPeriodFromJson(Map<String, dynamic> json) =>
    VaccinationPeriod(
      ageMonths: (json['ageMonths'] as num).toInt(),
      ageDisplay: json['ageDisplay'] as String,
      vaccines: (json['vaccines'] as List<dynamic>)
          .map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VaccinationPeriodToJson(VaccinationPeriod instance) =>
    <String, dynamic>{
      'ageMonths': instance.ageMonths,
      'ageDisplay': instance.ageDisplay,
      'vaccines': instance.vaccines,
    };

Vaccine _$VaccineFromJson(Map<String, dynamic> json) => Vaccine(
  name: json['name'] as String,
  nameArabic: json['nameArabic'] as String,
  description: json['description'] as String,
  mandatory: json['mandatory'] as bool,
);

Map<String, dynamic> _$VaccineToJson(Vaccine instance) => <String, dynamic>{
  'name': instance.name,
  'nameArabic': instance.nameArabic,
  'description': instance.description,
  'mandatory': instance.mandatory,
};

ReminderSettings _$ReminderSettingsFromJson(Map<String, dynamic> json) =>
    ReminderSettings(
      beforeDays: (json['beforeDays'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReminderSettingsToJson(ReminderSettings instance) =>
    <String, dynamic>{
      'beforeDays': instance.beforeDays,
      'message': instance.message,
    };

VaccinationReminder _$VaccinationReminderFromJson(Map<String, dynamic> json) =>
    VaccinationReminder(
      id: json['id'] as String,
      childId: json['childId'] as String,
      vaccineName: json['vaccineName'] as String,
      vaccineNameArabic: json['vaccineNameArabic'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      reminderDate: DateTime.parse(json['reminderDate'] as String),
      isCompleted: json['isCompleted'] as bool,
      isOverdue: json['isOverdue'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VaccinationReminderToJson(
  VaccinationReminder instance,
) => <String, dynamic>{
  'id': instance.id,
  'childId': instance.childId,
  'vaccineName': instance.vaccineName,
  'vaccineNameArabic': instance.vaccineNameArabic,
  'dueDate': instance.dueDate.toIso8601String(),
  'reminderDate': instance.reminderDate.toIso8601String(),
  'isCompleted': instance.isCompleted,
  'isOverdue': instance.isOverdue,
  'createdAt': instance.createdAt.toIso8601String(),
};

SeasonalHealthTip _$SeasonalHealthTipFromJson(Map<String, dynamic> json) =>
    SeasonalHealthTip(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      season: json['season'] as String,
      startMonth: (json['startMonth'] as num).toInt(),
      endMonth: (json['endMonth'] as num).toInt(),
      icon: json['icon'] as String,
      color: json['color'] as String,
      ageGroups: (json['ageGroups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SeasonalHealthTipToJson(SeasonalHealthTip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'season': instance.season,
      'startMonth': instance.startMonth,
      'endMonth': instance.endMonth,
      'icon': instance.icon,
      'color': instance.color,
      'ageGroups': instance.ageGroups,
    };
