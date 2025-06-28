import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/vaccination.dart';
import '../providers/child_profile_provider.dart';
import '../services/vaccination_service.dart';
import '../widgets/vaccination_reminder_card.dart';
import '../widgets/health_calendar_widget.dart';
import '../widgets/vaccination_progress_card.dart';

class HealthCalendarScreen extends StatefulWidget {
  const HealthCalendarScreen({super.key});

  @override
  State<HealthCalendarScreen> createState() => _HealthCalendarScreenState();
}

class _HealthCalendarScreenState extends State<HealthCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final VaccinationService _vaccinationService = VaccinationService.instance;
  List<VaccinationReminder> _upcomingVaccinations = [];
  List<VaccinationReminder> _overdueVaccinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVaccinationData();

    // تحميل ملفات الأطفال عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childProvider = Provider.of<ChildProfileProvider>(context, listen: false);
      childProvider.loadProfiles();
      childProvider.addListener(_onChildProfileChanged);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Remove listener to prevent memory leaks
    final childProvider = Provider.of<ChildProfileProvider>(context, listen: false);
    childProvider.removeListener(_onChildProfileChanged);
    super.dispose();
  }

  void _onChildProfileChanged() {
    // Reload vaccination data when child profile changes
    if (mounted) {
      _updateVaccinationReminders();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadVaccinationData();
    _updateVaccinationReminders();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadVaccinationData() async {
    try {
      await _vaccinationService.loadVaccinationSchedule();
      _updateVaccinationReminders();
    } catch (e) {
      // Handle error
      print('Error loading vaccination data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateVaccinationReminders() {
    final childProvider = Provider.of<ChildProfileProvider>(context, listen: false);
    final selectedChild = childProvider.selectedProfile;

    if (selectedChild != null) {
      setState(() {
        _upcomingVaccinations = _vaccinationService.getUpcomingVaccinations(selectedChild);
        _overdueVaccinations = _vaccinationService.getOverdueVaccinations(selectedChild);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'التقويم الصحي',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'تحديث البيانات',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotificationSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            )
          : Consumer<ChildProfileProvider>(
              builder: (context, childProvider, child) {
                final selectedChild = childProvider.selectedProfile;

                if (selectedChild == null) {
                  return _buildNoChildSelected();
                }

                return Column(
                  children: [
                    // Child selector and progress overview
                    Container(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: Column(
                        children: [
                          // Child selector
                          if (childProvider.profiles.length > 1)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.defaultPadding,
                                vertical: AppConstants.smallPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedChild.id,
                                  dropdownColor: AppColors.primaryBlueDark,
                                  style: const TextStyle(color: Colors.white),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                  items: childProvider.profiles.map((profile) {
                                    return DropdownMenuItem<String>(
                                      value: profile.id,
                                      child: Text(profile.name),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      final newProfile = childProvider.profiles
                                          .firstWhere((p) => p.id == newValue);
                                      childProvider.selectProfile(newProfile);
                                      _updateVaccinationReminders();
                                    }
                                  },
                                ),
                              ),
                            ),

                          if (childProvider.profiles.length > 1)
                            const SizedBox(height: AppConstants.defaultPadding),

                          // Vaccination progress
                          VaccinationProgressCard(
                            child: selectedChild,
                            vaccinationService: _vaccinationService,
                          ),
                        ],
                      ),
                    ),

                    // Tab bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primaryGreen,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primaryGreen,
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('القادمة'),
                                if (_upcomingVaccinations.isNotEmpty) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _upcomingVaccinations.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('المتأخرة'),
                                if (_overdueVaccinations.isNotEmpty) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _overdueVaccinations.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Tab(text: 'التقويم'),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUpcomingTab(selectedChild),
                          _buildOverdueTab(selectedChild),
                          _buildCalendarTab(selectedChild),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildNoChildSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const Text(
            'لا يوجد ملف طفل محدد',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          const Text(
            'يرجى إضافة ملف طفل أولاً',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add child profile
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة ملف طفل'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab(child) {
    if (_upcomingVaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const Text(
              'لا توجد تطعيمات قادمة',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const Text(
              'طفلك محدث بجميع التطعيمات',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _upcomingVaccinations.length,
      itemBuilder: (context, index) {
        final reminder = _upcomingVaccinations[index];
        return VaccinationReminderCard(
          reminder: reminder,
          onMarkCompleted: () => _markVaccinationCompleted(reminder),
          onSetReminder: () => _setReminder(reminder),
        );
      },
    );
  }

  Widget _buildOverdueTab(child) {
    if (_overdueVaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const Text(
              'لا توجد تطعيمات متأخرة',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const Text(
              'ممتاز! طفلك محدث بجميع التطعيمات',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _overdueVaccinations.length,
      itemBuilder: (context, index) {
        final reminder = _overdueVaccinations[index];
        return VaccinationReminderCard(
          reminder: reminder,
          isOverdue: true,
          onMarkCompleted: () => _markVaccinationCompleted(reminder),
          onSetReminder: () => _setReminder(reminder),
        );
      },
    );
  }

  Widget _buildCalendarTab(child) {
    return HealthCalendarWidget(
      child: child,
      vaccinationService: _vaccinationService,
    );
  }

  void _markVaccinationCompleted(VaccinationReminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد التطعيم'),
        content: Text('هل تم إعطاء تطعيم ${reminder.vaccineNameArabic}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _vaccinationService.markVaccinationCompleted(reminder.id, DateTime.now());
              _updateVaccinationReminders();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _setReminder(VaccinationReminder reminder) {
    // Implement reminder setting
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعيين تذكير لتطعيم ${reminder.vaccineNameArabic}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showNotificationSettings() {
    // Implement notification settings
  }
}
