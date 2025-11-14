import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Service d'authentification Firebase
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Connexion avec email et mot de passe
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) return null;

      // Récupérer les données utilisateur depuis Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Profil utilisateur introuvable');
      }

      return UserModel.fromFirestore(userDoc.data()!, userDoc.id);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Aucun compte trouvé avec cet email');
        case 'wrong-password':
          throw Exception('Mot de passe incorrect');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'user-disabled':
          throw Exception('Ce compte a été désactivé');
        default:
          throw Exception('Erreur de connexion: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error signing in: $e');
      }
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Inscription avec email et mot de passe
  Future<UserModel?> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    try {
      // Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) return null;

      // Créer le profil utilisateur dans Firestore
      final newUser = UserModel(
        id: credential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toFirestore());

      return newUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Un compte existe déjà avec cet email');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'weak-password':
          throw Exception('Mot de passe trop faible (min. 6 caractères)');
        default:
          throw Exception('Erreur d\'inscription: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error signing up: $e');
      }
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Récupérer l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) return null;

      // Mettre à jour la date de dernière connexion
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'lastLoginAt': FieldValue.serverTimestamp()});

      return UserModel.fromFirestore(userDoc.data()!, userDoc.id);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting current user: $e');
      }
      return null;
    }
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }

  /// Stream d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
