import 'dart:math';
import '../models/pain_history.dart';

class EvolutionService {
  // Singleton pattern
  static final EvolutionService _instance = EvolutionService._internal();
  factory EvolutionService() => _instance;
  EvolutionService._internal();

  /// Génère des données de démonstration réalistes pour un patient
  Future<EvolutionData> getPatientEvolution({
    required String patientId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));

    final historyPoints = _generateDemoHistory(
      patientId: patientId,
      startDate: startDate,
      endDate: endDate,
    );

    return EvolutionData(
      patientId: patientId,
      startDate: startDate,
      endDate: endDate,
      historyPoints: historyPoints,
    );
  }

  /// Génère un historique réaliste avec sessions et évolution
  List<PainHistoryPoint> _generateDemoHistory({
    required String patientId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final List<PainHistoryPoint> points = [];
    final random = Random(patientId.hashCode);
    final totalDays = endDate.difference(startDate).inDays;

    // Intensité de base qui évolue dans le temps
    double baseIntensity = 7.0 + random.nextDouble() * 2.0; // Commence entre 7-9

    // Zones affectées pour ce patient
    final affectedZones = _getAffectedZones(patientId);

    // Créer points tous les 2-3 jours avec sessions hebdomadaires
    for (int day = 0; day <= totalDays; day += random.nextInt(2) + 2) {
      final pointDate = startDate.add(Duration(days: day));

      // Session toutes les semaines (environ)
      final isSessionDay = day % 7 == 0 && day > 0;
      String? sessionId;

      if (isSessionDay) {
        sessionId = 'session_${patientId}_$day';

        // Point AVANT la session
        points.add(_createHistoryPoint(
          patientId: patientId,
          timestamp: pointDate.add(const Duration(hours: 9)),
          baseIntensity: baseIntensity,
          affectedZones: affectedZones,
          random: random,
          sessionId: sessionId,
          isBeforeSession: true,
        ));

        // Point APRÈS la session (amélioration)
        final afterIntensity = baseIntensity - (1.5 + random.nextDouble() * 1.5);
        points.add(_createHistoryPoint(
          patientId: patientId,
          timestamp: pointDate.add(const Duration(hours: 11)),
          baseIntensity: max(0, afterIntensity),
          affectedZones: affectedZones,
          random: random,
          sessionId: sessionId,
          isBeforeSession: false,
        ));

        // Amélioration progressive après session
        baseIntensity = max(2.0, baseIntensity - (0.5 + random.nextDouble() * 0.5));
      } else {
        // Point normal (légère variation)
        final variation = (random.nextDouble() - 0.5) * 1.0;
        points.add(_createHistoryPoint(
          patientId: patientId,
          timestamp: pointDate.add(Duration(hours: 8 + random.nextInt(12))),
          baseIntensity: max(0, min(10, baseIntensity + variation)),
          affectedZones: affectedZones,
          random: random,
        ));
      }
    }

    points.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return points;
  }

  /// Crée un point d'historique avec intensités par zone
  PainHistoryPoint _createHistoryPoint({
    required String patientId,
    required DateTime timestamp,
    required double baseIntensity,
    required List<String> affectedZones,
    required Random random,
    String? sessionId,
    bool isBeforeSession = false,
  }) {
    final Map<String, int> zoneIntensities = {};
    double totalIntensity = 0;

    // Créer intensités pour chaque zone affectée
    for (final zone in affectedZones) {
      final zoneVariation = (random.nextDouble() - 0.5) * 2.0;
      final zoneIntensity = max(0, min(10, baseIntensity + zoneVariation)).round();
      zoneIntensities[zone] = zoneIntensity;
      totalIntensity += zoneIntensity;
    }

    final averageIntensity = affectedZones.isEmpty
        ? baseIntensity
        : totalIntensity / affectedZones.length;

    return PainHistoryPoint(
      id: 'point_${timestamp.millisecondsSinceEpoch}',
      patientId: patientId,
      timestamp: timestamp,
      averageIntensity: averageIntensity,
      totalPainPoints: affectedZones.length,
      zoneIntensities: zoneIntensities,
      sessionId: sessionId,
      isBeforeSession: isBeforeSession,
      notes: sessionId != null
          ? (isBeforeSession ? 'Avant séance' : 'Après séance')
          : null,
    );
  }

  /// Retourne les zones affectées selon le patient
  List<String> _getAffectedZones(String patientId) {
    // Zones typiques selon profil patient
    final zoneProfiles = {
      'demo_patient_1': ['Lombaires', 'Épaule droite', 'Genou gauche'],
      'demo_patient_2': ['Cervicales', 'Épaule gauche', 'Poignet droit'],
      'demo_patient_3': ['Hanche droite', 'Genou droit', 'Cheville droite'],
      'demo_patient_4': ['Lombaires', 'Cervicales', 'Dos supérieur'],
      'demo_patient_5': ['Épaule gauche', 'Coude gauche', 'Poignet gauche'],
    };

    return zoneProfiles[patientId] ?? ['Lombaires', 'Cervicales'];
  }

  /// Récupère les périodes prédéfinies
  List<PeriodOption> getPeriodOptions() {
    final now = DateTime.now();
    return [
      PeriodOption(
        label: '7 derniers jours',
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now,
      ),
      PeriodOption(
        label: '30 derniers jours',
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now,
      ),
      PeriodOption(
        label: '3 derniers mois',
        startDate: now.subtract(const Duration(days: 90)),
        endDate: now,
      ),
      PeriodOption(
        label: '6 derniers mois',
        startDate: now.subtract(const Duration(days: 180)),
        endDate: now,
      ),
      PeriodOption(
        label: '1 an',
        startDate: now.subtract(const Duration(days: 365)),
        endDate: now,
      ),
    ];
  }

  /// Exporte les données en format texte (pour future implémentation PDF)
  Future<String> exportEvolutionReport(EvolutionData data) async {
    final buffer = StringBuffer();
    
    buffer.writeln('=== RAPPORT D\'ÉVOLUTION ===\n');
    buffer.writeln('Patient: ${data.patientId}');
    buffer.writeln('Période: ${_formatDate(data.startDate)} - ${_formatDate(data.endDate)}');
    buffer.writeln('Points de données: ${data.historyPoints.length}\n');
    
    buffer.writeln('--- STATISTIQUES ---');
    buffer.writeln('Intensité moyenne: ${data.averageIntensity.toStringAsFixed(1)}/10');
    buffer.writeln('Tendance: ${_getTrendLabel(data.trend)}\n');
    
    buffer.writeln('--- ZONES LES PLUS TOUCHÉES ---');
    for (final zone in data.topAffectedZones) {
      buffer.writeln('${zone.zoneName}: ${zone.averageIntensity.toStringAsFixed(1)}/10 (${zone.occurrences} occurrences)');
    }
    buffer.writeln();
    
    if (data.sessionComparisons.isNotEmpty) {
      buffer.writeln('--- SÉANCES ---');
      for (final session in data.sessionComparisons) {
        buffer.writeln('${_formatDate(session.sessionDate)}:');
        buffer.writeln('  Avant: ${session.beforeAverage.toStringAsFixed(1)}/10');
        buffer.writeln('  Après: ${session.afterAverage.toStringAsFixed(1)}/10');
        buffer.writeln('  Amélioration: ${session.improvement.toStringAsFixed(1)} (${session.improvementPercentage.toStringAsFixed(0)}%)');
      }
    }
    
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getTrendLabel(EvolutionTrend trend) {
    switch (trend) {
      case EvolutionTrend.improving:
        return 'Amélioration';
      case EvolutionTrend.stable:
        return 'Stable';
      case EvolutionTrend.worsening:
        return 'Détérioration';
    }
  }
}

/// Option de période prédéfinie
class PeriodOption {
  final String label;
  final DateTime startDate;
  final DateTime endDate;

  PeriodOption({
    required this.label,
    required this.startDate,
    required this.endDate,
  });
}
