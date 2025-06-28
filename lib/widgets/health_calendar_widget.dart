import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';
import '../models/vaccination.dart';
import '../services/vaccination_service.dart';
import '../utils/date_utils.dart';

class HealthCalendarWidget extends StatefulWidget {
  final ChildProfile child;
  final VaccinationService vaccinationService;

  const HealthCalendarWidget({
    super.key,
    required this.child,
    required this.vaccinationService,
  });

  @override
  State<HealthCalendarWidget> createState() => _HealthCalendarWidgetState();
}

class _HealthCalendarWidgetState extends State<HealthCalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  List<VaccinationReminder> _allReminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    setState(() {
      _allReminders = widget.vaccinationService.getVaccinationReminders(widget.child);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month navigation
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                _getMonthYearText(_selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),

        // Calendar grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Column(
              children: [
                // Day headers
                Row(
                  children: ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: AppConstants.smallPadding),

                // Calendar days
                Expanded(
                  child: _buildCalendarGrid(),
                ),
              ],
            ),
          ),
        ),

        // Selected date events
        if (_getEventsForDate(_selectedDate).isNotEmpty)
          Container(
            height: 200,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحداث ${AppDateUtils.formatDateArabic(_selectedDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDate(_selectedDate).length,
                    itemBuilder: (context, index) {
                      final reminder = _getEventsForDate(_selectedDate)[index];
                      return _buildEventItem(reminder);
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7; // Adjust for Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: firstDayWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstDayWeekday) {
          return const SizedBox(); // Empty cells before month starts
        }

        final day = index - firstDayWeekday + 1;
        final date = DateTime(_selectedDate.year, _selectedDate.month, day);
        final events = _getEventsForDate(date);
        final isSelected = _isSameDay(date, _selectedDate);
        final isToday = _isSameDay(date, DateTime.now());

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen
                  : isToday
                      ? AppColors.primaryBlue.withOpacity(0.1)
                      : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primaryBlue, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? AppColors.primaryBlue
                            : AppColors.textPrimary,
                  ),
                ),
                if (events.isNotEmpty)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : _getEventColor(events.first),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventItem(VaccinationReminder reminder) {
    final isOverdue = reminder.isOverdue;
    final daysUntilDue = reminder.dueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDue <= 7 && daysUntilDue >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue
              ? AppColors.error
              : isUrgent
                  ? AppColors.warning
                  : AppColors.primaryGreen,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.vaccines,
            color: isOverdue
                ? AppColors.error
                : isUrgent
                    ? AppColors.warning
                    : AppColors.primaryGreen,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              reminder.vaccineNameArabic,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isOverdue
                  ? AppColors.error
                  : isUrgent
                      ? AppColors.warning
                      : AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isOverdue
                  ? 'متأخر'
                  : isUrgent
                      ? 'عاجل'
                      : 'موعد',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<VaccinationReminder> _getEventsForDate(DateTime date) {
    return _allReminders.where((reminder) => _isSameDay(reminder.dueDate, date)).toList();
  }

  Color _getEventColor(VaccinationReminder reminder) {
    if (reminder.isOverdue) return AppColors.error;
    final daysUntilDue = reminder.dueDate.difference(DateTime.now()).inDays;
    if (daysUntilDue <= 7 && daysUntilDue >= 0) return AppColors.warning;
    return AppColors.primaryGreen;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }
}
