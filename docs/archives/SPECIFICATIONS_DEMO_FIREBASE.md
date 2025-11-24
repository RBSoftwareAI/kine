# 📋 SPÉCIFICATIONS TECHNIQUES - Démo MediDesk Firebase

**Version** : 1.5 (Démo Multi-Centres)  
**Date** : 18 novembre 2025  
**Objectif** : Plateforme de démonstration professionnelle avec Firebase

---

## 🎯 OBJECTIFS DE LA DÉMO

### **Besoins Fonctionnels**

1. ✅ **URL Professionnelle** : `demo.medidesk.fr`
2. ✅ **Inscription Auto** : Création de comptes utilisateurs sans validation admin
3. ✅ **Multi-Centres** : Plusieurs centres de soin testent simultanément (isolation données)
4. ✅ **Prise de RDV** : Module de réservation opérationnel dès la démo
5. ✅ **Cloud Firebase** : Pas besoin de HDS pour la démo

### **Personas Utilisateurs**

**1. Manager de Centre** :
- Crée son compte lors de la première visite
- Définit son centre de soin (nom, ville)
- Accède à toutes les fonctionnalités
- Peut inviter d'autres praticiens de son centre

**2. Kinésithérapeute** :
- Rejoint un centre existant (code d'invitation)
- Gère ses patients
- Configure ses créneaux de disponibilité
- Reçoit les demandes de RDV

**3. Patient Démo** :
- Accède à la page publique de prise de RDV
- Prend RDV sans création de compte
- Reçoit confirmation par email

---

## 🏗️ ARCHITECTURE TECHNIQUE

### **Stack Complète**

```
┌─────────────────────────────────────────────────────┐
│           demo.medidesk.fr (Netlify)                │
│              Flutter Web App                        │
└───────────────────┬─────────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────────────────┐
│              Firebase Services                      │
├─────────────────────────────────────────────────────┤
│  • Authentication (Email/Password)                  │
│  • Firestore Database (NoSQL)                      │
│  • Cloud Storage (Documents/Images)                │
│  • Cloud Functions (Emails, Notifications)         │
│  • Hosting (Alternative à Netlify)                 │
└─────────────────────────────────────────────────────┘
```

### **Dépendances Flutter Requises**

```yaml
dependencies:
  # Firebase Core (DÉJÀ DANS SPECS v1.0)
  firebase_core: 3.6.0
  cloud_firestore: 5.4.3
  firebase_storage: 12.3.2
  
  # Nouvelles dépendances pour démo
  firebase_auth: 5.3.1              # Authentification
  firebase_ui_auth: 1.18.0          # UI d'authentification
  
  # Calendrier et RDV
  table_calendar: 3.1.2             # Calendrier interactif
  syncfusion_flutter_calendar: 27.1.58  # Alternative pro
  
  # Notifications et emails
  cloud_functions: 5.1.3            # Appel Cloud Functions
  
  # Déjà présents
  provider: 6.1.5+1
  http: 1.5.0
  intl: ^0.19.0
```

---

## 🗄️ MODÈLE DE DONNÉES FIRESTORE

### **Collection : `centres`**

```javascript
centres/{centre_id}
{
  "centre_id": "centre_tourcoing_001",
  "name": "Centre Kiné Tourcoing",
  "city": "Tourcoing",
  "postal_code": "59200",
  "address": "123 Rue de Test",
  "phone": "0320123456",
  "email": "contact@centre-tourcoing.fr",
  "owner_id": "firebase_uid_manager",
  "created_at": Timestamp,
  "settings": {
    "rdv_enabled": true,
    "rdv_min_duration": 30,  // minutes
    "rdv_max_days_advance": 30,
    "auto_confirm_rdv": false
  },
  "subscription": {
    "plan": "demo",  // demo | essentiel | cabinet | clinique
    "expires_at": Timestamp  // Fin de la démo (90 jours)
  }
}
```

### **Collection : `users`**

```javascript
users/{user_id}
{
  "user_id": "firebase_auth_uid",
  "email": "marie.kine@centre-tourcoing.fr",
  "first_name": "Marie",
  "last_name": "Dupont",
  "phone": "0623456789",
  "role": "kine",  // manager | kine | assistant
  "centre_id": "centre_tourcoing_001",  // ← CLÉ D'ISOLATION
  "created_at": Timestamp,
  "last_login": Timestamp,
  "is_active": true,
  "permissions": {
    "can_manage_rdv": true,
    "can_manage_patients": true,
    "can_export_data": true,
    "can_invite_users": false  // Seulement manager
  },
  "availability": [
    {
      "day": 1,  // Lundi = 1, Dimanche = 7
      "start_time": "09:00",
      "end_time": "12:00"
    },
    {
      "day": 1,
      "start_time": "14:00",
      "end_time": "18:00"
    }
  ]
}
```

### **Collection : `patients`**

```javascript
patients/{patient_id}
{
  "patient_id": "auto_generated_id",
  "centre_id": "centre_tourcoing_001",  // ← ISOLATION
  "first_name": "Jean",
  "last_name": "Dupont",
  "email": "jean.dupont@email.fr",
  "phone": "0612345678",
  "birth_date": "1980-03-15",
  "address": "456 Avenue Test",
  "created_at": Timestamp,
  "created_by": "firebase_uid_kine",
  "assigned_therapist_id": "firebase_uid_kine",
  "is_active": true,
  "notes": "Douleur chronique lombaire"
}
```

### **Collection : `appointments` (NOUVEAU)**

```javascript
appointments/{appointment_id}
{
  "appointment_id": "auto_generated_id",
  "centre_id": "centre_tourcoing_001",  // ← ISOLATION
  "patient_id": "patient_id",
  "therapist_id": "firebase_uid_kine",
  "date": "2025-11-20",
  "start_time": "10:00",
  "end_time": "10:45",
  "duration_minutes": 45,
  "status": "confirmed",  // pending | confirmed | cancelled | completed
  "type": "consultation",  // consultation | suivi | bilan
  "notes": "Première consultation",
  "source": "online",  // online | manual | phone
  "patient_info": {  // Pour RDV en ligne sans compte
    "first_name": "Jean",
    "last_name": "Dupont",
    "email": "jean.dupont@email.fr",
    "phone": "0612345678",
    "reason": "Douleur au dos"
  },
  "created_at": Timestamp,
  "updated_at": Timestamp,
  "reminders_sent": {
    "email_24h": false,
    "sms_24h": false,
    "email_confirmation": true
  }
}
```

### **Collection : `pain_points`**

```javascript
pain_points/{pain_point_id}
{
  "pain_point_id": "auto_generated_id",
  "centre_id": "centre_tourcoing_001",  // ← ISOLATION
  "patient_id": "patient_id",
  "therapist_id": "firebase_uid_kine",
  "body_part": "lower_back",
  "position": {
    "x": 150,  // Coordonnées sur la silhouette
    "y": 220,
    "view": "back"  // front | back | left | right
  },
  "intensity": 7,  // 0-10
  "description": "Douleur lombaire chronique",
  "date_recorded": Timestamp,
  "status": "active"  // active | resolved
}
```

### **Collection : `sessions`**

```javascript
sessions/{session_id}
{
  "session_id": "auto_generated_id",
  "centre_id": "centre_tourcoing_001",  // ← ISOLATION
  "patient_id": "patient_id",
  "therapist_id": "firebase_uid_kine",
  "appointment_id": "appointment_id",  // Lien avec RDV
  "date": Timestamp,
  "duration_minutes": 45,
  "type": "massage",
  "observations": "Tensions importantes nuque...",
  "pain_evolution": [
    {
      "pain_point_id": "pain_point_id",
      "intensity_before": 7,
      "intensity_after": 4
    }
  ],
  "next_session_recommended": true,
  "next_session_delay_days": 7,
  "created_at": Timestamp
}
```

---

## 🔐 RÈGLES DE SÉCURITÉ FIRESTORE

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserCentreId() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.centre_id;
    }
    
    function belongsToSameCentre(centre_id) {
      return isAuthenticated() && getUserCentreId() == centre_id;
    }
    
    // Centres : Lecture publique (pour inscription), écriture par owner
    match /centres/{centreId} {
      allow read: if true;  // Publique pour affichage liste centres
      allow create: if isAuthenticated();
      allow update, delete: if isAuthenticated() 
        && get(/databases/$(database)/documents/centres/$(centreId)).data.owner_id == request.auth.uid;
    }
    
    // Users : Lecture/écriture seulement son propre profil
    match /users/{userId} {
      allow read: if isAuthenticated() && (
        request.auth.uid == userId 
        || belongsToSameCentre(resource.data.centre_id)
      );
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update, delete: if isAuthenticated() && request.auth.uid == userId;
    }
    
    // Patients : Isolation par centre_id
    match /patients/{patientId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
    }
    
    // Appointments : Isolation par centre_id + lecture publique pour URL de RDV
    match /appointments/{appointmentId} {
      allow read: if true;  // Publique pour vérification créneaux disponibles
      allow create: if true;  // Permettre prise RDV en ligne sans compte
      allow update, delete: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
    }
    
    // Pain Points : Isolation par centre_id
    match /pain_points/{painPointId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
    }
    
    // Sessions : Isolation par centre_id
    match /sessions/{sessionId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
    }
  }
}
```

---

## 🎨 NOUVELLES PAGES FLUTTER

### **1. Page d'Inscription (`signup_screen.dart`)**

```dart
class SignupScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Compte Démo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Étape 1 : Informations personnelles
              TextField(/* Email */),
              TextField(/* Mot de passe */),
              TextField(/* Prénom */),
              TextField(/* Nom */),
              
              // Étape 2 : Informations du centre
              TextField(/* Nom du centre */),
              TextField(/* Ville */),
              
              // Étape 3 : Rôle
              DropdownButton(
                items: ['Manager', 'Kinésithérapeute'],
              ),
              
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Créer mon Compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _createAccount() async {
    // 1. Créer compte Firebase Auth
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    
    // 2. Créer le centre dans Firestore
    String centreId = await _createCentre();
    
    // 3. Créer le profil utilisateur
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'centre_id': centreId,
      'role': role,
      'created_at': FieldValue.serverTimestamp(),
    });
    
    // 4. Rediriger vers dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }
}
```

### **2. Page Calendrier RDV (`appointments_calendar_screen.dart`)**

```dart
import 'package:table_calendar/table_calendar.dart';

class AppointmentsCalendarScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📅 Mes Rendez-vous'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createAppointment,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 90)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getAppointmentsForDay,
          ),
          Expanded(
            child: _buildAppointmentsList(),
          ),
        ],
      ),
    );
  }
  
  List<Appointment> _getAppointmentsForDay(DateTime day) {
    // Requête Firestore filtrée par centre_id et date
    return appointments.where((apt) => 
      isSameDay(apt.date, day) && 
      apt.centreId == currentUser.centreId
    ).toList();
  }
}
```

### **3. Page Publique Prise de RDV (`public_booking_screen.dart`)**

```dart
class PublicBookingScreen extends StatelessWidget {
  final String centreId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prendre Rendez-vous'),
      ),
      body: Stepper(
        steps: [
          Step(
            title: Text('Choisir un praticien'),
            content: _buildTherapistSelector(),
          ),
          Step(
            title: Text('Choisir une date'),
            content: _buildDatePicker(),
          ),
          Step(
            title: Text('Choisir un créneau'),
            content: _buildTimeSlotPicker(),
          ),
          Step(
            title: Text('Vos informations'),
            content: _buildPatientForm(),
          ),
        ],
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
      ),
    );
  }
  
  Widget _buildTimeSlotPicker() {
    // Afficher seulement les créneaux disponibles
    return StreamBuilder<List<Appointment>>(
      stream: _getAppointmentsStream(selectedDate),
      builder: (context, snapshot) {
        List<String> availableSlots = _calculateAvailableSlots(
          selectedDate,
          selectedTherapist.availability,
          snapshot.data ?? [],
        );
        
        return Wrap(
          children: availableSlots.map((slot) => 
            ChoiceChip(
              label: Text(slot),
              selected: selectedSlot == slot,
              onSelected: (selected) => setState(() => selectedSlot = slot),
            )
          ).toList(),
        );
      },
    );
  }
}
```

---

## 🚀 PLAN DE MIGRATION DONNÉES

### **Étape 1 : Migration SQLite → Firestore**

```python
# Script Python pour migrer les données de démo
import sqlite3
import firebase_admin
from firebase_admin import credentials, firestore

# Initialiser Firebase
cred = credentials.Certificate('firebase-admin-sdk.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# Connexion SQLite
conn = sqlite3.connect('/home/user/flutter_app/data/medidesk.db')
cursor = conn.cursor()

# Migrer utilisateurs
cursor.execute("SELECT * FROM users")
for user in cursor.fetchall():
    db.collection('users').document(user['id']).set({
        'email': user['email'],
        'first_name': user['first_name'],
        'last_name': user['last_name'],
        'centre_id': 'centre_demo_001',  # Centre par défaut
        'role': user['role'],
        'created_at': firestore.SERVER_TIMESTAMP,
    })

print("✅ Migration terminée")
```

### **Étape 2 : Créer Centres de Démo**

```javascript
// Créer 3 centres de démo par défaut
const demoCentres = [
  {
    centre_id: 'centre_tourcoing_demo',
    name: 'Centre Kiné Tourcoing (Démo)',
    city: 'Tourcoing',
    postal_code: '59200',
  },
  {
    centre_id: 'centre_lille_demo',
    name: 'Cabinet Kiné Lille (Démo)',
    city: 'Lille',
    postal_code: '59000',
  },
  {
    centre_id: 'centre_roubaix_demo',
    name: 'Clinique Kiné Roubaix (Démo)',
    city: 'Roubaix',
    postal_code: '59100',
  },
];
```

---

## 📧 CLOUD FUNCTIONS (Emails & Notifications)

### **Function : Confirmation RDV**

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

exports.sendAppointmentConfirmation = functions.firestore
  .document('appointments/{appointmentId}')
  .onCreate(async (snap, context) => {
    const appointment = snap.data();
    
    // Récupérer infos du centre et du praticien
    const centre = await admin.firestore()
      .collection('centres')
      .doc(appointment.centre_id)
      .get();
    
    const therapist = await admin.firestore()
      .collection('users')
      .doc(appointment.therapist_id)
      .get();
    
    // Envoyer email de confirmation au patient
    const mailOptions = {
      from: 'noreply@medidesk.fr',
      to: appointment.patient_info.email,
      subject: `Confirmation RDV - ${centre.data().name}`,
      html: `
        <h2>Rendez-vous confirmé</h2>
        <p>Bonjour ${appointment.patient_info.first_name},</p>
        <p>Votre rendez-vous a été confirmé :</p>
        <ul>
          <li><strong>Date</strong> : ${appointment.date}</li>
          <li><strong>Heure</strong> : ${appointment.start_time}</li>
          <li><strong>Praticien</strong> : ${therapist.data().first_name} ${therapist.data().last_name}</li>
          <li><strong>Lieu</strong> : ${centre.data().address}</li>
        </ul>
        <p>À bientôt !</p>
      `
    };
    
    await transporter.sendMail(mailOptions);
    
    console.log('✅ Email de confirmation envoyé');
  });
```

---

## 📱 CONFIGURATION DNS

### **Enregistrements à Créer**

Chez votre registrar (OVH, Gandi, etc.) :

```
Type: CNAME
Nom: demo
Valeur: [your-app].netlify.app.
TTL: 3600

Résultat : demo.medidesk.fr → Application Netlify
```

---

## ⏱️ TIMELINE D'IMPLÉMENTATION

### **Phase 1 : Configuration Firebase** (2-3 heures)
- [ ] Créer projet Firebase Console
- [ ] Télécharger `google-services.json` et `firebase-admin-sdk.json`
- [ ] Configurer Authentication (Email/Password)
- [ ] Créer base Firestore avec collections

### **Phase 2 : Intégration Flutter** (4-5 heures)
- [ ] Ajouter dépendances Firebase dans `pubspec.yaml`
- [ ] Créer `firebase_options.dart`
- [ ] Implémenter FirebaseRepository
- [ ] Créer page d'inscription
- [ ] Adapter les écrans existants (patients, douleurs, séances)

### **Phase 3 : Module RDV** (6-8 heures)
- [ ] Créer modèle Appointment
- [ ] Implémenter calendrier (TableCalendar)
- [ ] Page publique de prise de RDV
- [ ] Logique de créneaux disponibles
- [ ] Notifications (Cloud Functions)

### **Phase 4 : Multi-Tenant** (2-3 heures)
- [ ] Système de centres
- [ ] Isolation par centre_id
- [ ] Invitations utilisateurs

### **Phase 5 : Déploiement** (1-2 heures)
- [ ] Build Flutter Web
- [ ] Deploy Netlify
- [ ] Configuration DNS demo.medidesk.fr
- [ ] Tests end-to-end

**Total estimé : 15-21 heures de développement**

---

## ✅ CHECKLIST DE VALIDATION

Avant de passer en démo :

- [ ] Firebase Authentication fonctionne (inscription + login)
- [ ] Firestore stocke et récupère les données
- [ ] Multi-centres : Isolation des données validée
- [ ] Module RDV : Prise de RDV en ligne opérationnelle
- [ ] Emails de confirmation envoyés
- [ ] DNS demo.medidesk.fr configuré
- [ ] Tests avec 3 centres simultanés
- [ ] Performance < 2 secondes chargement
- [ ] Responsive mobile/tablet/desktop

---

## 📞 SUPPORT & DOCUMENTATION

**Firebase Console** : https://console.firebase.google.com  
**Netlify Dashboard** : https://app.netlify.com  
**Documentation Firebase Flutter** : https://firebase.google.com/docs/flutter

---

**Prochaine étape** : Voulez-vous que je commence l'implémentation maintenant ?

Je recommande de commencer par :
1. Configuration Firebase (Console)
2. Intégration authentification
3. Migration données vers Firestore

Qu'en pensez-vous ?
