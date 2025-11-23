import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

/// Service pour gérer les opérations CRUD des rendez-vous dans Firestore
class FirestoreAppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  /// Récupérer tous les rendez-vous d'un centre (Stream)
  Stream<List<Appointment>> getAppointmentsStream(String centreId) {
    return _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
    });
  }

  /// Récupérer tous les rendez-vous d'un centre (Future)
  Future<List<Appointment>> getAppointments(String centreId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();
  }

  /// Récupérer les rendez-vous d'une date spécifique
  Future<List<Appointment>> getAppointmentsByDate(
    String centreId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Filtrer par date en mémoire pour éviter index composite
    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) =>
            apt.dateHeure.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList();

    // Trier par heure
    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));

    return appointments;
  }

  /// Récupérer les rendez-vous d'un patient
  Future<List<Appointment>> getPatientAppointments(
    String centreId,
    String patientId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .where('patient_id', isEqualTo: patientId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();

    // Trier par date décroissante (plus récent en premier)
    appointments.sort((a, b) => b.dateHeure.compareTo(a.dateHeure));

    return appointments;
  }

  /// Récupérer les rendez-vous d'un praticien
  Future<List<Appointment>> getPraticienAppointments(
    String centreId,
    String praticienId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .where('praticien_id', isEqualTo: praticienId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList();

    // Trier par date
    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));

    return appointments;
  }

  /// Récupérer un rendez-vous par son ID
  Future<Appointment?> getAppointment(String appointmentId) async {
    final doc =
        await _firestore.collection(_collection).doc(appointmentId).get();

    if (!doc.exists) {
      return null;
    }

    return Appointment.fromFirestore(doc);
  }

  /// Ajouter un nouveau rendez-vous
  Future<String> addAppointment(Appointment appointment) async {
    final docRef = await _firestore.collection(_collection).add(
          appointment.toFirestore(),
        );

    return docRef.id;
  }

  /// Mettre à jour un rendez-vous
  Future<void> updateAppointment(
    String appointmentId,
    Appointment appointment,
  ) async {
    await _firestore.collection(_collection).doc(appointmentId).update(
          appointment
              .copyWith(dateModification: DateTime.now())
              .toFirestore(),
        );
  }

  /// Changer le statut d'un rendez-vous
  Future<void> updateAppointmentStatus(
    String appointmentId,
    String statut,
  ) async {
    await _firestore.collection(_collection).doc(appointmentId).update({
      'statut': statut,
      'date_modification': FieldValue.serverTimestamp(),
    });
  }

  /// Annuler un rendez-vous
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'annulé');
  }

  /// Confirmer un rendez-vous
  Future<void> confirmAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'confirmé');
  }

  /// Marquer un rendez-vous comme terminé
  Future<void> completeAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'terminé');
  }

  /// Supprimer définitivement un rendez-vous (à utiliser avec précaution)
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection(_collection).doc(appointmentId).delete();
  }

  /// Récupérer les rendez-vous d'une plage de dates
  Future<List<Appointment>> getAppointmentsByDateRange(
    String centreId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .get();

    // Filtrer par plage de dates en mémoire
    final appointments = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) =>
            apt.dateHeure.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endDate.add(const Duration(seconds: 1))))
        .toList();

    // Trier par date
    appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));

    return appointments;
  }

  /// Vérifier la disponibilité d'un créneau
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
        .collection(_collection)
        .where('centre_id', isEqualTo: centreId)
        .where('praticien_id', isEqualTo: praticienId)
        .get();

    // Vérifier les conflits en mémoire
    final conflicts = snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .where((apt) {
      // Exclure le RDV en cours de modification
      if (excludeAppointmentId != null && apt.id == excludeAppointmentId) {
        return false;
      }

      // Ignorer les RDV annulés
      if (apt.statut == 'annulé') {
        return false;
      }

      // Vérifier le chevauchement
      return apt.dateHeure.isBefore(heureFin) && apt.heureFin.isAfter(heureDebut);
    }).toList();

    return conflicts.isEmpty;
  }

  /// Compter les rendez-vous par statut
  Future<Map<String, int>> countByStatus(String centreId) async {
    final snapshot = await _firestore
        .collection(_collection)
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

  /// Récupérer les rendez-vous du jour
  Future<List<Appointment>> getTodayAppointments(String centreId) async {
    final now = DateTime.now();
    return getAppointmentsByDate(centreId, now);
  }

  /// Récupérer les prochains rendez-vous (X jours)
  Future<List<Appointment>> getUpcomingAppointments(
    String centreId, {
    int days = 7,
  }) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return getAppointmentsByDateRange(centreId, now, endDate);
  }
}
