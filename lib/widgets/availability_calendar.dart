import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/consultation.dart';

class AvailabilityCalendar extends StatefulWidget {
  final List<AvailableSlot> availableSlots;
  final Function(AvailableSlot) onSlotSelected;

  const AvailabilityCalendar({
    super.key,
    required this.availableSlots,
    required this.onSlotSelected,
  });

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  DateTime _selectedDate = DateTime.now();
  AvailableSlot? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date selector
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 14, // Next 14 days
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _isSameDay(date, _selectedDate);
              final hasSlots = _hasAvailableSlots(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _selectedSlot = null;
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: AppConstants.smallPadding),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : hasSlots
                            ? Colors.white
                            : AppColors.backgroundGrey,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : hasSlots
                              ? AppColors.borderLight
                              : AppColors.borderMedium,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayName(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white
                              : hasSlots
                                  ? AppColors.textSecondary
                                  : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : hasSlots
                                  ? AppColors.textPrimary
                                  : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getMonthName(date),
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white
                              : hasSlots
                                  ? AppColors.textSecondary
                                  : AppColors.textLight,
                        ),
                      ),
                      if (hasSlots && !isSelected)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppConstants.largePadding),

        // Time slots
        Expanded(
          child: _buildTimeSlots(),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    final slotsForDate = _getSlotsForDate(_selectedDate);

    if (slotsForDate.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const Text(
              'لا توجد مواعيد متاحة في هذا اليوم',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: AppConstants.smallPadding,
        mainAxisSpacing: AppConstants.smallPadding,
      ),
      itemCount: slotsForDate.length,
      itemBuilder: (context, index) {
        final slot = slotsForDate[index];
        final isSelected = _selectedSlot == slot;
        final isBooked = slot.isBooked;

        return GestureDetector(
          onTap: isBooked
              ? null
              : () {
                  setState(() {
                    _selectedSlot = slot;
                  });
                  widget.onSlotSelected(slot);
                },
          child: Container(
            decoration: BoxDecoration(
              color: isBooked
                  ? AppColors.backgroundGrey
                  : isSelected
                      ? AppColors.primaryGreen
                      : Colors.white,
              border: Border.all(
                color: isBooked
                    ? AppColors.borderMedium
                    : isSelected
                        ? AppColors.primaryGreen
                        : AppColors.borderLight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Center(
              child: Text(
                _formatTime(slot.startTime),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isBooked
                      ? AppColors.textLight
                      : isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<AvailableSlot> _getSlotsForDate(DateTime date) {
    // Mock available slots for the selected date
    // In a real app, this would filter actual slots from the doctor's availability
    if (!_hasAvailableSlots(date)) return [];

    return [
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 9, 0),
        endTime: DateTime(date.year, date.month, date.day, 9, 30),
        isBooked: false,
      ),
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 9, 30),
        endTime: DateTime(date.year, date.month, date.day, 10, 0),
        isBooked: true,
      ),
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 10, 0),
        endTime: DateTime(date.year, date.month, date.day, 10, 30),
        isBooked: false,
      ),
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 11, 0),
        endTime: DateTime(date.year, date.month, date.day, 11, 30),
        isBooked: false,
      ),
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 14, 0),
        endTime: DateTime(date.year, date.month, date.day, 14, 30),
        isBooked: false,
      ),
      AvailableSlot(
        startTime: DateTime(date.year, date.month, date.day, 15, 0),
        endTime: DateTime(date.year, date.month, date.day, 15, 30),
        isBooked: false,
      ),
    ];
  }

  bool _hasAvailableSlots(DateTime date) {
    // Mock logic - in real app, check actual availability
    return date.weekday != DateTime.friday && date.weekday != DateTime.saturday;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getDayName(DateTime date) {
    final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return days[date.weekday % 7];
  }

  String _getMonthName(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[date.month - 1];
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
