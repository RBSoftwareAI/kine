/// Modèle pour les demandes de consentement
class ConsentRequest {
  final String id;
  final String patientId;
  final String professionalId;
  final String professionalName;
  final ConsentType type;
  final String relatedEntityId; // ID du PainPoint ou autre entité concernée
  final String description;
  final DateTime requestedAt;
  final ConsentStatus status;
  final DateTime? respondedAt;
  final String? patientComment;

  ConsentRequest({
    required this.id,
    required this.patientId,
    required this.professionalId,
    required this.professionalName,
    required this.type,
    required this.relatedEntityId,
    required this.description,
    required this.requestedAt,
    this.status = ConsentStatus.pending,
    this.respondedAt,
    this.patientComment,
  });

  /// Conversion depuis Firestore
  factory ConsentRequest.fromFirestore(Map<String, dynamic> data, String id) {
    return ConsentRequest(
      id: id,
      patientId: data['patientId'] as String? ?? '',
      professionalId: data['professionalId'] as String? ?? '',
      professionalName: data['professionalName'] as String? ?? '',
      type: ConsentType.values.firstWhere(
        (e) => e.toString() == 'ConsentType.${data['type']}',
        orElse: () => ConsentType.painModification,
      ),
      relatedEntityId: data['relatedEntityId'] as String? ?? '',
      description: data['description'] as String? ?? '',
      requestedAt: (data['requestedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      status: ConsentStatus.values.firstWhere(
        (e) => e.toString() == 'ConsentStatus.${data['status']}',
        orElse: () => ConsentStatus.pending,
      ),
      respondedAt: (data['respondedAt'] as dynamic)?.toDate(),
      patientComment: data['patientComment'] as String?,
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'type': type.toString().split('.').last,
      'relatedEntityId': relatedEntityId,
      'description': description,
      'requestedAt': requestedAt,
      'status': status.toString().split('.').last,
      'respondedAt': respondedAt,
      'patientComment': patientComment,
    };
  }

  /// Copie avec modifications
  ConsentRequest copyWith({
    ConsentStatus? status,
    DateTime? respondedAt,
    String? patientComment,
  }) {
    return ConsentRequest(
      id: id,
      patientId: patientId,
      professionalId: professionalId,
      professionalName: professionalName,
      type: type,
      relatedEntityId: relatedEntityId,
      description: description,
      requestedAt: requestedAt,
      status: status ?? this.status,
      respondedAt: respondedAt ?? this.respondedAt,
      patientComment: patientComment ?? this.patientComment,
    );
  }
}

/// Types de consentement
enum ConsentType {
  painModification,     // Modification zone de douleur
  intensityAdjustment,  // Ajustement intensité
  observationAdd,       // Ajout observation
  dataAccess,           // Accès aux données
}

/// Statuts de consentement
enum ConsentStatus {
  pending,   // En attente
  approved,  // Approuvé
  rejected,  // Refusé
  expired,   // Expiré
}

extension ConsentTypeExtension on ConsentType {
  String get displayName {
    switch (this) {
      case ConsentType.painModification:
        return 'Modification zone de douleur';
      case ConsentType.intensityAdjustment:
        return 'Ajustement intensité';
      case ConsentType.observationAdd:
        return 'Ajout observation';
      case ConsentType.dataAccess:
        return 'Accès aux données';
    }
  }
}

extension ConsentStatusExtension on ConsentStatus {
  String get displayName {
    switch (this) {
      case ConsentStatus.pending:
        return 'En attente';
      case ConsentStatus.approved:
        return 'Approuvé';
      case ConsentStatus.rejected:
        return 'Refusé';
      case ConsentStatus.expired:
        return 'Expiré';
    }
  }
}
