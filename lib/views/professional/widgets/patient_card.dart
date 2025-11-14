import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/patient_summary.dart';
import '../../../models/session_note.dart';
import '../../../utils/app_theme.dart';

/// Carte patient pour le tableau de bord
class PatientCard extends StatelessWidget {
  final PatientSummary patient;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    child: Text(
                      patient.patientName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Nom et email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.patientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.patientEmail,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Badge attention
                  if (patient.needsAttention)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Attention',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Statistiques du patient
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.location_on,
                    label: '${patient.totalPainPoints} zones',
                    color: AppTheme.info,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    icon: Icons.timeline,
                    label: '${patient.sessionsCount} séances',
                    color: AppTheme.primaryOrange,
                  ),
                  const Spacer(),
                  if (patient.latestStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(patient.latestStatus!)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            patient.latestStatus!.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            patient.latestStatus!.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(patient.latestStatus!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Intensité moyenne de douleur
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intensité moyenne',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: patient.averagePainIntensity / 10,
                                backgroundColor: AppTheme.lightGrey,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.getPainColor(patient.averagePainIntensity.round()),
                                ),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.getPainColor(patient.averagePainIntensity.round())
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                patient.averagePainIntensity.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.getPainColor(patient.averagePainIntensity.round()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Zones de douleur principales
              if (patient.topPainZones.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: patient.topPainZones.map((zone) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGrey.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        zone,
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Dernière mise à jour
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: AppTheme.grey),
                  const SizedBox(width: 4),
                  Text(
                    _getLastUpdateText(),
                    style: TextStyle(fontSize: 12, color: AppTheme.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getStatusColor(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.improving:
        return AppTheme.success;
      case ProgressStatus.stable:
        return AppTheme.info;
      case ProgressStatus.worsening:
        return AppTheme.error;
      case ProgressStatus.recovered:
        return AppTheme.success;
    }
  }

  String _getLastUpdateText() {
    if (patient.lastPainUpdate == null) {
      return 'Aucune mise à jour';
    }

    final now = DateTime.now();
    final difference = now.difference(patient.lastPainUpdate!);

    if (difference.inMinutes < 60) {
      return 'Mis à jour il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Mis à jour il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Mis à jour il y a ${difference.inDays}j';
    } else {
      return 'Mis à jour le ${DateFormat('dd/MM/yyyy').format(patient.lastPainUpdate!)}';
    }
  }
}
