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
  
  // Gestion permissions
  final bool canManagePermissions;
  final String? delegatedBy; // ID de l'utilisateur qui a délégué
  final DateTime? delegationExpiresAt;

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
    this.canManagePermissions = false,
    this.delegatedBy,
    this.delegationExpiresAt,
  });

  String get fullName => '$firstName $lastName';

  bool get isPatient => role == UserRole.patient;
  bool get isProfessional => role == UserRole.kine || role == UserRole.coach;
  bool get isManager => role == UserRole.manager;
  bool get isSadmin => role == UserRole.sadmin;
  bool get isAdmin => isManager || isSadmin;
  
  /// Vérifie si la délégation est encore valide
  bool get isDelegationValid {
    if (!canManagePermissions) return false;
    if (delegationExpiresAt == null) return true; // Permanent
    return DateTime.now().isBefore(delegationExpiresAt!);
  }

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
      canManagePermissions: data['canManagePermissions'] as bool? ?? false,
      delegatedBy: data['delegatedBy'] as String?,
      delegationExpiresAt: (data['delegationExpiresAt'] as dynamic)?.toDate(),
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
      'canManagePermissions': canManagePermissions,
      'delegatedBy': delegatedBy,
      'delegationExpiresAt': delegationExpiresAt,
    };
  }
}

/// Rôles utilisateurs (hiérarchie: sadmin > manager > délégué > kine/coach > patient)
enum UserRole {
  patient,    // Patient
  kine,       // Kinésithérapeute
  coach,      // Coach APA
  manager,    // Responsable cabinet (patron)
  sadmin,     // Super administrateur configuration
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
      case UserRole.manager:
        return 'Responsable Cabinet';
      case UserRole.sadmin:
        return 'Super Admin';
    }
  }
  
  /// Niveau hiérarchique (plus élevé = plus de droits)
  int get hierarchyLevel {
    switch (this) {
      case UserRole.patient:
        return 0;
      case UserRole.kine:
      case UserRole.coach:
        return 1;
      case UserRole.manager:
        return 2;
      case UserRole.sadmin:
        return 3;
    }
  }
  
  /// Peut gérer les utilisateurs
  bool get canManageUsers => this == UserRole.sadmin || this == UserRole.manager;
  
  /// Peut traiter des patients
  bool get canTreatPatients => this == UserRole.kine || this == UserRole.coach;
  
  /// Accès configuration système
  bool get canAccessSystemConfig => this == UserRole.sadmin;
}
