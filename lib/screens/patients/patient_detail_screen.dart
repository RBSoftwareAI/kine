import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/patient_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/patient.dart';
import 'patient_form_screen.dart';

/// Écran de détail d'un patient
class PatientDetailScreen extends StatefulWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatient();
    });
  }

  Future<void> _loadPatient() async {
    final patientProvider = context.read<PatientProvider>();
    await patientProvider.selectPatient(widget.patientId);
  }

  Future<void> _confirmDelete(Patient patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Désactiver le patient'),
        content: Text(
          'Voulez-vous vraiment désactiver le patient ${patient.nomComplet} ?\n\nLe patient ne sera pas supprimé définitivement mais sera archivé.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Désactiver'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      final patientProvider = context.read<PatientProvider>();
      final centreId = authProvider.centre?.id;

      if (centreId != null) {
        final success = await patientProvider.deactivatePatient(
          widget.patientId,
          centreId,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Patient désactivé avec succès'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  patientProvider.error ?? 'Erreur lors de la désactivation',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final patient = patientProvider.selectedPatient;

    if (patientProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail patient'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail patient'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              const Text(
                'Patient introuvable',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail patient'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => PatientFormScreen(patient: patient),
                ),
              );

              if (result == true && mounted) {
                _loadPatient();
              }
            },
            tooltip: 'Modifier',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(patient);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Désactiver', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête avec avatar
            _buildHeader(patient),

            // Informations personnelles
            _buildSection(
              'Informations personnelles',
              [
                _buildInfoTile(
                  Icons.person_outline,
                  'Nom complet',
                  patient.nomComplet,
                ),
                _buildInfoTile(
                  Icons.cake_outlined,
                  'Date de naissance',
                  DateFormat('dd/MM/yyyy').format(patient.dateNaissance),
                ),
                _buildInfoTile(
                  Icons.tag_outlined,
                  'Âge',
                  '${patient.age} ans',
                ),
                if (patient.numeroSecuriteSociale != null)
                  _buildInfoTile(
                    Icons.badge_outlined,
                    'Numéro de sécurité sociale',
                    patient.numeroSecuriteSociale!,
                  ),
              ],
            ),

            // Contact
            if (patient.telephone != null ||
                patient.email != null ||
                patient.adresse != null)
              _buildSection(
                'Contact',
                [
                  if (patient.telephone != null)
                    _buildInfoTile(
                      Icons.phone_outlined,
                      'Téléphone',
                      patient.telephone!,
                      onTap: () {
                        // TODO: Appeler le numéro
                      },
                    ),
                  if (patient.email != null)
                    _buildInfoTile(
                      Icons.email_outlined,
                      'Email',
                      patient.email!,
                      onTap: () {
                        // TODO: Envoyer un email
                      },
                    ),
                  if (patient.adresseComplete != null)
                    _buildInfoTile(
                      Icons.location_on_outlined,
                      'Adresse',
                      patient.adresseComplete!,
                    ),
                ],
              ),

            // Informations complémentaires
            if (patient.profession != null || patient.medecinTraitant != null)
              _buildSection(
                'Informations complémentaires',
                [
                  if (patient.profession != null)
                    _buildInfoTile(
                      Icons.work_outline,
                      'Profession',
                      patient.profession!,
                    ),
                  if (patient.medecinTraitant != null)
                    _buildInfoTile(
                      Icons.medical_services_outlined,
                      'Médecin traitant',
                      patient.medecinTraitant!,
                    ),
                ],
              ),

            // Notes
            if (patient.notes != null && patient.notes!.isNotEmpty)
              _buildSection(
                'Notes',
                [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      patient.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

            // Historique
            _buildSection(
              'Historique des consultations',
              [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune consultation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fonctionnalité à venir (Phase D)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Métadonnées
            _buildSection(
              'Informations système',
              [
                _buildInfoTile(
                  Icons.add_circle_outline,
                  'Date de création',
                  DateFormat('dd/MM/yyyy à HH:mm').format(patient.dateCreation),
                ),
                if (patient.dateModification != null)
                  _buildInfoTile(
                    Icons.edit_outlined,
                    'Dernière modification',
                    DateFormat('dd/MM/yyyy à HH:mm')
                        .format(patient.dateModification!),
                  ),
                _buildInfoTile(
                  Icons.check_circle_outline,
                  'Statut',
                  patient.actif ? 'Actif' : 'Inactif',
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: patient.actif
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      patient.actif ? 'Actif' : 'Inactif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: patient.actif ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Patient patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              patient.initiales,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            patient.nomComplet,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${patient.age} ans',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
