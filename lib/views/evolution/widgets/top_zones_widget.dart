import 'package:flutter/material.dart';
import '../../../models/pain_history.dart';
import '../../../utils/app_theme.dart';

class TopZonesWidget extends StatelessWidget {
  final List<ZoneImpact> zones;

  const TopZonesWidget({
    super.key,
    required this.zones,
  });

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Aucune zone affectée',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.primaryOrange),
              const SizedBox(width: 8),
              const Text(
                'Zones les plus touchées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...zones.asMap().entries.map((entry) {
            final index = entry.key;
            final zone = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildZoneItem(zone, index + 1),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildZoneItem(ZoneImpact zone, int rank) {
    final intensityColor = AppTheme.getIntensityColor(zone.averageIntensity.round());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: intensityColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Rang
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank).withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: _getRankColor(rank)),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: _getRankColor(rank),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nom de la zone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.zoneName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${zone.occurrences} occurrence${zone.occurrences > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Barre d'intensité
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    zone.averageIntensity.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: intensityColor,
                    ),
                  ),
                  Text(
                    '/10',
                    style: TextStyle(
                      fontSize: 12,
                      color: intensityColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: zone.averageIntensity / 10,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(intensityColor),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Or
      case 2:
        return const Color(0xFFC0C0C0); // Argent
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.primaryOrange;
    }
  }
}
