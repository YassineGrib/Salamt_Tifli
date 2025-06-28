import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';
import '../services/child_profile_service.dart';

class AddMedicationScreen extends StatefulWidget {
  final ChildProfile child;
  final Medication? existingMedication;

  const AddMedicationScreen({
    super.key,
    required this.child,
    this.existingMedication,
  });

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _durationController = TextEditingController();
  final _dosesController = TextEditingController();
  
  String _selectedForm = 'أقراص';
  MedicationFrequency _selectedFrequency = MedicationFrequency.onceDaily;
  TimeOfDay? _preferredTime;
  DateTime? _startDate;
  bool _isLoading = false;

  final List<String> _medicationForms = [
    'أقراص', 'كبسولات', 'شراب', 'قطرات', 'مرهم', 'كريم', 'حقن'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingMedication != null) {
      _populateExistingData();
    } else {
      _startDate = DateTime.now();
      _preferredTime = const TimeOfDay(hour: 8, minute: 0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    _durationController.dispose();
    _dosesController.dispose();
    super.dispose();
  }

  void _populateExistingData() {
    final med = widget.existingMedication!;
    _nameController.text = med.name;
    _dosageController.text = med.dosage;
    _selectedForm = med.form;
    _instructionsController.text = med.instructions;
    _selectedFrequency = med.frequency ?? MedicationFrequency.onceDaily;
    _startDate = med.startDate;
    _preferredTime = med.preferredTime;
    _durationController.text = med.duration?.toString() ?? '';
    _dosesController.text = med.totalDoses?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingMedication != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل الدواء' : 'إضافة دواء جديد'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Child info header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Row(
                  children: [
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
                    Column(
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
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Medication name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم الدواء *',
                  prefixIcon: const Icon(Icons.medication),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم الدواء';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Dosage and form
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _dosageController,
                      decoration: InputDecoration(
                        labelText: 'الجرعة *',
                        prefixIcon: const Icon(Icons.straighten),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        hintText: 'مثال: 5 مل، 1 قرص',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الجرعة';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedForm,
                      decoration: InputDecoration(
                        labelText: 'الشكل',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      items: _medicationForms.map((form) {
                        return DropdownMenuItem(
                          value: form,
                          child: Text(form),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedForm = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Frequency
              DropdownButtonFormField<MedicationFrequency>(
                value: _selectedFrequency,
                decoration: InputDecoration(
                  labelText: 'تكرار الجرعة *',
                  prefixIcon: const Icon(Icons.schedule),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                items: MedicationFrequency.values.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(_getFrequencyText(frequency)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Preferred time
              InkWell(
                onTap: _selectPreferredTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'الوقت المفضل',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  child: Text(
                    _preferredTime != null
                        ? '${_preferredTime!.hour.toString().padLeft(2, '0')}:${_preferredTime!.minute.toString().padLeft(2, '0')}'
                        : 'اختر الوقت المفضل',
                    style: TextStyle(
                      color: _preferredTime != null 
                          ? AppColors.textPrimary 
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Start date
              InkWell(
                onTap: _selectStartDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'تاريخ البداية *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  child: Text(
                    _startDate != null
                        ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                        : 'اختر تاريخ البداية',
                    style: TextStyle(
                      color: _startDate != null 
                          ? AppColors.textPrimary 
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Duration and total doses
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'المدة (أيام)',
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: TextFormField(
                      controller: _dosesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'عدد الجرعات',
                        prefixIcon: const Icon(Icons.medication),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Instructions
              TextFormField(
                controller: _instructionsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'تعليمات الاستخدام',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  hintText: 'مثال: مع الطعام، قبل النوم، إلخ...',
                ),
              ),

              const SizedBox(height: AppConstants.largePadding * 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(isEditing ? 'حفظ التغييرات' : 'إضافة الدواء'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyText(MedicationFrequency frequency) {
    switch (frequency) {
      case MedicationFrequency.onceDaily:
        return 'مرة واحدة يومياً';
      case MedicationFrequency.twiceDaily:
        return 'مرتين يومياً';
      case MedicationFrequency.threeTimesDaily:
        return 'ثلاث مرات يومياً';
      case MedicationFrequency.fourTimesDaily:
        return 'أربع مرات يومياً';
      case MedicationFrequency.asNeeded:
        return 'حسب الحاجة';
    }
  }

  Future<void> _selectPreferredTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _preferredTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    
    if (picked != null) {
      setState(() {
        _preferredTime = picked;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار تاريخ البداية'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final medication = Medication(
        id: widget.existingMedication?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        form: _selectedForm,
        frequency: _selectedFrequency,
        instructions: _instructionsController.text.trim(),
        startDate: _startDate!,
        duration: _durationController.text.isNotEmpty ? int.tryParse(_durationController.text) : null,
        totalDoses: _dosesController.text.isNotEmpty ? int.tryParse(_dosesController.text) : null,
        preferredTime: _preferredTime,
        isActive: widget.existingMedication?.isActive ?? true,
        nextDoseTime: _calculateNextDoseTime(),
        lastDoseTime: widget.existingMedication?.lastDoseTime,
        dosesRemaining: _dosesController.text.isNotEmpty ? int.tryParse(_dosesController.text) : null,
        endDate: widget.existingMedication?.endDate,
      );

      // Update the child profile
      final profile = await ChildProfileService.instance.getProfileById(widget.child.id);
      if (profile != null) {
        List<Medication> updatedMedications;
        
        if (widget.existingMedication != null) {
          // Update existing medication
          updatedMedications = profile.medications.map((med) {
            return med.id == medication.id ? medication : med;
          }).toList();
        } else {
          // Add new medication
          updatedMedications = [...profile.medications, medication];
        }

        final updatedProfile = profile.copyWith(
          medications: updatedMedications,
          updatedAt: DateTime.now(),
        );

        await ChildProfileService.instance.saveChildProfile(updatedProfile);

        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.existingMedication != null 
                  ? 'تم تحديث الدواء بنجاح'
                  : 'تم إضافة الدواء بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء حفظ البيانات'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  DateTime? _calculateNextDoseTime() {
    if (_startDate == null || _preferredTime == null) return null;
    
    final now = DateTime.now();
    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _preferredTime!.hour,
      _preferredTime!.minute,
    );

    if (startDateTime.isAfter(now)) {
      return startDateTime;
    }

    // Calculate next dose based on frequency
    switch (_selectedFrequency) {
      case MedicationFrequency.onceDaily:
        return DateTime(now.year, now.month, now.day + 1, _preferredTime!.hour, _preferredTime!.minute);
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
