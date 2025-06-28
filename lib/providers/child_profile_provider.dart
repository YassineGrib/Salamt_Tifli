import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../services/child_profile_service.dart';

/// Provider for managing child profiles
class ChildProfileProvider extends ChangeNotifier {
  List<ChildProfile> _profiles = [];
  ChildProfile? _selectedProfile;

  // Getters
  List<ChildProfile> get profiles => _profiles;
  ChildProfile? get selectedProfile => _selectedProfile;
  bool get hasProfiles => _profiles.isNotEmpty;

  // Add a new child profile
  void addProfile(ChildProfile profile) {
    _profiles.add(profile);
    if (_selectedProfile == null) {
      _selectedProfile = profile;
    }
    notifyListeners();
  }

  // Update an existing profile
  void updateProfile(ChildProfile updatedProfile) {
    final index = _profiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      _profiles[index] = updatedProfile;
      if (_selectedProfile?.id == updatedProfile.id) {
        _selectedProfile = updatedProfile;
      }
      notifyListeners();
    }
  }

  // Remove a profile
  void removeProfile(String profileId) {
    _profiles.removeWhere((p) => p.id == profileId);
    if (_selectedProfile?.id == profileId) {
      _selectedProfile = _profiles.isNotEmpty ? _profiles.first : null;
    }
    notifyListeners();
  }

  // Select a profile
  void selectProfile(ChildProfile profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  // Load profiles from storage
  Future<void> loadProfiles() async {
    final profiles = await ChildProfileService.instance.getAllProfiles();
    final activeProfileId = await ChildProfileService.instance.getActiveProfileId();

    _profiles = profiles;
    if (profiles.isNotEmpty) {
      _selectedProfile = profiles.firstWhere(
        (p) => p.id == activeProfileId,
        orElse: () => profiles.first,
      );
    } else {
      _selectedProfile = null;
    }
    notifyListeners();
  }

  // Save profiles to storage (placeholder)
  Future<void> saveProfiles() async {
    // TODO: Implement saving to local storage
  }
}
