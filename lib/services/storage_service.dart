import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../models/child_profile.dart';

/// Service for handling local data storage
class StorageService {
  static StorageService? _instance;
  static Database? _database;
  static SharedPreferences? _prefs;
  
  StorageService._();
  
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }
  
  /// Initialize storage services
  Future<void> initialize() async {
    await _initializeSharedPreferences();
    await _initializeDatabase();
  }
  
  /// Initialize SharedPreferences
  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Initialize SQLite database
  Future<void> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.databaseName);
    
    _database = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }
  
  /// Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    // Child profiles table
    await db.execute('''
      CREATE TABLE child_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        gender TEXT NOT NULL,
        weight REAL,
        height REAL,
        allergies TEXT,
        medications TEXT,
        vaccinations TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    // Vaccination records table
    await db.execute('''
      CREATE TABLE vaccination_records (
        id TEXT PRIMARY KEY,
        child_id TEXT NOT NULL,
        vaccine_name TEXT NOT NULL,
        date_given TEXT NOT NULL,
        batch_number TEXT,
        location TEXT,
        notes TEXT,
        FOREIGN KEY (child_id) REFERENCES child_profiles (id)
      )
    ''');
    
    // Medication records table
    await db.execute('''
      CREATE TABLE medication_records (
        id TEXT PRIMARY KEY,
        child_id TEXT NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        notes TEXT,
        FOREIGN KEY (child_id) REFERENCES child_profiles (id)
      )
    ''');
  }
  
  /// Upgrade database schema
  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }
  
  // SharedPreferences methods
  
  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }
  
  /// Get string value
  String? getString(String key) {
    return _prefs!.getString(key);
  }
  
  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }
  
  /// Get boolean value
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs!.getBool(key) ?? defaultValue;
  }
  
  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }
  
  /// Get integer value
  int getInt(String key, {int defaultValue = 0}) {
    return _prefs!.getInt(key) ?? defaultValue;
  }
  
  /// Remove value
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }
  
  /// Clear all preferences
  Future<bool> clearAll() async {
    return await _prefs!.clear();
  }
  
  // Database methods for child profiles
  
  /// Save child profile
  Future<void> saveChildProfile(ChildProfile profile) async {
    await _database!.insert(
      'child_profiles',
      {
        'id': profile.id,
        'name': profile.name,
        'birth_date': profile.birthDate.toIso8601String(),
        'gender': profile.gender,
        'weight': profile.weight,
        'height': profile.height,
        'allergies': jsonEncode(profile.allergies),
        'medications': jsonEncode(profile.medications.map((m) => m.toJson()).toList()),
        'vaccinations': jsonEncode(profile.vaccinations.map((v) => v.toJson()).toList()),
        'notes': profile.notes,
        'created_at': profile.createdAt.toIso8601String(),
        'updated_at': profile.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// Get all child profiles
  Future<List<ChildProfile>> getChildProfiles() async {
    final List<Map<String, dynamic>> maps = await _database!.query('child_profiles');
    
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return ChildProfile(
        id: map['id'],
        name: map['name'],
        birthDate: DateTime.parse(map['birth_date']),
        gender: map['gender'],
        weight: map['weight'],
        height: map['height'],
        allergies: List<String>.from(jsonDecode(map['allergies'] ?? '[]')),
        medications: (jsonDecode(map['medications'] ?? '[]') as List)
            .map((m) => Medication.fromJson(m))
            .toList(),
        vaccinations: (jsonDecode(map['vaccinations'] ?? '[]') as List)
            .map((v) => VaccinationRecord.fromJson(v))
            .toList(),
        notes: map['notes'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
    });
  }
  
  /// Delete child profile
  Future<void> deleteChildProfile(String profileId) async {
    await _database!.delete(
      'child_profiles',
      where: 'id = ?',
      whereArgs: [profileId],
    );
  }
  
  /// Close database connection
  Future<void> close() async {
    await _database?.close();
  }
}
