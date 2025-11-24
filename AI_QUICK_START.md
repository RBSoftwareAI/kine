# 🚀 AI Quick Start - MediDesk

**Guide Express pour l'IA - Session 24 Novembre 2025**

---

## 📍 INFORMATIONS ESSENTIELLES

- **Date actuelle** : 24 Novembre 2025
- **Application** : MediDesk - Gestion médicale pour kinésithérapeutes
- **URL Production** : https://demo.medidesk.fr
- **Repository** : https://github.com/RBSoftwareAI/kine
- **Branche active** : `base`

---

## ✅ ÉTAT DU PROJET

### Fonctionnalités Actuelles (v1.3)

- ✅ **Cartographie corporelle** : Patients pointent leurs douleurs sur modèle anatomique
- ✅ **Graphiques d'évolution** : Suivi temporel de l'intensité des douleurs
- ✅ **Système de permissions** : Accès par rôle (Patient/Kine/Secrétaire/etc.)
- ✅ **Interface responsive** : Design Material 3, thème blanc cohérent
- ✅ **Déploiement** : Application en ligne sur demo.medidesk.fr

### Technologies

- **Flutter** : 3.35.4 (⚠️ VERSION VERROUILLÉE - NE PAS METTRE À JOUR)
- **Dart** : 3.9.2 (⚠️ VERSION VERROUILLÉE)
- **Backend** : Firebase (Firestore, Authentication, Hosting)
- **State Management** : Provider
- **Charts** : FL Chart 0.69.2

---

## 🔐 COMPTES DE TEST OFFICIELS

**⚠️ IMPORTANT : Ces comptes sont affichés sur la page de connexion de demo.medidesk.fr**

**Tous utilisent le mot de passe : `password123`**

| Nom | Rôle | Email |
|-----|------|-------|
| **Patient Test** | Patient | `test.patient@medidesk.fr` |
| **Pierre Durand** | Kinésithérapeute | `pierre.durand@medidesk.fr` |
| **Sophie Dupont** | Secrétaire | `so.phie@medadesk.fr` |
| **Marie Lefèvre** | Réceptionniste | `marie.lefevre@medidesk.fr` |
| **Jean Martin** | Comptable | `jean@medadesk.fr` |
| **Admin Système** | Administrateur | `admin.2wat@wp.fr` |

**🎯 Pour vérifier : Ouvrir https://demo.medidesk.fr et comparer avec la page de connexion**

---

## 📂 STRUCTURE DU PROJET

```
/home/user/flutter_app/
├── lib/                      # Code source Dart/Flutter
│   ├── main.dart            # Point d'entrée
│   ├── models/              # Modèles de données
│   ├── providers/           # State management (Provider)
│   ├── services/            # Services métier
│   ├── views/               # Écrans UI
│   │   ├── evolution/       # Graphiques d'évolution
│   │   ├── patient/         # Interface patient
│   │   └── settings/        # Paramètres
│   └── utils/               # Utilitaires (thème, etc.)
├── android/                 # Configuration Android
├── web/                     # Configuration Web
├── README.md                # Documentation principale
├── ROADMAP.md              # Feuille de route
├── AI_QUICK_START.md       # Ce fichier
└── CONTEXT.md              # Documentation complète
```

---

## 🎯 DERNIERS TRAVAUX RÉALISÉS

### Session du 24 Novembre 2025

1. ✅ **Correction thème blanc** : Tous les fonds noirs → blancs (100% cohérent)
2. ✅ **README professionnel** : Installation Windows/macOS/Linux pour centres
3. ✅ **ROADMAP détaillée** : Versions 2.0 à 3.0 planifiées
4. ✅ **Comptes test** : Synchronisés avec demo.medidesk.fr
5. ✅ **Contributeurs** : Équipe RBSoftwareAI

### Commits Récents

```
be70e32 📝 Correction comptes test - Vrais comptes de demo.medidesk.fr
77b9324 📝 Corrections README - 6 comptes test + Équipe RBSoftwareAI
606aa71 📚 README et ROADMAP professionnels pour centres de soin
66dd077 🎨 CORRECTION ABSOLUMENT FINALE - Zones noires → blanches
```

---

## ⚠️ POINTS D'ATTENTION

### Versions Verrouillées (NE PAS METTRE À JOUR)

- **Flutter** : 3.35.4 (fixé)
- **Dart** : 3.9.2 (fixé)
- **Packages Firebase** : Versions exactes dans `pubspec.yaml`

### Configuration Android

**Package Name** : `com.medidesk.app` (ou selon `google-services.json`)

**⚠️ CRITIQUE** : Le package Android doit correspondre à `google-services.json` :
- `android/app/build.gradle.kts` → `applicationId`
- `android/app/src/main/AndroidManifest.xml` → `package`
- `MainActivity.kt` → Emplacement et package

### Firebase

- **Project ID** : `kinecare-81f52`
- **URL Hosting** : https://kinecare-81f52.web.app (redirige vers demo.medidesk.fr)
- **Admin SDK** : `/opt/flutter/firebase-admin-sdk.json`
- **Google Services** : `/opt/flutter/google-services.json`

---

## 🚀 COMMANDES RAPIDES

### Développement

```bash
# Aller dans le projet
cd /home/user/flutter_app

# Installer dépendances
flutter pub get

# Analyser le code
flutter analyze

# Lancer en mode Web
flutter run -d chrome --web-port=5060
```

### Build & Déploiement

```bash
# Build Web optimisé
flutter build web --release

# Déployer sur Firebase
firebase deploy --only hosting

# Build APK Android
flutter build apk --release
```

### Git

```bash
# Status
git status

# Commit
git add .
git commit -m "Message"

# Push vers GitHub
git push origin base
```

---

## 📖 DOCUMENTATION COMPLÈTE

Pour plus de détails, consulter :
- **CONTEXT.md** : Documentation technique complète
- **README.md** : Guide utilisateur pour centres de soin
- **ROADMAP.md** : Feuille de route des versions futures

---

## 🎯 POUR VOTRE PROCHAINE SESSION

### Message Type

```
Bonjour nous sommes le 24 novembre 2025 ! Je continue le développement de l'application MediDesk.

📂 Repository : https://github.com/RBSoftwareAI/kine
🌿 Branche : base
📄 Documentation : Lis d'abord les fichiers dans cet ordre :
   1. AI_QUICK_START.md (guide express)
   2. CONTEXT.md (documentation complète)

🎯 Ma demande pour cette session :
[Décrivez votre demande ici]
```

### Exemples de Demandes

- "Corriger les comptes test dans README.md pour correspondre à demo.medidesk.fr"
- "Ajouter une nouvelle fonctionnalité dans l'écran Patient"
- "Optimiser les performances de l'écran Evolution"
- "Créer un nouveau type de graphique"
- "Corriger un bug dans la cartographie"

---

**Date de création** : 24 Novembre 2025  
**Version** : 1.0  
**Dernière mise à jour** : 24 Novembre 2025 - 16:15
