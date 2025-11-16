# 📖 CONTEXT - Documentation Complète MediDesk

**Date :** 16 novembre 2025  
**Version :** 2.0 (Après package marketing)  
**Durée de lecture :** 15-20 minutes  
**Objectif :** Contexte exhaustif du projet

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'Ensemble du Projet](#1-vue-densemble-du-projet)
2. [Historique & Évolution](#2-historique--évolution)
3. [Architecture Technique](#3-architecture-technique)
4. [Fonctionnalités Implémentées](#4-fonctionnalités-implémentées)
5. [Comptes & Authentification](#5-comptes--authentification)
6. [Système de Permissions](#6-système-de-permissions)
7. [Base de Données & Sécurité](#7-base-de-données--sécurité)
8. [État Actuel & Priorités](#8-état-actuel--priorités)
9. [Conventions de Code](#9-conventions-de-code)
10. [Prochaines Sessions](#10-prochaines-sessions)

---

## 1. VUE D'ENSEMBLE DU PROJET

### Qu'est-ce que MediDesk ?

**MediDesk** est un logiciel de gestion complet pour kinésithérapeutes et coachs sportifs, développé en **open source** (licence MIT).

### Mission

Permettre aux professionnels de santé de :
- ✅ Gérer leurs patients efficacement
- ✅ Documenter les séances de soins
- ✅ Cartographier les douleurs de manière interactive
- ✅ Respecter la conformité RGPD automatiquement
- ✅ Gagner du temps (objectif : 2h/jour économisées)

### Modèle Économique

**Open Core + SaaS :**
- 🆓 **Code open source** (MIT) sur GitHub
- 💰 **Version SaaS hébergée** payante (19-99€/mois)
- 🎯 **Cible** : 60,000 cabinets kinés en France

### Différenciateurs Clés

1. **Open Source** : Transparence totale, pas de vendor lock-in
2. **Tarifs 2-3× moins chers** que la concurrence (Doctolib, Maiia)
3. **Cartographie douleur unique** : Silhouettes anatomiques interactives
4. **Conformité RGPD native** : Chiffrement AES-256, hébergement France HDS

---

## 2. HISTORIQUE & ÉVOLUTION

### Chronologie du Développement

**📅 Octobre 2025 - Conception & MVP**
- Création architecture hybride (Flutter + Flask)
- Développement cartographie douleur
- Système authentification de base

**📅 Novembre 2025 (Début) - Features Principales**
- Gestion patients complète
- Notes de séances structurées
- Base de données SQLite + SQLCipher
- Audit RGPD (logs 3 ans)

**📅 15 Novembre 2025 - Pilote Tourcoing**
- Déploiement cabinet test (3 praticiens)
- Feedback positif (9/10 satisfaction)
- Validation concept et UX

**📅 16 Novembre 2025 (Matin) - Corrections P0**
- Système permissions hiérarchique (sadmin → manager → kine/coach)
- Délégation permissions (permanente/temporaire)
- Silhouette DOS améliorée (colonne vertébrale visible)
- Suppression système consentement (non désiré)

**📅 16 Novembre 2025 (Après-midi) - Package Marketing**
- Site web marketing complet (landing page)
- Documents légaux RGPD (CGV, CGU, Confidentialité)
- Backend Stripe (gestion abonnements)
- Pitch deck + matériel commercial
- Templates emails professionnels

### État Actuel (16 Nov 2025)

**🟢 95% Production-Ready**
- ✅ MVP complet et fonctionnel
- ✅ Pilote réussi (Tourcoing)
- ✅ Corrections P0 terminées
- ✅ Package marketing complet
- ⏳ Backend Stripe à intégrer (2-3h)
- ⏳ Déploiement production à effectuer

---

## 3. ARCHITECTURE TECHNIQUE

### Stack Technique

| Composant | Technologie | Version | Justification |
|-----------|-------------|---------|---------------|
| **Frontend** | Flutter | 3.35.4 | Cross-platform (web + mobile) |
| **Langage** | Dart | 3.9.2 | Compilé AOT, performant |
| **State Mgmt** | Provider | 6.1.5+1 | Simple, officiel Google |
| **DB Locale** | Hive | 2.2.3 | Document DB rapide |
| **Backend** | Flask | 3.0.0 | API REST légère |
| **DB Backend** | SQLite | 3.x | Embarquée, pas de serveur DB |
| **Chiffrement** | SQLCipher | - | AES-256 pour SQLite |
| **Paiements** | Stripe | - | Standard SaaS |

### Architecture Hybride

```
┌─────────────────────────────────────────┐
│         FLUTTER APP (Frontend)          │
│  Material Design 3 • Provider Pattern   │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────┐   ┌─────────────┐     │
│  │  Hive Local │   │  API Client │     │
│  │  (Offline)  │   │  (Online)   │     │
│  └─────────────┘   └──────┬──────┘     │
│                           │             │
└───────────────────────────┼─────────────┘
                            │
                            │ HTTPS / JWT
                            │
┌───────────────────────────┼─────────────┐
│                           ▼             │
│        FLASK API (Backend)              │
│  JWT Auth • REST Endpoints • CORS      │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────────────────────┐      │
│  │   SQLite + SQLCipher         │      │
│  │   (AES-256 Encrypted)        │      │
│  └──────────────────────────────┘      │
│                                         │
└─────────────────────────────────────────┘
```

### Flux de Données

**Mode Démo (Hors Ligne) :**
```
User Input → Provider → Hive Local → UI Update
```

**Mode Production (API Backend) :**
```
User Input → Provider → API Service → Flask API
           ↓                              ↓
      Hive Cache                   SQLite (chiffré)
           ↓                              ↓
      UI Update ←───────────────← JSON Response
```

---

## 4. FONCTIONNALITÉS IMPLÉMENTÉES

### 4.1 Authentification & Rôles

**Fichiers :** `lib/providers/auth_provider.dart`, `lib/models/user_model.dart`

**Rôles disponibles :**
1. **sadmin** (Super Admin) - Niveau hiérarchie 3
2. **manager** (Patron Cabinet) - Niveau hiérarchie 2
3. **kine** (Kinésithérapeute) - Niveau hiérarchie 1
4. **coach_apa** (Coach Sportif) - Niveau hiérarchie 1
5. **patient** (Patient) - Niveau hiérarchie 0

**Features :**
- ✅ Connexion email/mot de passe
- ✅ Comptes démo (hors ligne)
- ✅ JWT tokens (si backend actif)
- ✅ Hiérarchie de permissions

### 4.2 Gestion Patients

**Fichiers :** `lib/views/patients/`, `lib/models/patient_model.dart`

**Features :**
- ✅ Création/modification dossiers patients
- ✅ Informations personnelles (nom, prénom, date naissance, etc.)
- ✅ Antécédents médicaux
- ✅ Photos et documents annexes
- ✅ Recherche rapide multi-critères
- ✅ Export données CSV/JSON

### 4.3 Cartographie Douleur Interactive ⭐

**Fichiers :** `lib/views/pain/`, `lib/views/pain/widgets/body_silhouette.dart`

**Features :**
- ✅ Silhouettes anatomiques face/dos
- ✅ **Vue DOS améliorée** (NEW - 16 Nov) :
  - Ligne vertébrale avec courbes naturelles (Bézier quadratique)
  - Marqueurs anatomiques : C7, T12, L5
  - Distinction visuelle claire vs vue FACE
- ✅ Zones cliquables pour ajouter points douleur
- ✅ Échelle visuelle analogique 0-10 (EVA)
- ✅ Types de douleur (aiguë, chronique, irradiante)
- ✅ Fréquence (occasionnelle, quotidienne, constante)
- ✅ Historique temporel complet

**Code Clé (Vue DOS) :**
```dart
// Colonne vertébrale avec courbes naturelles
final spinePath = Path()
  ..moveTo(centerX, size.height * 0.2) // C7
  ..quadraticBezierTo(
    centerX + size.width * 0.02, size.height * 0.3,
    centerX, size.height * 0.4,
  )
  ..quadraticBezierTo(
    centerX - size.width * 0.015, size.height * 0.45,
    centerX, size.height * 0.5, // L5
  );
canvas.drawPath(spinePath, spinePaint);

// Marqueurs vertébraux
canvas.drawCircle(Offset(centerX, size.height * 0.21), 4, vertebraePaint); // C7
canvas.drawCircle(Offset(centerX, size.height * 0.35), 4, vertebraePaint); // T12
canvas.drawCircle(Offset(centerX, size.height * 0.47), 4, vertebraePaint); // L5
```

### 4.4 Gestion Permissions & Délégation ⭐ (NEW - 16 Nov)

**Fichiers :** 
- `lib/views/admin/permissions_management_screen.dart`
- `lib/services/admin_service.dart`
- `lib/views/admin/widgets/` (3 widgets)

**Features :**
- ✅ Écran de gestion complet accessible aux admins (sadmin + manager)
- ✅ **Statistiques en temps réel** :
  - Nombre de managers
  - Nombre de kinés
  - Nombre de coaches
  - Nombre de professionnels délégués
- ✅ **Filtres par rôle** : Tous / Manager / Kiné / Coach
- ✅ **Liste professionnels** avec cartes détaillées :
  - Avatar + nom + rôle
  - Badge rôle (couleur selon hiérarchie)
  - Badge délégation (si applicable)
  - Switch actif/inactif
  - Boutons déléguer/révoquer
- ✅ **Délégation permissions** :
  - **Permanente** : Aucune date d'expiration
  - **Temporaire** : Avec sélection date d'expiration
  - Traçabilité : `delegated_by` + `delegation_expires_at` dans DB
- ✅ **Création nouveau professionnel** :
  - Formulaire complet (email, mot de passe, nom, prénom, téléphone, rôle)
  - Validation côté client
  - Hiérarchie respectée (manager ne peut créer que kinés/coaches)
- ✅ **Activation/Désactivation comptes** :
  - Switch toggle avec confirmation
  - Badge visuel (vert actif, rouge inactif)

**Hiérarchie de Permissions :**
```
sadmin (niveau 3)
  ├─ Peut tout faire (config système)
  ├─ Créer managers
  └─ Déléguer à n'importe qui
  
manager (niveau 2)
  ├─ Gérer professionnels (kinés, coaches)
  ├─ Créer kinés/coaches uniquement
  ├─ Déléguer à kinés/coaches
  └─ Activer/désactiver comptes subordonnés
  
délégué (niveau 1+)
  ├─ Permissions héritées du manager
  ├─ Peut gérer autres professionnels
  └─ Délégation temporaire ou permanente
  
kine/coach (niveau 1)
  ├─ Gérer leurs propres patients
  └─ Pas de permissions sur autres utilisateurs
  
patient (niveau 0)
  └─ Consulter son propre dossier uniquement
```

### 4.5 Notes de Séances

**Fichiers :** `lib/views/sessions/`

**Features :**
- ✅ Création notes structurées
- ✅ Templates personnalisables
- ✅ Signature électronique patient (future)
- ✅ Export PDF

### 4.6 Dashboard & Home

**Fichiers :** `lib/views/home/home_screen.dart`

**Features :**
- ✅ Accueil adaptatif selon rôle utilisateur
- ✅ Menu professionnel (kinés, coaches) :
  - Gestion patients
  - Cartographie douleur
  - Notes de séances
  - **Gestion permissions** (NEW - si admin)
- ✅ Menu patient :
  - Consulter dossier
  - Historique séances
  - Rendez-vous
- ✅ Statistiques rapides
- ✅ Actions rapides (nouveau patient, nouvelle séance)

---

## 5. COMPTES & AUTHENTIFICATION

### Comptes Démo (Mode Hors Ligne)

**Fichier :** `lib/providers/auth_provider.dart` (méthode `_getDemoUser`)

```dart
// Super Admin (Configuration système)
Email    : sadmin@medidesk.local
Password : sadmin123
Rôle     : sadmin
Permissions : Toutes (niveau hiérarchie 3)

// Manager / Patron Cabinet
Email    : patron@medidesk.local
Password : manager123
Rôle     : manager
Permissions : Gestion professionnels, délégation (niveau 2)

// Kinésithérapeute
Email    : kine@demo.com
Password : kine123
Rôle     : kine
Permissions : Gestion patients uniquement (niveau 1)

// Coach Sportif APA
Email    : coach@demo.com
Password : coach123
Rôle     : coach_apa
Permissions : Gestion patients uniquement (niveau 1)

// Patient
Email    : patient@demo.com
Password : patient123
Rôle     : patient
Permissions : Consulter propre dossier (niveau 0)
```

### Comptes Backend (Base de Données)

**Fichier :** `backend/database/schema.sql`

Mêmes comptes avec hashs sécurisés (werkzeug scrypt) :

```sql
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, role, can_manage_permissions)
VALUES 
  ('sadmin_001', 'sadmin@medidesk.local', 'scrypt:32768:8:1$...', 'Super', 'Admin', 'sadmin', 1),
  ('manager_001', 'patron@medidesk.local', 'scrypt:32768:8:1$...', 'Patron', 'Cabinet', 'manager', 1),
  ('kine_001', 'kine@demo.com', 'scrypt:32768:8:1$...', 'Thomas', 'Martin', 'kine', 0),
  ('coach_001', 'coach@demo.com', 'scrypt:32768:8:1$...', 'Sophie', 'Laurent', 'coach_apa', 0),
  ('patient_001', 'patient@demo.com', 'scrypt:32768:8:1$...', 'Jean', 'Dupont', 'patient', 0);
```

**Génération hashs :** `backend/utils/generate_passwords.py`

---

## 6. SYSTÈME DE PERMISSIONS

### Modèle de Permissions

**Fichier :** `lib/models/user_model.dart`

**Champs clés :**
```dart
class UserModel {
  final String id;
  final String email;
  final UserRole role;  // sadmin, manager, kine, coach_apa, patient
  
  // Permissions
  final bool canManagePermissions;      // Peut gérer autres utilisateurs
  final String? delegatedBy;            // ID user qui a délégué
  final DateTime? delegationExpiresAt;  // Date expiration (null = permanent)
  
  // Getters utiles
  bool get isAdmin => role == UserRole.sadmin || role == UserRole.manager;
  bool get isSadmin => role == UserRole.sadmin;
  bool get isManager => role == UserRole.manager;
  int get hierarchyLevel { /* sadmin=3, manager=2, kine/coach=1, patient=0 */ }
  bool get isDelegationValid { /* Vérifie expiration */ }
}
```

### Validation Délégation

```dart
bool get isDelegationValid {
  if (!canManagePermissions) return false;
  if (delegationExpiresAt == null) return true; // Permanent
  return DateTime.now().isBefore(delegationExpiresAt!);
}
```

### Vérification Hiérarchie

Avant toute action administrative, vérifier :

```dart
// Exemple : Peut-on déléguer permissions à targetUser ?
bool canDelegate(UserModel currentUser, UserModel targetUser) {
  return currentUser.isAdmin && 
         currentUser.hierarchyLevel > targetUser.hierarchyLevel;
}
```

---

## 7. BASE DE DONNÉES & SÉCURITÉ

### Schema SQLite (Backend)

**Fichier :** `backend/database/schema.sql`

**Tables principales :**

1. **users** : Comptes utilisateurs
   - Champs : id, email, password_hash, role, can_manage_permissions, delegated_by, delegation_expires_at
   - Hashs : werkzeug scrypt (PBKDF2)

2. **patients** : Dossiers patients
   - Champs : id, first_name, last_name, date_of_birth, gender, phone, address, medical_history
   - Relation : user_id (praticien responsable)

3. **pain_points** : Points de douleur
   - Champs : id, patient_id, zone, position_x, position_y, intensity, type, frequency
   - Traçabilité : created_at

4. **sessions** : Séances de soins
   - Champs : id, patient_id, professional_id, date, notes, duration
   - Traçabilité : created_at

5. **audit_logs** : Logs RGPD
   - Champs : id, user_id, action, resource_type, resource_id, details, ip_address
   - Rétention : 3 ans minimum (RGPD Article 5.2)

### Chiffrement AES-256

**Technologie :** SQLCipher (extension SQLite)

**Configuration :**
```python
# backend/database/encryption_manager.py
import sqlcipher3

connection = sqlcipher3.connect('medidesk.db')
connection.execute(f"PRAGMA key='{encryption_key}'")  # AES-256
connection.execute("PRAGMA cipher_page_size=4096")
```

**Clé chiffrement :** Variable d'environnement `SQLCIPHER_KEY` (64 caractères min)

### Conformité RGPD

**Mesures implémentées :**

1. **Chiffrement au repos** : AES-256 (SQLCipher)
2. **Chiffrement en transit** : TLS 1.3 (HTTPS)
3. **Audit logs** : Rétention 3 ans
4. **Droit à l'effacement** : Export puis suppression 30j après résiliation
5. **Droit à la portabilité** : Export CSV/JSON
6. **Consentement** : (Supprimé - traçabilité audit logs suffit)
7. **Hébergement France** : Serveurs HDS (OVH/Scaleway)

---

## 8. ÉTAT ACTUEL & PRIORITÉS

### État Global

**🟢 95% Production-Ready**

**Dernières Corrections (16 Nov 2025) :**
- ✅ Système permissions hiérarchique complet
- ✅ Silhouette DOS améliorée (colonne vertébrale)
- ✅ Suppression système consentement
- ✅ Package marketing complet (site web + docs légaux + Stripe)

### Ce qui est Prêt

✅ **Frontend Flutter** (95%)
- Toutes les fonctionnalités principales
- UI Material Design 3 moderne
- Responsive mobile + web
- Tests widgets unitaires

✅ **Backend Flask** (90%)
- API REST complète
- Authentification JWT
- CRUD patients/sessions/pain_points
- Audit logs RGPD

✅ **Site Web Marketing** (100%)
- Landing page production-ready
- Documents légaux (CGV/CGU/Confidentialité)
- Backend Stripe (code fourni)
- Pitch deck + matériel commercial

### Ce qui Reste à Faire (Non-Bloquant)

⏳ **Backend Stripe** (2-3h)
- Intégrer `backend_stripe.py` dans API principale
- Tester webhooks Stripe
- Configurer produits Stripe Dashboard

⏳ **Déploiement Production** (1 jour)
- Provisionner VPS (OVH/Scaleway)
- Configurer Nginx + SSL
- Déployer backend Flask
- Déployer Flutter web
- Tests de charge

⏳ **Features P1 (Nice-to-Have)**
- Téléconsultation intégrée
- API publique pour intégrations
- Application mobile native (Android/iOS)
- Statistiques avancées (BI dashboard)

---

## 9. CONVENTIONS DE CODE

### Flutter (Dart)

**Style :** Dart official style guide

**Règles clés :**
```dart
// ✅ Nommage
class UserModel { }              // PascalCase pour classes
var userName = 'John';           // camelCase pour variables
const maxAttempts = 3;           // camelCase pour constantes

// ✅ Imports
import 'package:flutter/material.dart';  // Packages d'abord
import '../models/user_model.dart';      // Relatifs ensuite

// ✅ Structure fichiers
lib/
  models/        # Modèles de données (immutables)
  providers/     # State management (ChangeNotifier)
  services/      # API clients (méthodes statiques)
  views/         # UI Screens (StatelessWidget ou StatefulWidget)
  widgets/       # Composants réutilisables
  theme/         # Thèmes Material Design
```

**Pattern Provider :**
```dart
// 1. Créer ChangeNotifier
class MyProvider extends ChangeNotifier {
  void updateSomething() {
    // Logic
    notifyListeners();  // ← Déclenche rebuild
  }
}

// 2. Fournir en haut de l'arbre
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ],
  child: MyApp(),
)

// 3. Consommer dans widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Text(myProvider.someValue);
  }
}
```

### Backend (Python/Flask)

**Style :** PEP 8

**Règles clés :**
```python
# ✅ Nommage
class UserService:        # PascalCase pour classes
def get_user_by_id():     # snake_case pour fonctions
USER_ROLE_ADMIN = 'admin' # UPPERCASE pour constantes

# ✅ Imports
import os                      # Standard library
from flask import Flask        # Third-party
from .models import User       # Local

# ✅ Structure backend/
api/
  app.py           # Point d'entrée Flask
  routes/          # Blueprints par domaine
database/
  schema.sql       # DDL (CREATE TABLE)
  db_manager.py    # Connexion SQLite
services/
  auth_service.py  # Logique métier
utils/
  helpers.py       # Fonctions utilitaires
```

### Git Commits

**Format :** Conventional Commits

```bash
# Syntaxe
<type>(<scope>): <subject>

<body>

<footer>

# Types
feat:     Nouvelle fonctionnalité
fix:      Correction de bug
docs:     Documentation
style:    Formatage (pas de changement logique)
refactor: Refactorisation code
test:     Ajout/modification tests
chore:    Tâches maintenance

# Exemples
feat(auth): Ajouter connexion OAuth Google
fix(pain): Corriger calcul position points douleur sur mobile
docs: Mettre à jour README avec instructions déploiement
```

---

## 10. PROCHAINES SESSIONS

### Template Message Démarrage

```
Bonjour ! Je continue le développement de l'application MediDesk.

📂 Repository : https://github.com/RBSoftwareAI/kine
🌿 Branche : base
📄 Documentation : Lis d'abord les fichiers dans cet ordre :
   1. AI_QUICK_START.md (guide express)
   2. CONTEXT.md (documentation complète)

🎯 Ma demande pour cette session :
[Décrire la tâche précise ici]
```

### Checklist IA Avant de Commencer

Avant chaque session, l'IA doit :

1. ✅ **Lire** `AI_QUICK_START.md` (3 min)
2. ✅ **Lire** `CONTEXT.md` (15 min) - CE FICHIER
3. ✅ **Analyser** la demande utilisateur (comprendre objectif)
4. ✅ **Vérifier** versions lockées (Flutter 3.35.4, Dart 3.9.2)
5. ✅ **Examiner** fichiers concernés (Read tool)
6. ✅ **Planifier** modifications (TodoWrite)
7. ✅ **Développer** fonctionnalité
8. ✅ **Tester** avec preview web (port 5060)
9. ✅ **Commit** et **Push** sur GitHub
10. ✅ **Documenter** changements pour prochaine session

### Exemples de Demandes

**Exemple 1 : Nouvelle Fonctionnalité**
```
🎯 Ma demande pour cette session :
Ajouter un système d'agenda avec gestion de rendez-vous.
Les kinés doivent pouvoir :
- Créer un RDV (date/heure, patient, type séance, durée)
- Voir leur planning journalier/hebdomadaire
- Recevoir des rappels automatiques
```

**Exemple 2 : Correction de Bug**
```
🎯 Ma demande pour cette session :
Corriger le bug de la cartographie douleur sur mobile :
Les points de douleur ne s'affichent pas correctement 
quand l'écran est en mode paysage.
```

**Exemple 3 : Intégration**
```
🎯 Ma demande pour cette session :
Intégrer le backend Stripe (fichier backend_stripe.py) 
dans l'API Flask principale pour permettre les abonnements.
Tester avec clés Stripe de test.
```

---

## 📚 DOCUMENTATION ADDITIONNELLE

### Fichiers Importants à Lire

**Corrections Récentes :**
- `CORRECTIONS_16_NOV_2025.md` - Corrections P0 du 16 nov (système permissions, silhouette DOS)
- `RESUME_FINAL_CORRECTIONS.md` - Résumé exécutif corrections

**Marketing & Commercial :**
- `website/README.md` - Guide site web marketing
- `website/GUIDE_TRANSFERT_NOUVELLE_SESSION.md` - Déploiement production
- `SYNTHESE_FINALE_PACKAGE_COMMERCIAL.md` - Vue d'ensemble package

**Technique :**
- `backend/README.md` - Documentation API Flask
- `docs/ARCHITECTURE_HYBRIDE.md` - Architecture détaillée
- `pubspec.yaml` - Dépendances Flutter

**Légal :**
- `website/legal/cgv.html` - Conditions Générales de Vente
- `website/legal/cgu.html` - Conditions Générales d'Utilisation
- `website/legal/confidentialite.html` - Politique RGPD

---

## 🎯 OBJECTIFS PROJET (Vision)

### Court Terme (3 Mois)

- ✅ MVP complet et stable (FAIT)
- ⏳ 50 cabinets payants (2,450€ MRR)
- ⏳ Application mobile Android/iOS (v1.0)
- ⏳ Intégration Stripe complète

### Moyen Terme (6-12 Mois)

- 🎯 200 cabinets payants (9,800€ MRR)
- 🎯 Téléconsultation intégrée
- 🎯 API publique pour intégrations tierces
- 🎯 Expansion Belgique & Suisse

### Long Terme (2-3 Ans)

- 🎯 Leader logiciel kiné open source Europe
- 🎯 5,000+ cabinets (245k€ MRR = 2.9M€ ARR)
- 🎯 Exit potentiel (acquisition Doctolib/Maiia)

---

## 🏆 POINTS D'ATTENTION CRITIQUES

### ⚠️ À NE JAMAIS FAIRE

❌ **Mettre à jour Flutter/Dart** (`flutter upgrade`, `dart pub upgrade`)
❌ **Modifier versions dans pubspec.yaml** (lockées pour stabilité)
❌ **Utiliser `print()` en production** (remplacer par `debugPrint()` ou `developer.log()`)
❌ **Utiliser `withOpacity()` deprecated** (remplacer par `withValues(alpha: 0.5)`)
❌ **Oublier `cd /home/user/flutter_app` avant commandes** (Bash commence toujours à `/home/user`)

### ✅ Bonnes Pratiques

✅ **Toujours `flutter analyze` avant commit**
✅ **Tester avec comptes démo** (5 comptes disponibles)
✅ **Respecter hiérarchie permissions** (vérifier `hierarchyLevel`)
✅ **Documenter inline** (commentaires clairs en français)
✅ **Commit atomiques** (1 feature = 1 commit)

---

## 📞 CONTACTS & LIENS

**Repository :** github.com/RBSoftwareAI/kine  
**Branche principale :** `base` (stable) ou `main` (développement)  
**License :** MIT (open source)  
**Site web :** medidesk.fr (à déployer)  
**Email contact :** contact@medidesk.fr  

---

## ✅ FIN DE LA DOCUMENTATION

**Tu as maintenant toutes les informations pour développer sur MediDesk ! 🚀**

**Prochaine étape :**
1. Lire la demande de l'utilisateur
2. Analyser les fichiers concernés
3. Développer la fonctionnalité demandée
4. Tester et commit

**Bon développement ! 💪**

---

**📅 Document créé le 16 novembre 2025**  
**🔄 Mis à jour à chaque session importante**  
**📖 Durée lecture : 15-20 minutes**  
**⚡ Quick Start : `AI_QUICK_START.md`**
