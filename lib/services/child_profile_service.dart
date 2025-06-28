import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_profile.dart';

class ChildProfileService {
  static ChildProfileService? _instance;
  static const String _profilesKey = 'child_profiles';
  static const String _activeProfileKey = 'active_child_profile';

  ChildProfileService._();

  static ChildProfileService get instance {
    _instance ??= ChildProfileService._();
    return _instance!;
  }

  /// Get all child profiles
  Future<List<ChildProfile>> getAllProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getStringList(_profilesKey) ?? [];
      
      return profilesJson
          .map((json) => ChildProfile.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading profiles: $e');
      return [];
    }
  }

  /// Save a child profile
  Future<void> saveChildProfile(ChildProfile profile) async {
    try {
      final profiles = await getAllProfiles();
      
      // Check if profile already exists
      final existingIndex = profiles.indexWhere((p) => p.id == profile.id);
      
      if (existingIndex != -1) {
        // Update existing profile
        profiles[existingIndex] = profile;
      } else {
        // Add new profile
        profiles.add(profile);
      }
      
      await _saveAllProfiles(profiles);
      
      // If this is the first profile, make it active
      if (profiles.length == 1) {
        await setActiveProfile(profile.id);
      }
    } catch (e) {
      throw Exception('Failed to save child profile: $e');
    }
  }

  /// Delete a child profile
  Future<void> deleteChildProfile(String profileId) async {
    try {
      final profiles = await getAllProfiles();
      profiles.removeWhere((profile) => profile.id == profileId);
      
      await _saveAllProfiles(profiles);
      
      // If deleted profile was active, set new active profile
      final activeProfileId = await getActiveProfileId();
      if (activeProfileId == profileId) {
        if (profiles.isNotEmpty) {
          await setActiveProfile(profiles.first.id);
        } else {
          await clearActiveProfile();
        }
      }
    } catch (e) {
      throw Exception('Failed to delete child profile: $e');
    }
  }

  /// Get a specific child profile by ID
  Future<ChildProfile?> getProfileById(String profileId) async {
    try {
      final profiles = await getAllProfiles();
      return profiles.firstWhere(
        (profile) => profile.id == profileId,
        orElse: () => throw StateError('Profile not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get the active child profile
  Future<ChildProfile?> getActiveProfile() async {
    try {
      final activeProfileId = await getActiveProfileId();
      if (activeProfileId != null) {
        return await getProfileById(activeProfileId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Set the active child profile
  Future<void> setActiveProfile(String profileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeProfileKey, profileId);
    } catch (e) {
      throw Exception('Failed to set active profile: $e');
    }
  }

  /// Get the active profile ID
  Future<String?> getActiveProfileId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_activeProfileKey);
    } catch (e) {
      return null;
    }
  }

  /// Clear the active profile
  Future<void> clearActiveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activeProfileKey);
    } catch (e) {
      throw Exception('Failed to clear active profile: $e');
    }
  }

  /// Add vaccination to a child profile
  Future<void> addVaccination(String profileId, VaccinationRecord vaccination) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        final updatedVaccinations = [...profile.vaccinations, vaccination];
        final updatedProfile = profile.copyWith(
          vaccinations: updatedVaccinations,
          updatedAt: DateTime.now(),
        );
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to add vaccination: $e');
    }
  }

  /// Add medication to a child profile
  Future<void> addMedication(String profileId, Medication medication) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        final updatedMedications = [...profile.medications, medication];
        final updatedProfile = profile.copyWith(
          medications: updatedMedications,
          updatedAt: DateTime.now(),
        );
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  /// Add allergy to a child profile
  Future<void> addAllergy(String profileId, Allergy allergy) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        final updatedAllergies = [...profile.allergies, allergy];
        final updatedProfile = profile.copyWith(
          allergies: updatedAllergies,
          updatedAt: DateTime.now(),
        );
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to add allergy: $e');
    }
  }

  /// Add medical history entry to a child profile
  Future<void> addMedicalHistory(String profileId, MedicalHistoryEntry entry) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        final updatedHistory = [...profile.medicalHistory, entry];
        final updatedProfile = profile.copyWith(
          medicalHistory: updatedHistory,
          updatedAt: DateTime.now(),
        );
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to add medical history: $e');
    }
  }

  /// Update child's physical measurements
  Future<void> updatePhysicalMeasurements(
    String profileId, {
    double? weight,
    double? height,
  }) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        final updatedProfile = profile.copyWith(
          weight: weight ?? profile.weight,
          height: height ?? profile.height,
          updatedAt: DateTime.now(),
        );
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to update physical measurements: $e');
    }
  }

  /// Get vaccination history for a child
  Future<List<VaccinationRecord>> getVaccinationHistory(String profileId) async {
    try {
      final profile = await getProfileById(profileId);
      return profile?.vaccinations ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Get current medications for a child
  Future<List<Medication>> getCurrentMedications(String profileId) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile == null) return [];
      
      // Filter active medications
      return profile.medications.where((med) => med.isActive).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get allergies for a child
  Future<List<Allergy>> getAllergies(String profileId) async {
    try {
      final profile = await getProfileById(profileId);
      return profile?.allergies ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Search profiles by name
  Future<List<ChildProfile>> searchProfiles(String query) async {
    try {
      final profiles = await getAllProfiles();
      final lowerQuery = query.toLowerCase();
      
      return profiles.where((profile) =>
          profile.name.toLowerCase().contains(lowerQuery)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get profiles count
  Future<int> getProfilesCount() async {
    try {
      final profiles = await getAllProfiles();
      return profiles.length;
    } catch (e) {
      return 0;
    }
  }

  /// Export profile data (for backup)
  Future<Map<String, dynamic>> exportProfileData(String profileId) async {
    try {
      final profile = await getProfileById(profileId);
      if (profile != null) {
        return profile.toJson();
      }
      throw Exception('Profile not found');
    } catch (e) {
      throw Exception('Failed to export profile data: $e');
    }
  }

  /// Import profile data (from backup)
  Future<void> importProfileData(Map<String, dynamic> profileData) async {
    try {
      final profile = ChildProfile.fromJson(profileData);
      await saveChildProfile(profile);
    } catch (e) {
      throw Exception('Failed to import profile data: $e');
    }
  }

  /// Clear all profiles (for testing or reset)
  Future<void> clearAllProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profilesKey);
      await prefs.remove(_activeProfileKey);
    } catch (e) {
      throw Exception('Failed to clear all profiles: $e');
    }
  }

  /// Private method to save all profiles
  Future<void> _saveAllProfiles(List<ChildProfile> profiles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = profiles
          .map((profile) => jsonEncode(profile.toJson()))
          .toList();
      
      await prefs.setStringList(_profilesKey, profilesJson);
    } catch (e) {
      throw Exception('Failed to save profiles: $e');
    }
  }
}
