import 'package:flutter/material.dart';
import '../../../models/pain_point.dart';
import '../../../utils/app_theme.dart';

/// Sélecteur d'intensité de douleur avec échelle visuelle
class PainIntensitySelector extends StatelessWidget {
  final PainIntensity selectedIntensity;
  final ValueChanged<PainIntensity> onChanged;

  const PainIntensitySelector({
    super.key,
    required this.selectedIntensity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Intensité de la douleur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Échelle visuelle
        Row(
          children: PainIntensity.values.map((intensity) {
            final isSelected = intensity == selectedIntensity;
            final color = AppTheme.getPainColor(intensity.numericValue);
            
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(intensity),
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? color 
                        : color.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        intensity.numericValue.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 8),
        
        // Légende
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aucune',
              style: TextStyle(fontSize: 12, color: AppTheme.grey),
            ),
            Text(
              'Extrême',
              style: TextStyle(fontSize: 12, color: AppTheme.grey),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Description de l'intensité sélectionnée
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.getPainColor(selectedIntensity.numericValue)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _getIntensityIcon(selectedIntensity),
                color: AppTheme.getPainColor(selectedIntensity.numericValue),
              ),
              const SizedBox(width: 12),
              Text(
                selectedIntensity.displayName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getPainColor(selectedIntensity.numericValue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIntensityIcon(PainIntensity intensity) {
    switch (intensity) {
      case PainIntensity.none:
        return Icons.sentiment_very_satisfied;
      case PainIntensity.minimal:
        return Icons.sentiment_satisfied;
      case PainIntensity.mild:
        return Icons.sentiment_neutral;
      case PainIntensity.moderate:
        return Icons.sentiment_dissatisfied;
      case PainIntensity.severe:
        return Icons.sentiment_very_dissatisfied;
      case PainIntensity.extreme:
        return Icons.warning;
    }
  }
}
