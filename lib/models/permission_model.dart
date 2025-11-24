/// Modèle de permissions pour la gestion des accès par rôle
/// MediDesk - Gestion de cabinet médical
class Permission {
  final String id;
  final String name;
  final String description;
  final String category;
  final String action;

  const Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.action,
  });

  // Catégories de permissions
  static const String patients = 'patients';
  static const String appointments = 'appointments';
  static const String billing = 'billing';
  static const String medicalRecords = 'medical_records';
  static const String users = 'users';
  static const String statistics = 'statistics';
  static const String painMapping = 'pain_mapping';
  static const String ownData = 'own_data';

  // Actions
  static const String view = 'view';
  static const String create = 'create';
  static const String edit = 'edit';
  static const String delete = 'delete';
  static const String manage = 'manage';

  // Rôles
  static const String patient = 'patient';
  static const String secretaire = 'secretaire';
  static const String manager = 'manager';
  static const String admin = 'admin';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Permission &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Permission($id: $category.$action)';
}
