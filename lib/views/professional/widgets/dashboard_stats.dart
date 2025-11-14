import 'package:flutter/material.dart';
import '../../../models/patient_summary.dart';
import '../../../models/session_note.dart';
import '../../../utils/app_theme.dart';

/// Widget statistiques globales du tableau de bord
class DashboardStats extends StatelessWidget {
  final List<PatientSummary> patients;

  const DashboardStats({
    super.key,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange,
            AppTheme.primaryOrange.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vue d\'ensemble',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  value: stats['totalPatients'].toString(),
                  label: 'Patients',
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.warning_amber_rounded,
                  value: stats['needsAttention'].toString(),
                  label: 'Attention',
                  color: (stats['needsAttention'] ?? 0) > 0
                      ? AppTheme.warning
                      : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_up,
                  value: stats['improving'].toString(),
                  label: 'Amélioration',
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_down,
                  value: stats['worsening'].toString(),
                  label: 'Dégradation',
                  color: (stats['worsening'] ?? 0) > 0
                      ? AppTheme.error
                      : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats() {
    return {
      'totalPatients': patients.length,
      'needsAttention': patients.where((p) => p.needsAttention).length,
      'improving': patients
          .where((p) => p.latestStatus == ProgressStatus.improving)
          .length,
      'worsening': patients
          .where((p) => p.latestStatus == ProgressStatus.worsening)
          .length,
    };
  }
}
