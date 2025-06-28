import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/consultation.dart';
import '../providers/child_profile_provider.dart';
import '../widgets/specialty_card.dart';
import '../widgets/doctor_card.dart';
import '../widgets/time_slot_selector.dart';

class ConsultationBookingScreen extends StatefulWidget {
  const ConsultationBookingScreen({super.key});

  @override
  State<ConsultationBookingScreen> createState() => _ConsultationBookingScreenState();
}

class _ConsultationBookingScreenState extends State<ConsultationBookingScreen> {
  int _currentStep = 0;
  String? _selectedSpecialty;
  ConsultationType? _selectedType;
  Doctor? _selectedDoctor;
  DateTime? _selectedDateTime;

  final List<Map<String, dynamic>> _specialties = [
    {
      'id': 'pediatrics',
      'name': 'طب الأطفال',
      'icon': Icons.child_care,
      'color': AppColors.primaryGreen,
      'description': 'للمشاكل الصحية العامة للأطفال'
    },
    {
      'id': 'emergency',
      'name': 'طوارئ الأطفال',
      'icon': Icons.emergency,
      'color': AppColors.emergencyRed,
      'description': 'للحالات الطارئة والإسعافات الأولية'
    },
    {
      'id': 'burns',
      'name': 'الحروق',
      'icon': Icons.local_fire_department,
      'color': AppColors.burnCategory,
      'description': 'لعلاج الحروق والإصابات الحرارية'
    },
    {
      'id': 'poisoning',
      'name': 'التسمم',
      'icon': Icons.warning,
      'color': AppColors.poisonCategory,
      'description': 'للتعامل مع حالات التسمم'
    },
    {
      'id': 'trauma',
      'name': 'الإصابات والكسور',
      'icon': Icons.healing,
      'color': AppColors.fallCategory,
      'description': 'لإصابات السقوط والكسور'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز استشارة طبية'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                for (int i = 0; i < 4; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: i < 3 ? AppConstants.smallPadding : 0,
                      ),
                      decoration: BoxDecoration(
                        color: i <= _currentStep 
                            ? AppColors.primaryGreen 
                            : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Step content
          Expanded(
            child: _buildStepContent(),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: const Text('السابق'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _handleNext : null,
                    child: Text(_currentStep == 3 ? 'تأكيد الحجز' : 'التالي'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildSpecialtySelection();
      case 1:
        return _buildConsultationTypeSelection();
      case 2:
        return _buildDoctorSelection();
      case 3:
        return _buildTimeSelection();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSpecialtySelection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر التخصص المطلوب',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: AppConstants.defaultPadding,
                mainAxisSpacing: AppConstants.defaultPadding,
              ),
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                return SpecialtyCard(
                  specialty: specialty,
                  isSelected: _selectedSpecialty == specialty['id'],
                  onTap: () {
                    setState(() {
                      _selectedSpecialty = specialty['id'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationTypeSelection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر نوع الاستشارة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...ConsultationType.values.map((type) => Card(
            margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
            child: RadioListTile<ConsultationType>(
              title: Text(type.displayName),
              subtitle: Text(_getTypeDescription(type)),
              value: type,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              activeColor: AppColors.primaryGreen,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDoctorSelection() {
    // Mock doctors data - in real app, this would come from API
    final mockDoctors = [
      Doctor(
        id: '1',
        name: 'د. أحمد محمد',
        specialty: 'pediatrics',
        specialtyArabic: 'طب الأطفال',
        languages: ['العربية', 'الفرنسية'],
        rating: 4.8,
        reviewCount: 120,
        qualifications: ['دكتوراه في طب الأطفال', 'خبرة 15 سنة'],
        isAvailable: true,
        availableSlots: [],
      ),
      Doctor(
        id: '2',
        name: 'د. فاطمة بن علي',
        specialty: 'emergency',
        specialtyArabic: 'طوارئ الأطفال',
        languages: ['العربية'],
        rating: 4.9,
        reviewCount: 95,
        qualifications: ['أخصائية طوارئ الأطفال', 'خبرة 12 سنة'],
        isAvailable: true,
        availableSlots: [],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر الطبيب',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Expanded(
            child: ListView.builder(
              itemCount: mockDoctors.length,
              itemBuilder: (context, index) {
                final doctor = mockDoctors[index];
                return DoctorCard(
                  doctor: doctor,
                  isSelected: _selectedDoctor?.id == doctor.id,
                  onTap: () {
                    setState(() {
                      _selectedDoctor = doctor;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر الوقت المناسب',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Expanded(
            child: TimeSlotSelector(
              selectedDateTime: _selectedDateTime,
              onTimeSelected: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeDescription(ConsultationType type) {
    switch (type) {
      case ConsultationType.chat:
        return 'محادثة نصية مع الطبيب';
      case ConsultationType.video:
        return 'مكالمة فيديو مباشرة';
      case ConsultationType.voice:
        return 'مكالمة صوتية';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedSpecialty != null;
      case 1:
        return _selectedType != null;
      case 2:
        return _selectedDoctor != null;
      case 3:
        return _selectedDateTime != null;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmBooking();
    }
  }

  void _confirmBooking() {
    // Handle booking confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم تأكيد الحجز'),
        content: const Text('تم حجز الاستشارة بنجاح. سيتم التواصل معك قريباً.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
