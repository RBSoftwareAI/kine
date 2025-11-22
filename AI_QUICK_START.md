# 🚀 AI QUICK START - MediDesk

**Guide express pour démarrer rapidement une session de développement avec l'IA**

---

## 📋 Informations essentielles

### 🎯 Projet : **MediDesk**
Logiciel de gestion de cabinet médical (kinésithérapie, ostéopathie)

### 🏗️ Architecture technique
- **Frontend** : Flutter 3.35.4 + Dart 3.9.2 (Web + Android)
- **Backend MODE DEMO** : Firebase (Firestore, Auth, Storage)
- **Backend MODE LOCAL** : Flask + SQLite (EN DÉVELOPPEMENT)
- **État** : Provider Pattern
- **Base de données locale** : SQLite chiffré
- **Base de données demo** : Firestore

### 📂 Repository
- **URL** : https://github.com/RBSoftwareAI/kine
- **Branche principale** : `base`
- **Dossier Flutter** : `/home/user/flutter_app/`
- **Dossier Backend Flask** : `/home/user/medidesk_backend/`

---

## ⚡ Démarrage rapide

### 1️⃣ **État actuel du projet**

✅ **COMPLÉTÉ (100%)** :
- Phase B : Authentification (Login, Logout, Comptes test)
- Phase C : Dashboard + Gestion des patients
- Phase D : Système de réservation (Calendrier, RDV)

🔄 **EN DÉVELOPPEMENT** :
- Backend Flask + SQLite pour installation locale
- Architecture hybride (Firebase démo + Flask local)
- Documentation juridique RGPD

### 2️⃣ **Commandes essentielles**

```bash
# Naviguer vers le projet Flutter
cd /home/user/flutter_app

# Analyser le code (détection erreurs)
flutter analyze

# Rebuild application web
flutter build web --release

# Démarrer serveur de preview (port 5060)
cd build/web && python3 -m http.server 5060 --bind 0.0.0.0 &

# Voir les logs
tail -f /home/user/server.log

# Git status
git status

# Commit rapide
git add -A && git commit -m "Description"

# Push vers GitHub
git push origin base
```

### 3️⃣ **Comptes de test (Firebase)**

| Email | Mot de passe | Centre | Rôle |
|-------|--------------|--------|------|
| `marie.lefebvre@kine-paris.fr` | `password123` | Kiné Paris Centre | Kinésithérapeute |
| `pierre.girard@osteo-lyon.fr` | `password123` | Ostéo Lyon | Ostéopathe |

**Données test** : 20 patients + 15 RDV par centre

---

## 🎯 Structure du code

```
flutter_app/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── models/                      # Modèles de données
│   │   ├── user_model.dart
│   │   ├── patient_model.dart
│   │   └── appointment_model.dart
│   ├── services/                    # Logique métier
│   │   ├── firebase_auth_service.dart
│   │   ├── firestore_patient_service.dart
│   │   └── firestore_appointment_service.dart
│   ├── providers/                   # State management
│   │   ├── auth_provider.dart
│   │   ├── patient_provider.dart
│   │   └── appointment_provider.dart
│   └── screens/                     # UI
│       ├── auth/                    # Authentification
│       ├── dashboard/               # Dashboard principal
│       ├── patients/                # Gestion patients
│       └── appointments/            # Gestion RDV
├── android/                         # Configuration Android
└── web/                             # Configuration Web

medidesk_backend/                    # Backend Flask (EN DÉVELOPPEMENT)
├── app/
│   ├── __init__.py                  # Factory Flask
│   ├── models.py                    # Modèles SQLAlchemy
│   └── routes/                      # API REST endpoints
└── requirements.txt                 # Dépendances Python
```

---

## 🔧 Problèmes fréquents et solutions

### ❌ Erreur : "Port 5060 déjà utilisé"
```bash
lsof -ti:5060 | xargs -r kill -9
```

### ❌ Erreur : "firebase_localizations not found"
```bash
cd /home/user/flutter_app
flutter pub get
```

### ❌ Erreur : "Date picker fond gris"
✅ **RÉSOLU** : Mise à jour `table_calendar: ^3.2.0` + localisation française

### ❌ Erreur : "Liste patients ne charge pas"
✅ **RÉSOLU** : Simplification requêtes Firestore (filtrage en mémoire)

---

## 📊 URLs importantes

| Service | URL | Statut |
|---------|-----|--------|
| **Preview Web** | https://5060-ix0ake2l8sv44i0ezuq5t-2e77fc33.sandbox.novita.ai | ✅ Actif |
| **GitHub** | https://github.com/RBSoftwareAI/kine | ✅ Synchronisé |
| **Firebase Console** | https://console.firebase.google.com/ | ✅ Configuré |

---

## 🎯 Prochaines étapes recommandées

1. **Backend Flask local** : Créer API REST complète
2. **Architecture hybride** : DataService abstrait avec 2 implémentations
3. **Chiffrement SQLite** : Sécuriser données locales
4. **Logs d'audit** : Traçabilité RGPD
5. **Documentation juridique** : Guide praticien, CGU, RGPD

---

## 💡 Conseils pour l'IA

### ✅ Bonnes pratiques
- Toujours lire `CONTEXT.md` après ce fichier
- Vérifier l'état actuel avec `git status`
- Tester avec `flutter analyze` avant build
- Commit fréquents avec messages descriptifs
- Utiliser les commandes variables (`${FLUTTER_BUILD_CORS}`)

### ❌ Pièges à éviter
- Ne JAMAIS modifier les versions Flutter/Dart (LOCKED)
- Ne JAMAIS utiliser `print()` en production (utiliser `debugPrint`)
- Ne JAMAIS créer de nouveaux backends sans abstraction
- Toujours vérifier la compatibilité Web des packages

---

## 📞 Support

Pour questions ou problèmes :
1. Consulter `CONTEXT.md` (documentation complète)
2. Vérifier les logs : `tail -f /home/user/server.log`
3. Analyser le code : `flutter analyze`
4. Commits récents : `git log --oneline -10`

---

**Dernière mise à jour** : Session développement Phase D (Réservations)  
**Version** : 1.0.0  
**Statut** : Production-ready (Firebase) / En développement (Flask local)
