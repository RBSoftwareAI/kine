import 'package:cloud_firestore/cloud_firestore.dart';

/// Zone de douleur sur le corps
class PainZone {
  final String zoneId;
  final int intensity; // 1-10
  final String type; // acute, chronic, radiating
  final String frequency; // permanent, intermittent, occasional
  final String? description;

  const PainZone({
    required this.zoneId,
    required this.intensity,
    required this.type,
    required this.frequency,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'zone_id': zoneId,
        'intensity': intensity,
        'type': type,
        'frequency': frequency,
        'description': description,
      };

  factory PainZone.fromJson(Map<String, dynamic> json) => PainZone(
        zoneId: json['zone_id'] as String,
        intensity: json['intensity'] as int,
        type: json['type'] as String,
        frequency: json['frequency'] as String,
        description: json['description'] as String?,
      );
}

/// Cartographie complète de la douleur d'un patient
class PainMapping {
  final String id;
  final String patientId;
  final DateTime date;
  final Map<String, PainZone> zones; // zoneId -> PainZone
  final String? notes;

  const PainMapping({
    required this.id,
    required this.patientId,
    required this.date,
    required this.zones,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'date': Timestamp.fromDate(date),
        'zones': zones.map((key, value) => MapEntry(key, value.toJson())),
        'notes': notes,
      };

  factory PainMapping.fromJson(Map<String, dynamic> json, String id) {
    final zonesJson = json['zones'] as Map<String, dynamic>? ?? {};
    final zones = zonesJson.map(
      (key, value) => MapEntry(key, PainZone.fromJson(value)),
    );

    return PainMapping(
      id: id,
      patientId: json['patient_id'] as String,
      date: (json['date'] as Timestamp).toDate(),
      zones: zones,
      notes: json['notes'] as String?,
    );
  }

  // Zones corporelles prédéfinies
  static const Map<String, Map<String, String>> bodyZones = {
    'face': {
      'head': 'Tête',
      'neck': 'Cou',
      'left_shoulder': 'Épaule gauche',
      'right_shoulder': 'Épaule droite',
      'left_arm': 'Bras gauche',
      'right_arm': 'Bras droit',
      'chest': 'Poitrine',
      'upper_abdomen': 'Abdomen supérieur',
      'lower_abdomen': 'Abdomen inférieur',
      'left_hip': 'Hanche gauche',
      'right_hip': 'Hanche droite',
      'left_thigh': 'Cuisse gauche',
      'right_thigh': 'Cuisse droite',
      'left_knee': 'Genou gauche',
      'right_knee': 'Genou droit',
      'left_shin': 'Tibia gauche',
      'right_shin': 'Tibia droit',
      'left_foot': 'Pied gauche',
      'right_foot': 'Pied droit',
    },
    'back': {
      'upper_back': 'Haut du dos',
      'mid_back': 'Milieu du dos',
      'lower_back': 'Bas du dos',
      'left_glute': 'Fessier gauche',
      'right_glute': 'Fessier droit',
      'left_hamstring': 'Ischio-jambiers gauche',
      'right_hamstring': 'Ischio-jambiers droit',
      'left_calf': 'Mollet gauche',
      'right_calf': 'Mollet droit',
    },
  };

  static const List<String> painTypes = ['acute', 'chronic', 'radiating'];
  static const List<String> frequencies = [
    'permanent',
    'intermittent',
    'occasional'
  ];

  static String getPainTypeLabel(String type) {
    switch (type) {
      case 'acute':
        return 'Aiguë';
      case 'chronic':
        return 'Chronique';
      case 'radiating':
        return 'Irradiante';
      default:
        return type;
    }
  }

  static String getFrequencyLabel(String frequency) {
    switch (frequency) {
      case 'permanent':
        return 'Permanente';
      case 'intermittent':
        return 'Intermittente';
      case 'occasional':
        return 'Occasionnelle';
      default:
        return frequency;
    }
  }
}
