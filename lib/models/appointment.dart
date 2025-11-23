import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle représentant un rendez-vous
/// Chaque RDV appartient à un centre et peut être lié à un patient
class Appointment {
  final String id;
  final String centreId; // Centre du rendez-vous
  final String praticienId; // ID de l'utilisateur (praticien)
  final String? patientId; // ID du patient (null si RDV externe/public)
  final DateTime dateHeure; // Date et heure du rendez-vous
  final int duree; // Durée en minutes
  final String type; // 'consultation', 'suivi', 'urgence', etc.
  final String? motif; // Motif de consultation
  final String statut; // 'planifié', 'confirmé', 'en_cours', 'terminé', 'annulé'
  final String? notes; // Notes du praticien
  final DateTime dateCreation;
  final DateTime? dateModification;
  
  // Informations patient (pour RDV publics sans compte)
  final String? patientNom;
  final String? patientPrenom;
  final String? patientTelephone;
  final String? patientEmail;

  Appointment({
    required this.id,
    required this.centreId,
    required this.praticienId,
    this.patientId,
    required this.dateHeure,
    required this.duree,
    required this.type,
    this.motif,
    this.statut = 'planifié',
    this.notes,
    required this.dateCreation,
    this.dateModification,
    this.patientNom,
    this.patientPrenom,
    this.patientTelephone,
    this.patientEmail,
  });

  /// Heure de fin calculée
  DateTime get heureFin => dateHeure.add(Duration(minutes: duree));

  /// Le rendez-vous est-il dans le passé ?
  bool get estPasse => dateHeure.isBefore(DateTime.now());

  /// Le rendez-vous est-il aujourd'hui ?
  bool get estAujourdhui {
    final now = DateTime.now();
    return dateHeure.year == now.year &&
        dateHeure.month == now.month &&
        dateHeure.day == now.day;
  }

  /// Créer un Appointment depuis un document Firestore
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      centreId: data['centre_id'] ?? '',
      praticienId: data['praticien_id'] ?? '',
      patientId: data['patient_id'],
      dateHeure: (data['date_heure'] as Timestamp).toDate(),
      duree: data['duree'] ?? 30,
      type: data['type'] ?? 'consultation',
      motif: data['motif'],
      statut: data['statut'] ?? 'planifié',
      notes: data['notes'],
      dateCreation: (data['date_creation'] as Timestamp).toDate(),
      dateModification: data['date_modification'] != null
          ? (data['date_modification'] as Timestamp).toDate()
          : null,
      patientNom: data['patient_nom'],
      patientPrenom: data['patient_prenom'],
      patientTelephone: data['patient_telephone'],
      patientEmail: data['patient_email'],
    );
  }

  /// Convertir l'Appointment en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'centre_id': centreId,
      'praticien_id': praticienId,
      'patient_id': patientId,
      'date_heure': Timestamp.fromDate(dateHeure),
      'duree': duree,
      'type': type,
      'motif': motif,
      'statut': statut,
      'notes': notes,
      'date_creation': Timestamp.fromDate(dateCreation),
      'date_modification': dateModification != null
          ? Timestamp.fromDate(dateModification!)
          : null,
      'patient_nom': patientNom,
      'patient_prenom': patientPrenom,
      'patient_telephone': patientTelephone,
      'patient_email': patientEmail,
    };
  }

  /// Copier l'Appointment avec modifications
  Appointment copyWith({
    String? id,
    String? centreId,
    String? praticienId,
    String? patientId,
    DateTime? dateHeure,
    int? duree,
    String? type,
    String? motif,
    String? statut,
    String? notes,
    DateTime? dateCreation,
    DateTime? dateModification,
    String? patientNom,
    String? patientPrenom,
    String? patientTelephone,
    String? patientEmail,
  }) {
    return Appointment(
      id: id ?? this.id,
      centreId: centreId ?? this.centreId,
      praticienId: praticienId ?? this.praticienId,
      patientId: patientId ?? this.patientId,
      dateHeure: dateHeure ?? this.dateHeure,
      duree: duree ?? this.duree,
      type: type ?? this.type,
      motif: motif ?? this.motif,
      statut: statut ?? this.statut,
      notes: notes ?? this.notes,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      patientNom: patientNom ?? this.patientNom,
      patientPrenom: patientPrenom ?? this.patientPrenom,
      patientTelephone: patientTelephone ?? this.patientTelephone,
      patientEmail: patientEmail ?? this.patientEmail,
    );
  }
}
