import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle représentant un patient dans le système
class Patient {
  final String id;
  final String centreId;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String? telephone;
  final String? email;
  final String? adresse;
  final String? codePostal;
  final String? ville;
  final String? profession;
  final String? numeroSecuriteSociale;
  final String? medecinTraitant;
  final String? notes;
  final bool actif;
  final DateTime dateCreation;
  final DateTime? dateModification;

  Patient({
    required this.id,
    required this.centreId,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    this.telephone,
    this.email,
    this.adresse,
    this.codePostal,
    this.ville,
    this.profession,
    this.numeroSecuriteSociale,
    this.medecinTraitant,
    this.notes,
    this.actif = true,
    required this.dateCreation,
    this.dateModification,
  });

  /// Nom complet du patient
  String get nomComplet => '$prenom $nom';

  /// Âge calculé à partir de la date de naissance
  int get age {
    final now = DateTime.now();
    int age = now.year - dateNaissance.year;
    if (now.month < dateNaissance.month ||
        (now.month == dateNaissance.month && now.day < dateNaissance.day)) {
      age--;
    }
    return age;
  }

  /// Initiales du patient
  String get initiales {
    final p = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';
    final n = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    return '$p$n';
  }

  /// Adresse complète formatée
  String? get adresseComplete {
    if (adresse == null) return null;
    final parts = <String>[];
    parts.add(adresse!);
    if (codePostal != null && ville != null) {
      parts.add('$codePostal $ville');
    } else if (ville != null) {
      parts.add(ville!);
    }
    return parts.join(', ');
  }

  /// Créer un Patient depuis un document Firestore
  factory Patient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Patient(
      id: doc.id,
      centreId: data['centre_id'] ?? '',
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      dateNaissance: (data['date_naissance'] as Timestamp).toDate(),
      telephone: data['telephone'],
      email: data['email'],
      adresse: data['adresse'],
      codePostal: data['code_postal'],
      ville: data['ville'],
      profession: data['profession'],
      numeroSecuriteSociale: data['numero_securite_sociale'],
      medecinTraitant: data['medecin_traitant'],
      notes: data['notes'],
      actif: data['actif'] ?? true,
      dateCreation: (data['date_creation'] as Timestamp).toDate(),
      dateModification: data['date_modification'] != null
          ? (data['date_modification'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'centre_id': centreId,
      'nom': nom,
      'prenom': prenom,
      'date_naissance': Timestamp.fromDate(dateNaissance),
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'code_postal': codePostal,
      'ville': ville,
      'profession': profession,
      'numero_securite_sociale': numeroSecuriteSociale,
      'medecin_traitant': medecinTraitant,
      'notes': notes,
      'actif': actif,
      'date_creation': Timestamp.fromDate(dateCreation),
      'date_modification': dateModification != null
          ? Timestamp.fromDate(dateModification!)
          : null,
    };
  }

  /// Créer une copie modifiée du patient
  Patient copyWith({
    String? id,
    String? centreId,
    String? nom,
    String? prenom,
    DateTime? dateNaissance,
    String? telephone,
    String? email,
    String? adresse,
    String? codePostal,
    String? ville,
    String? profession,
    String? numeroSecuriteSociale,
    String? medecinTraitant,
    String? notes,
    bool? actif,
    DateTime? dateCreation,
    DateTime? dateModification,
  }) {
    return Patient(
      id: id ?? this.id,
      centreId: centreId ?? this.centreId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      adresse: adresse ?? this.adresse,
      codePostal: codePostal ?? this.codePostal,
      ville: ville ?? this.ville,
      profession: profession ?? this.profession,
      numeroSecuriteSociale: numeroSecuriteSociale ?? this.numeroSecuriteSociale,
      medecinTraitant: medecinTraitant ?? this.medecinTraitant,
      notes: notes ?? this.notes,
      actif: actif ?? this.actif,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  String toString() {
    return 'Patient(id: $id, nomComplet: $nomComplet, centreId: $centreId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Patient && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
