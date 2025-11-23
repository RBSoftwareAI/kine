import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/appointment.dart';
import 'appointment_form_screen.dart';

/// Écran de détail d'un rendez-vous
class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final patient = appointment.patientId != null
        ? patientProvider.patients.firstWhere(
            (p) => p.id == appointment.patientId,
            orElse: () => patientProvider.patients.first,
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du rendez-vous'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Modifier
          if (appointment.statut != 'terminé' && appointment.statut != 'annulé')
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Modifier',
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AppointmentFormScreen(
                      appointment: appointment,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          // Menu actions
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte patient
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              patient?.prenom[0].toUpperCase() ?? 'P',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient?.nomComplet ??
                                      (appointment.patientNom != null
                                          ? '${appointment.patientPrenom} ${appointment.patientNom}'
                                          : 'Patient inconnu'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (patient != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    patient.telephone ?? 'Pas de téléphone',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Informations du rendez-vous
              _buildInfoCard(
                context,
                'Informations du rendez-vous',
                [
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    _formatDate(appointment.dateHeure),
                  ),
                  _buildInfoRow(
                    Icons.access_time,
                    'Heure',
                    '${_formatTime(appointment.dateHeure)} - ${_formatTime(appointment.heureFin)}',
                  ),
                  _buildInfoRow(
                    Icons.timer,
                    'Durée',
                    '${appointment.duree} minutes',
                  ),
                  _buildInfoRow(
                    Icons.medical_services,
                    'Type',
                    _getTypeLabel(appointment.type),
                  ),
                  if (appointment.motif != null)
                    _buildInfoRow(
                      Icons.description,
                      'Motif',
                      appointment.motif!,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Statut
              _buildStatusCard(context),
              const SizedBox(height: 16),

              // Notes
              if (appointment.notes != null) ...[
                _buildInfoCard(
                  context,
                  'Notes',
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        appointment.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Actions rapides
              if (appointment.statut != 'terminé' && appointment.statut != 'annulé')
                _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final statusColor = _getStatusColor(appointment.statut);
    final statusIcon = _getStatusIcon(appointment.statut);

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statut',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  _getStatusLabel(appointment.statut),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (appointment.statut == 'planifié')
          ElevatedButton.icon(
            onPressed: () async {
              final success = await appointmentProvider.confirmAppointment(
                authProvider.centre!.id,
                appointment.id,
              );

              if (context.mounted) {
                if (success) {
                  Navigator.of(context).pop(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rendez-vous confirmé'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Confirmer le rendez-vous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        const SizedBox(height: 8),
        if (appointment.statut == 'confirmé')
          ElevatedButton.icon(
            onPressed: () async {
              final success = await appointmentProvider.completeAppointment(
                authProvider.centre!.id,
                appointment.id,
              );

              if (context.mounted) {
                if (success) {
                  Navigator.of(context).pop(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rendez-vous marqué comme terminé'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.done_all),
            label: const Text('Marquer comme terminé'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Annuler le rendez-vous'),
                content: const Text(
                  'Êtes-vous sûr de vouloir annuler ce rendez-vous ?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Non'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Annuler le RDV'),
                  ),
                ],
              ),
            );

            if (confirm == true && context.mounted) {
              final success = await appointmentProvider.cancelAppointment(
                authProvider.centre!.id,
                appointment.id,
              );

              if (context.mounted) {
                if (success) {
                  Navigator.of(context).pop(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rendez-vous annulé'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            }
          },
          icon: const Icon(Icons.cancel),
          label: const Text('Annuler le rendez-vous'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rendez-vous'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer définitivement ce rendez-vous ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final appointmentProvider = context.read<AppointmentProvider>();

      final success = await appointmentProvider.deleteAppointment(
        authProvider.centre!.id,
        appointment.id,
      );

      if (context.mounted) {
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous supprimé'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'confirmé':
        return Colors.green;
      case 'en_cours':
        return Colors.blue;
      case 'terminé':
        return Colors.grey;
      case 'annulé':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String statut) {
    switch (statut) {
      case 'confirmé':
        return Icons.check_circle;
      case 'en_cours':
        return Icons.play_circle;
      case 'terminé':
        return Icons.check_circle_outline;
      case 'annulé':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  String _getStatusLabel(String statut) {
    switch (statut) {
      case 'planifié':
        return 'Planifié';
      case 'confirmé':
        return 'Confirmé';
      case 'en_cours':
        return 'En cours';
      case 'terminé':
        return 'Terminé';
      case 'annulé':
        return 'Annulé';
      default:
        return statut;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'consultation':
        return 'Consultation';
      case 'suivi':
        return 'Suivi';
      case 'urgence':
        return 'Urgence';
      case 'bilan':
        return 'Bilan';
      default:
        return type;
    }
  }
}
