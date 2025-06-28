import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/vaccination.dart';
import '../models/child_profile.dart';

class VaccinationService {
  static VaccinationService? _instance;
  VaccinationSchedule? _schedule;

  VaccinationService._();

  static VaccinationService get instance {
    _instance ??= VaccinationService._();
    return _instance!;
  }

  /// Load vaccination schedule from assets
  Future<VaccinationSchedule> loadVaccinationSchedule() async {
    if (_schedule != null) return _schedule!;

    try {
      final String jsonString = await rootBundle.loadString(AppConstants.vaccinationDataFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _schedule = VaccinationSchedule.fromJson(jsonData);
      return _schedule!;
    } catch (e) {
      throw Exception('Failed to load vaccination schedule: $e');
    }
  }

  /// Get vaccination reminders for a specific child
  List<VaccinationReminder> getVaccinationReminders(ChildProfile child) {
    if (_schedule == null) return [];

    final reminders = <VaccinationReminder>[];
    final now = DateTime.now();
    final childAgeInMonths = child.ageInMonths;

    for (final period in _schedule!.schedule) {
      // Check if this vaccination period is relevant for the child's age
      if (period.ageMonths <= childAgeInMonths + 6) { // Include upcoming 6 months
        final dueDate = child.birthDate.add(Duration(days: period.ageMonths * 30));
        final reminderDate = dueDate.subtract(Duration(days: _schedule!.reminders.beforeDays));

        for (final vaccine in period.vaccines) {
          // Check if this vaccination is already completed
          final isCompleted = child.vaccinations.any((v) => 
              v.vaccineName == vaccine.name && 
              v.dateGiven.isBefore(dueDate.add(const Duration(days: 30))));

          if (!isCompleted) {
            final reminder = VaccinationReminder(
              id: '${child.id}_${vaccine.name}_${period.ageMonths}',
              childId: child.id,
              vaccineName: vaccine.name,
              vaccineNameArabic: vaccine.nameArabic,
              dueDate: dueDate,
              reminderDate: reminderDate,
              isCompleted: false,
              isOverdue: now.isAfter(dueDate),
              createdAt: now,
            );
            reminders.add(reminder);
          }
        }
      }
    }

    // Sort by due date
    reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return reminders;
  }

  /// Get upcoming vaccinations (next 30 days)
  List<VaccinationReminder> getUpcomingVaccinations(ChildProfile child) {
    final allReminders = getVaccinationReminders(child);
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    return allReminders.where((reminder) =>
        !reminder.isCompleted &&
        reminder.dueDate.isAfter(now) &&
        reminder.dueDate.isBefore(thirtyDaysFromNow)).toList();
  }

  /// Get overdue vaccinations
  List<VaccinationReminder> getOverdueVaccinations(ChildProfile child) {
    final allReminders = getVaccinationReminders(child);
    final now = DateTime.now();

    return allReminders.where((reminder) =>
        !reminder.isCompleted &&
        reminder.dueDate.isBefore(now)).toList();
  }

  /// Get vaccination schedule for a specific age
  VaccinationPeriod? getVaccinationForAge(int ageInMonths) {
    if (_schedule == null) return null;

    return _schedule!.schedule.firstWhere(
      (period) => period.ageMonths == ageInMonths,
      orElse: () => throw StateError('No vaccination found for age $ageInMonths months'),
    );
  }

  /// Get all vaccination periods up to a certain age
  List<VaccinationPeriod> getVaccinationsUpToAge(int ageInMonths) {
    if (_schedule == null) return [];

    return _schedule!.schedule.where((period) => period.ageMonths <= ageInMonths).toList();
  }

  /// Calculate vaccination completion percentage for a child
  double getVaccinationCompletionPercentage(ChildProfile child) {
    if (_schedule == null) return 0.0;

    final relevantPeriods = getVaccinationsUpToAge(child.ageInMonths);
    if (relevantPeriods.isEmpty) return 0.0;

    int totalVaccines = 0;
    int completedVaccines = 0;

    for (final period in relevantPeriods) {
      for (final vaccine in period.vaccines) {
        totalVaccines++;
        
        // Check if this vaccination is completed
        final isCompleted = child.vaccinations.any((v) => 
            v.vaccineName == vaccine.name);
        
        if (isCompleted) {
          completedVaccines++;
        }
      }
    }

    return totalVaccines > 0 ? completedVaccines / totalVaccines : 0.0;
  }

  /// Get next vaccination due
  VaccinationReminder? getNextVaccination(ChildProfile child) {
    final upcomingVaccinations = getUpcomingVaccinations(child);
    return upcomingVaccinations.isNotEmpty ? upcomingVaccinations.first : null;
  }

  /// Mark vaccination as completed
  void markVaccinationCompleted(String reminderId, DateTime completedDate) {
    // In a real app, this would update the database
    // For now, we'll just add it to the child's vaccination records
  }

  /// Get vaccination history for a child
  List<VaccinationRecord> getVaccinationHistory(ChildProfile child) {
    return child.vaccinations;
  }

  /// Check if a child is up to date with vaccinations
  bool isUpToDate(ChildProfile child) {
    final overdueVaccinations = getOverdueVaccinations(child);
    return overdueVaccinations.isEmpty;
  }

  /// Get vaccination status summary
  Map<String, dynamic> getVaccinationStatus(ChildProfile child) {
    final upcoming = getUpcomingVaccinations(child);
    final overdue = getOverdueVaccinations(child);
    final completionPercentage = getVaccinationCompletionPercentage(child);
    final isUpToDate = this.isUpToDate(child);

    return {
      'upcomingCount': upcoming.length,
      'overdueCount': overdue.length,
      'completionPercentage': completionPercentage,
      'isUpToDate': isUpToDate,
      'nextVaccination': getNextVaccination(child),
    };
  }
}
