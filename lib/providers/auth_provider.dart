import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/firebase_auth_service.dart';
import '../models/user.dart';
import '../models/centre.dart';

/// Provider pour la gestion de l'état d'authentification
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // État
  firebase_auth.User? _firebaseUser;
  User? _appUser;
  Centre? _centre;
  bool _isLoading = false;
  String? _error;

  // Getters
  firebase_auth.User? get firebaseUser => _firebaseUser;
  User? get appUser => _appUser;
  User? get currentUser => _appUser; // Alias pour compatibilité
  Centre? get centre => _centre;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get errorMessage => _error; // Alias pour compatibilité
  bool get isAuthenticated => _firebaseUser != null && _appUser != null;

  AuthProvider() {
    // Écouter les changements d'état d'authentification
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  /// Gérer les changements d'état d'authentification
  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    _firebaseUser = firebaseUser;

    if (firebaseUser != null) {
      // Utilisateur connecté - charger les données
      await loadUserData();
    } else {
      // Utilisateur déconnecté - réinitialiser
      _appUser = null;
      _centre = null;
    }

    notifyListeners();
  }

  /// Charger les données utilisateur et centre depuis Firestore
  Future<void> loadUserData() async {
    if (_firebaseUser == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Charger les données utilisateur
      _appUser = await _authService.getUserData(_firebaseUser!.uid);

      // Charger les données du centre
      _centre = await _authService.getUserCentre(_appUser!.centreId);

      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des données : $e';
      if (kDebugMode) {
        print('Erreur loadUserData: $e');
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
      await _authService.signup(
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

      // Les données seront chargées automatiquement via authStateChanges
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erreur signup: $e');
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
      await _authService.login(email, password);

      // Les données seront chargées automatiquement via authStateChanges
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erreur login: $e');
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
        print('🔴 Début déconnexion...');
      }
      
      // Déconnecter de Firebase
      await _authService.logout();
      
      // Réinitialiser l'état local immédiatement
      _firebaseUser = null;
      _appUser = null;
      _centre = null;
      _error = null;
      _isLoading = false;
      
      if (kDebugMode) {
        print('✅ Déconnexion réussie');
      }
      
      // Notifier les listeners APRÈS avoir réinitialisé l'état
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la déconnexion : $e';
      if (kDebugMode) {
        print('❌ Erreur logout: $e');
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
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erreur resetPassword: $e');
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
}
