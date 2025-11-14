/// Modèle pour un point de douleur sur la silhouette anatomique
class PainPoint {
  final String id;
  final String patientId;
  final BodyZone zone;
  final BodyView view; // Face, profil, dos
  final double x; // Position X sur la silhouette (0-1)
  final double y; // Position Y sur la silhouette (0-1)
  final PainIntensity intensity;
  final PainFrequency frequency;
  final String? description;
  final DateTime recordedAt;
  final String recordedBy; // ID de l'utilisateur qui a saisi
  final bool needsConsent; // Si modification par professionnel
  final bool consentGiven; // Consentement patient
  final DateTime? consentDate;

  PainPoint({
    required this.id,
    required this.patientId,
    required this.zone,
    required this.view,
    required this.x,
    required this.y,
    required this.intensity,
    required this.frequency,
    this.description,
    required this.recordedAt,
    required this.recordedBy,
    this.needsConsent = false,
    this.consentGiven = false,
    this.consentDate,
  });

  /// Conversion depuis Firestore
  factory PainPoint.fromFirestore(Map<String, dynamic> data, String id) {
    return PainPoint(
      id: id,
      patientId: data['patientId'] as String? ?? '',
      zone: BodyZone.values.firstWhere(
        (e) => e.toString() == 'BodyZone.${data['zone']}',
        orElse: () => BodyZone.other,
      ),
      view: BodyView.values.firstWhere(
        (e) => e.toString() == 'BodyView.${data['view']}',
        orElse: () => BodyView.front,
      ),
      x: (data['x'] as num?)?.toDouble() ?? 0.5,
      y: (data['y'] as num?)?.toDouble() ?? 0.5,
      intensity: PainIntensity.values.firstWhere(
        (e) => e.toString() == 'PainIntensity.${data['intensity']}',
        orElse: () => PainIntensity.moderate,
      ),
      frequency: PainFrequency.values.firstWhere(
        (e) => e.toString() == 'PainFrequency.${data['frequency']}',
        orElse: () => PainFrequency.occasional,
      ),
      description: data['description'] as String?,
      recordedAt: (data['recordedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      recordedBy: data['recordedBy'] as String? ?? '',
      needsConsent: data['needsConsent'] as bool? ?? false,
      consentGiven: data['consentGiven'] as bool? ?? false,
      consentDate: (data['consentDate'] as dynamic)?.toDate(),
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'zone': zone.toString().split('.').last,
      'view': view.toString().split('.').last,
      'x': x,
      'y': y,
      'intensity': intensity.toString().split('.').last,
      'frequency': frequency.toString().split('.').last,
      'description': description,
      'recordedAt': recordedAt,
      'recordedBy': recordedBy,
      'needsConsent': needsConsent,
      'consentGiven': consentGiven,
      'consentDate': consentDate,
    };
  }

  /// Copie avec modifications
  PainPoint copyWith({
    PainIntensity? intensity,
    PainFrequency? frequency,
    String? description,
    bool? consentGiven,
    DateTime? consentDate,
  }) {
    return PainPoint(
      id: id,
      patientId: patientId,
      zone: zone,
      view: view,
      x: x,
      y: y,
      intensity: intensity ?? this.intensity,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      recordedAt: recordedAt,
      recordedBy: recordedBy,
      needsConsent: needsConsent,
      consentGiven: consentGiven ?? this.consentGiven,
      consentDate: consentDate ?? this.consentDate,
    );
  }
}

/// Zones anatomiques du corps
enum BodyZone {
  head,           // Tête
  neck,           // Cou
  shoulder,       // Épaule
  upperBack,      // Haut du dos
  lowerBack,      // Bas du dos
  chest,          // Poitrine
  abdomen,        // Abdomen
  upperArm,       // Bras
  forearm,        // Avant-bras
  hand,           // Main
  hip,            // Hanche
  thigh,          // Cuisse
  knee,           // Genou
  shin,           // Tibia
  calf,           // Mollet
  ankle,          // Cheville
  foot,           // Pied
  other,          // Autre
}

/// Vues anatomiques
enum BodyView {
  front,    // Face
  back,     // Dos
  sideLeft, // Profil gauche
  sideRight,// Profil droit
}

/// Intensité de la douleur (échelle 0-10)
enum PainIntensity {
  none,      // 0 - Aucune
  minimal,   // 1-2 - Minimale
  mild,      // 3-4 - Légère
  moderate,  // 5-6 - Modérée
  severe,    // 7-8 - Sévère
  extreme,   // 9-10 - Extrême
}

/// Fréquence de la douleur
enum PainFrequency {
  occasional,  // Occasionnelle
  daily,       // Quotidienne
  frequent,    // Fréquente (plusieurs fois par jour)
  constant,    // Constante
}

extension PainIntensityExtension on PainIntensity {
  int get numericValue {
    switch (this) {
      case PainIntensity.none:
        return 0;
      case PainIntensity.minimal:
        return 2;
      case PainIntensity.mild:
        return 4;
      case PainIntensity.moderate:
        return 6;
      case PainIntensity.severe:
        return 8;
      case PainIntensity.extreme:
        return 10;
    }
  }

  String get displayName {
    switch (this) {
      case PainIntensity.none:
        return 'Aucune (0)';
      case PainIntensity.minimal:
        return 'Minimale (1-2)';
      case PainIntensity.mild:
        return 'Légère (3-4)';
      case PainIntensity.moderate:
        return 'Modérée (5-6)';
      case PainIntensity.severe:
        return 'Sévère (7-8)';
      case PainIntensity.extreme:
        return 'Extrême (9-10)';
    }
  }
}

extension PainFrequencyExtension on PainFrequency {
  String get displayName {
    switch (this) {
      case PainFrequency.occasional:
        return 'Occasionnelle';
      case PainFrequency.daily:
        return 'Quotidienne';
      case PainFrequency.frequent:
        return 'Fréquente';
      case PainFrequency.constant:
        return 'Constante';
    }
  }
}

extension BodyZoneExtension on BodyZone {
  String get displayName {
    switch (this) {
      case BodyZone.head:
        return 'Tête';
      case BodyZone.neck:
        return 'Cou';
      case BodyZone.shoulder:
        return 'Épaule';
      case BodyZone.upperBack:
        return 'Haut du dos';
      case BodyZone.lowerBack:
        return 'Bas du dos';
      case BodyZone.chest:
        return 'Poitrine';
      case BodyZone.abdomen:
        return 'Abdomen';
      case BodyZone.upperArm:
        return 'Bras';
      case BodyZone.forearm:
        return 'Avant-bras';
      case BodyZone.hand:
        return 'Main';
      case BodyZone.hip:
        return 'Hanche';
      case BodyZone.thigh:
        return 'Cuisse';
      case BodyZone.knee:
        return 'Genou';
      case BodyZone.shin:
        return 'Tibia';
      case BodyZone.calf:
        return 'Mollet';
      case BodyZone.ankle:
        return 'Cheville';
      case BodyZone.foot:
        return 'Pied';
      case BodyZone.other:
        return 'Autre';
    }
  }
}
