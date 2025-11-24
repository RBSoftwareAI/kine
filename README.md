# 🏥 MediDesk - Application de Gestion Médicale

**Application Flutter de gestion médicale pour kinésithérapeutes et patients**

[![Firebase](https://img.shields.io/badge/Firebase-Hosting-orange)](https://kinecare-81f52.web.app)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)](https://dart.dev)

---

## 🚀 Application en Ligne

**URL Production** : [https://kinecare-81f52.web.app](https://kinecare-81f52.web.app)

### 🔐 Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Patient** | `test.patient@medidesk.fr` | `password123` |
| **Kinésithérapeute** | `test.kine@medidesk.fr` | `password123` |
| **Secrétaire** | `test.secretaire@medidesk.fr` | `password123` |

---

## 📱 Fonctionnalités

### Pour les Patients
- ✅ Cartographie des douleurs corporelles
- ✅ Suivi de l'évolution des douleurs
- ✅ Graphiques et statistiques personnalisés
- ✅ Historique des séances de traitement
- ✅ Interface intuitive et responsive

### Pour les Kinésithérapeutes
- ✅ Gestion des patients
- ✅ Consultation des dossiers médicaux
- ✅ Analyse des évolutions
- ✅ Accès aux données de cartographie

### Pour les Secrétaires
- ✅ Gestion administrative
- ✅ Planning et rendez-vous
- ✅ Interface simplifiée

---

## 🛠️ Technologies

- **Framework** : Flutter 3.35.4
- **Langage** : Dart 3.9.2
- **Backend** : Firebase (Firestore, Authentication, Hosting)
- **State Management** : Provider
- **Charts** : FL Chart
- **UI** : Material Design 3

---

## 📦 Installation & Développement

### Prérequis
```bash
# Flutter 3.35.4 requis
flutter --version

# Java 17 requis pour Android
java -version
```

### Installation des dépendances
```bash
flutter pub get
```

### Lancement en mode développement
```bash
# Web (port 5060)
flutter run -d chrome --web-port=5060

# Android
flutter run -d android
```

### Build Production
```bash
# Build Web
flutter build web --release

# Build APK Android
flutter build apk --release

# Build App Bundle Android
flutter build appbundle --release
```

---

## 🔥 Firebase Configuration

### Configuration Requise
1. **Firebase Admin SDK** : `/opt/flutter/firebase-admin-sdk.json`
2. **Google Services** : `android/app/google-services.json`
3. **Firebase Options** : `lib/firebase_options.dart`

### Déploiement Firebase
```bash
# Déploiement Hosting
firebase deploy --only hosting

# Déploiement Firestore Rules
firebase deploy --only firestore:rules
```

---

## 🔒 Système de Permissions

L'application utilise un système de permissions granulaires par rôle :

| Rôle | Accès |
|------|-------|
| **Patient** | Mes données, Mes douleurs, Mes courbes |
| **Kinésithérapeute** | Tous patients, Toutes données médicales |
| **Secrétaire** | Gestion administrative, Planning |
| **Admin** | Accès complet, Gestion utilisateurs |

---

## 📊 Architecture

```
lib/
├── main.dart                 # Point d'entrée
├── firebase_options.dart     # Config Firebase multi-plateforme
├── models/                   # Modèles de données
│   ├── user_model.dart
│   ├── pain_mapping_model.dart
│   └── pain_history.dart
├── providers/                # State Management
│   ├── auth_provider.dart
│   ├── patient_provider.dart
│   └── appointment_provider.dart
├── services/                 # Services Backend
│   ├── firebase_data_service.dart
│   ├── permission_service.dart
│   └── evolution_service.dart
├── views/                    # Écrans UI
│   ├── evolution/
│   ├── patient/
│   └── settings/
└── utils/                    # Utilitaires
    └── app_theme.dart
```

---

## 📄 Documentation

### Guides Disponibles
- [📘 DEPLOIEMENT_COMPLET_REUSSI.md](./DEPLOIEMENT_COMPLET_REUSSI.md) - Guide de déploiement complet
- [📗 GUIDE_DNS_ETAPE3.md](./GUIDE_DNS_ETAPE3.md) - Configuration DNS personnalisé
- [📙 CORRECTION_ABSOLUMENT_FINALE.md](./CORRECTION_ABSOLUMENT_FINALE.md) - Corrections thème blanc
- [📕 RESUME_FINAL_24NOV.md](./RESUME_FINAL_24NOV.md) - Résumé des développements

### Dernières Mises à Jour
- **24/11/2024** : Correction finale thème blanc - 100% cohérent
- **24/11/2024** : Système de permissions par rôle déployé
- **24/11/2024** : Règles Firestore sécurisées activées
- **24/11/2024** : Écran de connexion avec 6 comptes test

---

## 🎨 Thème & Design

L'application utilise un thème clair cohérent :
- **Couleur principale** : Orange (`#FF6B35`)
- **Couleur secondaire** : Bleu (`#2196F3`)
- **Arrière-plan** : Blanc/Gris très clair
- **Texte** : Noir (`#000000`)
- **Design System** : Material Design 3

---

## 🧪 Tests

### Comptes de Test
Tous les comptes utilisent le mot de passe : `password123`

```dart
// Test Patient
Email: test.patient@medidesk.fr

// Test Kinésithérapeute
Email: test.kine@medidesk.fr

// Test Secrétaire
Email: test.secretaire@medidesk.fr
```

### Tests de Validation
1. Connexion avec différents rôles
2. Vérification des permissions
3. Cartographie des douleurs (Patient)
4. Graphiques d'évolution (Patient)
5. Gestion des patients (Kinésithérapeute)

---

## 🚀 Déploiement

### Firebase Hosting (Production)
```bash
# Build + Deploy
flutter build web --release
firebase deploy --only hosting
```

### Domaine Personnalisé
Configuration DNS pour `demo.medidesk.fr` :
Voir [GUIDE_DNS_ETAPE3.md](./GUIDE_DNS_ETAPE3.md)

---

## 🐛 Résolution de Problèmes

### Problème : Écran de chargement infini
**Solution** : Correction AuthProvider avec timeout 500ms
```dart
// Voir lib/providers/auth_provider.dart
await _initializeAuthState();
```

### Problème : Permissions refusées Firestore
**Solution** : Déployer les règles Firestore
```bash
firebase deploy --only firestore:rules
```

### Problème : Thème incohérent
**Solution** : Toutes les corrections sont dans le commit `66dd077`

---

## 📝 Changelog

### v1.3 - 24/11/2024
- ✅ Correction finale thème blanc (100% cohérent)
- ✅ Section "Zones touchées" : fond blanc
- ✅ Section "Séances de traitement" : fond blanc
- ✅ Upload GitHub automatique configuré

### v1.2 - 24/11/2024
- ✅ Système de permissions par rôle
- ✅ Règles Firestore sécurisées
- ✅ Écran de connexion redesigné
- ✅ 6 comptes de test créés

### v1.1 - 23/11/2024
- ✅ Correctif AuthProvider (chargement < 3s)
- ✅ Nettoyage doublons Firebase (9 utilisateurs finaux)
- ✅ Déploiement Firebase Hosting

### v1.0 - 22/11/2024
- ✅ Version initiale
- ✅ Cartographie des douleurs
- ✅ Graphiques d'évolution
- ✅ Interface Patient/Kinésithérapeute

---

## 👥 Contributeurs

- **Développement** : Équipe GenSpark AI
- **Design** : Material Design 3
- **Backend** : Firebase

---

## 📧 Support

Pour toute question ou problème :
- **Email** : support@medidesk.fr
- **GitHub Issues** : [github.com/RBSoftwareAI/kine/issues](https://github.com/RBSoftwareAI/kine/issues)

---

## 📄 Licence

© 2024 MediDesk - Tous droits réservés

---

**🏥 MediDesk - Simplifier la gestion médicale pour les professionnels de santé**
