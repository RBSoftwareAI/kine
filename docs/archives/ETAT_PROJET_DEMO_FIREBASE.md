# 📊 ÉTAT DU PROJET - Migration vers Démo Firebase

**Date** : 18 novembre 2025  
**Version cible** : 1.5 (Démo Multi-Centres Firebase)  
**Statut global** : ⏳ En attente des fichiers Firebase

---

## ✅ TRAVAIL DÉJÀ EFFECTUÉ

### **1. Documentation Stratégique** (100% ✅)

**Documents créés** :
- ✅ `SPECIFICATIONS_DEMO_FIREBASE.md` (19 pages) - Architecture complète
- ✅ `GUIDE_CONFIGURATION_FIREBASE.md` (12 pages) - Guide pas-à-pas Firebase Console
- ✅ `ETAT_PROJET_DEMO_FIREBASE.md` (ce fichier) - Suivi du projet

**Contenu détaillé** :
- Modèle de données Firestore (6 collections)
- Règles de sécurité multi-tenant
- Flux d'inscription utilisateurs
- Système de prise de RDV
- Architecture technique complète
- Timeline d'implémentation (15-21h)

---

### **2. Configuration Projet Flutter** (80% ✅)

**pubspec.yaml mis à jour** :
```yaml
dependencies:
  # Firebase
  firebase_core: 3.6.0          ✅
  cloud_firestore: 5.4.3        ✅
  firebase_auth: 5.3.1           ✅
  firebase_storage: 12.3.2       ✅
  cloud_functions: 5.1.3         ✅
  firebase_ui_auth: 1.18.0       🆕 NOUVEAU
  
  # Calendrier RDV
  table_calendar: 3.1.2          🆕 NOUVEAU
  
  # Autres (déjà présentes)
  provider, http, csv, intl...   ✅
```

**Fichiers de configuration à recevoir** :
- ⏳ `firebase-config.json` (Web)
- ⏳ `google-services.json` (Android)
- ⏳ `firebase-admin-sdk.json` (Backend)

---

### **3. Infrastructure de Déploiement** (100% ✅)

**Fichiers créés précédemment** :
- ✅ `netlify.toml` - Configuration Netlify
- ✅ `backend/Dockerfile` - Image Docker
- ✅ `install_vps.sh` - Script VPS

**DNS à configurer** :
- ⏳ `demo.medidesk.fr` → Netlify (en attente)

---

## ⏳ TRAVAIL EN ATTENTE (Firebase)

### **Bloquant : Fichiers Firebase Requis**

**Fichier 1 : `firebase-config.json`** (Web)
```
Localisation future : /home/user/flutter_app/lib/firebase_options.dart
Nécessaire pour : Initialisation Firebase dans Flutter Web
```

**Fichier 2 : `google-services.json`** (Android)
```
Localisation future : /home/user/flutter_app/android/app/google-services.json
Nécessaire pour : Build Android avec Firebase
```

**Fichier 3 : `firebase-admin-sdk.json`** (Backend)
```
Localisation future : /opt/flutter/firebase-admin-sdk.json
Nécessaire pour : Scripts de migration et Cloud Functions
```

---

## 🚀 PROCHAINES ÉTAPES (Après Réception Fichiers)

### **Phase 1 : Intégration Firebase** (Temps estimé : 2-3 heures)

**1.1 Configuration de base**
- [ ] Créer `lib/firebase_options.dart` à partir de firebase-config.json
- [ ] Copier `google-services.json` dans `android/app/`
- [ ] Copier `firebase-admin-sdk.json` dans `/opt/flutter/`
- [ ] Installer les dépendances : `flutter pub get`

**1.2 Initialisation Firebase dans main.dart**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

**1.3 Test de connexion**
- [ ] Build test : `flutter build web --release`
- [ ] Vérifier console Firebase : Connexion détectée

---

### **Phase 2 : Authentication Firebase** (Temps estimé : 3-4 heures)

**2.1 Créer FirebaseAuthService**
```dart
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Inscription
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Connexion
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

**2.2 Créer les écrans d'authentification**
- [ ] `lib/views/auth/signup_screen.dart` - Inscription
- [ ] `lib/views/auth/login_screen.dart` - Connexion
- [ ] `lib/views/auth/auth_wrapper.dart` - Wrapper auth

**2.3 Formulaire d'inscription complet**
Champs :
- Email
- Mot de passe
- Prénom / Nom
- **Nouveau centre** OU **Rejoindre centre existant**
  - Si nouveau : Nom du centre, Ville
  - Si existant : Code d'invitation
- Rôle : Manager / Kinésithérapeute

---

### **Phase 3 : Migration Firestore** (Temps estimé : 4-5 heures)

**3.1 Créer FirestoreRepository**
```dart
class FirestoreRepository implements DataRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String centreId;  // ← Clé d'isolation
  
  FirestoreRepository({required this.centreId});
  
  // Patients (avec isolation centre_id)
  Future<List<Patient>> getPatients() async {
    final snapshot = await _firestore
        .collection('patients')
        .where('centre_id', isEqualTo: centreId)
        .get();
    
    return snapshot.docs
        .map((doc) => Patient.fromFirestore(doc.data(), doc.id))
        .toList();
  }
  
  Future<void> createPatient(Patient patient) async {
    await _firestore.collection('patients').add({
      ...patient.toJson(),
      'centre_id': centreId,  // ← Ajout automatique
      'created_at': FieldValue.serverTimestamp(),
    });
  }
  
  // Autres méthodes similaires...
}
```

**3.2 Adapter les modèles existants**
- [ ] `Patient.fromFirestore()` - Ajouter méthode
- [ ] `PainPoint.fromFirestore()` - Ajouter méthode
- [ ] `SessionNote.fromFirestore()` - Ajouter méthode

**3.3 Créer nouveaux modèles**
- [ ] `lib/models/centre.dart` - Modèle Centre
- [ ] `lib/models/appointment.dart` - Modèle RDV
- [ ] `lib/models/firebase_user.dart` - Utilisateur Firebase

---

### **Phase 4 : Système Multi-Tenant** (Temps estimé : 2-3 heures)

**4.1 Gestion des Centres**
```dart
class CentreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Créer un nouveau centre
  Future<String> createCentre({
    required String name,
    required String city,
    required String ownerId,
  }) async {
    final centreRef = await _firestore.collection('centres').add({
      'name': name,
      'city': city,
      'owner_id': ownerId,
      'created_at': FieldValue.serverTimestamp(),
      'settings': {
        'rdv_enabled': true,
        'rdv_min_duration': 30,
      },
      'subscription': {
        'plan': 'demo',
        'expires_at': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 90)),
        ),
      },
    });
    
    return centreRef.id;
  }
  
  // Inviter un utilisateur
  Future<String> generateInvitationCode(String centreId) async {
    // Générer code unique 6 caractères
    final code = _generateCode();
    
    await _firestore.collection('invitations').doc(code).set({
      'centre_id': centreId,
      'created_at': FieldValue.serverTimestamp(),
      'expires_at': Timestamp.fromDate(
        DateTime.now().add(Duration(days: 7)),
      ),
      'used': false,
    });
    
    return code;
  }
}
```

**4.2 Provider Multi-Tenant**
```dart
class TenantProvider extends ChangeNotifier {
  String? _centreId;
  Centre? _centre;
  
  String? get centreId => _centreId;
  Centre? get centre => _centre;
  
  Future<void> loadCentre(String userId) async {
    // Récupérer le centre_id de l'utilisateur
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    
    _centreId = userDoc.data()?['centre_id'];
    
    // Charger les infos du centre
    final centreDoc = await FirebaseFirestore.instance
        .collection('centres')
        .doc(_centreId)
        .get();
    
    _centre = Centre.fromFirestore(centreDoc.data()!, centreDoc.id);
    notifyListeners();
  }
}
```

---

### **Phase 5 : Module de Prise de RDV** (Temps estimé : 6-8 heures)

**5.1 Créer les écrans**
- [ ] `lib/views/appointments/appointments_calendar_screen.dart` - Calendrier praticien
- [ ] `lib/views/appointments/create_appointment_dialog.dart` - Créer RDV manuel
- [ ] `lib/views/appointments/public_booking_screen.dart` - Prise RDV en ligne

**5.2 Logique de créneaux disponibles**
```dart
class AvailabilityService {
  // Calculer les créneaux disponibles pour un jour
  List<TimeSlot> getAvailableSlots({
    required DateTime date,
    required List<Availability> therapistAvailability,
    required List<Appointment> existingAppointments,
    required int durationMinutes,
  }) {
    // 1. Récupérer les plages horaires du praticien pour ce jour
    final dayOfWeek = date.weekday;
    final dayAvailability = therapistAvailability
        .where((a) => a.day == dayOfWeek)
        .toList();
    
    // 2. Générer tous les créneaux possibles
    List<TimeSlot> allSlots = [];
    for (var availability in dayAvailability) {
      allSlots.addAll(_generateSlots(
        startTime: availability.startTime,
        endTime: availability.endTime,
        duration: durationMinutes,
      ));
    }
    
    // 3. Filtrer les créneaux déjà réservés
    final availableSlots = allSlots.where((slot) {
      return !_isSlotTaken(slot, existingAppointments);
    }).toList();
    
    return availableSlots;
  }
  
  bool _isSlotTaken(TimeSlot slot, List<Appointment> appointments) {
    for (var appointment in appointments) {
      if (_slotsOverlap(slot, appointment)) {
        return true;
      }
    }
    return false;
  }
}
```

**5.3 Interface publique de prise de RDV**
- URL : `demo.medidesk.fr/booking?centre=[centre_id]`
- Étapes :
  1. Sélection praticien
  2. Sélection date
  3. Sélection créneau
  4. Formulaire patient
  5. Confirmation

**5.4 Notifications email (Cloud Functions)**
```javascript
// functions/index.js
exports.sendAppointmentConfirmation = functions.firestore
  .document('appointments/{appointmentId}')
  .onCreate(async (snap, context) => {
    const appointment = snap.data();
    
    // Envoyer email via SendGrid/Mailgun
    await sendEmail({
      to: appointment.patient_info.email,
      subject: 'Confirmation RDV - MediDesk',
      template: 'appointment_confirmation',
      data: appointment,
    });
  });
```

---

### **Phase 6 : Déploiement demo.medidesk.fr** (Temps estimé : 1-2 heures)

**6.1 Build Flutter Web**
```bash
cd /home/user/flutter_app
flutter build web --release
```

**6.2 Déploiement Netlify**
- Upload `build/web` sur Netlify
- Configurer domaine custom : `demo.medidesk.fr`
- DNS : `CNAME demo → [app].netlify.app`

**6.3 Tests post-déploiement**
- [ ] Inscription fonctionne
- [ ] Connexion fonctionne
- [ ] Création patient fonctionne
- [ ] Isolation multi-centres validée
- [ ] Prise de RDV en ligne fonctionnelle
- [ ] Emails de confirmation reçus

---

## 📊 ESTIMATION GLOBALE

| Phase | Tâches | Temps Estimé | Dépendances |
|-------|--------|--------------|-------------|
| **Phase 1** | Configuration Firebase | 2-3h | ⏳ Fichiers Firebase |
| **Phase 2** | Authentication | 3-4h | Phase 1 ✅ |
| **Phase 3** | Migration Firestore | 4-5h | Phase 2 ✅ |
| **Phase 4** | Multi-Tenant | 2-3h | Phase 3 ✅ |
| **Phase 5** | Module RDV | 6-8h | Phase 4 ✅ |
| **Phase 6** | Déploiement | 1-2h | Phase 5 ✅ |
| **TOTAL** | - | **18-25 heures** | - |

**Délai de livraison estimé** : 3-4 jours de développement intensif après réception des fichiers Firebase.

---

## 🎯 FONCTIONNALITÉS CIBLES

### **✅ Déjà Fonctionnelles (v1.0)**
- Gestion patients
- Cartographie douleurs (unique !)
- Notes de séances
- Export CSV/JSON
- Gestion permissions hiérarchique

### **🆕 Nouvelles Fonctionnalités (v1.5 Démo)**
- **Inscription auto** - Création compte sans validation admin
- **Multi-centres** - Isolation totale des données par centre
- **Prise de RDV en ligne** - Interface publique + calendrier praticien
- **Notifications email** - Confirmations et rappels automatiques
- **Cloud Firebase** - Données hébergées, pas de backend local

---

## 📞 ACTIONS REQUISES DE VOTRE PART

### **✅ Action Immédiate**

**1. Suivre le guide `GUIDE_CONFIGURATION_FIREBASE.md`** (30 minutes)
   - Créer projet Firebase Console
   - Activer Authentication Email/Password
   - Créer Firestore Database
   - Télécharger les 3 fichiers JSON

**2. M'envoyer les 3 fichiers JSON**
   - Via onglet "Firebase" du sandbox
   - Ou par copier-coller dans le chat

**3. Décider du nom de domaine**
   - Confirmer : `demo.medidesk.fr` ?
   - Ou alternative : `test.medidesk.fr`, `essai.medidesk.fr` ?

---

## 📅 PLANNING PROPOSÉ

### **Aujourd'hui (Jour 1)** - Configuration Firebase
- ✅ Vous : Suivre guide Firebase (30 min)
- ✅ Vous : Envoyer fichiers JSON
- ✅ Moi : Valider fichiers et démarrer Phase 1

### **Demain (Jour 2)** - Intégration Core
- Phase 1 : Configuration Firebase (2-3h)
- Phase 2 : Authentication (3-4h)

### **Jour 3** - Migration & Multi-Tenant
- Phase 3 : Migration Firestore (4-5h)
- Phase 4 : Multi-Tenant (2-3h)

### **Jour 4** - Module RDV
- Phase 5 : Système de prise de RDV (6-8h)

### **Jour 5** - Déploiement & Tests
- Phase 6 : Déploiement demo.medidesk.fr (1-2h)
- Tests end-to-end complets
- Documentation finale

---

## ✅ CHECKLIST PRÉ-DÉPLOIEMENT DÉMO

**Configuration Firebase** :
- [ ] Projet Firebase créé
- [ ] Authentication Email/Password activée
- [ ] Firestore Database créée
- [ ] Règles de sécurité configurées
- [ ] 3 fichiers JSON récupérés

**Intégration Flutter** :
- [ ] `firebase_options.dart` créé
- [ ] Dépendances installées (`flutter pub get`)
- [ ] Compilation sans erreur
- [ ] Tests authentication réussis

**Fonctionnalités** :
- [ ] Inscription utilisateur fonctionne
- [ ] Création centre fonctionne
- [ ] Isolation multi-centres validée
- [ ] Module RDV opérationnel
- [ ] Emails de confirmation envoyés

**Déploiement** :
- [ ] Build Flutter Web réussi
- [ ] Netlify configuré
- [ ] DNS `demo.medidesk.fr` configuré
- [ ] Tests publics réussis

---

## 📞 SUPPORT

**Questions sur Firebase Console** ?
→ Consultez `GUIDE_CONFIGURATION_FIREBASE.md`

**Questions sur l'architecture** ?
→ Consultez `SPECIFICATIONS_DEMO_FIREBASE.md`

**Besoin d'aide** ?
→ Décrivez votre problème avec capture d'écran

---

**Statut actuel** : ⏳ **En attente des fichiers Firebase pour démarrer l'implémentation**

**Prochaine action** : **Vous → Configuration Firebase Console (30 min)**

Dès que vous m'envoyez les fichiers, je démarre immédiatement l'intégration ! 🚀🔥
