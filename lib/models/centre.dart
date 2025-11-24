import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle représentant un centre de santé (cabinet, clinique, etc.)
/// Chaque centre a ses propres utilisateurs, patients et rendez-vous isolés
class Centre {
  final String id;
  final String nom;
  final String adresse;
  final String? telephone;
  final String? email;
  final String? siteWeb;
  final String? logo; // URL du logo
  final DateTime dateCreation;
  final DateTime? dateModification;
  final bool actif;
  
  // Paramètres du centre
  final int dureeConsultationDefaut; // en minutes
  final String? heureOuverture; // Format: "08:00"
  final String? heureFermeture; // Format: "18:00"
  final List<int>? joursOuverture; // 1=Lundi, 7=Dimanche
  
  // Propriétaire du centre
  final String proprietaireId; // ID de l'utilisateur créateur

  Centre({
    required this.id,
    required this.nom,
    required this.adresse,
    this.telephone,
    this.email,
    this.siteWeb,
    this.logo,
    required this.dateCreation,
    this.dateModification,
    this.actif = true,
    this.dureeConsultationDefaut = 30,
    this.heureOuverture = '08:00',
    this.heureFermeture = '18:00',
    this.joursOuverture = const [1, 2, 3, 4, 5], // Lun-Ven par défaut
    required this.proprietaireId,
  });

  /// Créer un Centre depuis un document Firestore
  factory Centre.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Centre(
      id: doc.id,
      nom: data['nom'] ?? '',
      adresse: data['adresse'] ?? '',
      telephone: data['telephone'],
      email: data['email'],
      siteWeb: data['site_web'],
      logo: data['logo'],
      dateCreation: (data['date_creation'] as Timestamp).toDate(),
      dateModification: data['date_modification'] != null
          ? (data['date_modification'] as Timestamp).toDate()
          : null,
      actif: data['actif'] ?? true,
      dureeConsultationDefaut: data['duree_consultation_defaut'] ?? 30,
      heureOuverture: data['heure_ouverture'] ?? '08:00',
      heureFermeture: data['heure_fermeture'] ?? '18:00',
      joursOuverture: data['jours_ouverture'] != null
          ? List<int>.from(data['jours_ouverture'])
          : [1, 2, 3, 4, 5],
      proprietaireId: data['proprietaire_id'] ?? '',
    );
  }

  /// Créer un Centre depuis un JSON (Flask API)
  factory Centre.fromJson(Map<String, dynamic> json) {
    return Centre(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      adresse: json['adresse'] ?? '',
      telephone: json['telephone'],
      email: json['email'],
      siteWeb: json['site_web'],
      logo: json['logo'],
      dateCreation: json['cree_le'] != null
          ? DateTime.parse(json['cree_le'])
          : DateTime.now(),
      dateModification: json['modifie_le'] != null
          ? DateTime.parse(json['modifie_le'])
          : null,
      actif: json['actif'] ?? true,
      dureeConsultationDefaut: json['duree_consultation_defaut'] ?? 30,
      heureOuverture: json['horaires_debut'] ?? '08:00',
      heureFermeture: json['horaires_fin'] ?? '18:00',
      joursOuverture: json['jours_travail'] != null
          ? (json['jours_travail'] as String).split(',').map((j) {
              final Map<String, int> jours = {
                'lundi': 1,
                'mardi': 2,
                'mercredi': 3,
                'jeudi': 4,
                'vendredi': 5,
                'samedi': 6,
                'dimanche': 7,
              };
              return jours[j.trim().toLowerCase()] ?? 1;
            }).toList()
          : [1, 2, 3, 4, 5],
      proprietaireId: json['proprietaire_id'] ?? '',
    );
  }

  /// Convertir le Centre en JSON (Flask API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'site_web': siteWeb,
      'logo': logo,
      'cree_le': dateCreation.toIso8601String(),
      'modifie_le': dateModification?.toIso8601String(),
      'actif': actif,
      'duree_consultation_defaut': dureeConsultationDefaut,
      'horaires_debut': heureOuverture,
      'horaires_fin': heureFermeture,
      'jours_travail': joursOuverture?.map((j) {
        final Map<int, String> jours = {
          1: 'lundi',
          2: 'mardi',
          3: 'mercredi',
          4: 'jeudi',
          5: 'vendredi',
          6: 'samedi',
          7: 'dimanche',
        };
        return jours[j] ?? 'lundi';
      }).join(','),
      'proprietaire_id': proprietaireId,
    };
  }

  /// Convertir le Centre en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'site_web': siteWeb,
      'logo': logo,
      'date_creation': Timestamp.fromDate(dateCreation),
      'date_modification': dateModification != null
          ? Timestamp.fromDate(dateModification!)
          : null,
      'actif': actif,
      'duree_consultation_defaut': dureeConsultationDefaut,
      'heure_ouverture': heureOuverture,
      'heure_fermeture': heureFermeture,
      'jours_ouverture': joursOuverture,
      'proprietaire_id': proprietaireId,
    };
  }

  /// Copier le Centre avec modifications
  Centre copyWith({
    String? id,
    String? nom,
    String? adresse,
    String? telephone,
    String? email,
    String? siteWeb,
    String? logo,
    DateTime? dateCreation,
    DateTime? dateModification,
    bool? actif,
    int? dureeConsultationDefaut,
    String? heureOuverture,
    String? heureFermeture,
    List<int>? joursOuverture,
    String? proprietaireId,
  }) {
    return Centre(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      siteWeb: siteWeb ?? this.siteWeb,
      logo: logo ?? this.logo,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      actif: actif ?? this.actif,
      dureeConsultationDefaut:
          dureeConsultationDefaut ?? this.dureeConsultationDefaut,
      heureOuverture: heureOuverture ?? this.heureOuverture,
      heureFermeture: heureFermeture ?? this.heureFermeture,
      joursOuverture: joursOuverture ?? this.joursOuverture,
      proprietaireId: proprietaireId ?? this.proprietaireId,
    );
  }
}
