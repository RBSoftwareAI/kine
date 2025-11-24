import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../services/permission_service.dart';

/// Dashboard spécifique pour les patients
/// Affiche uniquement les données du patient connecté
class PatientDashboard extends Scaffold {
  PatientDashboard({super.key})
      : super(
          appBar: AppBar(
            title: const Text('🏥 Mon Espace Patient'),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Se déconnecter',
                  onPressed: () async {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                ),
              ),
            ],
          ),
          body: const PatientDashboardBody(),
        );
}

class PatientDashboardBody extends StatelessWidget {
  const PatientDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: Text('Utilisateur non connecté'));
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête patient
            _buildPatientHeader(context, user),
            const SizedBox(height: 24),

            // Mes rendez-vous
            _buildAppointmentsSection(context, user),
            const SizedBox(height: 24),

            // Cartographie douleur (placeholder)
            _buildPainMappingSection(context),
            const SizedBox(height: 24),

            // Mon dossier
            _buildProfileSection(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '${user.prenom[0]}${user.nom[0]}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue, ${user.prenom} ${user.nom}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    PermissionService.getRoleDisplayName(user.role),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mes Rendez-vous',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, child) {
                final appointments = appointmentProvider.appointments
                    .where((apt) => apt.patientId == user.uid)
                    .toList()
                  ..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));

                if (appointments.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Aucun rendez-vous planifié'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length > 3 ? 3 : appointments.length,
                  itemBuilder: (context, index) {
                    final apt = appointments[index];
                    return ListTile(
                      leading: Icon(
                        Icons.event,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(apt.motif ?? 'Consultation'),
                      subtitle: Text(
                        '${apt.dateHeure.day}/${apt.dateHeure.month}/${apt.dateHeure.year} à ${apt.dateHeure.hour}:${apt.dateHeure.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: Chip(
                        label: Text(apt.statut),
                        backgroundColor: _getStatusColor(apt.statut),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Naviguer vers calendrier pour demander RDV
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Demande de rendez-vous - À implémenter'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Demander un rendez-vous'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPainMappingSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.accessibility_new,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ma Cartographie Douleur',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Localisez vos douleurs sur le schéma corporel pour aider votre praticien à mieux vous prendre en charge.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ouvrir écran cartographie
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cartographie douleur - À implémenter'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Mettre à jour'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Historique - À implémenter'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Historique'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mon Dossier',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Téléphone', user.telephone ?? 'Non renseigné'),
            const SizedBox(height: 8),
            const Text(
              '📌 Information : Votre dossier est en lecture seule. '
              'Pour modifier vos coordonnées, contactez la secrétaire.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'planifie':
        return Colors.blue[100]!;
      case 'confirme':
        return Colors.green[100]!;
      case 'termine':
        return Colors.grey[300]!;
      case 'annule':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}
