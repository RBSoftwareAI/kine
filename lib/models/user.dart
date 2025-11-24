import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle représentant un utilisateur (professionnel de santé)
/// Chaque utilisateur appartient à un centre spécifique
class User {
  final String id; // Firebase Auth UID
  final String centreId; // Centre auquel appartient l'utilisateur
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String? photo; // URL photo de profil
  final String role; // 'admin', 'praticien', 'assistant'
  final String? specialite; // 'kinésithérapeute', 'ostéopathe', etc.
  final String? numeroOrdre; // Numéro d'inscription à l'ordre
  final DateTime dateCreation;
  final DateTime? dateModification;
  final DateTime? derniereConnexion;
  final bool actif;

  User({
    required this.id,
    required this.centreId,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.photo,
    this.role = 'praticien',
    this.specialite,
    this.numeroOrdre,
    required this.dateCreation,
    this.dateModification,
    this.derniereConnexion,
    this.actif = true,
  });

  /// Nom complet de l'utilisateur
  String get nomComplet => '$prenom $nom';
  
  // Alias pour compatibilité avec d'autres écrans
  String get fullName => '$prenom $nom';
  String get firstName => prenom;
  String get lastName => nom;
  String get displayName => '$prenom $nom';
  
  // Getters de rôle pour compatibilité
  bool get isAdmin => role == 'admin';
  bool get isSadmin => role == 'sadmin';
  bool get isPatient => role == 'patient';
  bool get isProfessional => role == 'praticien' || role == 'kine' || role == 'coach';

  /// Créer un User depuis un document Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      centreId: data['centre_id'] ?? '',
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'],
      photo: data['photo'],
      role: data['role'] ?? 'praticien',
      specialite: data['specialite'],
      numeroOrdre: data['numero_ordre'],
      dateCreation: (data['date_creation'] as Timestamp).toDate(),
      dateModification: data['date_modification'] != null
          ? (data['date_modification'] as Timestamp).toDate()
          : null,
      derniereConnexion: data['derniere_connexion'] != null
          ? (data['derniere_connexion'] as Timestamp).toDate()
          : null,
      actif: data['actif'] ?? true,
    );
  }

  /// Convertir le User en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'centre_id': centreId,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'photo': photo,
      'role': role,
      'specialite': specialite,
      'numero_ordre': numeroOrdre,
      'date_creation': Timestamp.fromDate(dateCreation),
      'date_modification': dateModification != null
          ? Timestamp.fromDate(dateModification!)
          : null,
      'derniere_connexion': derniereConnexion != null
          ? Timestamp.fromDate(derniereConnexion!)
          : null,
      'actif': actif,
    };
  }

  /// Créer un User depuis un JSON (Flask API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      centreId: json['centre_id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      photo: json['photo'],
      role: json['role'] ?? 'praticien',
      specialite: json['specialite'],
      numeroOrdre: json['numero_ordre'],
      dateCreation: json['cree_le'] != null 
          ? DateTime.parse(json['cree_le'])
          : DateTime.now(),
      dateModification: json['modifie_le'] != null
          ? DateTime.parse(json['modifie_le'])
          : null,
      derniereConnexion: json['derniere_connexion'] != null
          ? DateTime.parse(json['derniere_connexion'])
          : null,
      actif: json['actif'] ?? true,
    );
  }

  /// Convertir le User en JSON (Flask API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'centre_id': centreId,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'photo': photo,
      'role': role,
      'specialite': specialite,
      'numero_ordre': numeroOrdre,
      'cree_le': dateCreation.toIso8601String(),
      'modifie_le': dateModification?.toIso8601String(),
      'derniere_connexion': derniereConnexion?.toIso8601String(),
      'actif': actif,
    };
  }

  /// Copier le User avec modifications
  User copyWith({
    String? id,
    String? centreId,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? photo,
    String? role,
    String? specialite,
    String? numeroOrdre,
    DateTime? dateCreation,
    DateTime? dateModification,
    DateTime? derniereConnexion,
    bool? actif,
  }) {
    return User(
      id: id ?? this.id,
      centreId: centreId ?? this.centreId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      specialite: specialite ?? this.specialite,
      numeroOrdre: numeroOrdre ?? this.numeroOrdre,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      derniereConnexion: derniereConnexion ?? this.derniereConnexion,
      actif: actif ?? this.actif,
    );
  }
}
