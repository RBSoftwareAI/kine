import 'package:flutter/material.dart';
import '../../../models/pain_point.dart';
import '../../../utils/app_theme.dart';

/// Sélecteur de fréquence de douleur
class PainFrequencySelector extends StatelessWidget {
  final PainFrequency selectedFrequency;
  final ValueChanged<PainFrequency> onChanged;

  const PainFrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fréquence de la douleur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Options de fréquence
        for (final frequency in PainFrequency.values)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onChanged(frequency),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (frequency == selectedFrequency)
                      ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (frequency == selectedFrequency)
                        ? AppTheme.primaryOrange
                        : AppTheme.lightGrey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getFrequencyIcon(frequency),
                      color: (frequency == selectedFrequency)
                          ? AppTheme.primaryOrange
                          : AppTheme.grey,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            frequency.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (frequency == selectedFrequency)
                                  ? AppTheme.primaryOrange
                                  : AppTheme.darkBackground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getFrequencyDescription(frequency),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (frequency == selectedFrequency)
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryOrange,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _getFrequencyIcon(PainFrequency frequency) {
    switch (frequency) {
      case PainFrequency.occasional:
        return Icons.schedule;
      case PainFrequency.daily:
        return Icons.today;
      case PainFrequency.frequent:
        return Icons.repeat;
      case PainFrequency.constant:
        return Icons.all_inclusive;
    }
  }

  String _getFrequencyDescription(PainFrequency frequency) {
    switch (frequency) {
      case PainFrequency.occasional:
        return 'De temps en temps, moins d\'une fois par jour';
      case PainFrequency.daily:
        return 'Une fois par jour ou presque';
      case PainFrequency.frequent:
        return 'Plusieurs fois par jour';
      case PainFrequency.constant:
        return 'Tout le temps, sans interruption';
    }
  }
}
