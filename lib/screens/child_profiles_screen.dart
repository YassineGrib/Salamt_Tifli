import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';
import '../services/child_profile_service.dart';
import '../screens/add_child_profile_screen.dart';
import '../widgets/child_profile_card.dart';

class ChildProfilesScreen extends StatefulWidget {
  const ChildProfilesScreen({super.key});

  @override
  State<ChildProfilesScreen> createState() => _ChildProfilesScreenState();
}

class _ChildProfilesScreenState extends State<ChildProfilesScreen> {
  List<ChildProfile> _profiles = [];
  String? _activeProfileId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = await ChildProfileService.instance.getAllProfiles();
      final activeProfileId = await ChildProfileService.instance.getActiveProfileId();
      
      setState(() {
        _profiles = profiles;
        _activeProfileId = activeProfileId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('ملفات الأطفال'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            )
          : _profiles.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: _profiles.length,
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    final isActive = profile.id == _activeProfileId;
                    
                    return ChildProfileCard(
                      profile: profile,
                      isActive: isActive,
                      onTap: () => _selectProfile(profile),
                      onEdit: () => _editProfile(profile),
                      onDelete: () => _deleteProfile(profile),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProfile,
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add),
        label: const Text('إضافة طفل'),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'لا توجد ملفات أطفال',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          const Text(
            'أضف ملف طفلك الأول لبدء الاستخدام',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: _addNewProfile,
            icon: const Icon(Icons.add),
            label: const Text('إضافة طفل جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddChildProfileScreen(),
      ),
    );

    if (result != null) {
      _loadProfiles();
    }
  }

  Future<void> _editProfile(ChildProfile profile) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddChildProfileScreen(existingProfile: profile),
      ),
    );

    if (result != null) {
      _loadProfiles();
    }
  }

  Future<void> _selectProfile(ChildProfile profile) async {
    try {
      await ChildProfileService.instance.setActiveProfile(profile.id);
      setState(() {
        _activeProfileId = profile.id;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم اختيار ${profile.name} كملف نشط'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء اختيار الملف'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteProfile(ChildProfile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف ملف الطفل'),
        content: Text('هل أنت متأكد من حذف ملف ${profile.name}؟ لا يمكن التراجع عن هذا الإجراء.'),
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
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ChildProfileService.instance.deleteChildProfile(profile.id);
        _loadProfiles();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف ملف الطفل بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء حذف الملف'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
