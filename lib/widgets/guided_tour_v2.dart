import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/patients/patients_list_screen.dart';
import '../views/guided_tour/statistics_preview_screen.dart';
import '../views/guided_tour/evolution_preview_screen.dart';

/// Visite guidée interactive V2 pour MediDesk
/// Permet aux utilisateurs de découvrir l'application en 6 étapes
class GuidedTourV2 {
  // Flag global pour indiquer qu'on veut lancer la visite guidée
  static bool _shouldStartTour = false;
  
  /// Vérifier et lancer la visite guidée si nécessaire (appelé depuis Dashboard)
  static void checkAndStartTour(BuildContext context) {
    if (_shouldStartTour) {
      _shouldStartTour = false;
      // Attendre un frame pour que le Dashboard soit complètement monté
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const GuidedTourController(),
            ),
          );
        }
      });
    }
  }
  
  /// Démarrer la visite guidée depuis n'importe quel écran
  /// Se connecte automatiquement avec le compte demo pierre.durand@osteo-lyon.fr
  static Future<void> startTour(BuildContext context) async {
    if (kDebugMode) {
      debugPrint('🎯 Démarrage de la visite guidée...');
    }

    final authProvider = context.read<AuthProvider>();
    
    // Si déjà connecté, déconnecter d'abord
    if (authProvider.isAuthenticated) {
      if (kDebugMode) {
        debugPrint('🔄 Déconnexion de l\'utilisateur actuel...');
      }
      await authProvider.logout();
      // Attendre que la déconnexion soit effective
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Connexion automatique avec le compte demo
    if (kDebugMode) {
      debugPrint('🔑 Connexion automatique...');
    }
    
    final success = await authProvider.login(
      'pierre.durand@osteo-lyon.fr',
      'password123',
    );

    if (!success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur de connexion: ${authProvider.error ?? "Erreur inconnue"}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('✅ Connexion réussie, activation du flag de visite guidée...');
    }

    // Activer le flag pour lancer la visite guidée
    // Le Dashboard appellera checkAndStartTour() lors de son initState
    _shouldStartTour = true;
  }
}

/// Configuration d'une étape de la visite guidée
class TourStepConfig {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget Function(BuildContext) screenBuilder;

  const TourStepConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.screenBuilder,
  });
}

/// Contrôleur de la visite guidée
class GuidedTourController extends StatefulWidget {
  const GuidedTourController({super.key});

  @override
  State<GuidedTourController> createState() => _GuidedTourControllerState();
}

class _GuidedTourControllerState extends State<GuidedTourController> {
  int _currentStep = 0;

  // Configuration des étapes de la visite
  late final List<TourStepConfig> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      TourStepConfig(
        title: '👋 Bienvenue dans MediDesk !',
        description: 'Découvrez comment MediDesk simplifie la gestion de votre cabinet médical. '
            'Cette visite guidée dure environ 5-7 minutes. '
            'Vous êtes connecté en tant que Pierre Durand (Ostéopathe).',
        icon: Icons.waving_hand,
        color: Colors.blue,
        screenBuilder: (context) => const DashboardScreen(),
      ),
      TourStepConfig(
        title: '📊 Dashboard & Statistiques',
        description: 'Visualisez vos statistiques en un coup d\'œil : '
            'nombre de patients actifs, rendez-vous de la semaine, taux d\'amélioration. '
            'Le dashboard vous donne une vue d\'ensemble de votre activité.',
        icon: Icons.dashboard,
        color: Colors.orange,
        screenBuilder: (context) => const StatisticsPreviewScreen(),
      ),
      TourStepConfig(
        title: '👥 Dossiers Patients',
        description: 'Consultez et gérez tous vos dossiers patients. '
            'Chaque dossier contient l\'historique complet : notes de séances, '
            'cartographies des douleurs, et graphiques d\'évolution.',
        icon: Icons.people,
        color: Colors.green,
        screenBuilder: (context) => const PatientsListScreen(),
      ),
      TourStepConfig(
        title: '🎯 Cartographie des Douleurs',
        description: 'Localisez précisément les zones douloureuses sur une silhouette 3D. '
            'Enregistrez l\'intensité, la fréquence et l\'évolution des douleurs. '
            'Un outil visuel puissant pour le suivi thérapeutique.',
        icon: Icons.accessibility_new,
        color: Colors.red,
        screenBuilder: (context) => const PatientsListScreen(),
      ),
      TourStepConfig(
        title: '📈 Graphiques d\'Évolution',
        description: 'Suivez l\'évolution de vos patients avec des graphiques interactifs. '
            'Comparez les séances, identifiez les tendances, '
            'et démontrez visuellement les progrès thérapeutiques.',
        icon: Icons.show_chart,
        color: Colors.purple,
        screenBuilder: (context) => const EvolutionPreviewScreen(),
      ),
      TourStepConfig(
        title: '✅ Visite Terminée !',
        description: 'Vous connaissez maintenant les fonctionnalités principales de MediDesk. '
            'N\'hésitez pas à explorer davantage ou à créer un compte pour démarrer. '
            'Toutes vos données restent locales et sécurisées.',
        icon: Icons.check_circle,
        color: Colors.teal,
        screenBuilder: (context) => const DashboardScreen(),
      ),
    ];
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishTour();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _skipTour() {
    _finishTour();
  }

  void _restartTour() {
    setState(() {
      _currentStep = 0;
    });
  }

  void _finishTour() {
    // Fermer la visite guidée et retourner au dashboard
    // Le dashboard est déjà monté en arrière-plan, donc on ferme simplement la route
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentConfig = _steps[_currentStep];

    return Scaffold(
      body: Stack(
        children: [
          // Afficher l'écran réel en arrière-plan
          currentConfig.screenBuilder(context),
          
          // Overlay semi-transparent pour assombrir l'arrière-plan
          Container(
            color: Colors.black.withValues(alpha: 0.65),
          ),
          
          // Carte d'explication de l'étape
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône de l'étape
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: currentConfig.color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            currentConfig.icon,
                            size: 40,
                            color: currentConfig.color,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Titre de l'étape
                        Text(
                          currentConfig.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          currentConfig.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Indicateur de progression
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _steps.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentStep
                                    ? currentConfig.color
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Boutons de navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Bouton Précédent
                            if (_currentStep > 0)
                              TextButton.icon(
                                onPressed: _previousStep,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Précédent'),
                              )
                            else
                              const SizedBox(width: 120),
                            
                            // Bouton Passer (sauf à la dernière étape)
                            if (_currentStep < _steps.length - 1)
                              TextButton(
                                onPressed: _skipTour,
                                child: const Text('Passer'),
                              )
                            else
                              // Bouton Recommencer à la dernière étape
                              OutlinedButton.icon(
                                onPressed: _restartTour,
                                icon: const Icon(Icons.restart_alt),
                                label: const Text('Recommencer'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: currentConfig.color,
                                  side: BorderSide(color: currentConfig.color),
                                ),
                              ),
                            
                            // Bouton Suivant/Terminer
                            ElevatedButton.icon(
                              onPressed: _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentConfig.color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              icon: Icon(
                                _currentStep < _steps.length - 1
                                    ? Icons.arrow_forward
                                    : Icons.check,
                              ),
                              label: Text(
                                _currentStep < _steps.length - 1
                                    ? 'Suivant'
                                    : 'Terminer',
                              ),
                            ),
                          ],
                        ),
                        
                        // Compteur d'étapes
                        const SizedBox(height: 16),
                        Text(
                          'Étape ${_currentStep + 1} sur ${_steps.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
