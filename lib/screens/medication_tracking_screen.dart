import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';
import '../services/child_profile_service.dart';
import '../widgets/medication_card.dart';
import '../screens/add_medication_screen.dart';

class MedicationTrackingScreen extends StatefulWidget {
  final ChildProfile child;

  const MedicationTrackingScreen({
    super.key,
    required this.child,
  });

  @override
  State<MedicationTrackingScreen> createState() => _MedicationTrackingScreenState();
}

class _MedicationTrackingScreenState extends State<MedicationTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Medication> _allMedications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMedications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    try {
      final profile = await ChildProfileService.instance.getProfileById(widget.child.id);
      setState(() {
        _allMedications = profile?.medications ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Medication> get _activeMedications {
    return _allMedications.where((med) => med.isActive).toList();
  }

  List<Medication> get _completedMedications {
    return _allMedications.where((med) => !med.isActive).toList();
  }

  List<Medication> get _upcomingDoses {
    final now = DateTime.now();
    return _activeMedications.where((med) {
      if (med.nextDoseTime != null) {
        final timeDiff = med.nextDoseTime!.difference(now).inHours;
        return timeDiff <= 2 && timeDiff >= 0;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('أدوية ${widget.child.name}'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: const Icon(Icons.medication),
              text: 'الحالية (${_activeMedications.length})',
            ),
            Tab(
              icon: const Icon(Icons.schedule),
              text: 'قادمة (${_upcomingDoses.length})',
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: 'السابقة (${_completedMedications.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            )
          : Column(
              children: [
                // Summary card
                Container(
                  margin: const EdgeInsets.all(AppConstants.defaultPadding),
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Row(
                    children: [
                      // Child avatar
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          widget.child.name.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.child.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.child.ageDisplay,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quick stats
                      Column(
                        children: [
                          Text(
                            '${_activeMedications.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'دواء نشط',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActiveMedicationsTab(),
                      _buildUpcomingDosesTab(),
                      _buildCompletedMedicationsTab(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMedication,
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add),
        label: const Text('إضافة دواء'),
      ),
    );
  }

  Widget _buildActiveMedicationsTab() {
    if (_activeMedications.isEmpty) {
      return _buildEmptyState(
        'لا توجد أدوية نشطة',
        'أضف دواء جديد لبدء المتابعة',
        Icons.medication,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _activeMedications.length,
      itemBuilder: (context, index) {
        final medication = _activeMedications[index];
        return MedicationCard(
          medication: medication,
          child: widget.child,
          onTakeDose: () => _takeDose(medication),
          onEdit: () => _editMedication(medication),
          onStop: () => _stopMedication(medication),
        );
      },
    );
  }

  Widget _buildUpcomingDosesTab() {
    if (_upcomingDoses.isEmpty) {
      return _buildEmptyState(
        'لا توجد جرعات قادمة',
        'الجرعات القادمة خلال الساعتين القادمتين ستظهر هنا',
        Icons.schedule,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _upcomingDoses.length,
      itemBuilder: (context, index) {
        final medication = _upcomingDoses[index];
        return MedicationCard(
          medication: medication,
          child: widget.child,
          isUpcoming: true,
          onTakeDose: () => _takeDose(medication),
          onEdit: () => _editMedication(medication),
          onStop: () => _stopMedication(medication),
        );
      },
    );
  }

  Widget _buildCompletedMedicationsTab() {
    if (_completedMedications.isEmpty) {
      return _buildEmptyState(
        'لا توجد أدوية سابقة',
        'الأدوية المكتملة أو المتوقفة ستظهر هنا',
        Icons.history,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _completedMedications.length,
      itemBuilder: (context, index) {
        final medication = _completedMedications[index];
        return MedicationCard(
          medication: medication,
          child: widget.child,
          isCompleted: true,
          onEdit: () => _editMedication(medication),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: _addMedication,
            icon: const Icon(Icons.add),
            label: const Text('إضافة دواء'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMedication() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMedicationScreen(child: widget.child),
      ),
    );

    if (result == true) {
      _loadMedications();
    }
  }

  Future<void> _editMedication(Medication medication) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMedicationScreen(
          child: widget.child,
          existingMedication: medication,
        ),
      ),
    );

    if (result == true) {
      _loadMedications();
    }
  }

  Future<void> _takeDose(Medication medication) async {
    try {
      // Update medication with new dose taken
      final updatedMedication = medication.copyWith(
        lastDoseTime: DateTime.now(),
        nextDoseTime: _calculateNextDoseTime(medication),
        dosesRemaining: medication.dosesRemaining != null 
            ? medication.dosesRemaining! - 1 
            : null,
      );

      // Update the profile
      final profile = await ChildProfileService.instance.getProfileById(widget.child.id);
      if (profile != null) {
        final updatedMedications = profile.medications.map((med) {
          return med.id == medication.id ? updatedMedication : med;
        }).toList();

        final updatedProfile = profile.copyWith(
          medications: updatedMedications,
          updatedAt: DateTime.now(),
        );

        await ChildProfileService.instance.saveChildProfile(updatedProfile);
        _loadMedications();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الجرعة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الجرعة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _stopMedication(Medication medication) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إيقاف الدواء'),
        content: Text('هل أنت متأكد من إيقاف دواء ${medication.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('إيقاف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final updatedMedication = medication.copyWith(
          isActive: false,
          endDate: DateTime.now(),
        );

        final profile = await ChildProfileService.instance.getProfileById(widget.child.id);
        if (profile != null) {
          final updatedMedications = profile.medications.map((med) {
            return med.id == medication.id ? updatedMedication : med;
          }).toList();

          final updatedProfile = profile.copyWith(
            medications: updatedMedications,
            updatedAt: DateTime.now(),
          );

          await ChildProfileService.instance.saveChildProfile(updatedProfile);
          _loadMedications();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إيقاف الدواء بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إيقاف الدواء'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  DateTime? _calculateNextDoseTime(Medication medication) {
    if (medication.frequency == null) return null;
    
    final now = DateTime.now();
    switch (medication.frequency!) {
      case MedicationFrequency.onceDaily:
        return DateTime(now.year, now.month, now.day + 1, 
            medication.preferredTime?.hour ?? 8, 
            medication.preferredTime?.minute ?? 0);
      case MedicationFrequency.twiceDaily:
        return now.add(const Duration(hours: 12));
      case MedicationFrequency.threeTimesDaily:
        return now.add(const Duration(hours: 8));
      case MedicationFrequency.fourTimesDaily:
        return now.add(const Duration(hours: 6));
      case MedicationFrequency.asNeeded:
        return null;
    }
  }
}
