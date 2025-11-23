import '../models/audit_log.dart';

/// Service pour gérer les logs d'audit (version locale temporaire)
/// À remplacer par Firebase Firestore plus tard
class AuditService {
  /// Enregistrer un log d'audit
  Future<void> logAction({
    required String patientId,
    required String userId,
    required String userName,
    required String userRole,
    required ActionType actionType,
    required String entityType,
    String? entityId,
    required String description,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
  }) async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 100));

    // Créer le log d'audit
    AuditLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      userId: userId,
      userName: userName,
      userRole: userRole,
      actionType: actionType,
      entityType: entityType,
      entityId: entityId,
      description: description,
      oldValues: oldValues,
      newValues: newValues,
      timestamp: DateTime.now(),
      deviceInfo: 'Web Browser',
    );

    // TODO: Sauvegarder dans Firebase
    // await _firestore.collection('audit_logs').add(log.toFirestore());
  }

  /// Obtenir l'historique d'audit pour un patient
  Future<List<AuditLog>> getAuditLogsForPatient(String patientId) async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Données de démonstration
    return [
      AuditLog(
        id: 'log_001',
        patientId: patientId,
        userId: 'patient_001',
        userName: 'Jean Dupont',
        userRole: 'patient',
        actionType: ActionType.created,
        entityType: 'pain_point',
        entityId: 'pain_001',
        description: 'Ajout d\'un point de douleur : Bas du dos',
        newValues: {
          'zone': 'Bas du dos',
          'intensité': 7,
          'fréquence': 'Quotidienne',
        },
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
      ),
      AuditLog(
        id: 'log_002',
        patientId: patientId,
        userId: 'kine_001',
        userName: 'Dr. Marie Martin',
        userRole: 'kine',
        actionType: ActionType.updated,
        entityType: 'pain_point',
        entityId: 'pain_001',
        description: 'Modification de l\'intensité de la douleur',
        oldValues: {
          'intensité': 7,
        },
        newValues: {
          'intensité': 8,
        },
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
      ),
      AuditLog(
        id: 'log_003',
        patientId: patientId,
        userId: 'kine_001',
        userName: 'Dr. Marie Martin',
        userRole: 'kine',
        actionType: ActionType.created,
        entityType: 'session_note',
        entityId: 'note_001',
        description: 'Ajout d\'une note de séance',
        newValues: {
          'statut': 'Amélioration',
          'observations': 'Le patient montre des signes d\'amélioration...',
        },
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
      ),
      AuditLog(
        id: 'log_004',
        patientId: patientId,
        userId: 'patient_001',
        userName: 'Jean Dupont',
        userRole: 'patient',
        actionType: ActionType.updated,
        entityType: 'pain_point',
        entityId: 'pain_001',
        description: 'Modification de la fréquence de la douleur',
        oldValues: {
          'fréquence': 'Quotidienne',
        },
        newValues: {
          'fréquence': 'Occasionnelle',
        },
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      AuditLog(
        id: 'log_005',
        patientId: patientId,
        userId: 'coach_001',
        userName: 'Pierre Durand',
        userRole: 'coach',
        actionType: ActionType.commented,
        entityType: 'session_note',
        entityId: 'note_001',
        description: 'Ajout d\'un commentaire sur la séance',
        newValues: {
          'commentaire': 'Continuer les exercices de renforcement',
        },
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AuditLog(
        id: 'log_006',
        patientId: patientId,
        userId: 'kine_001',
        userName: 'Dr. Marie Martin',
        userRole: 'kine',
        actionType: ActionType.viewed,
        entityType: 'patient_profile',
        entityId: patientId,
        description: 'Consultation du dossier patient',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AuditLog(
        id: 'log_007',
        patientId: patientId,
        userId: 'patient_001',
        userName: 'Jean Dupont',
        userRole: 'patient',
        actionType: ActionType.created,
        entityType: 'pain_point',
        entityId: 'pain_002',
        description: 'Ajout d\'un point de douleur : Genou droit',
        newValues: {
          'zone': 'Genou droit',
          'intensité': 5,
          'fréquence': 'Occasionnelle',
        },
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  /// Filtrer les logs par type d'action
  Future<List<AuditLog>> filterLogsByAction(
    String patientId,
    ActionType actionType,
  ) async {
    final allLogs = await getAuditLogsForPatient(patientId);
    return allLogs.where((log) => log.actionType == actionType).toList();
  }

  /// Filtrer les logs par utilisateur
  Future<List<AuditLog>> filterLogsByUser(
    String patientId,
    String userId,
  ) async {
    final allLogs = await getAuditLogsForPatient(patientId);
    return allLogs.where((log) => log.userId == userId).toList();
  }

  /// Obtenir les logs modifiés par des professionnels
  Future<List<AuditLog>> getProfessionalModifications(String patientId) async {
    final allLogs = await getAuditLogsForPatient(patientId);
    return allLogs.where((log) => log.isModifiedByProfessional).toList();
  }
}
