/// Modèle pour les notes de séance professionnelles
class SessionNote {
  final String id;
  final String patientId;
  final String professionalId;
  final String professionalName;
  final DateTime sessionDate;
  final String observations;
  final ProgressStatus progressStatus;
  final List<String> painPointIds; // Références aux points de douleur
  final String? recommendations;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SessionNote({
    required this.id,
    required this.patientId,
    required this.professionalId,
    required this.professionalName,
    required this.sessionDate,
    required this.observations,
    required this.progressStatus,
    this.painPointIds = const [],
    this.recommendations,
    required this.createdAt,
    this.updatedAt,
  });

  /// Conversion depuis Firestore
  factory SessionNote.fromFirestore(Map<String, dynamic> data, String id) {
    return SessionNote(
      id: id,
      patientId: data['patientId'] as String? ?? '',
      professionalId: data['professionalId'] as String? ?? '',
      professionalName: data['professionalName'] as String? ?? '',
      sessionDate: (data['sessionDate'] as dynamic)?.toDate() ?? DateTime.now(),
      observations: data['observations'] as String? ?? '',
      progressStatus: ProgressStatus.values.firstWhere(
        (e) => e.toString() == 'ProgressStatus.${data['progressStatus']}',
        orElse: () => ProgressStatus.stable,
      ),
      painPointIds: (data['painPointIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recommendations: data['recommendations'] as String?,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'sessionDate': sessionDate,
      'observations': observations,
      'progressStatus': progressStatus.toString().split('.').last,
      'painPointIds': painPointIds,
      'recommendations': recommendations,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Statut de progression du patient
enum ProgressStatus {
  improving,    // Amélioration
  stable,       // Stable
  worsening,    // Dégradation
  recovered,    // Guérison
}

extension ProgressStatusExtension on ProgressStatus {
  String get displayName {
    switch (this) {
      case ProgressStatus.improving:
        return 'Amélioration';
      case ProgressStatus.stable:
        return 'Stable';
      case ProgressStatus.worsening:
        return 'Dégradation';
      case ProgressStatus.recovered:
        return 'Guérison';
    }
  }

  String get emoji {
    switch (this) {
      case ProgressStatus.improving:
        return '📈';
      case ProgressStatus.stable:
        return '➡️';
      case ProgressStatus.worsening:
        return '📉';
      case ProgressStatus.recovered:
        return '✅';
    }
  }
}
