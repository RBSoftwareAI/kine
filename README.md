# 🏥 MediDesk - Logiciel de Gestion de Cabinet Médical

**Solution locale-first pour kinésithérapeutes et ostéopathes**

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-Proprietary-red)

---

## 🎯 Vision

Révolutionner la gestion des cabinets médicaux avec une solution **locale-first**, respectueuse de la vie privée et économiquement accessible.

### Positionnement : "Le Linux du logiciel médical"
- 🏠 **Local-first** : Vos données restent CHEZ VOUS
- 💰 **0€/mois** : Installation locale sans coûts cloud
- 🔒 **Privacy by Design** : Conformité RGPD intégrée
- 🌐 **Open & Interoperable** : Compatible Doctolib, Maiia (roadmap)

---

## ✨ Fonctionnalités

### ✅ Disponibles maintenant

**Authentification sécurisée**
- Connexion/déconnexion avec Firebase Auth
- Gestion multi-praticiens
- Isolation par centre (multi-tenant)

**Gestion des patients**
- Dossiers patients complets
- Recherche et filtres avancés
- Historique des consultations
- Notes médicales confidentielles

**Système de réservation**
- Calendrier mensuel interactif
- Prise de RDV intuitive
- Gestion des statuts (Planifié, Confirmé, En cours, Terminé, Annulé)
- Modification et annulation de RDV

**Dashboard intelligent**
- Statistiques en temps réel
- Patients actifs
- RDV du jour et de la semaine
- Actions rapides

### 🔜 Roadmap

**Q1 2025**
- 🔧 Backend Flask local (installation PC)
- 🔐 Chiffrement SQLite des données sensibles
- 📊 Logs d'audit RGPD
- 📄 Dossiers médicaux (consultations, prescriptions)
- 💰 Facturation et comptabilité

**Q2 2025**
- 🤖 IA médicale (aide au diagnostic)
- 📱 Application mobile Android/iOS
- 🔗 Interopérabilité Doctolib/Maiia
- 💬 Téléconsultation sécurisée P2P

---

## 🏗️ Architecture

### Mode hybride : DEMO + LOCAL

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│   MODE DEMO                 │     │   MODE LOCAL                │
│   (demo.medidesk.fr)        │     │   (Cabinet)                 │
├─────────────────────────────┤     ├─────────────────────────────┤
│ Backend: Firebase           │     │ Backend: Flask + SQLite     │
│ Données: Fictives           │     │ Données: Réelles chiffrées  │
│ Usage: Formation, démo      │     │ Usage: Production           │
│ Coût: 0€ (free tier)        │     │ Coût: 0€ (local)            │
└─────────────────────────────┘     └─────────────────────────────┘
              ↓                                   ↓
        ┌─────────────────────────────────────────────┐
        │     Frontend Flutter unique                 │
        │     (Web + Android + iOS)                   │
        └─────────────────────────────────────────────┘
```

### Stack technique

**Frontend**
- Flutter 3.35.4 + Dart 3.9.2
- Material Design 3
- Provider (state management)
- Localisation française complète

**Backend MODE DEMO**
- Firebase Auth
- Firestore (NoSQL)
- Cloud Storage

**Backend MODE LOCAL** (en développement)
- Flask 3.0.0 (API REST)
- SQLite chiffré (SQLCipher)
- JWT authentication
- Logs d'audit RGPD

---

## 🚀 Démarrage rapide

### Prérequis
- Flutter 3.35.4 (LOCKED)
- Dart 3.9.2 (LOCKED)
- Python 3.10+ (pour backend local)

### Installation

```bash
# Cloner le repository
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# Installer dépendances Flutter
flutter pub get

# Lancer en mode développement (Firebase demo)
flutter run -d web-server --web-port=5060

# Ou build pour production
flutter build web --release
cd build/web && python3 -m http.server 5060
```

### Comptes de test (Firebase demo)

| Email | Mot de passe | Centre | Rôle |
|-------|--------------|--------|------|
| `marie.lefebvre@kine-paris.fr` | `password123` | Kiné Paris Centre | Kinésithérapeute |
| `pierre.girard@osteo-lyon.fr` | `password123` | Ostéo Lyon | Ostéopathe |

**Données test** : 20 patients + 15 RDV par centre

---

## 📊 Conformité juridique

### ⚠️ Données de santé - Obligations légales

MediDesk traite des **données de santé**. Les obligations légales s'appliquent **dès le premier utilisateur**.

### ✅ Conformité intégrée

**Chiffrement**
- Données au repos (SQLite chiffré)
- Données en transit (HTTPS/TLS)
- Mots de passe hashés (bcrypt)

**Traçabilité**
- Logs d'audit RGPD
- Conservation 3 ans minimum
- Export pour contrôle CNIL

**Droits patients**
- Consentement explicite
- Droit d'accès, rectification, suppression
- Portabilité des données

### Modèle juridique

```
┌─────────────────────────────────────────────────┐
│  Praticien = Responsable de traitement         │
│  MediDesk = Fournisseur d'outil conforme       │
│                                                  │
│  ✅ Praticien gère ses données localement       │
│  ✅ MediDesk ne stocke ni n'héberge             │
│  ✅ Documentation juridique fournie             │
└─────────────────────────────────────────────────┘
```

**Documentation juridique** (roadmap) :
- Guide praticien (responsabilités RGPD)
- Modèle consentement patient
- Registre des traitements pré-rempli
- CGU/CGV

---

## 🔧 Développement

### Structure du projet

```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données
├── services/                    # Services backend (Firebase/Flask)
├── providers/                   # State management (Provider)
└── screens/                     # UI (Auth, Dashboard, Patients, RDV)

medidesk_backend/                # Backend Flask (en développement)
├── app/
│   ├── models.py                # SQLAlchemy models
│   ├── routes/                  # API REST endpoints
│   └── utils/                   # Chiffrement, audit logs
└── requirements.txt
```

### Commandes utiles

```bash
# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Build production
flutter build web --release
flutter build apk --release  # Android

# Backend Flask (quand prêt)
cd medidesk_backend
pip install -r requirements.txt
flask run --port=5000
```

### Documentation IA

Pour développement assisté par IA :
1. Lire `AI_QUICK_START.md` (guide express)
2. Consulter `CONTEXT.md` (documentation complète)
3. Utiliser `NEXT_SESSION_PROMPT.md` pour nouvelles sessions

---

## 🤝 Contribution

**Projet propriétaire** - Contributions sur invitation uniquement.

Pour suggérer des fonctionnalités ou reporter des bugs :
- Ouvrir une issue sur GitHub
- Contacter l'équipe MediDesk

---

## 📄 License

**Propriétaire** - Tous droits réservés © 2024 MediDesk

---

## 📞 Contact

- **GitHub** : https://github.com/RBSoftwareAI/kine
- **Email** : [À définir]
- **Site web** : [En développement]

---

## 🎯 Différenciation vs Concurrence

| Critère | Doctolib | Maiia | **MediDesk** |
|---------|----------|-------|--------------|
| Données locales | ❌ | ❌ | ✅ |
| Coût démarrage | Élevé | Moyen | **0€** |
| Dossier complet | ✅ | Limité | ✅ |
| IA médicale | ❌ | ❌ | 🔜 |
| Interopérabilité | Fermé | Fermé | ✅ Ouvert |
| Propriété données | Plateforme | Plateforme | **Praticien** |
| HDS obligatoire | ✅ | ✅ | ✅ Option |

---

## 🏆 Objectifs

**Mission** : Redonner aux praticiens le contrôle de leurs outils et de leurs données.

**Vision 2025** :
- 100 cabinets pilotes (Q1)
- Backend local stable (Q2)
- IA médicale intégrée (Q3)
- Interopérabilité complète (Q4)

**Slogan** : *"Vos données médicales restent CHEZ VOUS. Nous ne les hébergeons jamais."*

---

**Dernière mise à jour** : Décembre 2024  
**Version** : 1.0.0 (MVP Flutter Firebase)  
**Statut** : Production-ready (demo) / Backend local en développement
