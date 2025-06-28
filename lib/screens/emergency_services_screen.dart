import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/emergency_service.dart';
import '../widgets/hospital_card.dart';
import '../widgets/pharmacy_card.dart';
import '../widgets/emergency_numbers_card.dart';

class EmergencyServicesScreen extends StatefulWidget {
  const EmergencyServicesScreen({super.key});

  @override
  State<EmergencyServicesScreen> createState() => _EmergencyServicesScreenState();
}

class _EmergencyServicesScreenState extends State<EmergencyServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Hospital> _hospitals = [];
  List<Pharmacy> _pharmacies = [];
  EmergencyNumbers? _emergencyNumbers;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEmergencyServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEmergencyServices() async {
    try {
      // Load hospitals
      final String hospitalsJson = await rootBundle.loadString(AppConstants.hospitalsDataFile);
      final Map<String, dynamic> hospitalsData = json.decode(hospitalsJson);
      final hospitalData = HospitalData.fromJson(hospitalsData);
      
      // Load pharmacies
      final String pharmaciesJson = await rootBundle.loadString(AppConstants.pharmaciesDataFile);
      final Map<String, dynamic> pharmaciesData = json.decode(pharmaciesJson);
      final pharmacyData = PharmacyData.fromJson(pharmaciesData);
      
      setState(() {
        _hospitals = hospitalData.hospitals;
        _pharmacies = pharmacyData.pharmacies;
        _emergencyNumbers = hospitalData.emergencyNumbers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading emergency services: $e');
    }
  }

  List<Hospital> get _filteredHospitals {
    if (_searchQuery.isEmpty) {
      return _hospitals;
    }
    
    return _hospitals.where((hospital) =>
        hospital.nameArabic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        hospital.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        hospital.specialties.any((specialty) => 
            specialty.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
  }

  List<Pharmacy> get _filteredPharmacies {
    if (_searchQuery.isEmpty) {
      return _pharmacies;
    }
    
    return _pharmacies.where((pharmacy) =>
        pharmacy.nameArabic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        pharmacy.address.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'الخدمات الطارئة',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: AppColors.emergencyRed,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: _showEmergencyNumbers,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_hospital),
              text: 'المستشفيات',
            ),
            Tab(
              icon: Icon(Icons.local_pharmacy),
              text: 'الصيدليات',
            ),
            Tab(
              icon: Icon(Icons.phone),
              text: 'أرقام الطوارئ',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Emergency banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              gradient: AppColors.emergencyGradient,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                const Expanded(
                  child: Text(
                    'في حالات الطوارئ الخطيرة، اتصل بالرقم 14 فوراً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _callEmergency('14'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.emergencyRed,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    'اتصال',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Search bar (for hospitals and pharmacies tabs)
          if (_tabController.index < 2)
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: _tabController.index == 0 
                      ? 'ابحث عن مستشفى...'
                      : 'ابحث عن صيدلية...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    borderSide: BorderSide(color: AppColors.emergencyRed),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

          // Tab content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.emergencyRed,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildHospitalsTab(),
                      _buildPharmaciesTab(),
                      _buildEmergencyNumbersTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalsTab() {
    if (_filteredHospitals.isEmpty) {
      return _buildEmptyState('لا توجد مستشفيات', 'جرب البحث بكلمات أخرى');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = _filteredHospitals[index];
        return HospitalCard(
          hospital: hospital,
          onCall: () => _callHospital(hospital),
          onDirections: () => _getDirections(hospital.latitude, hospital.longitude),
        );
      },
    );
  }

  Widget _buildPharmaciesTab() {
    if (_filteredPharmacies.isEmpty) {
      return _buildEmptyState('لا توجد صيدليات', 'جرب البحث بكلمات أخرى');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _filteredPharmacies.length,
      itemBuilder: (context, index) {
        final pharmacy = _filteredPharmacies[index];
        return PharmacyCard(
          pharmacy: pharmacy,
          onCall: () => _callPharmacy(pharmacy),
          onDirections: () => _getDirections(pharmacy.latitude, pharmacy.longitude),
        );
      },
    );
  }

  Widget _buildEmergencyNumbersTab() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    EmergencyNumbersCard(
                      emergencyNumbers: _emergencyNumbers!,
                      onCall: _callEmergency,
                    ),
                    const SizedBox(height: AppConstants.largePadding),
                    // Additional emergency info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: AppConstants.smallPadding),
                              const Text(
                                'معلومات مهمة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.info,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          const Text(
                            '• في حالات الطوارئ الخطيرة، اتصل بالرقم 14 أولاً\n'
                            '• احتفظ بهدوئك وتحدث بوضوح\n'
                            '• اذكر موقعك بدقة\n'
                            '• اتبع تعليمات المختص\n'
                            '• لا تنه المكالمة حتى يطلب منك ذلك',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.5,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
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
          ),
        ],
      ),
    );
  }

  void _showEmergencyNumbers() {
    if (_emergencyNumbers != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.emergency,
                color: AppColors.emergencyRed,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              const Text('أرقام الطوارئ'),
            ],
          ),
          content: EmergencyNumbersCard(
            emergencyNumbers: _emergencyNumbers!,
            onCall: _callEmergency,
            isCompact: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    }
  }

  void _callEmergency(String number) {
    // In a real app, use url_launcher to make phone calls
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: Text('سيتم الاتصال بالرقم: $number'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement actual phone call
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
            ),
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _callHospital(Hospital hospital) {
    final phoneNumber = hospital.emergencyPhone ?? hospital.phone;
    _callEmergency(phoneNumber);
  }

  void _callPharmacy(Pharmacy pharmacy) {
    _callEmergency(pharmacy.phone);
  }

  void _getDirections(double latitude, double longitude) {
    // In a real app, open maps app with directions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الاتجاهات'),
        content: Text('سيتم فتح الخرائط للموقع: $latitude, $longitude'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement actual maps navigation
            },
            child: const Text('فتح الخرائط'),
          ),
        ],
      ),
    );
  }
}
