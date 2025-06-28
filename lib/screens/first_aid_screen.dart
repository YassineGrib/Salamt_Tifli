import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/first_aid.dart';
import '../widgets/first_aid_category_card.dart';
import '../screens/first_aid_scenario_screen.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  List<FirstAidCategory> _categories = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFirstAidData();
  }

  Future<void> _loadFirstAidData() async {
    try {
      final String jsonString = await rootBundle.loadString(AppConstants.firstAidDataFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final firstAidData = FirstAidData.fromJson(jsonData);
      
      setState(() {
        _categories = firstAidData.categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print('Error loading first aid data: $e');
    }
  }

  List<FirstAidCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _categories;
    }
    
    return _categories.where((category) {
      return category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          category.scenarios.any((scenario) =>
              scenario.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              scenario.description.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('دليل الإسعافات الأولية'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: _showEmergencyDialog,
          ),
        ],
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
                TextButton(
                  onPressed: _callEmergency,
                  child: const Text(
                    'اتصال',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن نوع الإصابة أو الحادث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: AppColors.primaryGreen),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Categories grid
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : _filteredCategories.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                        ),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: AppConstants.defaultPadding,
                            mainAxisSpacing: AppConstants.defaultPadding,
                          ),
                          itemCount: _filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = _filteredCategories[index];
                            return FirstAidCategoryCard(
                              category: category,
                              onTap: () => _navigateToCategory(category),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
          const Text(
            'لم يتم العثور على نتائج',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          const Text(
            'جرب البحث بكلمات أخرى',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(FirstAidCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FirstAidScenarioScreen(
          scenarioId: category.id,
          scenarioTitle: category.name,
          categoryColor: _parseColor(category.color),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      final hexColor = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return AppColors.primaryGreen;
    }
  }

  void _showEmergencyDialog() {
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmergencyNumber('الطوارئ العامة', '14'),
            _buildEmergencyNumber('الهلال الأحمر', '021 65 65 65'),
            _buildEmergencyNumber('الحماية المدنية', '14'),
            _buildEmergencyNumber('الشرطة', '17'),
          ],
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

  Widget _buildEmergencyNumber(String label, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: () => _callNumber(number),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callEmergency() {
    _callNumber('14');
  }

  void _callNumber(String number) {
    // In a real app, use url_launcher to make phone calls
    // For now, just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال'),
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
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }
}
