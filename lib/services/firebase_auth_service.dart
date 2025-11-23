import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/centre.dart';
import '../models/user.dart' as app_user;

/// Service d'authentification Firebase avec création automatique de centre
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  /// Inscription avec création automatique du centre
  Future<UserCredential> signup({
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
    try {
      // 1. Créer le compte Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Créer le centre dans Firestore
      final centreRef = _firestore.collection('centres').doc();
      final centre = Centre(
        id: centreRef.id,
        nom: centreName,
        adresse: centreAdresse,
        telephone: centreTelephone,
        email: centreEmail ?? email,
        dateCreation: DateTime.now(),
        proprietaireId: uid,
        actif: true,
        dureeConsultationDefaut: 30,
        heureOuverture: '08:00',
        heureFermeture: '19:00',
        joursOuverture: [1, 2, 3, 4, 5], // Lundi-Vendredi
      );

      await centreRef.set(centre.toFirestore());

      // 3. Créer l'utilisateur dans Firestore
      final user = app_user.User(
        id: uid,
        centreId: centreRef.id,
        nom: nom,
        prenom: prenom,
        email: email,
        role: 'admin', // Premier utilisateur = admin
        specialite: specialite,
        dateCreation: DateTime.now(),
        actif: true,
      );

      await _firestore.collection('users').doc(uid).set(user.toFirestore());

      // 4. Mettre à jour le profil Firebase Auth
      await userCredential.user!.updateDisplayName('$prenom $nom');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs d'authentification
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription : $e');
    }
  }

  /// Connexion
  Future<UserCredential> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour la dernière connexion
      final uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).update({
        'derniere_connexion': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Récupérer les données utilisateur depuis Firestore
  Future<app_user.User> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('Utilisateur introuvable dans Firestore');
    }
    return app_user.User.fromFirestore(doc);
  }

  /// Récupérer le centre de l'utilisateur
  Future<Centre> getUserCentre(String centreId) async {
    final doc = await _firestore.collection('centres').doc(centreId).get();
    if (!doc.exists) {
      throw Exception('Centre introuvable');
    }
    return Centre.fromFirestore(doc);
  }

  /// Gestion des exceptions Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible (minimum 6 caractères)';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'invalid-email':
        return 'Format d\'email invalide';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      default:
        return 'Erreur d\'authentification : ${e.message}';
    }
  }
}
