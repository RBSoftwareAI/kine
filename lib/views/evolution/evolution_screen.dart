import 'package:flutter/material.dart';
import '../../models/pain_history.dart';
import '../../services/evolution_service.dart';
import '../../utils/app_theme.dart';
import 'widgets/intensity_chart.dart';
import 'widgets/session_comparison_card.dart';
import 'widgets/trend_indicator.dart';
import 'widgets/top_zones_widget.dart';

class EvolutionScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const EvolutionScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<EvolutionScreen> createState() => _EvolutionScreenState();
}

class _EvolutionScreenState extends State<EvolutionScreen> {
  final _evolutionService = EvolutionService();
  
  EvolutionData? _evolutionData;
  bool _isLoading = true;
  String? _error;
  
  late PeriodOption _selectedPeriod;
  late List<PeriodOption> _periodOptions;

  @override
  void initState() {
    super.initState();
    _periodOptions = _evolutionService.getPeriodOptions();
    _selectedPeriod = _periodOptions[1]; // 30 derniers jours par défaut
    _loadEvolutionData();
  }

  Future<void> _loadEvolutionData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _evolutionService.getPatientEvolution(
        patientId: widget.patientId,
        startDate: _selectedPeriod.startDate,
        endDate: _selectedPeriod.endDate,
      );

      setState(() {
        _evolutionData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  void _onPeriodChanged(PeriodOption? period) {
    if (period != null && period != _selectedPeriod) {
      setState(() {
        _selectedPeriod = period;
      });
      _loadEvolutionData();
    }
  }

  Future<void> _exportReport() async {
    if (_evolutionData == null) return;

    try {
      final report = await _evolutionService.exportEvolutionReport(_evolutionData!);
      
      if (!mounted) return;
      
      // Afficher le rapport (pour démo, en production: générer PDF)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rapport d\'évolution'),
          content: SingleChildScrollView(
            child: Text(report, style: const TextStyle(fontFamily: 'monospace')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'export: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Courbes d\'évolution'),
            Text(
              widget.patientName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _evolutionData != null ? _exportReport : null,
            tooltip: 'Exporter le rapport',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _evolutionData == null
                  ? const Center(child: Text('Aucune donnée disponible'))
                  : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEvolutionData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final data = _evolutionData!;

    return RefreshIndicator(
      onRefresh: _loadEvolutionData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sélecteur de période
          _buildPeriodSelector(),
          const SizedBox(height: 24),

          // Statistiques rapides
          _buildQuickStats(data),
          const SizedBox(height: 24),

          // Graphique d'intensité temporelle
          _buildIntensityChartCard(data),
          const SizedBox(height: 24),

          // Indicateur de tendance
          TrendIndicator(trend: data.trend),
          const SizedBox(height: 24),

          // Zones les plus touchées
          TopZonesWidget(zones: data.topAffectedZones),
          const SizedBox(height: 24),

          // Comparaisons avant/après séances
          if (data.sessionComparisons.isNotEmpty) ...[
            _buildSectionTitle('Séances de traitement'),
            const SizedBox(height: 12),
            ...data.sessionComparisons.map((comparison) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SessionComparisonCard(comparison: comparison),
              ),
            ),
          ],
        ],
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
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppTheme.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PeriodOption>(
                value: _selectedPeriod,
                items: _periodOptions.map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(
                      period.label,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: _onPeriodChanged,
                dropdownColor: Colors.grey[50],
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryOrange),
              ),
            ),
          ),
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
            icon: Icons.event_note,
            label: 'Séances',
            value: data.sessionComparisons.length.toString(),
            unit: '',
            color: Colors.blue,
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
          Row(
            children: [
              const Icon(Icons.insert_chart, color: AppTheme.primaryOrange),
              const SizedBox(width: 8),
              const Text(
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        const Icon(Icons.healing, color: AppTheme.primaryOrange),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
