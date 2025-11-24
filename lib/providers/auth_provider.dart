import 'package:flutter/foundation.dart';
import '../services/data_service.dart';
import '../services/firebase_data_service.dart';
import '../models/user.dart';
import '../models/centre.dart';

/// Provider pour la gestion de l'état d'authentification
/// Utilise Firebase directement (mode DEMO simplifié)
class AuthProvider extends ChangeNotifier {
  final DataService _dataService = FirebaseDataService();

  // État
  String? _userId;
  User? _appUser;
  Centre? _centre;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get userId => _userId;
  User? get appUser => _appUser;
  User? get currentUser => _appUser; // Alias pour compatibilité
  Centre? get centre => _centre;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get errorMessage => _error; // Alias pour compatibilité
  bool get isAuthenticated => _userId != null && _appUser != null;

  AuthProvider() {
    // Écouter les changements d'état d'authentification
    _dataService.authStateChanges.listen(_onAuthStateChanged);
    
    // CRITICAL FIX: Initialiser l'état immédiatement pour éviter le blocage
    _initializeAuthState();
  }

  /// Initialiser l'état d'authentification au démarrage
  Future<void> _initializeAuthState() async {
    _isLoading = true;
    notifyListeners();
    
    // Attendre un court délai pour que le stream auth se stabilise
    await Future.delayed(const Duration(milliseconds: 500));
    
    _isLoading = false;
    notifyListeners();
  }

  /// Gérer les changements d'état d'authentification
  Future<void> _onAuthStateChanged(AuthState authState) async {
    _userId = authState.userId;

    if (authState.isAuthenticated && authState.userId != null) {
      // Utilisateur connecté - charger les données
      await loadUserData();
    } else {
      // Utilisateur déconnecté - réinitialiser
      _appUser = null;
      _centre = null;
      _isLoading = false; // CRITICAL: Arrêter le chargement si déconnecté
    }

    notifyListeners();
  }

  /// Charger les données utilisateur et centre depuis le service
  Future<void> loadUserData() async {
    if (_userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Charger les données utilisateur
      _appUser = await _dataService.getUserData(_userId!);

      // Charger les données du centre
      _centre = await _dataService.getUserCentre(_appUser!.centreId);

      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des données : $e';
      if (kDebugMode) {
        debugPrint('Erreur loadUserData: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inscription
  Future<bool> signup({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String specialite,
    required String centreName,
    required String centreAdresse,
    String? centreTelephone,
    String? centreEmail,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _dataService.signup(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        specialite: specialite,
        centreName: centreName,
        centreAdresse: centreAdresse,
        centreTelephone: centreTelephone,
        centreEmail: centreEmail,
      );

      if (!result.success) {
        _error = result.error;
        return false;
      }

      // Les données seront chargées automatiquement via authStateChanges
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        debugPrint('Erreur signup: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Connexion
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _dataService.login(email, password);

      if (!result.success) {
        _error = result.error;
        return false;
      }

      // Les données seront chargées automatiquement via authStateChanges
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        debugPrint('Erreur login: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Alias pour compatibilité
  Future<bool> signIn(String email, String password) async {
    return await login(email, password);
  }

  /// Déconnexion
  Future<void> logout() async {
    try {
      if (kDebugMode) {
        debugPrint('🔴 Début déconnexion...');
      }

      // Déconnecter du service
      await _dataService.logout();

      // Réinitialiser l'état local immédiatement
      _userId = null;
      _appUser = null;
      _centre = null;
      _error = null;
      _isLoading = false;

      if (kDebugMode) {
        debugPrint('✅ Déconnexion réussie');
      }

      // Notifier les listeners APRÈS avoir réinitialisé l'état
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la déconnexion : $e';
      if (kDebugMode) {
        debugPrint('❌ Erreur logout: $e');
      }
      notifyListeners();
    }
  }

  /// Alias pour compatibilité
  Future<void> signOut() async {
    await logout();
  }

  /// Réinitialiser le mot de passe
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dataService.resetPassword(email);
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        debugPrint('Erreur resetPassword: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Mode actuel (toujours DEMO en mode simplifié)
  String get currentModeName => 'DEMO (Firebase)';

  /// Vérifier si on est en mode DEMO (toujours vrai)
  bool get isDemoMode => true;

  /// Vérifier si on est en mode LOCAL (toujours faux)
  bool get isLocalMode => false;
}
