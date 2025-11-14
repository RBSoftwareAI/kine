import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

/// Provider pour gérer l'authentification
class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  UserModel? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initAuth();
  }

  /// Initialisation de l'authentification
  Future<void> _initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing auth: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Connexion
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // MODE DÉMONSTRATION LOCAL - Vérifier si c'est un compte de démo
      final demoUser = _getDemoUser(email, password);
      if (demoUser != null) {
        // Connexion locale réussie
        _currentUser = demoUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Sinon, utiliser Firebase Auth
      _currentUser = await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Récupère un utilisateur de démonstration local
  UserModel? _getDemoUser(String email, String password) {
    final demoAccounts = {
      'patient@demo.com': {
        'password': 'patient123',
        'firstName': 'Jean',
        'lastName': 'Patient',
        'role': UserRole.patient,
      },
      'kine@demo.com': {
        'password': 'kine123',
        'firstName': 'Marie',
        'lastName': 'Kinésithérapeute',
        'role': UserRole.kine,
      },
      'coach@demo.com': {
        'password': 'coach123',
        'firstName': 'Pierre',
        'lastName': 'Coach',
        'role': UserRole.coach,
      },
    };

    if (demoAccounts.containsKey(email)) {
      final account = demoAccounts[email]!;
      if (account['password'] == password) {
        return UserModel(
          id: 'demo_${account['role'].toString().split('.').last}',
          email: email,
          firstName: account['firstName'] as String,
          lastName: account['lastName'] as String,
          role: account['role'] as UserRole,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      }
    }
    return null;
  }

  /// Inscription
  Future<bool> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signUp(
        email,
        password,
        firstName,
        lastName,
        role,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error signing out: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Réinitialiser le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
