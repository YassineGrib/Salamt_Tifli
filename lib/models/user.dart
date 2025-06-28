class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final UserProfile? profile;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      profile: json['profile'] != null 
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'profile': profile?.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    UserProfile? profile,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profile: profile ?? this.profile,
    );
  }
}

class UserProfile {
  final String? avatar;
  final String? city;
  final String? wilaya;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String> interests;
  final Map<String, dynamic> preferences;

  UserProfile({
    this.avatar,
    this.city,
    this.wilaya,
    this.dateOfBirth,
    this.gender,
    this.interests = const [],
    this.preferences = const {},
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      avatar: json['avatar'] as String?,
      city: json['city'] as String?,
      wilaya: json['wilaya'] as String?,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'city': city,
      'wilaya': wilaya,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'interests': interests,
      'preferences': preferences,
    };
  }

  UserProfile copyWith({
    String? avatar,
    String? city,
    String? wilaya,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? interests,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      avatar: avatar ?? this.avatar,
      city: city ?? this.city,
      wilaya: wilaya ?? this.wilaya,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      preferences: preferences ?? this.preferences,
    );
  }
}

// Demo users for testing
class DemoUsers {
  static final List<User> users = [
    User(
      id: 'demo_user_1',
      email: 'demo@salamttifli.dz',
      name: 'أحمد محمد',
      phoneNumber: '+213555123456',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      isEmailVerified: true,
      profile: UserProfile(
        city: 'سطيف',
        wilaya: 'سطيف',
        dateOfBirth: DateTime(1985, 5, 15),
        gender: 'ذكر',
        interests: ['الصحة', 'السلامة', 'التعليم'],
        preferences: {
          'notifications': true,
          'language': 'ar',
          'theme': 'light',
        },
      ),
    ),
    User(
      id: 'demo_user_2',
      email: 'parent@salamttifli.dz',
      name: 'فاطمة علي',
      phoneNumber: '+213666789012',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isEmailVerified: true,
      profile: UserProfile(
        city: 'الجزائر العاصمة',
        wilaya: 'الجزائر',
        dateOfBirth: DateTime(1990, 8, 22),
        gender: 'أنثى',
        interests: ['الأطفال', 'الطبخ', 'الرياضة'],
        preferences: {
          'notifications': true,
          'language': 'ar',
          'theme': 'light',
        },
      ),
    ),
  ];

  static const String demoPassword = '123456';
  
  static User? findUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }
}
