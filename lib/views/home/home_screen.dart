import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../pain/pain_tracking_screen.dart';
import '../professional/patients_dashboard_screen.dart';
import '../audit/audit_history_screen.dart';
import '../evolution/evolution_screen.dart';
import '../admin/permissions_management_screen.dart';
import '../../widgets/guided_tour_v2.dart';
import '../../screens/session_notes/session_notes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
              // Carte de bienvenue
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryOrange,
                            child: Text(
                              user.firstName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenue,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.grey,
                                  ),
                                ),
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user.role,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
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

              // Bouton Visite Guidée (pour les professionnels uniquement)
              if (user.isProfessional)
                Card(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  child: InkWell(
                    onTap: () async {
                      await GuidedTourV2.startTour(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.explore,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Découvrir MediDesk',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkBackground,
                                  ),
                                ),
                                SizedBox(height: 4),
                                const Text(
                                  'Visite guidée interactive (5-7 min)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xB3000000),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.primaryOrange,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Menu selon le rôle
              if (user.isPatient) ..._buildPatientMenu(context),
              if (user.isProfessional) ..._buildProfessionalMenu(context),

              const SizedBox(height: 24),

              // Informations Phase 1
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.info),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.info),
                        SizedBox(width: 8),
                        Text(
                          'Phase 1 - MVP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MVP Phase 1 COMPLET (100%) :',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.success),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem('✅ Authentification multi-rôles'),
                    _buildFeatureItem('✅ Suivi des douleurs interactif'),
                    _buildFeatureItem('✅ Silhouettes anatomiques cliquables'),
                    _buildFeatureItem('✅ Dashboard professionnel'),
                    _buildFeatureItem('✅ Système de traçabilité RGPD'),
                    _buildFeatureItem('✅ Courbes d\'évolution graphiques'),
                    _buildFeatureItem('✅ Comparaisons avant/après séances'),
                    _buildFeatureItem('✅ Analyse des tendances'),
                  ],
                ),
              ),
            ],
      ),
    );
  }

  List<Widget> _buildPatientMenu(BuildContext context) {
    return [
      const Text(
        'Mon suivi',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      _buildMenuCard(
        context,
        icon: Icons.accessibility_new,
        title: 'Mes douleurs',
        subtitle: 'Indiquer mes zones de douleur',
        color: AppTheme.primaryOrange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PainTrackingScreen(),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.show_chart,
        title: 'Courbes d\'évolution',
        subtitle: 'Graphiques et tendances de douleur',
        color: Colors.blue,
        onTap: () {
          final authProvider = context.read<AuthProvider>();
          final user = authProvider.currentUser;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvolutionScreen(
                patientId: user?.id ?? 'demo_patient_1',
                patientName: user?.fullName ?? 'Patient',
              ),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.timeline,
        title: 'Mon historique',
        subtitle: 'Traçabilité et modifications',
        color: AppTheme.info,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AuditHistoryScreen(),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _buildProfessionalMenu(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    return [
      const Text(
        'Mes patients',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      
      // Menu Gestion Permissions (sadmin et manager uniquement)
      if (user!.isAdmin) ...[
        _buildMenuCard(
          context,
          icon: Icons.admin_panel_settings,
          title: 'Gestion des Permissions',
          subtitle: user.isSadmin 
            ? 'Configuration système (Super Admin)' 
            : 'Gérer professionnels et délégations',
          color: AppTheme.error,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PermissionsManagementScreen(),
              ),
            );
          },
        ),
      ],
      
      _buildMenuCard(
        context,
        icon: Icons.people,
        title: 'Liste des patients',
        subtitle: 'Accès rapide à l\'état des patients',
        color: AppTheme.primaryOrange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatientsDashboardScreen(),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.accessibility_new,
        title: 'Cartographie des douleurs',
        subtitle: 'Localiser les zones douloureuses',
        color: Colors.red,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PainTrackingScreen(),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.edit_note,
        title: 'Notes de séance',
        subtitle: 'Consulter et ajouter des observations',
        color: AppTheme.info,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SessionNotesScreen(),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.show_chart,
        title: 'Courbes d\'évolution',
        subtitle: 'Visualiser la progression patients',
        color: Colors.blue,
        onTap: () {
          // Pour demo: utiliser le premier patient
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EvolutionScreen(
                patientId: 'demo_patient_1',
                patientName: 'Jean Dupont (Demo)',
              ),
            ),
          );
        },
      ),
      _buildMenuCard(
        context,
        icon: Icons.timeline,
        title: 'Historique des modifications',
        subtitle: 'Traçabilité complète RGPD',
        color: AppTheme.info,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AuditHistoryScreen(),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
