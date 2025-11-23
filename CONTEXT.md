# 📘 CONTEXT - MediDesk Documentation Complète

**Documentation technique et stratégique pour le développement de MediDesk**

---

## 🎯 VISION STRATÉGIQUE

### Mission
Révolutionner la gestion des cabinets de kinésithérapie et d'ostéopathie avec une solution **locale-first**, respectueuse de la vie privée et économiquement accessible.

### Positionnement marché
**"Le Linux du logiciel médical"** - Open, local, souverain

### Différenciation vs concurrence

| Critère | Doctolib | Maiia | MediDesk |
|---------|----------|-------|----------|
| **Données locales** | ❌ Cloud | ❌ Cloud | ✅ Local-first |
| **Coût démarrage** | Élevé | Moyen | **0€** |
| **Dossier patient complet** | ✅ | Limité | ✅ |
| **IA médicale** | ❌ | ❌ | 🔜 Roadmap |
| **Interopérabilité** | Fermé | Fermé | ✅ Ouvert |
| **Propriété données** | Plateforme | Plateforme | **Praticien** |
| **Conformité HDS** | ✅ Obligatoire | ✅ Obligatoire | ✅ Option (si SaaS) |

---

## 🏗️ ARCHITECTURE TECHNIQUE

### Architecture hybride (MODE DEMO + MODE LOCAL)

```
┌─────────────────────────────────────────────────────────┐
│  FRONTEND FLUTTER (unique pour les 2 modes)             │
│  ┌───────────────────────────────────────────────────┐  │
│  │  UI Screens (Auth, Dashboard, Patients, RDV)     │  │
│  └───────────────────────────────────────────────────┘  │
│                        ↓                                 │
│  ┌───────────────────────────────────────────────────┐  │
│  │  DataService (interface abstraite)               │  │
│  │  → Permet de basculer entre Firebase et Flask    │  │
│  └───────────────────────────────────────────────────┘  │
│           ↙                              ↘              │
└─────────────────────────────────────────────────────────┘
            ↙                                      ↘
┌──────────────────────┐              ┌──────────────────────┐
│  MODE DEMO           │              │  MODE LOCAL          │
│  (demo.medidesk.fr)  │              │  (Cabinet Tourcoing) │
├──────────────────────┤              ├──────────────────────┤
│  Backend Firebase    │              │  Backend Flask       │
│  - Firebase Auth     │              │  - JWT Auth          │
│  - Firestore         │              │  - SQLite Database   │
│  - Cloud Storage     │              │  - Chiffrement AES   │
│                      │              │  - Logs audit RGPD   │
│  ✅ Données fictives │              │  ✅ Données réelles  │
│  ✅ Accès public     │              │  ✅ 100% local       │
│  ✅ 0€ (free tier)   │              │  ✅ 0€ hébergement   │
│  ✅ Formation        │              │  ✅ PC salle soins   │
└──────────────────────┘              └──────────────────────┘
```

### Stack technique

**Frontend (unique)** :
- Flutter 3.35.4 (LOCKED - ne pas updater)
- Dart 3.9.2 (LOCKED - ne pas updater)
- Provider (state management)
- Material Design 3
- Localisation française complète

**Backend MODE DEMO** :
- Firebase Auth (authentification)
- Firestore (base NoSQL)
- Cloud Storage (documents)
- Cloud Functions (logique serveur)

**Backend MODE LOCAL** (EN DÉVELOPPEMENT) :
- Flask 3.0.0 (API REST)
- SQLAlchemy (ORM)
- SQLite (base locale chiffrée)
- JWT (authentification)
- CORS (communication Flutter)

---

## 📊 MODÈLE DE DONNÉES

### Schéma de base de données

```sql
-- Table CENTRES (multi-tenant)
CREATE TABLE centres (
    id TEXT PRIMARY KEY,
    nom TEXT NOT NULL,
    adresse TEXT,
    telephone TEXT,
    email TEXT,
    horaires_debut TEXT DEFAULT '08:00',
    horaires_fin TEXT DEFAULT '19:00',
    jours_travail TEXT DEFAULT 'lundi,mardi,mercredi,jeudi,vendredi',
    duree_consultation_defaut INTEGER DEFAULT 30,
    cree_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifie_le DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table USERS (praticiens)
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    centre_id TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    specialite TEXT,
    telephone TEXT,
    role TEXT DEFAULT 'praticien', -- admin, praticien, secretaire
    actif BOOLEAN DEFAULT TRUE,
    cree_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    derniere_connexion DATETIME,
    FOREIGN KEY (centre_id) REFERENCES centres(id)
);

-- Table PATIENTS (données sensibles - chiffrement requis)
CREATE TABLE patients (
    id TEXT PRIMARY KEY,
    centre_id TEXT NOT NULL,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    date_naissance DATE,
    sexe TEXT,
    telephone TEXT,
    email TEXT,
    adresse TEXT,
    numero_securite_sociale TEXT, -- À CHIFFRER
    medecin_traitant TEXT,
    mutuelle TEXT,
    numero_mutuelle TEXT,
    notes TEXT, -- À CHIFFRER
    antecedents TEXT, -- À CHIFFRER
    allergies TEXT, -- À CHIFFRER
    actif BOOLEAN DEFAULT TRUE,
    cree_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifie_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (centre_id) REFERENCES centres(id)
);

-- Table APPOINTMENTS (rendez-vous)
CREATE TABLE appointments (
    id TEXT PRIMARY KEY,
    centre_id TEXT NOT NULL,
    praticien_id TEXT NOT NULL,
    patient_id TEXT NOT NULL,
    date_heure DATETIME NOT NULL,
    duree INTEGER DEFAULT 30, -- minutes
    type TEXT DEFAULT 'consultation',
    motif TEXT,
    statut TEXT DEFAULT 'planifie', -- planifie, confirme, en_cours, termine, annule
    notes TEXT,
    cree_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifie_le DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (centre_id) REFERENCES centres(id),
    FOREIGN KEY (praticien_id) REFERENCES users(id),
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- Table AUDIT_LOGS (traçabilité RGPD obligatoire)
CREATE TABLE audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    user_email TEXT,
    action TEXT NOT NULL, -- login, create_patient, update_patient, etc.
    resource_type TEXT, -- patient, appointment, etc.
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    user_agent TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Index pour optimisation des requêtes
CREATE INDEX idx_patients_centre_actif ON patients(centre_id, actif);
CREATE INDEX idx_patients_nom_prenom ON patients(nom, prenom);
CREATE INDEX idx_appointments_centre_date ON appointments(centre_id, date_heure);
CREATE INDEX idx_appointments_praticien_date ON appointments(praticien_id, date_heure);
CREATE INDEX idx_audit_user_timestamp ON audit_logs(user_id, timestamp);
```

---

## 🔒 CONFORMITÉ JURIDIQUE (RGPD + DONNÉES DE SANTÉ)

### ⚠️ OBLIGATIONS LÉGALES CRITIQUES

**ATTENTION** : Même en local, MediDesk traite des **données de santé**.  
Les obligations légales s'appliquent **dès le premier utilisateur**.

### Ce qui est OBLIGATOIRE (même sans HDS)

✅ **Chiffrement** :
- Données au repos (SQLite chiffré avec SQLCipher)
- Données en transit (HTTPS/TLS obligatoire)
- Mots de passe hashés (bcrypt/argon2)

✅ **Traçabilité** :
- Logs d'audit pour chaque accès/modification
- Conservation logs 3 ans minimum
- Export logs pour contrôle CNIL

✅ **Consentement patient** :
- Consentement explicite documenté
- Droit d'accès, rectification, suppression
- Export données patient (portabilité)

✅ **Responsabilités** :
- DPO (Délégué à la Protection des Données) - peut être externe
- Analyse d'impact (AIPD) sur la vie privée
- Registre des traitements

### Parade juridique MediDesk

```
┌─────────────────────────────────────────────────┐
│  MODÈLE "RESPONSABILITÉ PRATICIEN"              │
├─────────────────────────────────────────────────┤
│  Le praticien = Responsable de traitement      │
│  MediDesk = Fournisseur d'outil conforme       │
│                                                  │
│  ✅ Praticien gère ses données localement       │
│  ✅ MediDesk ne stocke ni n'héberge             │
│  ✅ Conformité "Privacy by Design"              │
│  ✅ Documentation juridique blindée fournie     │
└─────────────────────────────────────────────────┘
```

### Documents juridiques à fournir

1. **Guide praticien** (responsabilités RGPD)
2. **CGU/CGV MediDesk**
3. **Modèle consentement patient**
4. **Procédure gestion droits patients**
5. **Registre des traitements pré-rempli**
6. **Notice d'information CNIL**

---

## 🚀 ROADMAP DÉVELOPPEMENT

### ✅ Phase B : Authentification (TERMINÉE)
- Écran connexion/déconnexion moderne
- Firebase Auth intégré
- Comptes de test fonctionnels
- Déconnexion rapide (bouton AppBar)

### ✅ Phase C : Dashboard + Patients (TERMINÉE)
- Dashboard avec statistiques
- Liste patients (recherche, filtres)
- Formulaire création/édition patient
- Détails patient
- Multi-tenancy (isolation par centre)

### ✅ Phase D : Système de réservation (TERMINÉE)
- Calendrier mensuel interactif (table_calendar)
- Création RDV (DatePicker français)
- Modification/Annulation RDV
- Gestion statuts (5 états)
- Affichage détaillé RDV

### ✅ Phase E : Backend Flask REST API (TERMINÉE - 22/11/2024)
- **Backend Flask complet** : 40+ fichiers créés
- **5 routes REST** : auth, patients, appointments, centres, audit
- **5 modèles SQLAlchemy** : User, Centre, Patient, Appointment, AuditLog
- **Authentification JWT** : login, register, refresh, logout, change password
- **Sécurité** : bcrypt, verrouillage compte, validation données
- **RGPD** : Logs d'audit automatiques, multi-tenant, données sensibles identifiées
- **Configuration** : .env, multi-environnements (dev, test, prod)
- **Documentation** : README.md complet, structure claire
- **Tests** : Backend démarre et fonctionne (port 5000)

### ✅ Option B : Préparation déploiement demo.medidesk.fr (TERMINÉE - 22/11/2024)
- **Guide déploiement** : DEPLOYMENT_GUIDE.md (4 options)
- **Documentation publique** : README_DEMO.md
- **Configuration Firebase Hosting** : firebase.json, .firebaserc
- **Optimisations SEO** : Meta tags, Open Graph, Twitter Cards
- **PWA optimisé** : manifest.json amélioré
- **Build production** : flutter build web --release (17.2s)
- **Corrections compatibilité** : auth_provider, user model, home_screen
- **Prêt pour déploiement** : `firebase deploy --only hosting`

### 🔄 Phase F : Architecture Hybride (EN COURS - Prochaine session)
- DataService abstrait (interface commune) ← **PRIORITÉ ACTUELLE**
- Implémentation Firebase (démo publique)
- Implémentation Flask (installation locale)
- Switcher mode demo/local dans l'app
- Chiffrement SQLite (SQLCipher)
- Script installation Windows

### 🔜 Phase G : Documentation juridique (Prochaine session)
- Guide praticien (responsabilités RGPD)
- CGU/CGV MediDesk
- Modèle consentement patient
- Procédure gestion droits patients
- Registre des traitements pré-rempli
- Notice d'information CNIL

### 🔜 Phase H : Fonctionnalités avancées (Q1 2025)
- Dossiers médicaux (consultations, prescriptions)
- Facturation et comptabilité
- Téléconsultation sécurisée P2P
- IA médicale (aide diagnostic)
- Notifications et rappels

### 🔜 Phase I : Interopérabilité (Q2 2025)
- Import agendas Doctolib/Maiia
- Export vers plateformes tierces
- API publique documentée
- Format HL7 FHIR

---

## 📁 STRUCTURE DU PROJET

```
/home/user/
├── flutter_app/                     # Frontend Flutter
│   ├── lib/
│   │   ├── main.dart                # Point d'entrée
│   │   ├── models/                  # Modèles de données
│   │   │   ├── user_model.dart
│   │   │   ├── centre_model.dart
│   │   │   ├── patient_model.dart
│   │   │   └── appointment_model.dart
│   │   ├── services/                # Services backend
│   │   │   ├── firebase_auth_service.dart
│   │   │   ├── firestore_patient_service.dart
│   │   │   ├── firestore_appointment_service.dart
│   │   │   └── local_flask_service.dart (À CRÉER)
│   │   ├── providers/               # State management
│   │   │   ├── auth_provider.dart
│   │   │   ├── patient_provider.dart
│   │   │   └── appointment_provider.dart
│   │   └── screens/                 # UI
│   │       ├── auth/
│   │       │   ├── login_screen.dart
│   │       │   ├── signup_screen.dart
│   │       │   └── loading_screen.dart
│   │       ├── dashboard/
│   │       │   ├── dashboard_screen.dart
│   │       │   └── home_screen.dart
│   │       ├── patients/
│   │       │   ├── patients_list_screen.dart
│   │       │   ├── patient_detail_screen.dart
│   │       │   └── patient_form_screen.dart
│   │       └── appointments/
│   │           ├── calendar_screen.dart
│   │           ├── appointment_form_screen.dart
│   │           └── appointment_detail_screen.dart
│   ├── android/                     # Config Android
│   ├── web/                         # Config Web
│   ├── pubspec.yaml                 # Dépendances
│   ├── AI_QUICK_START.md            # Guide express IA
│   └── CONTEXT.md                   # Ce fichier
│
└── medidesk_backend/                # Backend Flask (EN DÉVELOPPEMENT)
    ├── app/
    │   ├── __init__.py              # Factory Flask
    │   ├── models.py                # Modèles SQLAlchemy
    │   ├── routes/                  # API REST
    │   │   ├── auth.py
    │   │   ├── patients.py
    │   │   ├── appointments.py
    │   │   ├── centres.py
    │   │   └── audit.py
    │   └── utils/
    │       ├── encryption.py        # Chiffrement SQLite
    │       └── audit_logger.py      # Logs RGPD
    ├── migrations/                  # Migrations DB
    ├── tests/                       # Tests unitaires
    ├── requirements.txt             # Dépendances Python
    ├── config.py                    # Configuration
    └── run.py                       # Lancement serveur
```

---

## 🔧 DÉVELOPPEMENT

### Commandes essentielles

```bash
# Flutter
cd /home/user/flutter_app
flutter pub get              # Installer dépendances
flutter analyze              # Analyser code
flutter build web --release  # Build production

# Backend Flask (quand prêt)
cd /home/user/medidesk_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask db init
flask db migrate
flask db upgrade
flask run --port=5000

# Git
git status
git add -A
git commit -m "Message"
git push origin base
```

### Variables d'environnement

**Flutter** :
```bash
export FLUTTER_MODE=demo    # ou 'local'
export API_BASE_URL=http://localhost:5000  # pour mode local
```

**Flask** :
```bash
export FLASK_APP=run.py
export FLASK_ENV=development
export SECRET_KEY=your-secret-key
export JWT_SECRET_KEY=your-jwt-secret
export DATABASE_URL=sqlite:///medidesk_local.db
```

---

## 🐛 PROBLÈMES CONNUS ET SOLUTIONS

### ✅ RÉSOLUS

| Problème | Solution | Commit |
|----------|----------|--------|
| Liste patients vide | Simplification requêtes Firestore | `601c3c5` |
| Comptes test absents | Script `create_test_accounts.py` | `7ecb521` |
| Déconnexion ne fonctionne pas | Réinitialisation état provider | `81171bd` |
| Stats dashboard erreur | Filtrage dates en mémoire | `6b97485` |
| Bouton logout invisible | Bouton rapide AppBar | `8b9e37f` |
| Interface login obsolète | Design moderne Card | `2e8d16a` |
| DatePicker fond gris | table_calendar 3.2.0 + localisation | `27f014c` |

### ⚠️ EN COURS

- Backend Flask REST API (Phase E)
- Architecture hybride DataService
- Chiffrement SQLite
- Logs d'audit RGPD

---

## 📞 CONTACTS & RESSOURCES

### Équipe
- **Responsable** : Développement MediDesk
- **Target** : Cabinets kinésithérapie/ostéopathie France

### Resources
- **GitHub** : https://github.com/RBSoftwareAI/kine
- **Firebase Console** : https://console.firebase.google.com/
- **Preview URL** : https://5060-ix0ake2l8sv44i0ezuq5t-2e77fc33.sandbox.novita.ai

### Support IA
- Lire **AI_QUICK_START.md** en premier
- Consulter **CONTEXT.md** pour détails
- Vérifier `git log` pour historique
- Tester avec `flutter analyze`

---

## 🎯 PRIORITÉS ACTUELLES

**🔥 HAUTE PRIORITÉ (Prochaine session)** :
1. ✅ ~~Backend Flask REST API complet~~ (TERMINÉ 22/11/2024)
2. 🔄 Adapter services Flutter : Créer DataService abstrait (Firebase + Flask)
3. 🔄 Documentation juridique RGPD complète (Option C - 6 documents)
4. 🔄 Déployer demo.medidesk.fr (Firebase Hosting)

**📋 MOYENNE PRIORITÉ** :
5. ⏳ Tests backend Flask (pytest + intégration)
6. ⏳ Chiffrement SQLite (SQLCipher pour production)
7. ⏳ Script installation Windows (.exe)
8. ⏳ Tests unitaires Flutter
9. ⏳ Build APK Android

**🔮 BASSE PRIORITÉ** :
10. 🔜 Guide utilisateur final
11. 🔜 IA médicale (aide diagnostic)
12. 🔜 Interopérabilité Doctolib/Maiia
13. 🔜 Téléconsultation P2P

---

**Dernière mise à jour** : 22/11/2024 - Session Options B+A  
**Version** : 1.1.0  
**Statut projet** : 
- Frontend Flutter : ✅ MVP complet (Firebase) - Production-ready
- Backend Flask : ✅ REST API complet (auth, patients, appointments, centres, audit)
- Déploiement : 🔜 Prêt pour demo.medidesk.fr
- Documentation : 📚 Complète (DEPLOYMENT_GUIDE, README_DEMO, SESSION_SUMMARY)
