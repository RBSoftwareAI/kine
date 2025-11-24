# 🏥 MediDesk - Application de Gestion Médicale

**Application Flutter de gestion médicale pour kinésithérapeutes et patients**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)](https://dart.dev)
[![Licence](https://img.shields.io/badge/Licence-Propriétaire-red)](https://medidesk.fr)

---

## 🚀 Démo en Ligne

**URL** : [https://demo.medidesk.fr](https://demo.medidesk.fr)

### 🔐 Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Patient** | `test.patient@medidesk.fr` | `password123` |
| **Kinésithérapeute** | `test.kine@medidesk.fr` | `password123` |
| **Secrétaire** | `test.secretaire@medidesk.fr` | `password123` |

---

## 📱 Fonctionnalités

### Pour les Patients
- ✅ **Cartographie corporelle interactive** : Pointez vos douleurs sur un modèle anatomique
- ✅ **Suivi de l'évolution** : Graphiques temporels de l'intensité des douleurs
- ✅ **Historique des séances** : Consultez vos traitements passés
- ✅ **Statistiques personnalisées** : Zones les plus touchées, tendances
- ✅ **Interface intuitive** : Design moderne et responsive

### Pour les Kinésithérapeutes
- ✅ **Gestion des patients** : Vue complète du dossier médical
- ✅ **Analyse des évolutions** : Outils de visualisation avancés
- ✅ **Accès aux cartographies** : Consultation des zones douloureuses
- ✅ **Suivi des traitements** : Historique complet des interventions

### Pour les Secrétaires
- ✅ **Gestion administrative** : Planning et rendez-vous
- ✅ **Interface simplifiée** : Accès rapide aux fonctions essentielles

---

## 💻 Installation pour Centres de Soin

**Vous êtes un centre de kinésithérapie et souhaitez installer MediDesk en local ?**

### 📋 Prérequis Système

Avant de commencer, assurez-vous d'avoir :
- **Système d'exploitation** : Windows 10/11, macOS 11+, ou Linux (Ubuntu 20.04+)
- **Espace disque** : Minimum 5 GB disponibles
- **Mémoire RAM** : Minimum 4 GB recommandé
- **Connexion Internet** : Pour téléchargement initial et mises à jour

---

### 🪟 Installation sur Windows

#### Étape 1 : Installer Flutter SDK

1. **Télécharger Flutter** :
   - Aller sur : https://docs.flutter.dev/get-started/install/windows
   - Télécharger le fichier ZIP Flutter 3.35.4
   - Extraire dans `C:\src\flutter` (créer le dossier si nécessaire)

2. **Configurer les variables d'environnement** :
   - Ouvrir "Paramètres système avancés"
   - Cliquer sur "Variables d'environnement"
   - Ajouter `C:\src\flutter\bin` à la variable `Path`

3. **Vérifier l'installation** :
   ```powershell
   flutter --version
   # Doit afficher : Flutter 3.35.4
   ```

#### Étape 2 : Cloner le Projet MediDesk

```powershell
# Installer Git si nécessaire : https://git-scm.com/download/win
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# Installer les dépendances
flutter pub get
```

#### Étape 3 : Lancer l'Application

```powershell
# Lancer sur navigateur Web (Chrome)
flutter run -d chrome --web-port=5060

# L'application sera accessible sur : http://localhost:5060
```

#### Étape 4 : Build pour Production (Optionnel)

```powershell
# Créer un build Web optimisé
flutter build web --release

# Les fichiers seront dans : build/web/
# Déployez-les sur votre serveur web local (IIS, Apache, etc.)
```

---

### 🍎 Installation sur macOS

#### Étape 1 : Installer Flutter SDK

1. **Télécharger Flutter** :
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.35.4-stable.zip
   unzip flutter_macos_3.35.4-stable.zip
   ```

2. **Configurer le PATH** :
   ```bash
   # Ouvrir le fichier de configuration
   nano ~/.zshrc
   
   # Ajouter cette ligne à la fin :
   export PATH="$PATH:$HOME/development/flutter/bin"
   
   # Sauvegarder (Ctrl+O, Enter, Ctrl+X)
   
   # Recharger la configuration
   source ~/.zshrc
   ```

3. **Vérifier l'installation** :
   ```bash
   flutter --version
   # Doit afficher : Flutter 3.35.4
   ```

#### Étape 2 : Cloner le Projet MediDesk

```bash
# Installer Git si nécessaire
brew install git

# Cloner le projet
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# Installer les dépendances
flutter pub get
```

#### Étape 3 : Lancer l'Application

```bash
# Lancer sur navigateur Web (Chrome)
flutter run -d chrome --web-port=5060

# L'application sera accessible sur : http://localhost:5060
```

#### Étape 4 : Build pour Production (Optionnel)

```bash
# Créer un build Web optimisé
flutter build web --release

# Les fichiers seront dans : build/web/
# Déployez-les sur votre serveur web local (nginx, Apache, etc.)
```

---

### 🐧 Installation sur Linux (Ubuntu/Debian)

#### Étape 1 : Installer Flutter SDK

```bash
# Installer les dépendances
sudo apt update
sudo apt install curl git unzip xz-utils zip libglu1-mesa

# Télécharger Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.4-stable.tar.xz
tar xf flutter_linux_3.35.4-stable.tar.xz

# Configurer le PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

#### Étape 2 : Vérifier l'installation

```bash
flutter --version
# Doit afficher : Flutter 3.35.4

# Vérifier les dépendances
flutter doctor
```

#### Étape 3 : Cloner le Projet MediDesk

```bash
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# Installer les dépendances
flutter pub get
```

#### Étape 4 : Lancer l'Application

```bash
# Lancer sur navigateur Web (Chrome)
flutter run -d chrome --web-port=5060

# L'application sera accessible sur : http://localhost:5060
```

#### Étape 5 : Build pour Production (Optionnel)

```bash
# Créer un build Web optimisé
flutter build web --release

# Les fichiers seront dans : build/web/
# Déployez-les sur votre serveur web local (nginx, Apache, etc.)
```

---

## 📧 Inscription et Support pour Centres de Soin

**Vous souhaitez installer MediDesk dans votre centre ?**

### 🎯 Processus d'Inscription

1. **Inscrivez-vous sur** : [https://medidesk.fr](https://medidesk.fr)
2. **Remplissez le formulaire** avec les informations de votre centre
3. **Recevez par email** :
   - 📄 Guide d'installation détaillé (PDF)
   - 🔑 Clés de licence
   - 📞 Coordonnées du support technique
   - 💾 Fichiers de configuration personnalisés

### 📞 Support Technique

Une fois inscrit, vous bénéficiez de :
- ✅ **Support par email** : support@medidesk.fr
- ✅ **Documentation complète** : Guides d'installation pas à pas
- ✅ **Assistance à l'installation** : Configuration initiale incluse
- ✅ **Mises à jour gratuites** : Nouvelles fonctionnalités régulières

---

## 🛠️ Technologies

- **Framework** : Flutter 3.35.4
- **Langage** : Dart 3.9.2
- **State Management** : Provider
- **Charts** : FL Chart 0.69.2
- **UI** : Material Design 3
- **Stockage local** : Hive 2.2.3 (base de données locale)

---

## 📊 Architecture Technique

```
lib/
├── main.dart                 # Point d'entrée
├── models/                   # Modèles de données
│   ├── user_model.dart
│   ├── pain_mapping_model.dart
│   └── pain_history.dart
├── providers/                # State Management
│   ├── auth_provider.dart
│   ├── patient_provider.dart
│   └── appointment_provider.dart
├── services/                 # Services Métier
│   ├── data_service.dart
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

## 🎨 Thème & Design

L'application utilise un thème clair moderne :
- **Couleur principale** : Orange (`#FF6B35`)
- **Couleur secondaire** : Bleu (`#2196F3`)
- **Arrière-plan** : Blanc/Gris clair
- **Texte** : Noir
- **Design** : Material Design 3 (Google)

---

## 🔒 Système de Permissions

| Rôle | Accès |
|------|-------|
| **Patient** | Mes données, Mes douleurs, Mes statistiques |
| **Kinésithérapeute** | Tous patients, Toutes données médicales |
| **Secrétaire** | Gestion administrative, Planning |
| **Admin** | Accès complet, Configuration système |

---

## 🚀 Roadmap - Prochaines Fonctionnalités

### Version 2.0 (Prévue Q1 2026)

**Nouvelles Fonctionnalités** :
- 🎯 **Export PDF des rapports** : Génération automatique de comptes-rendus
- 📱 **Application mobile native** : iOS et Android
- 🔔 **Notifications push** : Rappels de rendez-vous
- 📊 **Tableaux de bord avancés** : Analytics et KPIs pour les centres
- 🤝 **Partage de données** : Export sécurisé vers autres praticiens
- 🌐 **Multi-langue** : Anglais, Espagnol, Allemand

**Améliorations Prévues** :
- ⚡ **Performance optimisée** : Chargement 50% plus rapide
- 🎨 **Thèmes personnalisables** : Mode sombre, thèmes par centre
- 📈 **Graphiques enrichis** : Plus de types de visualisations
- 🔐 **Sécurité renforcée** : Authentification à deux facteurs (2FA)
- 💾 **Backup automatique** : Sauvegarde planifiée des données
- 🖨️ **Impression directe** : Imprimer cartographies et rapports

### Version 2.1 (Prévue Q2 2026)

**Intelligence Artificielle** :
- 🧠 **Recommandations IA** : Suggestions de traitements basées sur historique
- 📊 **Prédiction d'évolution** : Algorithmes de prévision des améliorations
- 🔍 **Détection d'anomalies** : Alertes sur évolutions inhabituelles

**Intégrations** :
- 🏥 **API RPPS** : Vérification automatique des praticiens
- 📅 **Google Calendar** : Synchronisation bidirectionnelle
- 💳 **Facturation** : Module de gestion comptable intégré

---

## 🐛 Résolution de Problèmes Courants

### Problème : Flutter non reconnu après installation

**Windows** :
```powershell
# Vérifier que Flutter est dans le PATH
echo $env:Path | Select-String "flutter"

# Si absent, ajouter manuellement
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```

**macOS/Linux** :
```bash
# Vérifier le PATH
echo $PATH | grep flutter

# Si absent, ajouter dans ~/.bashrc ou ~/.zshrc
export PATH="$PATH:$HOME/flutter/bin"
source ~/.bashrc  # ou source ~/.zshrc
```

### Problème : Erreur lors de `flutter pub get`

```bash
# Nettoyer le cache Flutter
flutter clean
flutter pub cache repair

# Réessayer
flutter pub get
```

### Problème : Application ne démarre pas

```bash
# Vérifier la configuration Flutter
flutter doctor

# Résoudre les problèmes identifiés par Flutter Doctor
```

---

## 📝 Changelog

### v1.3 - 24/11/2025 (Actuelle)
- ✅ **Correction finale thème blanc** : Interface 100% cohérente
- ✅ **Section "Zones touchées"** : Affichage optimisé
- ✅ **Section "Séances de traitement"** : Design amélioré
- ✅ **Documentation complète** : README professionnel

### v1.2 - 23/11/2025
- ✅ **Système de permissions par rôle** : Sécurité renforcée
- ✅ **Écran de connexion redesigné** : UX améliorée
- ✅ **3 comptes de test créés** : Démo fonctionnelle

### v1.1 - 22/11/2025
- ✅ **Correctif AuthProvider** : Chargement < 3 secondes
- ✅ **Optimisations performance** : Fluidité accrue

### v1.0 - 20/11/2025
- ✅ **Version initiale** : MVP complet
- ✅ **Cartographie des douleurs** : Fonctionnalité core
- ✅ **Graphiques d'évolution** : Suivi temporel
- ✅ **Interface Patient/Kinésithérapeute** : Deux profils

---

## 👥 Contributeurs

- **Développement** : Équipe GenSpark AI
- **Design UI/UX** : Material Design 3 (Google)
- **Produit** : MediDesk

---

## 📧 Contact

**Site Web** : [https://medidesk.fr](https://medidesk.fr)  
**Email** : support@medidesk.fr  
**Démo** : [https://demo.medidesk.fr](https://demo.medidesk.fr)

---

## 📄 Licence

© 2025 MediDesk - Tous droits réservés

**Application propriétaire destinée aux professionnels de santé**

---

**🏥 MediDesk - Simplifiez la gestion de votre cabinet médical**

*Conçu par des professionnels de santé, pour des professionnels de santé*
