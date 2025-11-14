/// Modèle utilisateur pour patients et professionnels
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phoneNumber,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  bool get isPatient => role == UserRole.patient;
  bool get isProfessional => role == UserRole.kine || role == UserRole.coach;

  /// Conversion depuis Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.patient,
      ),
      phoneNumber: data['phoneNumber'] as String?,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as dynamic)?.toDate(),
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'isActive': isActive,
    };
  }
}

/// Rôles utilisateurs
enum UserRole {
  patient,    // Patient
  kine,       // Kinésithérapeute
  coach,      // Coach APA
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.kine:
        return 'Kinésithérapeute';
      case UserRole.coach:
        return 'Coach APA';
    }
  }
}
