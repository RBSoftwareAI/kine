import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'data_service.dart';
import '../models/user.dart';
import '../models/centre.dart';
import '../models/patient.dart';
import '../models/appointment.dart';

/// Implémentation Firebase du DataService (MODE DEMO)
/// Utilise Firebase Auth + Firestore pour stocker les données
class FirebaseDataService implements DataService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // StreamController pour l'état d'authentification
  final _authStateController = StreamController<AuthState>.broadcast();

  FirebaseDataService() {
    // Écouter les changements d'état d'authentification Firebase
    _auth.authStateChanges().listen((firebaseUser) {
      _authStateController.add(AuthState(
        userId: firebaseUser?.uid,
        isAuthenticated: firebaseUser != null,
      ));
    });
  }

  @override
  void dispose() {
    _authStateController.close();
  }

  // ==================== AUTHENTIFICATION ====================

  @override
  Stream<AuthState> get authStateChanges => _authStateController.stream;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<AuthResult> signup({
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
      final user = User(
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

      return AuthResult.success(uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('Erreur lors de l\'inscription : $e');
    }
  }

  @override
  Future<AuthResult> login(String email, String password) async {
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

      return AuthResult.success(uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('Erreur lors de la connexion : $e');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  @override
  Future<User> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('Utilisateur introuvable dans Firestore');
    }
    return User.fromFirestore(doc);
  }

  @override
  Future<Centre> getUserCentre(String centreId) async {
    final doc = await _firestore.collection('centres').doc(centreId).get();
    if (!doc.exists) {
      throw Exception('Centre introuvable');
    }
    return Centre.fromFirestore(doc);
  }

  /// Gestion des exceptions Firebase Auth
  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
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

  // ==================== PATIENTS ====================

  @override
  Stream<List<Patient>> getPatientsStream(String centreId) {
    return _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .snapshots()
        .map((snapshot) {
      final patients = snapshot.docs
          .map((doc) => Patient.fromFirestore(doc))
          .where((p) => p.actif)
          .toList();
      
      patients.sort((a, b) => a.nom.compareTo(b.nom));
      return patients;
    });
  }

  @override
  Future<List<Patient>> getPatients(String centreId) async {
    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif)
        .toList();
    
    patients.sort((a, b) => a.nom.compareTo(b.nom));
    return patients;
  }

  @override
  Future<Patient?> getPatient(String patientId) async {
    final doc = await _firestore.collection('patients').doc(patientId).get();
    if (!doc.exists) {
      return null;
    }
    return Patient.fromFirestore(doc);
  }

  @override
  Future<List<Patient>> searchPatients(String centreId, String query) async {
    final queryLower = query.toLowerCase();
    final patients = await getPatients(centreId);

    return patients.where((patient) {
      final nomComplet = patient.nomComplet.toLowerCase();
      final nom = patient.nom.toLowerCase();
      final prenom = patient.prenom.toLowerCase();

      return nomComplet.contains(queryLower) ||
          nom.contains(queryLower) ||
          prenom.contains(queryLower);
    }).toList();
  }

  @override
  Future<String> addPatient(Patient patient) async {
    final docRef = await _firestore.collection('patients').add(
      patient.toFirestore(),
    );
    return docRef.id;
  }

  @override
  Future<void> updatePatient(String patientId, Patient patient) async {
    await _firestore.collection('patients').doc(patientId).update(
      patient.copyWith(dateModification: DateTime.now()).toFirestore(),
    );
  }

  @override
  Future<void> deactivatePatient(String patientId) async {
    await _firestore.collection('patients').doc(patientId).update({
      'actif': false,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> reactivatePatient(String patientId) async {
    await _firestore.collection('patients').doc(patientId).update({
      'actif': true,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await _firestore.collection('patients').doc(patientId).delete();
  }

  @override
  Future<List<Patient>> getInactivePatients(String centreId) async {
    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => !p.actif)
        .toList();
    
    patients.sort((a, b) => a.nom.compareTo(b.nom));
    return patients;
  }

  @override
  Future<int> countActivePatients(String centreId) async {
    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .get();

    return snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif)
        .length;
  }

  @override
  Future<List<Patient>> getRecentPatients(String centreId, {int days = 30}) async {
    final date = DateTime.now().subtract(Duration(days: days));

    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif && p.dateCreation.isAfter(date))
        .toList();
    
    patients.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    return patients;
  }

  @override
  Future<bool> patientExistsByEmail(String centreId, String email) async {
    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // ==================== RENDEZ-VOUS ====================

  @override
  Stream<List<Appointment>> getAppointmentsStream(String centreId) {
    return _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<List<Appointment>> getAppointments(String centreId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDate(String centreId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) =>
            apt.dateHeure.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList();

    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    return appointments;
  }

  @override
  Future<List<Appointment>> getPatientAppointments(String centreId, String patientId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .where('patient_id', isEqualTo: patientId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();

    appointments.sort((a, b) => b.dateHeure.compareTo(a.dateHeure));
    return appointments;
  }

  @override
  Future<List<Appointment>> getPraticienAppointments(String centreId, String praticienId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .where('praticien_id', isEqualTo: praticienId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();

    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    return appointments;
  }

  @override
  Future<Appointment?> getAppointment(String appointmentId) async {
    final doc = await _firestore.collection('appointments').doc(appointmentId).get();
    if (!doc.exists) {
      return null;
    }
    return Appointment.fromFirestore(doc);
  }

  @override
  Future<String> addAppointment(Appointment appointment) async {
    final docRef = await _firestore.collection('appointments').add(
      appointment.toFirestore(),
    );
    return docRef.id;
  }

  @override
  Future<void> updateAppointment(String appointmentId, Appointment appointment) async {
    await _firestore.collection('appointments').doc(appointmentId).update(
      appointment.copyWith(dateModification: DateTime.now()).toFirestore(),
    );
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, String statut) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'statut': statut,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'annulé');
  }

  @override
  Future<void> confirmAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'confirmé');
  }

  @override
  Future<void> completeAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'terminé');
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDateRange(
    String centreId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) =>
            apt.dateHeure.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endDate.add(const Duration(seconds: 1))))
        .toList();

    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    return appointments;
  }

  @override
  Future<bool> isSlotAvailable(
    String centreId,
    String praticienId,
    DateTime dateHeure,
    int duree, {
    String? excludeAppointmentId,
  }) async {
    final heureDebut = dateHeure;
    final heureFin = dateHeure.add(Duration(minutes: duree));

    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .where('praticien_id', isEqualTo: praticienId)
        .get();

    final conflicts = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) {
      if (excludeAppointmentId != null && apt.id == excludeAppointmentId) {
        return false;
      }
      if (apt.statut == 'annulé') {
        return false;
      }
      return apt.dateHeure.isBefore(heureFin) && apt.heureFin.isAfter(heureDebut);
    }).toList();

    return conflicts.isEmpty;
  }

  @override
  Future<Map<String, int>> countByStatus(String centreId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('centre_id', isEqualTo: centreId)
        .get();

    final counts = <String, int>{
      'planifié': 0,
      'confirmé': 0,
      'en_cours': 0,
      'terminé': 0,
      'annulé': 0,
    };

    for (final doc in snapshot.docs) {
      final appointment = Appointment.fromFirestore(doc);
      counts[appointment.statut] = (counts[appointment.statut] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Future<List<Appointment>> getTodayAppointments(String centreId) async {
    final now = DateTime.now();
    return getAppointmentsByDate(centreId, now);
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments(String centreId, {int days = 7}) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    return getAppointmentsByDateRange(centreId, now, endDate);
  }
}
