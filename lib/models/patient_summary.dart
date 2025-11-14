import 'pain_point.dart';
import 'session_note.dart';

/// Résumé d'un patient pour le tableau de bord professionnel
class PatientSummary {
  final String patientId;
  final String patientName;
  final String patientEmail;
  final int totalPainPoints;
  final double averagePainIntensity;
  final ProgressStatus? latestStatus;
  final DateTime? lastSessionDate;
  final DateTime? lastPainUpdate;
  final List<PainPoint> recentPainPoints;
  final int sessionsCount;

  PatientSummary({
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    this.totalPainPoints = 0,
    this.averagePainIntensity = 0.0,
    this.latestStatus,
    this.lastSessionDate,
    this.lastPainUpdate,
    this.recentPainPoints = const [],
    this.sessionsCount = 0,
  });

  /// Obtenir la couleur de statut
  String get statusColor {
    if (latestStatus == null) return 'grey';
    switch (latestStatus!) {
      case ProgressStatus.improving:
        return 'green';
      case ProgressStatus.stable:
        return 'blue';
      case ProgressStatus.worsening:
        return 'red';
      case ProgressStatus.recovered:
        return 'success';
    }
  }

  /// Obtenir le texte de priorité
  String get priorityText {
    if (averagePainIntensity >= 8) return 'Urgente';
    if (averagePainIntensity >= 6) return 'Élevée';
    if (averagePainIntensity >= 4) return 'Moyenne';
    return 'Faible';
  }

  /// Vérifier si le patient nécessite attention
  bool get needsAttention {
    // Douleur élevée
    if (averagePainIntensity >= 7) return true;
    
    // Dégradation
    if (latestStatus == ProgressStatus.worsening) return true;
    
    // Pas de session récente (> 7 jours)
    if (lastSessionDate != null) {
      final daysSinceSession = DateTime.now().difference(lastSessionDate!).inDays;
      if (daysSinceSession > 7) return true;
    }
    
    return false;
  }

  /// Obtenir les zones les plus douloureuses
  List<String> get topPainZones {
    if (recentPainPoints.isEmpty) return [];
    
    // Grouper par zone et compter
    final zoneMap = <String, int>{};
    for (final point in recentPainPoints) {
      final zoneName = point.zone.displayName;
      zoneMap[zoneName] = (zoneMap[zoneName] ?? 0) + 1;
    }
    
    // Trier par fréquence
    final sortedZones = zoneMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedZones.take(3).map((e) => e.key).toList();
  }
}
