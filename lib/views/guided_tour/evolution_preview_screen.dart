import 'package:flutter/material.dart';
import '../../models/pain_history.dart';
import '../../utils/app_theme.dart';
import '../evolution/widgets/intensity_chart.dart';
import '../evolution/widgets/trend_indicator.dart';
import '../evolution/widgets/top_zones_widget.dart';

/// Écran de prévisualisation des graphiques d'évolution pour la visite guidée
/// Affiche des graphiques factices montrant l'évolution d'un patient
class EvolutionPreviewScreen extends StatelessWidget {
  const EvolutionPreviewScreen({super.key});

  // Données factices pour la démonstration
  List<PainHistoryPoint> _getMockHistoryPoints() {
    final now = DateTime.now();
    return [
      PainHistoryPoint(
        id: 'mock_1',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 30)),
        averageIntensity: 8.0,
        totalPainPoints: 5,
        zoneIntensities: {'Bas du dos': 8, 'Épaule droite': 7, 'Genou gauche': 6},
      ),
      PainHistoryPoint(
        id: 'mock_2',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 27)),
        averageIntensity: 7.8,
        totalPainPoints: 5,
        zoneIntensities: {'Bas du dos': 8, 'Épaule droite': 7, 'Genou gauche': 6},
      ),
      PainHistoryPoint(
        id: 'mock_3',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 25)),
        averageIntensity: 7.5,
        totalPainPoints: 5,
        zoneIntensities: {'Bas du dos': 7, 'Épaule droite': 7, 'Genou gauche': 6},
      ),
      PainHistoryPoint(
        id: 'mock_4',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 22)),
        averageIntensity: 7.0,
        totalPainPoints: 5,
        zoneIntensities: {'Bas du dos': 7, 'Épaule droite': 6, 'Genou gauche': 6},
      ),
      PainHistoryPoint(
        id: 'mock_5',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 20)),
        averageIntensity: 6.8,
        totalPainPoints: 4,
        zoneIntensities: {'Bas du dos': 7, 'Épaule droite': 6, 'Genou gauche': 5},
      ),
      PainHistoryPoint(
        id: 'mock_6',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 18)),
        averageIntensity: 6.5,
        totalPainPoints: 4,
        zoneIntensities: {'Bas du dos': 6, 'Épaule droite': 6, 'Genou gauche': 5},
      ),
      PainHistoryPoint(
        id: 'mock_7',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 15)),
        averageIntensity: 5.5,
        totalPainPoints: 4,
        zoneIntensities: {'Bas du dos': 6, 'Épaule droite': 5, 'Genou gauche': 4},
      ),
      PainHistoryPoint(
        id: 'mock_8',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 12)),
        averageIntensity: 5.0,
        totalPainPoints: 3,
        zoneIntensities: {'Bas du dos': 5, 'Épaule droite': 4, 'Genou gauche': 4},
      ),
      PainHistoryPoint(
        id: 'mock_9',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 10)),
        averageIntensity: 4.2,
        totalPainPoints: 3,
        zoneIntensities: {'Bas du dos': 4, 'Épaule droite': 4, 'Genou gauche': 3},
      ),
      PainHistoryPoint(
        id: 'mock_10',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 7)),
        averageIntensity: 3.8,
        totalPainPoints: 2,
        zoneIntensities: {'Bas du dos': 4, 'Épaule droite': 3, 'Genou gauche': 2},
      ),
      PainHistoryPoint(
        id: 'mock_11',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 5)),
        averageIntensity: 3.0,
        totalPainPoints: 2,
        zoneIntensities: {'Bas du dos': 3, 'Épaule droite': 3, 'Genou gauche': 2},
      ),
      PainHistoryPoint(
        id: 'mock_12',
        patientId: 'demo_patient',
        timestamp: now.subtract(const Duration(days: 2)),
        averageIntensity: 2.8,
        totalPainPoints: 2,
        zoneIntensities: {'Bas du dos': 3, 'Épaule droite': 2, 'Genou gauche': 2},
      ),
      PainHistoryPoint(
        id: 'mock_13',
        patientId: 'demo_patient',
        timestamp: now,
        averageIntensity: 2.5,
        totalPainPoints: 2,
        zoneIntensities: {'Bas du dos': 3, 'Épaule droite': 2, 'Genou gauche': 1},
      ),
    ];
  }

  EvolutionData _getMockEvolutionData() {
    final historyPoints = _getMockHistoryPoints();
    final now = DateTime.now();
    
    return EvolutionData(
      patientId: 'demo_patient',
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
      historyPoints: historyPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    final evolutionData = _getMockEvolutionData();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Courbes d\'évolution'),
            Text(
              'Sophie Martin',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.file_download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélecteur de période
            _buildPeriodSelector(),
            const SizedBox(height: 24),

            // Statistiques rapides
            _buildQuickStats(evolutionData),
            const SizedBox(height: 24),

            // Graphique d'intensité temporelle
            _buildIntensityChartCard(evolutionData),
            const SizedBox(height: 24),

            // Indicateur de tendance
            TrendIndicator(trend: evolutionData.trend),
            const SizedBox(height: 24),

            // Zones les plus touchées
            TopZonesWidget(zones: evolutionData.topAffectedZones),
            const SizedBox(height: 24),

            // Informations supplémentaires
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today, color: AppTheme.primaryOrange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '30 derniers jours',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkBackground,
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down, color: AppTheme.primaryOrange),
        ],
      ),
    );
  }

  Widget _buildQuickStats(EvolutionData data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.show_chart,
            label: 'Intensité moyenne',
            value: data.averageIntensity.toStringAsFixed(1),
            unit: '/10',
            color: AppTheme.getIntensityColor(data.averageIntensity.round()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.timeline,
            label: 'Points de données',
            value: data.historyPoints.length.toString(),
            unit: '',
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_down,
            label: 'Amélioration',
            value: '68.8%',
            unit: '',
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (unit.isNotEmpty)
                Text(
                  unit,
                  style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.7)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityChartCard(EvolutionData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insert_chart, color: AppTheme.primaryOrange),
              SizedBox(width: 8),
              Text(
                'Évolution de l\'intensité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntensityChart(historyPoints: data.historyPoints),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.success.withValues(alpha: 0.1),
            AppTheme.success.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: AppTheme.success, size: 24),
              SizedBox(width: 8),
              Text(
                'Analyse de progression',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.check_circle,
            text: 'Amélioration significative sur 30 jours',
            color: AppTheme.success,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.trending_down,
            text: 'Intensité moyenne passée de 8.0/10 à 2.5/10',
            color: AppTheme.success,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.healing,
            text: '3 zones principales en cours de traitement',
            color: AppTheme.primaryOrange,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.timeline,
            text: '13 points de suivi enregistrés',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
