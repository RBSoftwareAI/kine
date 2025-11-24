import 'package:flutter/material.dart';
import '../../../models/pain_history.dart';
import '../../../utils/app_theme.dart';

class TrendIndicator extends StatelessWidget {
  final EvolutionTrend trend;

  const TrendIndicator({
    super.key,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final trendData = _getTrendData();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            trendData.color.withValues(alpha: 0.2),
            trendData.color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: trendData.color.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        children: [
          // Icône animée
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: trendData.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: trendData.color, width: 2),
            ),
            child: Icon(
              trendData.icon,
              color: trendData.color,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),

          // Texte de tendance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tendance : ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      trendData.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: trendData.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  trendData.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TrendData _getTrendData() {
    switch (trend) {
      case EvolutionTrend.improving:
        return _TrendData(
          label: 'Amélioration',
          description: 'L\'intensité de la douleur diminue progressivement. Continuez le traitement !',
          icon: Icons.trending_down,
          color: AppTheme.success,
        );
      case EvolutionTrend.stable:
        return _TrendData(
          label: 'Stable',
          description: 'L\'intensité de la douleur reste relativement constante.',
          icon: Icons.trending_flat,
          color: Colors.blue,
        );
      case EvolutionTrend.worsening:
        return _TrendData(
          label: 'Détérioration',
          description: 'L\'intensité de la douleur augmente. Une consultation est recommandée.',
          icon: Icons.trending_up,
          color: Colors.red,
        );
    }
  }
}

class _TrendData {
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  _TrendData({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}
