# 📘 CONTEXT COMPLET - MediDesk Demo

**Projet :** MediDesk - Système de Gestion Multi-Centres pour Professionnels de Santé  
**Date :** 19 Novembre 2025  
**Version :** 1.0.0  
**Package Android :** fr.medidesk.demo

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'Ensemble](#vue-densemble)
2. [Architecture Firebase](#architecture-firebase)
3. [Services Créés](#services-créés)
4. [Modèles de Données](#modèles-de-données)
5. [Base de Données](#base-de-données)
6. [Sécurité Firestore](#sécurité-firestore)
7. [Phases de Développement](#phases-de-développement)
8. [Configuration](#configuration)
9. [Déploiement](#déploiement)

---

## 🎯 VUE D'ENSEMBLE

### **Objectif du Projet**

MediDesk Demo est une application Flutter de gestion pour professionnels de santé avec :
- **Multi-tenant** : Isolation complète des données par centre
- **Gestion patients** : CRUD complet avec historique
- **Réservation RDV** : Calendrier + disponibilités + réservations publiques
- **Authentication** : Inscription avec création automatique de centre

### **Technologies**

- **Frontend :** Flutter 3.35.4 / Dart 3.9.2 (versions verrouillées)
- **Backend :** Firebase (Auth, Firestore, Storage, Functions)
- **State Management :** Provider 6.1.5+1
- **Database :** Cloud Firestore (NoSQL)
- **Calendrier :** table_calendar 3.1.2

### **Plateformes Cibles**

- ✅ Web (prioritaire pour démo)
- ✅ Android (package: fr.medidesk.demo)
- 📋 iOS (à configurer si nécessaire)

---

## 🔥 ARCHITECTURE FIREBASE

### **Configuration Firebase**

**Projet Firebase :** kinecare-81f52

**Fichiers de configuration :**
```
lib/firebase_options.dart              ✅ Multi-plateforme (Web/Android/iOS)
android/app/google-services.json       ✅ Configuration Android
/opt/flutter/firebase-admin-sdk.json   ✅ Clé backend Python
```

### **Services Firebase Utilisés**

| Service | Usage | Status |
|---------|-------|--------|
| **Authentication** | Email/Password | ✅ Activé |
| **Firestore** | Base de données | ✅ Opérationnel |
| **Storage** | Documents/Images | ✅ Configuré |
| **Functions** | Notifications (futur) | 📋 À configurer |

### **URLs Importantes**

- **Application Live :** https://5060-iwvw0ubiemorjzzgug549-2b54fc91.sandbox.novita.ai
- **Firebase Console :** https://console.firebase.google.com/
- **GitHub Repository :** https://github.com/RBSoftwareAI/kine

---

## 🛠️ SERVICES CRÉÉS

### **1. FirebaseAuthService**

**Fichier :** `lib/services/firebase_auth_service.dart` (4891 caractères)

**Responsabilités :**
- Inscription avec création automatique du centre
- Connexion / Déconnexion
- Réinitialisation mot de passe
- Récupération données utilisateur/centre
- Gestion erreurs Firebase Auth

**Méthodes principales :**

```dart
class FirebaseAuthService {
  // Inscription avec création centre
  Future<UserCredential> signup({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String specialite,
    required String centreName,
    required String centreAdresse,
    String? centreTelephone,
    String? centreEmail,
  });
  
  // Connexion
  Future<UserCredential> login(String email, String password);
  
  // Déconnexion
  Future<void> logout();
  
  // Réinitialisation mot de passe
  Future<void> resetPassword(String email);
  
  // Récupérer données utilisateur
  Future<User> getUserData(String uid);
  
  // Récupérer centre utilisateur
  Future<Centre> getUserCentre(String centreId);
}
```

**Workflow d'inscription :**
1. Créer compte Firebase Auth
2. Créer centre dans Firestore
3. Créer utilisateur dans Firestore avec `centre_id`
4. Mettre à jour profil Firebase Auth

### **2. AuthProvider**

**Fichier :** `lib/providers/auth_provider.dart` (4568 caractères)

**Responsabilités :**
- Gestion de l'état d'authentification global
- Écoute des changements d'auth Firebase
- Chargement automatique des données user/centre
- Gestion du loading et des erreurs

**État géré :**

```dart
class AuthProvider extends ChangeNotifier {
  firebase_auth.User? _firebaseUser;      // User Firebase Auth
  User? _appUser;                         // User Firestore
  Centre? _centre;                        // Centre Firestore
  bool _isLoading = false;
  String? _error;
  
  // Getters
  bool get isAuthenticated;
  User? get appUser;
  Centre? get centre;
  
  // Méthodes
  Future<bool> signup(...);
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<void> loadUserData();
}
```

**Utilisation dans l'app :**

```dart
// Dans main.dart
runApp(
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: MediDeskApp(),
  ),
);

// Dans les widgets
Consumer<AuthProvider>(
  builder: (context, auth, _) {
    if (auth.isLoading) return LoadingScreen();
    if (!auth.isAuthenticated) return LoginScreen();
    return DashboardScreen();
  },
)
```

---

## 📊 MODÈLES DE DONNÉES

### **1. Centre**

**Fichier :** `lib/models/centre.dart` (4167 caractères)

**Champs principaux :**
```dart
class Centre {
  final String id;
  final String nom;
  final String adresse;
  final String? telephone;
  final String? email;
  final String proprietaireId;           // ID premier utilisateur
  final int dureeConsultationDefaut;     // Minutes
  final String? heureOuverture;          // Format: "08:00"
  final String? heureFermeture;          // Format: "19:00"
  final List<int>? joursOuverture;       // 1=Lundi, 7=Dimanche
  final bool actif;
  final DateTime dateCreation;
}
```

**Méthodes :**
- `fromFirestore(DocumentSnapshot)` - Créer depuis Firestore
- `toFirestore()` - Convertir pour Firestore
- `copyWith(...)` - Copie immutable avec modifications

### **2. User (Professionnel de Santé)**

**Fichier :** `lib/models/user.dart` (3774 caractères)

**Champs principaux :**
```dart
class User {
  final String id;                       // Firebase Auth UID
  final String centreId;                 // ⚠️ CRITIQUE pour isolation
  final String nom;
  final String prenom;
  final String email;
  final String role;                     // 'admin', 'praticien', 'assistant'
  final String? specialite;              // 'Kinésithérapeute', etc.
  final String? numeroOrdre;
  final bool actif;
  final DateTime dateCreation;
  final DateTime? derniereConnexion;
  
  String get nomComplet => '$prenom $nom';
}
```

**Rôles :**
- `admin` : Propriétaire du centre, peut tout modifier
- `praticien` : Peut gérer patients et RDV
- `assistant` : Accès limité (futur)

### **3. Appointment (Rendez-vous)**

**Fichier :** `lib/models/appointment.dart` (4710 caractères)

**Champs principaux :**
```dart
class Appointment {
  final String id;
  final String centreId;                 // ⚠️ Isolation multi-tenant
  final String praticienId;              // ID de l'utilisateur
  final String? patientId;               // Null si RDV public
  final DateTime dateHeure;
  final int duree;                       // Minutes
  final String type;                     // 'consultation', 'suivi', etc.
  final String statut;                   // 'planifié', 'confirmé', 'terminé', 'annulé'
  
  // Pour RDV publics (sans compte patient)
  final String? patientNom;
  final String? patientPrenom;
  final String? patientTelephone;
  final String? patientEmail;
  
  DateTime get heureFin;
  bool get estPasse;
  bool get estAujourdhui;
}
```

**Statuts possibles :**
- `planifié` : RDV créé, en attente confirmation
- `confirmé` : RDV confirmé par patient/centre
- `en_cours` : Consultation en cours
- `terminé` : Consultation terminée
- `annulé` : RDV annulé

### **4. Patient**

**Fichier :** `lib/models/patient.dart` (existant)

**Champs principaux :**
```dart
class Patient {
  final String id;
  final String centreId;                 // ⚠️ Isolation multi-tenant
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String? telephone;
  final String? email;
  final String? adresse;
  final bool actif;
  final DateTime dateCreation;
}
```

---

## 🗄️ BASE DE DONNÉES

### **Collections Firestore**

| Collection | Documents | Description |
|------------|-----------|-------------|
| **centres** | 2 | Centres de santé (Paris, Lyon) |
| **users** | 6 | Professionnels (3 par centre) |
| **patients** | 20 | Patients (10 par centre) |
| **appointments** | 30 | Rendez-vous (15 par centre) |

### **Centres de Test**

**1. Cabinet Kiné Paris Centre**
- ID : `FNjyP2TYD1QXksh8ijke`
- Adresse : 15 Rue de Rivoli, 75001 Paris
- Tel : 01 42 60 38 38
- Email : contact@kine-paris-centre.fr

**2. Centre Ostéo Lyon**
- ID : `qMhGxTrAZfqRWTRB7LZT`
- Adresse : 42 Cours Vitton, 69006 Lyon
- Tel : 04 78 52 63 74
- Email : contact@osteo-lyon.fr

### **Script d'Initialisation**

**Fichier :** `scripts/init_firestore_demo.py` (9181 caractères)

**Utilisation :**
```bash
cd /home/user/flutter_app
python3 scripts/init_firestore_demo.py
```

**Résultats :**
- 2 centres créés
- 6 utilisateurs créés (Dr. Marie Lefebvre, Dr. Pierre Girard, Dr. Sophie Rousseau × 2 centres)
- 20 patients avec noms/prénoms réalistes
- 30 rendez-vous sur les 30 prochains jours

---

## 🔒 SÉCURITÉ FIRESTORE

### **Règles de Sécurité**

**Fichier :** `firestore.rules` (3129 caractères)

**⚠️ IMPORTANT :** Règles créées mais **pas encore publiées**  
**Action requise :** Firebase Console → Firestore Database → Règles → Publier

### **Fonctions Helper**

```javascript
// Vérifie si utilisateur est authentifié
function isAuthenticated() {
  return request.auth != null;
}

// Récupère le centre_id de l'utilisateur
function getUserCentreId() {
  return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.centre_id;
}

// Vérifie si appartient au même centre
function belongsToSameCentre(centreId) {
  return isAuthenticated() && getUserCentreId() == centreId;
}

// Vérifie si utilisateur est admin
function isAdmin() {
  return isAuthenticated() && 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
}
```

### **Règles par Collection**

**Centres :**
```javascript
match /centres/{centreId} {
  allow read: if belongsToSameCentre(centreId);
  allow create: if isAuthenticated();  // Inscription
  allow update: if belongsToSameCentre(centreId) && isAdmin();
  allow delete: if false;  // Pas de suppression
}
```

**Users :**
```javascript
match /users/{userId} {
  allow read: if isAuthenticated() && belongsToSameCentre(resource.data.centre_id);
  allow create: if isAuthenticated();  // Inscription
  allow update: if request.auth.uid == userId || isAdmin();
  allow delete: if false;
}
```

**Patients :**
```javascript
match /patients/{patientId} {
  allow read, write: if isAuthenticated() && belongsToSameCentre(resource.data.centre_id);
  allow create: if isAuthenticated();
}
```

**Appointments :**
```javascript
match /appointments/{appointmentId} {
  allow read, write: if isAuthenticated() && belongsToSameCentre(resource.data.centre_id);
  allow create: if true;  // ⚠️ Permet réservations publiques
}
```

### **Isolation Multi-Tenant**

**Principe :** Chaque requête doit filtrer par `centre_id`

```dart
// ✅ CORRECT - Filtrage automatique
final patients = await FirebaseFirestore.instance
    .collection('patients')
    .where('centre_id', isEqualTo: currentUser.centreId)
    .get();

// ❌ INTERDIT - Accès à un autre centre
final patients = await FirebaseFirestore.instance
    .collection('patients')
    .where('centre_id', isEqualTo: 'autre-centre-id')  // PERMISSION_DENIED
    .get();
```

---

## 📋 PHASES DE DÉVELOPPEMENT

### **Phase A : Backend & Database ✅ COMPLÉTÉE**

**Durée :** 1-2h  
**Status :** ✅ 100%

**Accomplissements :**
- ✅ Script Python backend créé
- ✅ 58 documents Firestore créés
- ✅ Règles de sécurité documentées

### **Phase B : Authentication 📋 EN COURS**

**Durée estimée :** 3-4h  
**Status :** Services ✅ 100%, Écrans 📋 0%

**Services créés :**
- ✅ FirebaseAuthService
- ✅ AuthProvider

**À développer :**
```
📋 lib/screens/auth/signup_screen.dart
   - Formulaire inscription
   - Validation champs
   - Création compte + centre
   
📋 lib/screens/auth/login_screen.dart
   - Formulaire connexion
   - Gestion erreurs
   - Lien mot de passe oublié
   
📋 Mise à jour main.dart
   - Intégration Provider
   - Router basé sur auth
   - Gestion states (loading, authenticated, etc.)
```

**Exemple SignupScreen :**
```dart
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _centreNameController = TextEditingController();
  final _centreAdresseController = TextEditingController();
  
  String _selectedSpecialite = 'Kinésithérapeute';
  
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signup(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      specialite: _selectedSpecialite,
      centreName: _centreNameController.text.trim(),
      centreAdresse: _centreAdresseController.text.trim(),
    );
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Erreur')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Tous les champs de formulaire
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            // ... autres champs
            ElevatedButton(
              onPressed: _handleSignup,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Phase C : Dashboard & Patients 📋 À FAIRE**

**Durée estimée :** 4-5h  
**Status :** 📋 0%

**À développer :**

**1. FirestoreRepository** (`lib/services/firestore_repository.dart`)
```dart
class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Patients
  Stream<List<Patient>> getPatients(String centreId) {
    return _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Patient.fromFirestore(doc))
            .toList());
  }
  
  Future<void> addPatient(Patient patient) async {
    await _firestore
        .collection('patients')
        .add(patient.toFirestore());
  }
  
  Future<void> updatePatient(String patientId, Map<String, dynamic> data) async {
    await _firestore
        .collection('patients')
        .doc(patientId)
        .update(data);
  }
  
  // Appointments
  Stream<List<Appointment>> getAppointments(String centreId, DateTime date) {
    // Filtrer par centre_id ET date
  }
  
  // Statistiques
  Future<Map<String, int>> getStatistics(String centreId) async {
    // Nombre de patients, RDV du jour, etc.
  }
}
```

**2. DashboardScreen** (`lib/screens/dashboard/dashboard_screen.dart`)
- Carte statistiques (nb patients, RDV aujourd'hui, RDV semaine)
- Liste RDV du jour
- Navigation : Patients, Calendrier, Paramètres

**3. PatientsListScreen** (`lib/screens/patients/patients_list_screen.dart`)
- Liste scrollable avec StreamBuilder
- Barre de recherche
- Bouton "Ajouter patient"

**4. PatientFormScreen** (`lib/screens/patients/patient_form_screen.dart`)
- Formulaire complet patient
- Mode création / édition
- Validation des champs

### **Phase D : Système Réservation 📋 À FAIRE**

**Durée estimée :** 6-8h  
**Status :** 📋 0%

**À développer :**

**1. AppointmentService** (`lib/services/appointment_service.dart`)
```dart
class AppointmentService {
  // Calcule créneaux disponibles
  Future<List<TimeSlot>> getAvailableSlots({
    required DateTime date,
    required String praticienId,
    required int dureeMinutes,
  }) async {
    // Récupérer horaires centre
    // Récupérer RDV existants du praticien
    // Calculer créneaux libres
    // Retourner liste de TimeSlot
  }
  
  // Vérifie disponibilité
  Future<bool> isSlotAvailable(DateTime dateHeure, String praticienId) async {
    // Vérifier si créneau libre
  }
  
  // Crée rendez-vous
  Future<void> createAppointment(Appointment appointment) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .add(appointment.toFirestore());
  }
}
```

**2. CalendarScreen** (`lib/screens/appointments/calendar_screen.dart`)
- Utiliser `table_calendar: 3.1.2`
- Afficher indicateurs RDV par jour
- Sélection date → liste RDV

**3. AppointmentFormScreen** (`lib/screens/appointments/appointment_form_screen.dart`)
- Sélection praticien, patient
- Choix date/heure/durée
- Motif consultation

**4. PublicBookingScreen** (`lib/screens/appointments/public_booking_screen.dart`)
- Accessible sans authentification
- Formulaire patient simple
- Choix créneaux disponibles

---

## ⚙️ CONFIGURATION

### **Environnement**

```yaml
# pubspec.yaml
name: medidesk
version: 1.0.0+1

environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase (versions verrouillées)
  firebase_core: 3.6.0
  cloud_firestore: 5.4.3
  firebase_auth: 5.3.1
  firebase_storage: 12.3.2
  cloud_functions: 5.1.3
  
  # State management & utilities
  provider: 6.1.5+1
  shared_preferences: 2.5.3
  intl: ^0.19.0
  http: 1.5.0
  
  # Calendrier
  table_calendar: 3.1.2
  
  # UI
  cupertino_icons: ^1.0.8
```

### **Android**

**Package :** `fr.medidesk.demo`

**Fichiers configurés :**
- `android/app/build.gradle.kts` - applicationId
- `android/app/src/main/AndroidManifest.xml` - package + permissions
- `android/app/src/main/kotlin/fr/medidesk/demo/MainActivity.kt`
- `android/app/google-services.json`

### **Commandes Utiles**

```bash
# Installation dépendances
flutter pub get

# Analyse code
flutter analyze

# Build Web
flutter build web --release

# Serveur local
cd build/web && python3 -m http.server 5060 --bind 0.0.0.0 &

# Réinitialiser base de données
python3 scripts/init_firestore_demo.py
```

---

## 🚀 DÉPLOIEMENT

### **Netlify (Recommandé)**

**Configuration :**
```yaml
# netlify.toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[build.environment]
  FLUTTER_VERSION = "3.35.4"
```

**DNS Gandi :**
```
Type: CNAME
Nom: demo
Valeur: [netlify-app].netlify.app
TTL: 300
```

**URL finale :** https://demo.medidesk.fr

### **Étapes Déploiement**

1. Connecter GitHub à Netlify
2. Configurer build command
3. Déployer
4. Configurer DNS chez Gandi
5. Activer SSL automatique

---

## 📊 STATISTIQUES

```
Date dernière session :       19 Novembre 2025
Durée session :               ~3h30
Fichiers créés :              25+
Lignes de code :              2500+
Documentation :               40000+ caractères

Infrastructure :              100% ✅
Backend Database :            100% ✅
Services Authentication :     100% ✅
Écrans UI :                   0% 📋

Temps estimé restant :        12-18h
```

---

**✅ Documentation complète et à jour !**

**Pour démarrer rapidement, lire d'abord AI_QUICK_START.md**
