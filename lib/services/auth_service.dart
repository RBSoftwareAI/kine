import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Service d'authentification (version locale temporaire)
/// À remplacer par Firebase Auth plus tard
class AuthService {
  static const String _keyUserId = 'userId';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserRole = 'userRole';
  static const String _keyUserFirstName = 'userFirstName';
  static const String _keyUserLastName = 'userLastName';

  /// Utilisateurs de démonstration
  static final List<Map<String, dynamic>> _demoUsers = [
    {
      'id': 'patient_001',
      'email': 'patient@demo.com',
      'password': 'patient123',
      'firstName': 'Jean',
      'lastName': 'Dupont',
      'role': UserRole.patient,
    },
    {
      'id': 'kine_001',
      'email': 'kine@demo.com',
      'password': 'kine123',
      'firstName': 'Dr. Marie',
      'lastName': 'Martin',
      'role': UserRole.kine,
    },
    {
      'id': 'coach_001',
      'email': 'coach@demo.com',
      'password': 'coach123',
      'firstName': 'Pierre',
      'lastName': 'Durand',
      'role': UserRole.coach,
    },
  ];

  /// Connexion
  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation réseau

    // Recherche utilisateur démo
    final userData = _demoUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (userData.isEmpty) {
      throw Exception('Email ou mot de passe incorrect');
    }

    // Création du modèle utilisateur
    final user = UserModel(
      id: userData['id'] as String,
      email: userData['email'] as String,
      firstName: userData['firstName'] as String,
      lastName: userData['lastName'] as String,
      role: userData['role'] as UserRole,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Sauvegarde session
    await _saveUserSession(user);

    return user;
  }

  /// Inscription (version démo)
  Future<UserModel?> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation réseau

    // Vérification email existant
    final existingUser = _demoUsers.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      throw Exception('Un compte existe déjà avec cet email');
    }

    // Création nouveau compte
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Sauvegarde session
    await _saveUserSession(newUser);

    return newUser;
  }

  /// Déconnexion
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Récupérer l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    final userId = prefs.getString(_keyUserId);
    final email = prefs.getString(_keyUserEmail);
    final roleStr = prefs.getString(_keyUserRole);
    final firstName = prefs.getString(_keyUserFirstName);
    final lastName = prefs.getString(_keyUserLastName);

    if (userId == null || email == null || roleStr == null) {
      return null;
    }

    final role = UserRole.values.firstWhere(
      (e) => e.toString() == roleStr,
      orElse: () => UserRole.patient,
    );

    return UserModel(
      id: userId,
      email: email,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      role: role,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  /// Sauvegarder la session utilisateur
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserRole, user.role.toString());
    await prefs.setString(_keyUserFirstName, user.firstName);
    await prefs.setString(_keyUserLastName, user.lastName);
  }
}
