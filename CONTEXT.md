# 📚 CONTEXT - Documentation Complète MediDesk

**Documentation technique détaillée - 24 Novembre 2025**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#vue-densemble)
2. [Comptes de test](#comptes-de-test)
3. [Architecture technique](#architecture-technique)
4. [Configuration Firebase](#configuration-firebase)
5. [Thème et design](#thème-et-design)
6. [Problèmes résolus](#problèmes-résolus)
7. [Roadmap](#roadmap)
8. [Commandes utiles](#commandes-utiles)

---

## 🎯 VUE D'ENSEMBLE

### Informations Projet

- **Nom** : MediDesk
- **Type** : Application Flutter de gestion médicale
- **Cible** : Tous professionnels de santé (kinés, ostéopathes, médecins, infirmiers, coachs sportifs, etc.)
- **Modèle économique** : Gratuit & Open Source (installation locale) + Upsells payants (gestion RDV, cloud sync, exports avancés)
- **Version actuelle** : v1.3 (26 Novembre 2025)
- **URL Production** : https://demo.medidesk.fr
- **Repository GitHub** : https://github.com/RBSoftwareAI/kine
- **Branche principale** : `base` et `main` (synchronisées)

### Technologies & Versions

**⚠️ VERSIONS VERROUILLÉES - NE PAS METTRE À JOUR**

| Technologie | Version | Raison |
|-------------|---------|--------|
| Flutter | 3.35.4 | Stabilité environnement sandbox |
| Dart | 3.9.2 | Compatibilité Flutter |
| Firebase Core | 3.6.0 | Testé et compatible |
| Firestore | 5.4.3 | Testé et compatible |
| FL Chart | 0.69.2 | Graphiques optimisés |
| Provider | 6.1.5+1 | State management |
| Hive | 2.2.3 | Base locale |

---

## 🔐 COMPTES DE TEST

### ⚠️ IMPORTANT : Source des Comptes

**Les comptes de test sont affichés sur la page de connexion de demo.medidesk.fr**

Pour vérifier les comptes réels :
1. Aller sur https://demo.medidesk.fr
2. Observer la liste "Comptes de test disponibles"
3. Utiliser ces comptes exactement comme affichés

### Comptes Actuels (24 Nov 2025)

**Tous utilisent le mot de passe : `password123`**

| Nom | Rôle | Email | Couleur Card |
|-----|------|-------|--------------|
| **Patient Test** | Patient | `test.patient@medidesk.fr` | Bleu |
| **Marie Lefèvre** | Réceptionniste | `marie.lefevre@medidesk.fr` | Vert |
| **Pierre Durand** | Kiné/Praticien | `pierre.durand@medidesk.fr` | Cyan |
| **Jean Martin** | Comptable/Admin | `jean@medadesk.fr` | Orange |
| **Admin Système** | Super Admin | `admin.2wat@wp.fr` | Rose |
| **Sophie Dupont** | Secrétaire | `so.phie@medadesk.fr` | Violet |

### Permissions par Rôle

| Rôle | Accès Patient | Accès Kine | Accès Admin | Cartographie | Évolution |
|------|---------------|------------|-------------|--------------|-----------|
| Patient | Mes données uniquement | ❌ | ❌ | ✅ Mes douleurs | ✅ Mes stats |
| Kinésithérapeute | ✅ Tous patients | ✅ | ❌ | ✅ Toutes | ✅ Toutes |
| Secrétaire | ✅ Liste patients | ❌ | ❌ | ❌ | ❌ |
| Réceptionniste | ✅ Accueil | ❌ | ❌ | ❌ | ❌ |
| Comptable | ✅ Gestion | ❌ | ⚠️ Limité | ❌ | ❌ |
| Administrateur | ✅ Complet | ✅ Complet | ✅ Complet | ✅ Complet | ✅ Complet |

---

## 🏗️ ARCHITECTURE TECHNIQUE

### Structure du Code

```
lib/
├── main.dart                          # Point d'entrée + Firebase init
├── firebase_options.dart              # Config Firebase multi-plateforme
│
├── models/                            # Modèles de données
│   ├── user_model.dart               # Utilisateur (Patient/Kine/etc.)
│   ├── pain_mapping_model.dart       # Cartographie des douleurs
│   ├── pain_history.dart             # Historique et évolution
│   ├── appointment_model.dart        # Rendez-vous
│   └── permission_model.dart         # Permissions par rôle
│
├── providers/                         # State Management (Provider)
│   ├── auth_provider.dart            # Authentification
│   ├── patient_provider.dart         # Gestion patients
│   └── appointment_provider.dart     # Gestion rendez-vous
│
├── services/                          # Services Métier
│   ├── firebase_data_service.dart    # CRUD Firebase
│   ├── permission_service.dart       # Gestion permissions
│   ├── evolution_service.dart        # Calculs évolution
│   └── data_service.dart             # Interface générique
│
├── views/                             # Écrans UI
│   ├── auth/
│   │   └── login_screen.dart         # Écran connexion
│   ├── evolution/
│   │   ├── evolution_screen.dart     # Graphiques évolution
│   │   └── widgets/                  # Composants graphiques
│   │       ├── intensity_chart.dart  # Graphique temporel
│   │       ├── trend_indicator.dart  # Indicateur tendance
│   │       ├── top_zones_widget.dart # Zones les plus touchées
│   │       └── session_comparison_card.dart # Comparaison séances
│   ├── patient/
│   │   ├── patient_dashboard.dart    # Dashboard patient
│   │   └── pain_tracking_screen.dart # Cartographie douleurs
│   └── settings/
│       └── app_mode_settings_screen.dart
│
└── utils/
    └── app_theme.dart                 # Thème Material Design 3
```

### Flux de Données

```
┌─────────────┐
│   Firebase  │
│  Firestore  │
└──────┬──────┘
       │
       │ CRUD Operations
       │
┌──────▼──────────────────┐
│ FirebaseDataService     │
│ - getUsers()            │
│ - getPainMappings()     │
│ - getEvolutionData()    │
└──────┬──────────────────┘
       │
       │ Business Logic
       │
┌──────▼──────────────────┐
│ Providers               │
│ - AuthProvider          │
│ - PatientProvider       │
│ - AppointmentProvider   │
└──────┬──────────────────┘
       │
       │ State Updates
       │
┌──────▼──────────────────┐
│ UI Widgets              │
│ - Screens               │
│ - Components            │
└─────────────────────────┘
```

---

## 🔥 CONFIGURATION FIREBASE

### Projet Firebase

- **Project ID** : `kinecare-81f52`
- **Region** : `europe-west1` (Europe)
- **Hosting URL** : https://kinecare-81f52.web.app
- **Custom Domain** : https://demo.medidesk.fr (configuré avec DNS)

### Fichiers de Configuration

| Fichier | Emplacement | Usage |
|---------|-------------|-------|
| `firebase-admin-sdk.json` | `/opt/flutter/` | Backend Python (création données) |
| `google-services.json` | `/opt/flutter/` | Android Firebase config |
| `firebase_options.dart` | `lib/` | Config multi-plateforme (Web+Android) |
| `firestore.rules` | Racine projet | Règles de sécurité Firestore |
| `firebase.json` | Racine projet | Config déploiement Hosting |

### Collections Firestore

| Collection | Données | Indexation |
|-----------|---------|------------|
| `users` | Utilisateurs (Patient/Kine/etc.) | email, role |
| `pain_mappings` | Cartographies des douleurs | user_id, date |
| `pain_history` | Historique évolution | user_id, zone, date |
| `appointments` | Rendez-vous | patient_id, practitioner_id, date |
| `centers` | Centres de soin | name, address |

### Règles de Sécurité Actuelles

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Lecture : Tous les utilisateurs authentifiés
    match /{document=**} {
      allow read: if request.auth != null;
    }
    
    // Écriture : Selon le rôle
    match /pain_mappings/{mapping} {
      allow write: if request.auth != null 
                   && (get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'patient'
                       || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'kine');
    }
  }
}
```

---

## 🎨 THÈME ET DESIGN

### Palette de Couleurs

**⚠️ CRITIQUE : Thème 100% Blanc Cohérent**

| Élément | Couleur | Hex Code |
|---------|---------|----------|
| Couleur principale | Orange | `#FF6B35` |
| Couleur secondaire | Bleu | `#2196F3` |
| Arrière-plan | Blanc | `#FFFFFF` |
| Cartes | Blanc | `#FFFFFF` |
| Bordures | Gris clair | `#E0E0E0` |
| Texte principal | Noir | `#000000` |
| Texte secondaire | Gris foncé | `#757575` |
| Succès | Vert | `#4CAF50` |
| Erreur | Rouge | `#F44336` |

### Widgets d'Évolution

**Dernières corrections (24 Nov 2025)** :

| Widget | Fond | Texte | Status |
|--------|------|-------|---------|
| Sélecteur période | Blanc | Noir | ✅ Corrigé |
| Cartes stats | Blanc | Couleur métrique | ✅ Corrigé |
| Graphique intensité | Blanc | Noir | ✅ Corrigé |
| Zones touchées | Blanc | Noir | ✅ Corrigé |
| Séances traitement | Blanc | Noir | ✅ Corrigé |
| Indicateur tendance | Dégradé | Gris 800 | ✅ Corrigé |

### Règles de Design

1. **Aucun fond noir** dans l'application
2. **Tous les conteneurs** : `Colors.white` ou `Colors.grey[50]`
3. **Tous les textes** : `Colors.black` ou `Colors.grey[600-800]`
4. **Bordures** : Couleur primaire avec alpha 0.3
5. **Ombres** : Subtiles (`Colors.grey.withValues(alpha: 0.1)`)

---

## 🐛 PROBLÈMES RÉSOLUS

### Historique des Corrections Majeures

#### 1. Écran de Chargement Infini (23 Nov 2025)

**Problème** : Application bloquée sur "fond violet" au démarrage

**Cause** : `AuthProvider` n'initialisait pas le stream Firebase Auth

**Solution** :
```dart
Future<void> _initializeAuthState() async {
  await Future.delayed(Duration(milliseconds: 500));
  _authStateSubscription = _auth.authStateChanges().listen((User? user) {
    // ...
  });
}
```

**Commit** : `ab391c8`

#### 2. Thème Incohérent - Fonds Noirs (24 Nov 2025)

**Problème** : Zones noires dans l'écran "Courbes d'évolution"

**Cause** : Utilisation de `Colors.black87` et `Colors.black` pour les fonds

**Solution** : Remplacement systématique par `Colors.white`

**Fichiers corrigés** :
- `evolution_screen.dart` : 3 conteneurs
- `top_zones_widget.dart` : 2 conteneurs
- `session_comparison_card.dart` : 1 conteneur
- Tous les widgets avec `Colors.black87` → `Colors.black` (textes)

**Commits** : `796edc5`, `66dd077`

#### 3. Comptes Test Incorrects dans README (24 Nov 2025)

**Problème** : README mentionnait des comptes génériques au lieu des vrais comptes

**Cause** : Documentation pas synchronisée avec la page de connexion

**Solution** : Extraction des comptes réels de demo.medidesk.fr

**Commit** : `be70e32`

---

## 🗺️ ROADMAP

### Modèle Économique Détaillé

**🆓 Version Gratuite & Open Source** (Installation locale) :
- ✅ Cartographie interactive des douleurs
- ✅ Graphiques d'évolution
- ✅ Notes de séances
- ✅ Historique des consultations
- ✅ Gestion multi-patients
- ✅ Conformité RGPD
- ✅ Code source accessible sur GitHub

**💰 Upsells Payants** (Fonctionnalités premium) :
- 📅 **Module Gestion des Rendez-vous** : 19€/mois (calendrier, rappels SMS/Email, synchronisation)
- ☁️ **Cloud Sync & Backup** : 14€/mois (sauvegarde automatique, accès multi-appareils)
- 📄 **Export PDF Avancé** : 9€/mois (rapports personnalisés, logo cabinet, e-signature)
- 📊 **Analytics & BI** : 24€/mois (tableaux de bord avancés, KPIs, prédictions IA)
- 🌐 **Multi-Centres** : 49€/mois (réseau de centres, partage patients avec consentement)
- 🔔 **Notifications Push** : 7€/mois (rappels patients, alertes évolution)

**Bundles** :
- **Pack Essentiel** : 39€/mois (RDV + Cloud + Export PDF) - Économie 15%
- **Pack Professionnel** : 69€/mois (Tous modules sauf Multi-Centres) - Économie 25%
- **Pack Cabinet** : 99€/mois (Tous modules inclus) - Économie 35%

### Version 2.0 (Q1 2026 - Mars 2026)

**Fonctionnalités principales** :
- 📄 Export PDF des rapports (**Upsell payant**)
- 📱 Application mobile native (iOS/Android) (**Gratuit**)
- 🔔 Notifications push (**Upsell payant**)
- 📊 Tableaux de bord avancés (**Upsell payant**)
- 🤝 Partage de données sécurisé (**Gratuit**)
- 🌐 Multi-langue (FR/EN/ES/DE) (**Gratuit**)

**Améliorations techniques** :
- ⚡ Performance +50%
- 🎨 Thèmes personnalisables (clair/sombre)
- 📈 Graphiques enrichis
- 🔐 Authentification à 2 facteurs
- 💾 Backup automatique
- 🖨️ Impression directe

### Version 2.1 (Q2 2026 - Juin 2026)

**Intelligence Artificielle** :
- 🧠 Recommandations de traitement
- 📊 Prédiction d'évolution
- 🔍 Détection d'anomalies

**Intégrations** :
- 🏥 API RPPS (vérification praticiens)
- 📅 Google Calendar (synchronisation)
- 💳 Module de facturation

### Version 2.2+ (Q3-Q4 2026)

- 📖 Protocoles de traitement préenregistrés
- 🎥 Vidéos d'exercices pour patients
- 📋 Questionnaires de satisfaction
- 🌐 Plateforme multi-centres
- 🛒 Marketplace de plugins

---

## 🔧 COMMANDES UTILES

### Développement Local

```bash
# Navigation
cd /home/user/flutter_app

# Installation dépendances
flutter pub get

# Analyse du code
flutter analyze

# Format du code
dart format .

# Lancer en Web (dev)
flutter run -d chrome --web-port=5060

# Build Web (prod)
flutter build web --release
```

### Firebase

```bash
# Deploy Hosting
firebase deploy --only hosting --project kinecare-81f52

# Deploy Firestore Rules
firebase deploy --only firestore:rules --project kinecare-81f52

# Voir logs
firebase functions:log --project kinecare-81f52
```

### Git & GitHub

```bash
# Status
git status

# Voir différences
git diff

# Commit
git add .
git commit -m "Message descriptif"

# Push vers branche base
git push origin base

# Pull derniers changements
git pull origin base

# Voir historique
git log --oneline -10
```

### Android Build

```bash
# Build APK debug
flutter build apk

# Build APK release
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release

# Installer sur device connecté
flutter install
```

---

## 📞 SUPPORT & RESSOURCES

### Documentation

- **README.md** : Guide utilisateur pour centres de soin
- **ROADMAP.md** : Feuille de route détaillée
- **AI_QUICK_START.md** : Guide express pour l'IA
- **CONTEXT.md** : Ce document

### Liens Utiles

- **Application** : https://demo.medidesk.fr
- **GitHub** : https://github.com/RBSoftwareAI/kine
- **Firebase Console** : https://console.firebase.google.com/project/kinecare-81f52
- **Flutter Docs** : https://docs.flutter.dev

### Contact

- **Email Support** : support@medidesk.fr
- **Site Web** : https://medidesk.fr
- **Équipe** : RBSoftwareAI

---

**Date de création** : 24 Novembre 2025  
**Version** : 1.0  
**Dernière mise à jour** : 26 Novembre 2025 - Corrections majeures positionnement
