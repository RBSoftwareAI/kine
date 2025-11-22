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
- **Option B** : Préparation déploiement demo.medidesk.fr ✨ NOUVEAU
- **Option A** : Backend Flask REST API complet (auth, patients, appointments, centres, audit) ✨ NOUVEAU

🔄 **EN COURS (Prochaine session)** :
- Adapter services Flutter pour utiliser API Flask (DataService abstrait)
- Documentation juridique RGPD complète (Option C)
- Déploiement demo.medidesk.fr sur Firebase Hosting

### 2️⃣ **Commandes essentielles**

```bash
# ========== FLUTTER ==========
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

# ========== BACKEND FLASK ✨ NOUVEAU ==========
# Naviguer vers le backend
cd /home/user/medidesk_backend

# Activer environnement virtuel
source venv/bin/activate

# Démarrer serveur Flask (port 5000)
python run.py

# Tester API
curl http://localhost:5000/health

# ========== GIT ==========
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

medidesk_backend/                    # Backend Flask ✨ COMPLET
├── app/
│   ├── __init__.py                  # Factory Flask
│   ├── models/                      # 5 modèles SQLAlchemy
│   │   ├── user.py                  # Utilisateurs/Praticiens
│   │   ├── centre.py                # Centres (multi-tenant)
│   │   ├── patient.py               # Patients (RGPD)
│   │   ├── appointment.py           # Rendez-vous
│   │   └── audit_log.py             # Logs traçabilité
│   ├── routes/                      # 5 blueprints REST
│   │   ├── auth.py                  # JWT authentication
│   │   ├── patients.py              # Patients CRUD
│   │   ├── appointments.py          # Appointments CRUD
│   │   ├── centres.py               # Centres management
│   │   └── audit.py                 # Audit logs
│   └── utils/                       # Utilitaires
│       ├── decorators.py            # @jwt_required, @centre_required
│       └── validators.py            # Validation données
├── config.py                        # Configuration environnements
├── run.py                           # Point d'entrée
├── requirements.txt                 # Dépendances Python
├── .env                             # Variables environnement
└── README.md                        # Documentation complète
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

**🔥 PRIORITÉ HAUTE (Prochaine session)** :
1. **Adapter services Flutter** : Créer DataService abstrait avec 2 implémentations (Firebase + Flask)
2. **Documentation juridique** : Guide praticien, CGU/CGV, modèle consentement patient (Option C)
3. **Déployer demo.medidesk.fr** : Firebase Hosting (`firebase deploy --only hosting`)

**📋 PRIORITÉ MOYENNE** :
4. **Tests backend** : pytest + tests d'intégration
5. **Chiffrement SQLite** : SQLCipher pour données sensibles
6. **Script installation** : Exe Windows pour installation locale
7. **APK Android** : Build production pour démo mobile

**🔮 PRIORITÉ BASSE** :
8. IA médicale (aide diagnostic)
9. Téléconsultation P2P
10. Interopérabilité Doctolib/Maiia

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

**Dernière mise à jour** : 22/11/2024 - Session Options B+A (Déploiement + Backend Flask)  
**Version** : 1.1.0  
**Statut** : 
- Frontend Flutter : ✅ Production-ready (Firebase)
- Backend Flask : ✅ Complet et fonctionnel (port 5000)
- Déploiement : 🔜 Prêt pour demo.medidesk.fr
