import 'package:json_annotation/json_annotation.dart';

part 'first_aid.g.dart';

@JsonSerializable()
class FirstAidCategory {
  final String id;
  final String name;
  final String icon;
  final String color;
  final List<FirstAidScenario> scenarios;

  FirstAidCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.scenarios,
  });

  factory FirstAidCategory.fromJson(Map<String, dynamic> json) => 
      _$FirstAidCategoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$FirstAidCategoryToJson(this);
}

@JsonSerializable()
class FirstAidScenario {
  final String id;
  final String title;
  final String description;
  final bool emergency;
  final List<FirstAidStep> steps;

  FirstAidScenario({
    required this.id,
    required this.title,
    required this.description,
    this.emergency = false,
    required this.steps,
  });

  factory FirstAidScenario.fromJson(Map<String, dynamic> json) => 
      _$FirstAidScenarioFromJson(json);
  
  Map<String, dynamic> toJson() => _$FirstAidScenarioToJson(this);
}

@JsonSerializable()
class FirstAidStep {
  final int step;
  final String title;
  final String description;
  final String? warning;
  final String? image;
  final bool urgent;

  FirstAidStep({
    required this.step,
    required this.title,
    required this.description,
    this.warning,
    this.image,
    this.urgent = false,
  });

  factory FirstAidStep.fromJson(Map<String, dynamic> json) => 
      _$FirstAidStepFromJson(json);
  
  Map<String, dynamic> toJson() => _$FirstAidStepToJson(this);
}

@JsonSerializable()
class FirstAidData {
  final List<FirstAidCategory> categories;

  FirstAidData({
    required this.categories,
  });

  factory FirstAidData.fromJson(Map<String, dynamic> json) => 
      _$FirstAidDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$FirstAidDataToJson(this);
}
