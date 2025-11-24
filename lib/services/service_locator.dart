import 'package:shared_preferences/shared_preferences.dart';
import 'data_service.dart';
import 'firebase_data_service.dart';
import 'flask_data_service.dart';

/// Mode d'exécution de l'application
enum AppMode {
  demo, // Mode DEMO - Firebase (données fictives, accès public)
  local, // Mode LOCAL - Flask (données réelles, installation locale)
}

/// Service Locator pour gérer l'injection de dépendances
/// Permet de basculer entre Firebase et Flask de manière transparente
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  DataService? _dataService;
  AppMode _currentMode = AppMode.demo; // Mode par défaut : DEMO

  /// Clé de stockage du mode dans SharedPreferences
  static const String _modeStorageKey = 'app_mode';

  /// Clé de stockage de l'URL de l'API Flask
  static const String _flaskUrlStorageKey = 'flask_api_url';

  /// URL par défaut de l'API Flask
  static const String defaultFlaskUrl = 'http://localhost:5000';

  /// Initialiser le ServiceLocator
  /// À appeler au démarrage de l'application
  Future<void> initialize() async {
    // Charger le mode depuis le stockage local
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_modeStorageKey);

    if (savedMode != null) {
      _currentMode = savedMode == 'local' ? AppMode.local : AppMode.demo;
    }

    // Initialiser le service de données approprié
    await _initializeDataService();
  }

  /// Initialiser le service de données selon le mode actuel
  Future<void> _initializeDataService() async {
    // Nettoyer l'ancien service si existant
    if (_dataService != null) {
      try {
        _dataService!.dispose();
      } catch (e) {
        // Ignorer les erreurs de dispose
      }
    }

    // Créer le nouveau service selon le mode
    if (_currentMode == AppMode.demo) {
      _dataService = FirebaseDataService();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final flaskUrl = prefs.getString(_flaskUrlStorageKey) ?? defaultFlaskUrl;
      _dataService = FlaskDataService(baseUrl: flaskUrl);
    }
  }

  /// Obtenir l'instance du DataService actuel
  DataService get dataService {
    if (_dataService == null) {
      throw Exception(
        'ServiceLocator non initialisé. Appelez initialize() au démarrage de l\'application.',
      );
    }
    return _dataService!;
  }

  /// Obtenir le mode actuel
  AppMode get currentMode => _currentMode;

  /// Vérifier si on est en mode DEMO
  bool get isDemoMode => _currentMode == AppMode.demo;

  /// Vérifier si on est en mode LOCAL
  bool get isLocalMode => _currentMode == AppMode.local;

  /// Obtenir le nom du mode actuel
  String get currentModeName {
    switch (_currentMode) {
      case AppMode.demo:
        return 'DEMO (Firebase)';
      case AppMode.local:
        return 'LOCAL (Flask)';
    }
  }

  /// Obtenir la description du mode actuel
  String get currentModeDescription {
    switch (_currentMode) {
      case AppMode.demo:
        return 'Données fictives hébergées sur Firebase.\nPour démonstration et formation.';
      case AppMode.local:
        return 'Données réelles stockées localement.\nPrivé et conforme RGPD.';
    }
  }

  /// Basculer vers le mode DEMO (Firebase)
  Future<void> switchToDemoMode() async {
    if (_currentMode == AppMode.demo) return;

    _currentMode = AppMode.demo;
    
    // Sauvegarder le mode
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeStorageKey, 'demo');

    // Réinitialiser le service de données
    await _initializeDataService();
  }

  /// Basculer vers le mode LOCAL (Flask)
  Future<void> switchToLocalMode({String? flaskUrl}) async {
    if (_currentMode == AppMode.local && flaskUrl == null) return;

    _currentMode = AppMode.local;
    
    // Sauvegarder le mode et l'URL
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeStorageKey, 'local');
    
    if (flaskUrl != null) {
      await prefs.setString(_flaskUrlStorageKey, flaskUrl);
    }

    // Réinitialiser le service de données
    await _initializeDataService();
  }

  /// Obtenir l'URL de l'API Flask configurée
  Future<String> getFlaskUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_flaskUrlStorageKey) ?? defaultFlaskUrl;
  }

  /// Définir l'URL de l'API Flask
  Future<void> setFlaskUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_flaskUrlStorageKey, url);

    // Si on est en mode local, réinitialiser le service
    if (_currentMode == AppMode.local) {
      await _initializeDataService();
    }
  }

  /// Réinitialiser le ServiceLocator (pour les tests)
  Future<void> reset() async {
    if (_dataService != null) {
      try {
        _dataService!.dispose();
      } catch (e) {
        // Ignorer les erreurs de dispose
      }
      _dataService = null;
    }

    _currentMode = AppMode.demo;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_modeStorageKey);
    await prefs.remove(_flaskUrlStorageKey);
  }
}

// Extension supprimée car dispose() est maintenant dans l'interface DataService
