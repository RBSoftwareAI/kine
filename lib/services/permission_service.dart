import '../models/permission_model.dart';

/// Service de gestion des permissions basées sur les rôles
/// MediDesk - Contrôle d'accès granulaire
class PermissionService {
  // Matrice de permissions : role -> category -> actions autorisées
  static final Map<String, Map<String, List<String>>> _permissionMatrix = {
    // 👤 PATIENT - Accès minimal (seulement ses propres données)
    Permission.patient: {
      Permission.ownData: [
        Permission.view,
        Permission.edit
      ], // Son propre profil
      Permission.painMapping: [
        Permission.view,
        Permission.create,
        Permission.edit
      ], // Sa cartographie
      Permission.appointments: [
        Permission.view,
        Permission.create
      ], // Ses RDV (création = demande)
    },

    // 📋 SECRÉTAIRE - Gestion administrative
    Permission.secretaire: {
      Permission.patients: [
        Permission.view,
        Permission.create,
        Permission.edit
      ],
      Permission.appointments: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete
      ],
      Permission.billing: [Permission.view, Permission.create, Permission.edit],
      Permission.statistics: [Permission.view], // Statistiques basiques
    },

    // 🏢 MANAGER - Gestion complète
    Permission.manager: {
      Permission.patients: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete
      ],
      Permission.appointments: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete
      ],
      Permission.billing: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete
      ],
      Permission.users: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete
      ],
      Permission.statistics: [
        Permission.view,
        Permission.manage
      ], // Stats avancées
      Permission.medicalRecords: [Permission.view], // Lecture seule
    },

    // 🩺 ADMIN (Praticien) - Accès total
    Permission.admin: {
      Permission.patients: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete,
        Permission.manage
      ],
      Permission.appointments: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete,
        Permission.manage
      ],
      Permission.billing: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete,
        Permission.manage
      ],
      Permission.users: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete,
        Permission.manage
      ],
      Permission.statistics: [Permission.view, Permission.manage],
      Permission.medicalRecords: [
        Permission.view,
        Permission.create,
        Permission.edit,
        Permission.delete,
        Permission.manage
      ],
      Permission.painMapping: [
        Permission.view,
        Permission.create,
        Permission.edit
      ], // Voir tous les patients
    },
  };

  /// Vérifie si un rôle a une permission spécifique
  static bool hasPermission(String role, String category, String action) {
    final rolePermissions = _permissionMatrix[role];
    if (rolePermissions == null) return false;

    final categoryPermissions = rolePermissions[category];
    if (categoryPermissions == null) return false;

    return categoryPermissions.contains(action);
  }

  /// Vérifie si un rôle a au moins une action dans une catégorie
  static bool hasAnyPermission(String role, String category) {
    final rolePermissions = _permissionMatrix[role];
    if (rolePermissions == null) return false;

    final categoryPermissions = rolePermissions[category];
    return categoryPermissions != null && categoryPermissions.isNotEmpty;
  }

  /// Obtient toutes les actions autorisées pour un rôle et une catégorie
  static List<String> getAllowedActions(String role, String category) {
    final rolePermissions = _permissionMatrix[role];
    if (rolePermissions == null) return [];

    return rolePermissions[category] ?? [];
  }

  /// Vérifie si un utilisateur peut voir la liste des patients
  static bool canViewPatientsList(String role) {
    return hasPermission(role, Permission.patients, Permission.view) &&
        role != Permission.patient;
  }

  /// Vérifie si un utilisateur peut voir un patient spécifique
  static bool canViewPatient(String role, String userId, String patientId) {
    // Patient peut voir seulement son propre dossier
    if (role == Permission.patient) {
      return userId == patientId;
    }

    // Autres rôles avec permission patients
    return hasPermission(role, Permission.patients, Permission.view);
  }

  /// Vérifie si un utilisateur peut utiliser la cartographie douleur
  static bool canUsePainMapping(String role) {
    return hasAnyPermission(role, Permission.painMapping);
  }

  /// Vérifie si un utilisateur peut voir les cartographies d'autres patients
  static bool canViewOthersPainMapping(String role) {
    return role == Permission.admin;
  }

  /// Vérifie si un utilisateur peut accéder aux statistiques
  static bool canViewStatistics(String role) {
    return hasPermission(role, Permission.statistics, Permission.view);
  }

  /// Vérifie si un utilisateur peut gérer les utilisateurs
  static bool canManageUsers(String role) {
    return hasAnyPermission(role, Permission.users);
  }

  /// Vérifie si un utilisateur peut accéder aux dossiers médicaux
  static bool canAccessMedicalRecords(String role) {
    return hasAnyPermission(role, Permission.medicalRecords);
  }

  /// Vérifie si un utilisateur peut créer/éditer des factures
  static bool canManageBilling(String role) {
    return hasAnyPermission(role, Permission.billing);
  }

  /// Obtient la liste des catégories accessibles pour un rôle
  static List<String> getAccessibleCategories(String role) {
    final rolePermissions = _permissionMatrix[role];
    if (rolePermissions == null) return [];

    return rolePermissions.keys.toList();
  }

  /// Détermine si un rôle est un rôle administratif
  static bool isAdministrativeRole(String role) {
    return role == Permission.admin ||
        role == Permission.manager ||
        role == Permission.secretaire;
  }

  /// Détermine si un rôle est un rôle patient
  static bool isPatientRole(String role) {
    return role == Permission.patient;
  }

  /// Obtient un nom d'affichage convivial pour un rôle
  static String getRoleDisplayName(String role) {
    switch (role) {
      case Permission.patient:
        return 'Patient';
      case Permission.secretaire:
        return 'Secrétaire';
      case Permission.manager:
        return 'Manager';
      case Permission.admin:
        return 'Administrateur / Praticien';
      default:
        return role;
    }
  }

  /// Obtient une description du niveau d'accès pour un rôle
  static String getRoleDescription(String role) {
    switch (role) {
      case Permission.patient:
        return 'Accès limité aux données personnelles et cartographie douleur';
      case Permission.secretaire:
        return 'Gestion administrative : patients, rendez-vous, facturation';
      case Permission.manager:
        return 'Gestion complète du cabinet et des utilisateurs';
      case Permission.admin:
        return 'Accès total : dossiers médicaux, prescriptions, tous les modules';
      default:
        return 'Rôle inconnu';
    }
  }
}
