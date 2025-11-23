import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';

/// Service pour gérer les opérations CRUD des patients dans Firestore
class FirestorePatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'patients';

  /// Récupérer tous les patients d'un centre (Stream)
  Stream<List<Patient>> getPatientsStream(String centreId) {
    return _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .snapshots()
        .map((snapshot) {
      // Filtrer les patients actifs en mémoire et trier par nom
      final patients = snapshot.docs
          .map((doc) => Patient.fromFirestore(doc))
          .where((p) => p.actif)
          .toList();
      
      patients.sort((a, b) => a.nom.compareTo(b.nom));
      return patients;
    });
  }

  /// Récupérer tous les patients d'un centre (Future)
  Future<List<Patient>> getPatients(String centreId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Filtrer les patients actifs en mémoire et trier par nom
    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif)
        .toList();
    
    patients.sort((a, b) => a.nom.compareTo(b.nom));
    return patients;
  }

  /// Récupérer un patient par son ID
  Future<Patient?> getPatient(String patientId) async {
    final doc = await _firestore.collection(_collection).doc(patientId).get();

    if (!doc.exists) {
      return null;
    }

    return Patient.fromFirestore(doc);
  }

  /// Rechercher des patients par nom/prénom
  Future<List<Patient>> searchPatients(String centreId, String query) async {
    final queryLower = query.toLowerCase();

    // Récupérer tous les patients du centre
    final patients = await getPatients(centreId);

    // Filtrer localement (Firestore ne supporte pas LIKE)
    return patients.where((patient) {
      final nomComplet = patient.nomComplet.toLowerCase();
      final nom = patient.nom.toLowerCase();
      final prenom = patient.prenom.toLowerCase();

      return nomComplet.contains(queryLower) ||
          nom.contains(queryLower) ||
          prenom.contains(queryLower);
    }).toList();
  }

  /// Ajouter un nouveau patient
  Future<String> addPatient(Patient patient) async {
    final docRef = await _firestore.collection(_collection).add(
          patient.toFirestore(),
        );

    return docRef.id;
  }

  /// Mettre à jour un patient
  Future<void> updatePatient(String patientId, Patient patient) async {
    await _firestore.collection(_collection).doc(patientId).update(
          patient.copyWith(dateModification: DateTime.now()).toFirestore(),
        );
  }

  /// Désactiver un patient (soft delete)
  Future<void> deactivatePatient(String patientId) async {
    await _firestore.collection(_collection).doc(patientId).update({
      'actif': false,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  /// Réactiver un patient
  Future<void> reactivatePatient(String patientId) async {
    await _firestore.collection(_collection).doc(patientId).update({
      'actif': true,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  /// Supprimer définitivement un patient (à utiliser avec précaution)
  Future<void> deletePatient(String patientId) async {
    await _firestore.collection(_collection).doc(patientId).delete();
  }

  /// Récupérer les patients inactifs
  Future<List<Patient>> getInactivePatients(String centreId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Filtrer les patients inactifs en mémoire et trier par nom
    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => !p.actif)
        .toList();
    
    patients.sort((a, b) => a.nom.compareTo(b.nom));
    return patients;
  }

  /// Compter les patients actifs d'un centre
  Future<int> countActivePatients(String centreId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Compter les patients actifs en mémoire
    return snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif)
        .length;
  }

  /// Récupérer les patients récents (créés dans les X derniers jours)
  Future<List<Patient>> getRecentPatients(
    String centreId, {
    int days = 30,
  }) async {
    final date = DateTime.now().subtract(Duration(days: days));

    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Filtrer et trier en mémoire
    final patients = snapshot.docs
        .map((doc) => Patient.fromFirestore(doc))
        .where((p) => p.actif && p.dateCreation.isAfter(date))
        .toList();
    
    patients.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    return patients;
  }

  /// Vérifier si un patient existe avec cet email dans le centre
  Future<bool> patientExistsByEmail(String centreId, String email) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
