/// Modèle pour l'historique de traçabilité (audit log)
class AuditLog {
  final String id;
  final String patientId;
  final String userId;
  final String userName;
  final String userRole; // 'patient', 'kine', 'coach'
  final ActionType actionType;
  final String entityType; // 'pain_point', 'session_note', etc.
  final String? entityId;
  final String description;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final DateTime timestamp;
  final String? ipAddress;
  final String? deviceInfo;

  AuditLog({
    required this.id,
    required this.patientId,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.actionType,
    required this.entityType,
    this.entityId,
    required this.description,
    this.oldValues,
    this.newValues,
    required this.timestamp,
    this.ipAddress,
    this.deviceInfo,
  });

  /// Conversion depuis Firestore
  factory AuditLog.fromFirestore(Map<String, dynamic> data, String id) {
    return AuditLog(
      id: id,
      patientId: data['patientId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      userRole: data['userRole'] as String? ?? '',
      actionType: ActionType.values.firstWhere(
        (e) => e.toString() == 'ActionType.${data['actionType']}',
        orElse: () => ActionType.other,
      ),
      entityType: data['entityType'] as String? ?? '',
      entityId: data['entityId'] as String?,
      description: data['description'] as String? ?? '',
      oldValues: data['oldValues'] as Map<String, dynamic>?,
      newValues: data['newValues'] as Map<String, dynamic>?,
      timestamp: (data['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
      ipAddress: data['ipAddress'] as String?,
      deviceInfo: data['deviceInfo'] as String?,
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'actionType': actionType.toString().split('.').last,
      'entityType': entityType,
      'entityId': entityId,
      'description': description,
      'oldValues': oldValues,
      'newValues': newValues,
      'timestamp': timestamp,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
    };
  }

  /// Obtenir une description lisible des changements
  String get changesSummary {
    if (oldValues == null || newValues == null) {
      return description;
    }

    final changes = <String>[];
    newValues!.forEach((key, newValue) {
      final oldValue = oldValues![key];
      if (oldValue != newValue) {
        changes.add('$key: $oldValue → $newValue');
      }
    });

    return changes.isEmpty ? description : changes.join(', ');
  }

  /// Vérifier si la modification a été faite par un professionnel
  bool get isModifiedByProfessional {
    return userRole == 'kine' || userRole == 'coach';
  }
}

/// Types d'actions pour l'audit
enum ActionType {
  created,      // Création
  updated,      // Modification
  deleted,      // Suppression
  viewed,       // Consultation
  exported,     // Export
  shared,       // Partage
  commented,    // Commentaire
  approved,     // Approbation
  rejected,     // Refus
  other,        // Autre
}

extension ActionTypeExtension on ActionType {
  String get displayName {
    switch (this) {
      case ActionType.created:
        return 'Création';
      case ActionType.updated:
        return 'Modification';
      case ActionType.deleted:
        return 'Suppression';
      case ActionType.viewed:
        return 'Consultation';
      case ActionType.exported:
        return 'Export';
      case ActionType.shared:
        return 'Partage';
      case ActionType.commented:
        return 'Commentaire';
      case ActionType.approved:
        return 'Approbation';
      case ActionType.rejected:
        return 'Refus';
      case ActionType.other:
        return 'Autre';
    }
  }

  String get emoji {
    switch (this) {
      case ActionType.created:
        return '➕';
      case ActionType.updated:
        return '✏️';
      case ActionType.deleted:
        return '🗑️';
      case ActionType.viewed:
        return '👁️';
      case ActionType.exported:
        return '📤';
      case ActionType.shared:
        return '🔗';
      case ActionType.commented:
        return '💬';
      case ActionType.approved:
        return '✅';
      case ActionType.rejected:
        return '❌';
      case ActionType.other:
        return '📝';
    }
  }
}
