import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/pain_history.dart';
import '../../../utils/app_theme.dart';

class SessionComparisonCard extends StatelessWidget {
  final SessionComparison comparison;

  const SessionComparisonCard({
    super.key,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    final improvement = comparison.improvement;
    final improvementPercentage = comparison.improvementPercentage;
    final isPositive = improvement > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive
              ? AppTheme.success.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // En-tête avec date
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(comparison.sessionDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                _buildImprovementBadge(improvement, improvementPercentage),
              ],
            ),
          ),

          // Comparaison avant/après
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avant
                Expanded(
                  child: _buildComparisonColumn(
                    label: 'Avant',
                    value: comparison.beforeAverage,
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                ),

                // Flèche
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    isPositive ? Icons.trending_down : Icons.trending_up,
                    color: isPositive ? AppTheme.success : Colors.red,
                    size: 32,
                  ),
                ),

                // Après
                Expanded(
                  child: _buildComparisonColumn(
                    label: 'Après',
                    value: comparison.afterAverage,
                    icon: Icons.check_circle,
                    color: isPositive ? AppTheme.success : Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Barre de progression visuelle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildProgressBar(
              before: comparison.beforeAverage,
              after: comparison.afterAverage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementBadge(double improvement, double percentage) {
    final isPositive = improvement > 0;
    final color = isPositive ? AppTheme.success : Colors.red;
    final icon = isPositive ? Icons.arrow_downward : Icons.arrow_upward;
    final sign = isPositive ? '-' : '+';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$sign${improvement.abs().toStringAsFixed(1)} (${percentage.abs().toStringAsFixed(0)}%)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonColumn({
    required String label,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '/10',
              style: TextStyle(
                fontSize: 16,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar({
    required double before,
    required double after,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Évolution visuelle',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Barre "Avant"
            Expanded(
              flex: before.round(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
            // Espace vide (amélioration)
            if (before > after)
              Expanded(
                flex: (before - after).round(),
                child: Container(
                  height: 8,
                  color: Colors.grey[50],
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Barre "Après"
            Expanded(
              flex: after.round(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
            // Espace vide
            if (after < 10)
              Expanded(
                flex: (10 - after).round(),
                child: Container(
                  height: 8,
                  color: Colors.grey[50],
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }
}
