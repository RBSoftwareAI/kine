import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../views/home/home_screen.dart'; // ✅ Nouveau HomeScreen avec gestion des rôles
import '../patients/patients_list_screen.dart';
import '../appointments/calendar_screen.dart';
import '../settings/app_mode_settings_screen.dart';
import '../../widgets/guided_tour_v2.dart';

/// Écran principal du dashboard avec navigation par onglets
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Vérifier si on doit lancer la visite guidée
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuidedTourV2.checkAndStartTour(context);
    });
  }

  // Obtenir les écrans en fonction du rôle
  List<Widget> _getScreensForRole(String? role) {
    if (role == 'patient') {
      // Patient : seulement Accueil et Paramètres
      return [
        const HomeScreen(),
        const AppModeSettingsScreen(),
      ];
    } else {
      // Professionnels : tous les écrans
      return [
        const HomeScreen(),
        const PatientsListScreen(),
        const CalendarScreen(),
        const AppModeSettingsScreen(),
      ];
    }
  }

  // Obtenir les destinations de navigation en fonction du rôle
  List<NavigationDestination> _getDestinationsForRole(String? role) {
    if (role == 'patient') {
      // Patient : seulement Accueil et Paramètres
      return const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ];
    } else {
      // Professionnels : tous les onglets
      return const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'Patients',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: 'Calendrier',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.appUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('MediDesk - ${_getRoleLabel(user?.role)}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Bouton de déconnexion rapide
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion rapide',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text('Voulez-vous vraiment vous déconnecter ?'),
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
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                // Déconnexion simple - AuthWrapper gère la redirection
                await context.read<AuthProvider>().logout();
              }
            },
          ),
          const SizedBox(width: 8),
          // Avatar profil
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user?.prenom[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            tooltip: 'Profil',
            onPressed: () {
              _showProfileMenu(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _getScreensForRole(user?.role)[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _getDestinationsForRole(user?.role),
      ),
    );
  }

  // Obtenir le label du rôle pour l'affichage
  String _getRoleLabel(String? role) {
    switch (role) {
      case 'patient':
        return 'Patient';
      case 'assistant':
      case 'secretaire':
        return 'Secrétaire';
      case 'praticien':
      case 'kine':
        return 'Praticien';
      case 'manager':
        return 'Manager';
      case 'admin':
      case 'sadmin':
        return 'Admin';
      default:
        return '';
    }
  }

  void _showProfileMenu(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.appUser;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      user?.prenom[0].toUpperCase() ?? 'U',
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
                          user?.nomComplet ?? 'Utilisateur',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mon profil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('Mon centre'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                        'Voulez-vous vraiment vous déconnecter ?'),
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
                        child: const Text('Déconnexion'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  // Déconnecter directement sans dialog de chargement
                  // pour éviter les problèmes de navigation
                  await context.read<AuthProvider>().logout();

                  // Le AuthWrapper devrait automatiquement rediriger vers LoginScreen
                  // car isAuthenticated devient false
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Écran placeholder pour les fonctionnalités à venir
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonctionnalité à venir',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              'Cette fonctionnalité sera disponible dans une prochaine version',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
