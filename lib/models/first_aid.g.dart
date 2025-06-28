// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_aid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirstAidCategory _$FirstAidCategoryFromJson(Map<String, dynamic> json) =>
    FirstAidCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      scenarios: (json['scenarios'] as List<dynamic>)
          .map((e) => FirstAidScenario.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirstAidCategoryToJson(FirstAidCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'scenarios': instance.scenarios,
    };

FirstAidScenario _$FirstAidScenarioFromJson(Map<String, dynamic> json) =>
    FirstAidScenario(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      emergency: json['emergency'] as bool? ?? false,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => FirstAidStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirstAidScenarioToJson(FirstAidScenario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'emergency': instance.emergency,
      'steps': instance.steps,
    };

FirstAidStep _$FirstAidStepFromJson(Map<String, dynamic> json) => FirstAidStep(
  step: (json['step'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  warning: json['warning'] as String?,
  image: json['image'] as String?,
  urgent: json['urgent'] as bool? ?? false,
);

Map<String, dynamic> _$FirstAidStepToJson(FirstAidStep instance) =>
    <String, dynamic>{
      'step': instance.step,
      'title': instance.title,
      'description': instance.description,
      'warning': instance.warning,
      'image': instance.image,
      'urgent': instance.urgent,
    };

FirstAidData _$FirstAidDataFromJson(Map<String, dynamic> json) => FirstAidData(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => FirstAidCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FirstAidDataToJson(FirstAidData instance) =>
    <String, dynamic>{'categories': instance.categories};
