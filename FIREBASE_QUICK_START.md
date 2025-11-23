# 🔥 FIREBASE - GUIDE RAPIDE (10 MINUTES)

**Projet actuel** : KinéCare (à renommer cosmétiquement en "MediDesk Demo")  
**Objectif** : Obtenir les 3 fichiers JSON en 10 minutes

---

## 🎯 LES 3 FICHIERS REQUIS

```
1. ✅ firebase-config.json (Web)
2. ✅ google-services.json (Android)
3. ✅ firebase-admin-sdk.json (Backend)
```

---

## ⚡ ÉTAPE 1 : RENOMMER LE PROJET (2 minutes)

1. Allez sur : https://console.firebase.google.com
2. Sélectionnez votre projet **"KinéCare"**
3. Cliquez sur l'icône **⚙️ (roue dentée)** en haut à gauche
4. Cliquez sur **"Project settings"**
5. Section **"General"**
6. **Project name** : Changez en **"MediDesk Demo"**
7. Cliquez sur le crayon ✏️ pour modifier
8. Cliquez **"Save"**

✅ **Résultat** : Project name = "MediDesk Demo", Project ID reste `kinecare-xxxxx` (OK)

---

## ⚡ ÉTAPE 2 : ACTIVER AUTHENTICATION (3 minutes)

1. Menu latéral gauche → **"Authentication"** (🔐)
2. Cliquez sur **"Get started"**
3. Onglet **"Sign-in method"**
4. Cliquez sur **"Email/Password"**
5. **Activez** le bouton : Email/Password ✅
6. **Désactivez** : Email link (pas besoin)
7. Cliquez **"Save"**

✅ **Résultat** : Les utilisateurs pourront s'inscrire avec email + mot de passe

---

## ⚡ ÉTAPE 3 : CRÉER FIRESTORE DATABASE (3 minutes)

1. Menu latéral gauche → **"Firestore Database"** (📊)
2. Cliquez sur **"Create database"**
3. **Mode de sécurité** :
   - Sélectionnez **"Start in test mode"** (pour la démo)
4. **Localisation** :
   - Sélectionnez **"europe-west1 (Belgium)"** ← Proche de la France
5. Cliquez **"Enable"**
6. Attendez 1-2 minutes

✅ **Résultat** : Base Firestore créée (vide pour l'instant)

---

## ⚡ ÉTAPE 4 : TÉLÉCHARGER LES 3 FICHIERS JSON

### **Fichier 1 : firebase-config.json (Web)** - 2 minutes

1. Sur la page d'accueil du projet, cherchez **"Your apps"**
2. Si aucune app Web n'existe, cliquez sur l'icône **"</>"** (Web)
3. **App nickname** : `MediDesk Demo Web`
4. **NE PAS** cocher "Also set up Firebase Hosting"
5. Cliquez **"Register app"**

6. **📋 COPIER CETTE CONFIGURATION** :

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "kinecare-xxxxx.firebaseapp.com",
  projectId: "kinecare-xxxxx",
  storageBucket: "kinecare-xxxxx.firebasestorage.app",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef...",
  measurementId: "G-XXXXXXXXXX"
};
```

7. **Créez un fichier texte** nommé `firebase-config.json` sur votre ordinateur
8. **Collez** ce contenu (format JSON) :

```json
{
  "apiKey": "AIzaSy...",
  "authDomain": "kinecare-xxxxx.firebaseapp.com",
  "projectId": "kinecare-xxxxx",
  "storageBucket": "kinecare-xxxxx.firebasestorage.app",
  "messagingSenderId": "123456789012",
  "appId": "1:123456789012:web:abcdef...",
  "measurementId": "G-XXXXXXXXXX"
}
```

9. **Sauvegardez** le fichier

---

### **Fichier 2 : google-services.json (Android)** - 2 minutes

1. Dans **Project settings** (⚙️)
2. Onglet **"General"**
3. Section **"Your apps"**
4. Cliquez sur **"Add app"** → Icône **Android**
5. **Android package name** :
   ```
   fr.medidesk.demo
   ```
6. **App nickname** :
   ```
   MediDesk Demo Android
   ```
7. Cliquez **"Register app"**
8. **Téléchargez google-services.json** (bouton vert)
9. **Sauvegardez** ce fichier sur votre ordinateur

---

### **Fichier 3 : firebase-admin-sdk.json (Backend)** - 2 minutes

1. Dans **Project settings** (⚙️)
2. Onglet **"Service accounts"**
3. Section **"Firebase Admin SDK"**
4. **⚠️ IMPORTANT** : Dans le menu déroulant, sélectionnez **"Python"**
5. Cliquez sur **"Generate new private key"**
6. Popup de confirmation → Cliquez **"Generate key"**
7. Un fichier JSON est téléchargé automatiquement :
   ```
   kinecare-xxxxx-firebase-adminsdk-xxxxx.json
   ```
8. **Renommez-le** en `firebase-admin-sdk.json` pour plus de simplicité
9. **Sauvegardez** ce fichier sur votre ordinateur

⚠️ **SÉCURITÉ** : Ce fichier contient des clés privées. Ne le partagez JAMAIS publiquement !

---

## 📤 ÉTAPE 5 : M'ENVOYER LES FICHIERS

**Option 1 : Upload via l'interface Sandbox (RECOMMANDÉ)**

Si vous avez accès à l'interface avec un onglet "Firebase" :
1. Cliquez sur l'onglet **"Firebase"**
2. **Glissez-déposez** les 3 fichiers JSON

---

**Option 2 : Copier-Coller le Contenu (ALTERNATIF)**

1. **Ouvrez chaque fichier JSON** dans un éditeur de texte (Notepad++, VS Code, ou Bloc-notes)

2. **Copiez TOUT le contenu** de chaque fichier

3. **Envoyez-moi dans le chat** avec ce format :

```
📄 FICHIER 1 : firebase-config.json
{
  "apiKey": "AIzaSy...",
  ...
}

📄 FICHIER 2 : google-services.json
{
  "project_info": {
    ...
  }
}

📄 FICHIER 3 : firebase-admin-sdk.json
{
  "type": "service_account",
  "project_id": "kinecare-xxxxx",
  ...
}
```

---

## ⚡ ÉTAPE BONUS : CONFIGURER LES RÈGLES FIRESTORE (Optionnel - 2 minutes)

1. Menu latéral → **"Firestore Database"**
2. Onglet **"Rules"**
3. **Remplacez** les règles par défaut par ceci :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper : Vérifier authentification
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper : Récupérer le centre_id de l'utilisateur
    function getUserCentreId() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.centre_id;
    }
    
    // Helper : Vérifier appartenance au même centre
    function belongsToSameCentre(centreId) {
      return isAuthenticated() && getUserCentreId() == centreId;
    }
    
    // Centres : Lecture publique, écriture par owner
    match /centres/{centreId} {
      allow read: if true;
      allow create: if isAuthenticated();
      allow update, delete: if isAuthenticated() 
        && resource.data.owner_id == request.auth.uid;
    }
    
    // Users : Lecture/écriture son profil
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update, delete: if isAuthenticated() && request.auth.uid == userId;
    }
    
    // Patients : Isolation par centre_id
    match /patients/{patientId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
      allow create: if isAuthenticated();
    }
    
    // Appointments : Lecture publique (créneaux), création libre
    match /appointments/{appointmentId} {
      allow read: if true;
      allow create: if true;
      allow update, delete: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
    }
    
    // Pain Points : Isolation par centre_id
    match /pain_points/{painPointId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
      allow create: if isAuthenticated();
    }
    
    // Sessions : Isolation par centre_id
    match /sessions/{sessionId} {
      allow read, write: if isAuthenticated() 
        && belongsToSameCentre(resource.data.centre_id);
      allow create: if isAuthenticated();
    }
  }
}
```

4. Cliquez **"Publish"**

✅ **Résultat** : Règles de sécurité multi-tenant configurées

---

## ✅ CHECKLIST FINALE

Avant de me renvoyer les fichiers, vérifiez :

- [ ] Projet renommé "MediDesk Demo" (cosmétiquement)
- [ ] Authentication Email/Password activée
- [ ] Firestore Database créée (europe-west1)
- [ ] 3 fichiers JSON téléchargés :
  - [ ] firebase-config.json (Web)
  - [ ] google-services.json (Android)
  - [ ] firebase-admin-sdk.json (Backend)
- [ ] Règles Firestore configurées (optionnel mais recommandé)

---

## 🚀 APRÈS L'ENVOI DES FICHIERS

**Ce que je vais faire immédiatement** :

1. ✅ Intégrer les fichiers dans le projet Flutter
2. ✅ Créer `firebase_options.dart`
3. ✅ Initialiser Firebase dans l'app
4. ✅ Test de connexion Firebase
5. ✅ Créer système d'authentification (inscription/connexion)
6. ✅ Implémenter FirestoreRepository
7. ✅ Tests multi-tenant

**Temps estimé** : 6-8 heures de développement

**Délai de livraison** : Demain soir (19 novembre) pour première version fonctionnelle avec authentification

---

## 📞 BESOIN D'AIDE ?

**Si vous êtes bloqué** :

1. Faites une capture d'écran de l'étape problématique
2. Décrivez où vous en êtes
3. Envoyez-moi la question dans le chat

Je vous guiderai en direct ! 💪

---

**Temps total** : ⏱️ **10-15 minutes maximum**

**Prêt ? Commencez maintenant !** 🔥
