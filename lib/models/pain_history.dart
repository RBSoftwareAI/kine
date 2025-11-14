import 'package:cloud_firestore/cloud_firestore.dart';

/// Représente un point de données dans l'historique de douleur
class PainHistoryPoint {
  final String id;
  final String patientId;
  final DateTime timestamp;
  final double averageIntensity; // Moyenne des intensités de douleur à ce moment
  final int totalPainPoints; // Nombre de points de douleur
  final Map<String, int> zoneIntensities; // Intensité par zone corporelle
  final String? sessionId; // ID de la séance si lié à une consultation
  final bool isBeforeSession; // Enregistrement avant ou après séance
  final String? notes; // Notes optionnelles

  PainHistoryPoint({
    required this.id,
    required this.patientId,
    required this.timestamp,
    required this.averageIntensity,
    required this.totalPainPoints,
    required this.zoneIntensities,
    this.sessionId,
    this.isBeforeSession = false,
    this.notes,
  });

  // Conversion vers/depuis Firestore
  factory PainHistoryPoint.fromFirestore(Map<String, dynamic> data, String id) {
    return PainHistoryPoint(
      id: id,
      patientId: data['patient_id'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      averageIntensity: (data['average_intensity'] as num?)?.toDouble() ?? 0.0,
      totalPainPoints: data['total_pain_points'] as int? ?? 0,
      zoneIntensities: Map<String, int>.from(data['zone_intensities'] as Map? ?? {}),
      sessionId: data['session_id'] as String?,
      isBeforeSession: data['is_before_session'] as bool? ?? false,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patient_id': patientId,
      'timestamp': Timestamp.fromDate(timestamp),
      'average_intensity': averageIntensity,
      'total_pain_points': totalPainPoints,
      'zone_intensities': zoneIntensities,
      'session_id': sessionId,
      'is_before_session': isBeforeSession,
      'notes': notes,
    };
  }
}

/// Données d'évolution pour analyse et graphiques
class EvolutionData {
  final String patientId;
  final DateTime startDate;
  final DateTime endDate;
  final List<PainHistoryPoint> historyPoints;

  EvolutionData({
    required this.patientId,
    required this.startDate,
    required this.endDate,
    required this.historyPoints,
  });

  /// Calcule l'intensité moyenne sur la période
  double get averageIntensity {
    if (historyPoints.isEmpty) return 0.0;
    final total = historyPoints.fold<double>(
      0.0,
      (acc, point) => acc + point.averageIntensity,
    );
    return total / historyPoints.length;
  }

  /// Calcule la tendance (amélioration, stable, détérioration)
  EvolutionTrend get trend {
    if (historyPoints.length < 2) return EvolutionTrend.stable;

    // Comparer première moitié vs deuxième moitié
    final midpoint = historyPoints.length ~/ 2;
    final firstHalf = historyPoints.sublist(0, midpoint);
    final secondHalf = historyPoints.sublist(midpoint);

    final firstAvg = firstHalf.fold<double>(0.0, (acc, p) => acc + p.averageIntensity) / firstHalf.length;
    final secondAvg = secondHalf.fold<double>(0.0, (acc, p) => acc + p.averageIntensity) / secondHalf.length;

    final difference = secondAvg - firstAvg;

    if (difference < -1.0) return EvolutionTrend.improving;
    if (difference > 1.0) return EvolutionTrend.worsening;
    return EvolutionTrend.stable;
  }

  /// Zones les plus touchées avec fréquence
  List<ZoneImpact> get topAffectedZones {
    final Map<String, ZoneImpactData> zoneData = {};

    for (final point in historyPoints) {
      point.zoneIntensities.forEach((zone, intensity) {
        if (!zoneData.containsKey(zone)) {
          zoneData[zone] = ZoneImpactData(zoneName: zone);
        }
        zoneData[zone]!.addIntensity(intensity);
      });
    }

    final zones = zoneData.values.map((data) => data.toZoneImpact()).toList();
    zones.sort((a, b) => b.averageIntensity.compareTo(a.averageIntensity));
    return zones.take(5).toList();
  }

  /// Points avant/après séances pour comparaison
  List<SessionComparison> get sessionComparisons {
    final List<SessionComparison> comparisons = [];
    final Map<String, List<PainHistoryPoint>> sessionPoints = {};

    // Grouper par session
    for (final point in historyPoints) {
      if (point.sessionId != null) {
        sessionPoints.putIfAbsent(point.sessionId!, () => []).add(point);
      }
    }

    // Créer comparaisons
    sessionPoints.forEach((sessionId, points) {
      final before = points.where((p) => p.isBeforeSession).toList();
      final after = points.where((p) => !p.isBeforeSession).toList();

      if (before.isNotEmpty && after.isNotEmpty) {
        comparisons.add(SessionComparison(
          sessionId: sessionId,
          beforePoints: before,
          afterPoints: after,
        ));
      }
    });

    comparisons.sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
    return comparisons;
  }
}

enum EvolutionTrend {
  improving,
  stable,
  worsening,
}

/// Impact d'une zone corporelle
class ZoneImpact {
  final String zoneName;
  final double averageIntensity;
  final int occurrences;

  ZoneImpact({
    required this.zoneName,
    required this.averageIntensity,
    required this.occurrences,
  });
}

class ZoneImpactData {
  final String zoneName;
  final List<int> intensities = [];

  ZoneImpactData({required this.zoneName});

  void addIntensity(int intensity) {
    intensities.add(intensity);
  }

  ZoneImpact toZoneImpact() {
    final avg = intensities.isEmpty
        ? 0.0
        : intensities.reduce((a, b) => a + b) / intensities.length;
    return ZoneImpact(
      zoneName: zoneName,
      averageIntensity: avg,
      occurrences: intensities.length,
    );
  }
}

/// Comparaison avant/après séance
class SessionComparison {
  final String sessionId;
  final List<PainHistoryPoint> beforePoints;
  final List<PainHistoryPoint> afterPoints;

  SessionComparison({
    required this.sessionId,
    required this.beforePoints,
    required this.afterPoints,
  });

  DateTime get sessionDate {
    final allPoints = [...beforePoints, ...afterPoints];
    allPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return allPoints.first.timestamp;
  }

  double get beforeAverage {
    if (beforePoints.isEmpty) return 0.0;
    return beforePoints.fold<double>(0.0, (acc, p) => acc + p.averageIntensity) / beforePoints.length;
  }

  double get afterAverage {
    if (afterPoints.isEmpty) return 0.0;
    return afterPoints.fold<double>(0.0, (acc, p) => acc + p.averageIntensity) / afterPoints.length;
  }

  double get improvement => beforeAverage - afterAverage;
  double get improvementPercentage => beforeAverage == 0 ? 0 : (improvement / beforeAverage) * 100;
}
