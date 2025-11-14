# 🏥 KinéCare - Application de Suivi Kinésithérapie

[![Flutter Version](https://img.shields.io/badge/Flutter-3.35.4-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Private-red.svg)]()
[![MVP Phase 1](https://img.shields.io/badge/MVP%20Phase%201-100%25-success.svg)]()

Application Flutter professionnelle pour le suivi des patients en kinésithérapie et coaching APA (Activité Physique Adaptée).

## 🎯 MVP Phase 1 - Fonctionnalités Complètes

### ✅ 1. Authentification Multi-Rôles
- 🔐 Système de connexion local (mode démonstration)
- 👥 Support 3 rôles : Patient, Kinésithérapeute, Coach APA
- 🎨 Interface professionnelle avec thème Workout Warrior

### ✅ 2. Suivi Interactif des Douleurs
- 🎨 **Silhouettes anatomiques cliquables** (Face/Dos)
- 📍 **18 zones corporelles** mappées avec détection précise
- 📊 **Échelle d'intensité** 0-10 avec visualisation couleur
- ⏰ **4 niveaux de fréquence** (occasionnel, quotidien, fréquent, constant)
- 📝 Enregistrement avec coordonnées précises

### ✅ 3. Dashboard Professionnel
- 📋 Liste patients avec statistiques temps réel
- 🔍 Recherche et filtres multiples
- 🚨 Détection automatique patients nécessitant attention
- 📊 Indicateurs visuels de progression
- 🔄 Pull-to-refresh

### ✅ 4. Système de Traçabilité RGPD
- 📝 **Historique complet** des modifications (qui/quoi/quand)
- 🏷️ **10 types d'actions** trackées
- 🔄 **Comparaison avant/après** pour chaque modification
- 👨‍⚕️ Identification modifications professionnelles vs patients
- 📊 Timeline verticale avec codes couleur
- ✅ Conformité RGPD totale

### ✅ 5. Courbes d'Évolution Graphiques
- 📈 **Graphiques d'intensité temporelle** avec fl_chart
- 📅 **Sélection de période** (7j, 30j, 3m, 6m, 1an)
- 🎯 **Points de session** marqués (avant/après)
- 💡 **Tooltips interactifs** avec détails
- 🌊 Gradient de zone sous la courbe

### ✅ 6. Comparaisons Avant/Après Séances
- 📊 Cards de comparaison détaillées
- 📉 Visualisation amélioration en pourcentage
- 📏 Barres de progression visuelles
- 🏅 Badges d'amélioration colorés
- 📈 Tendances (amélioration, stable, détérioration)

### ✅ 7. Analyse des Tendances
- 🎯 Indicateur de tendance global
- 🥇 **Zones les plus touchées** avec classement Or/Argent/Bronze
- 📊 Statistiques rapides (intensité moyenne, nb points, séances)
- 📄 Export de rapport (texte, PDF prévu)

### ✅ 8. Navigation Intuitive
- 🧭 Menu adapté selon rôle utilisateur
- ⚡ Accès rapide à toutes les fonctionnalités
- 🎨 Material Design 3
- 📱 Responsive mobile-first

## 🚀 Démarrage Rapide

### Prérequis
- Flutter 3.35.4 (LOCKED version)
- Dart 3.9.2 (LOCKED version)
- Android SDK (API Level 35)
- Java JDK 17

### Installation

```bash
# Cloner le repository
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# Installer les dépendances
flutter pub get

# Vérifier l'environnement
flutter doctor -v

# Lancer en mode web (développement)
flutter run -d chrome

# Ou builder pour production web
flutter build web --release
```

### 🔐 Comptes de Démonstration

Mode démonstration local (sans Firebase) :

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| 👤 **Patient** | patient@demo.com | patient123 |
| 🏥 **Kinésithérapeute** | kine@demo.com | kine123 |
| 🎯 **Coach APA** | coach@demo.com | coach123 |

## 🏗️ Architecture

### Structure du Projet

```
lib/
├── models/              # Modèles de données
│   ├── user_model.dart
│   ├── pain_point.dart
│   ├── pain_history.dart
│   ├── patient_summary.dart
│   └── audit_log.dart
│
├── services/            # Logique métier
│   ├── firebase_auth_service.dart
│   ├── patient_service.dart
│   ├── audit_service.dart
│   └── evolution_service.dart
│
├── providers/           # State management
│   └── auth_provider.dart
│
├── views/              # Interfaces utilisateur
│   ├── auth/          # Authentification
│   ├── home/          # Page d'accueil
│   ├── pain/          # Suivi douleurs
│   ├── professional/  # Dashboard pro
│   ├── audit/         # Traçabilité
│   └── evolution/     # Courbes graphiques
│
├── utils/             # Utilitaires
│   └── app_theme.dart
│
└── main.dart          # Point d'entrée
```

### Stack Technique

**Frontend:**
- 🎨 Flutter 3.35.4 / Dart 3.9.2
- 🎭 Material Design 3
- 📊 fl_chart 0.69.0 (graphiques)
- 🔄 Provider 6.1.5+1 (state management)

**Backend (Ready):**
- 🔥 Firebase Core 3.6.0
- 📦 Cloud Firestore 5.4.3
- 🔐 Firebase Auth 5.3.1

**Storage:**
- 💾 shared_preferences 2.5.3 (key-value)
- 📝 Hive 2.2.3 + hive_flutter 1.1.0 (document DB)

## 🎨 Design

### Thème Workout Warrior
- **Primaire:** Orange `#FF6B35`
- **Fond sombre:** `#1A1A1A`
- **Blanc:** `#FFFFFF`

### Couleurs Intensité Douleur
| Niveau | Couleur | Code |
|--------|---------|------|
| 0 (Aucune) | Vert | `#4CAF50` |
| 1-2 (Minimale) | Vert clair | `#8BC34A` |
| 3-4 (Légère) | Jaune | `#FFEB3B` |
| 5-6 (Modérée) | Orange | `#FF9800` |
| 7-8 (Sévère) | Rouge-orange | `#FF5722` |
| 9-10 (Extrême) | Rouge | `#F44336` |

## 📦 Dépendances

### Production (LOCKED versions)
```yaml
dependencies:
  firebase_core: 3.6.0
  cloud_firestore: 5.4.3
  firebase_auth: 5.3.1
  provider: 6.1.5+1
  shared_preferences: 2.5.3
  intl: ^0.19.0
  fl_chart: ^0.69.0
```

⚠️ **ATTENTION:** Ces versions sont verrouillées pour garantir la stabilité. Ne pas mettre à jour.

## 🔒 Configuration Firebase (Optionnel)

Pour passer en mode production avec Firebase :

### 1. Créer un Projet Firebase
1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Créer un nouveau projet
3. Activer **Firestore Database** et **Authentication**

### 2. Configuration Android
```bash
# Télécharger google-services.json
# Placer dans: android/app/google-services.json

# Package name: com.workoutwarrior.kinecare
```

### 3. Configuration Web
```bash
# Mettre à jour lib/firebase_options.dart
# avec les credentials Web de Firebase Console
```

### 4. Créer les Utilisateurs
```bash
# Télécharger Firebase Admin SDK (JSON)
# Exécuter script de création des comptes démo
python3 create_demo_users.py
```

## 📱 Build Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (nécessite keystore)
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

## 🌐 Déploiement Web

```bash
# Build optimisé
flutter build web --release

# Servir localement
python3 -m http.server 5060 --directory build/web

# Deploy sur Firebase Hosting
firebase deploy --only hosting
```

## 📊 Données de Démonstration

L'application génère automatiquement :
- ✅ **Historique 30-180 jours** avec évolution progressive
- ✅ **Sessions hebdomadaires** avec mesures avant/après
- ✅ **Amélioration réaliste** (-1.5 à -3 points par session)
- ✅ **Variations quotidiennes** naturelles
- ✅ **3-5 zones affectées** par patient selon profil

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Analyse de code
flutter analyze
```

## 📈 Roadmap - Phase 2

### Fonctionnalités Prévues
- [ ] 🤝 Coordination entre professionnels
- [ ] 📅 Système de rendez-vous/agenda
- [ ] 💪 Programmes d'exercices personnalisés
- [ ] 💬 Messagerie interne sécurisée
- [ ] 🏊 Module balnéothérapie
- [ ] 📊 Statistiques avancées et BI
- [ ] 📄 Export PDF des rapports
- [ ] 🔔 Notifications push
- [ ] 📱 Application mobile native
- [ ] 🌍 Multi-langue (FR/EN)

## 👥 Équipe

**Développement:** RBSoftware AI  
**Design:** Inspiré de Workout Warrior  
**Framework:** Flutter Team

## 📄 License

Projet privé - Tous droits réservés

## 🆘 Support

Pour toute question ou support :
- 📧 Email: [contact]
- 🐛 Issues: [GitHub Issues](https://github.com/RBSoftwareAI/kine/issues)

---

**🎉 MVP Phase 1 COMPLET - Prêt pour production !**

*Développé avec ❤️ et Flutter*
