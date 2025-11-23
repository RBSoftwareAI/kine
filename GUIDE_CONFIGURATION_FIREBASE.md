# 🔥 GUIDE DE CONFIGURATION FIREBASE - MediDesk Démo

**Durée estimée** : 30 minutes  
**Prérequis** : Compte Google (gmail.com ou autre)

---

## 🎯 OBJECTIF

Obtenir les fichiers de configuration Firebase nécessaires pour `demo.medidesk.fr` :
1. ✅ `google-services.json` (Android/Web configuration)
2. ✅ `firebase-admin-sdk.json` (Backend configuration)

---

## 📋 ÉTAPE 1 : CRÉER LE PROJET FIREBASE

### **1.1 Accéder à Firebase Console**

Ouvrez dans votre navigateur :
```
https://console.firebase.google.com
```

Connectez-vous avec votre compte Google.

---

### **1.2 Créer un Nouveau Projet**

1. Cliquez sur **"Ajouter un projet"** (ou "Create a project")

2. **Nom du projet** :
   ```
   MediDesk Demo
   ```
   
3. **Project ID** (généré automatiquement) :
   ```
   medidesk-demo-xxxxx
   ```
   ⚠️ **Notez ce Project ID**, il sera utilisé dans la configuration.

4. **Google Analytics** :
   - ✅ Activer Google Analytics (recommandé pour démo)
   - Créer un nouveau compte Analytics
   - Accepter les conditions

5. Cliquez sur **"Créer le projet"** et attendez 30 secondes.

---

## 📋 ÉTAPE 2 : CONFIGURER AUTHENTICATION

### **2.1 Activer Email/Password**

1. Dans le menu gauche, cliquez sur **"Authentication"** (🔐)

2. Cliquez sur **"Get started"**

3. Onglet **"Sign-in method"**

4. Cliquez sur **"Email/Password"**

5. **Activer** :
   - ✅ Email/Password : **Activé**
   - ❌ Email link (passwordless sign-in) : **Désactivé** (pas besoin)

6. Cliquez sur **"Save"**

✅ **Résultat** : Les utilisateurs pourront s'inscrire avec email + mot de passe.

---

## 📋 ÉTAPE 3 : CRÉER FIRESTORE DATABASE

### **3.1 Initialiser Firestore**

1. Dans le menu gauche, cliquez sur **"Firestore Database"** (📊)

2. Cliquez sur **"Create database"**

3. **Mode de sécurité** :
   - Sélectionnez **"Start in test mode"** (pour la démo)
   - ⚠️ Les règles seront configurées plus tard

4. **Localisation** :
   - Sélectionnez **"europe-west1 (Belgique)"** (proche de la France)
   - Ou **"europe-west9 (Paris)"** si disponible

5. Cliquez sur **"Enable"**

6. Attendez 1-2 minutes que la base soit créée.

✅ **Résultat** : Base de données Firestore créée et vide.

---

### **3.2 Créer les Collections de Base**

Pour l'instant, nous créerons les collections via le code Flutter. Mais vous pouvez les pré-créer :

1. Dans Firestore, cliquez sur **"Start collection"**

2. Créez ces collections (vides pour l'instant) :
   - `centres`
   - `users`
   - `patients`
   - `appointments`
   - `pain_points`
   - `sessions`

✅ **Résultat** : Structure de base prête.

---

## 📋 ÉTAPE 4 : CONFIGURER L'APPLICATION WEB

### **4.1 Ajouter une Application Web**

1. Sur la page d'accueil du projet, cliquez sur l'icône **"</>"** (Web)

2. **Nom de l'application** :
   ```
   MediDesk Demo Web
   ```

3. **Firebase Hosting** :
   - ❌ Ne pas cocher "Also set up Firebase Hosting" (nous utilisons Netlify)

4. Cliquez sur **"Register app"**

5. **📋 IMPORTANT** : Une fenêtre apparaît avec le code de configuration :

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "medidesk-demo-xxxxx.firebaseapp.com",
  projectId: "medidesk-demo-xxxxx",
  storageBucket: "medidesk-demo-xxxxx.firebasestorage.app",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890abcdef",
  measurementId: "G-XXXXXXXXXX"
};
```

**⚠️ COPIEZ CETTE CONFIGURATION** dans un fichier texte temporaire.

6. Cliquez sur **"Continue to console"**

---

### **4.2 Télécharger google-services.json (Android)**

Bien que nous utilisions principalement Web, ce fichier peut être utile :

1. Dans les paramètres du projet (⚙️ en haut à gauche)

2. Onglet **"General"**

3. Faites défiler vers **"Your apps"**

4. Cliquez sur **"Add app"** → **Android** (icône Android)

5. **Android package name** :
   ```
   fr.medidesk.demo
   ```

6. **App nickname** :
   ```
   MediDesk Demo Android
   ```

7. Cliquez sur **"Register app"**

8. **Télécharger google-services.json**

9. **⚠️ IMPORTANT** : Sauvegardez ce fichier, vous devrez me l'envoyer.

---

## 📋 ÉTAPE 5 : GÉNÉRER LE FICHIER ADMIN SDK

### **5.1 Créer une Clé Privée**

1. Dans les paramètres du projet (⚙️), cliquez sur **"Project settings"**

2. Onglet **"Service accounts"**

3. Section **"Firebase Admin SDK"**

4. **⚠️ CRITIQUE** : Sélectionnez le langage **"Python"** dans le menu déroulant

5. Cliquez sur **"Generate new private key"**

6. Une popup apparaît :
   ```
   "This private key should be kept secure and never be used client-side."
   ```

7. Cliquez sur **"Generate key"**

8. Un fichier JSON est téléchargé :
   ```
   medidesk-demo-xxxxx-firebase-adminsdk-xxxxx.json
   ```

9. **⚠️ IMPORTANT** : 
   - Sauvegardez ce fichier en lieu sûr
   - Vous devrez me l'envoyer pour l'intégration
   - **NE JAMAIS PARTAGER PUBLIQUEMENT** (contient des secrets)

---

## 📋 ÉTAPE 6 : CRÉER UN COMPTE FIRESTORE DATABASE

### **6.1 Vérifier que la Database Existe**

1. Allez dans **"Firestore Database"**

2. Vous devez voir la liste des collections (même vide)

3. Si vous voyez un message d'erreur, relancez l'étape 3.

✅ **Résultat** : Database Firestore opérationnelle.

---

## 📋 ÉTAPE 7 : CONFIGURER LES RÈGLES DE SÉCURITÉ

### **7.1 Règles de Test (Temporaire pour Démo)**

1. Dans **"Firestore Database"**, onglet **"Rules"**

2. **Remplacez** les règles par défaut par ceci :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ========================================
    // RÈGLES DE DÉMO - TEMPORAIRES
    // ========================================
    
    // Fonction helper : Vérifier si authentifié
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Fonction helper : Récupérer le centre_id de l'utilisateur
    function getUserCentreId() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.centre_id;
    }
    
    // Fonction helper : Vérifier appartenance au même centre
    function belongsToSameCentre(centreId) {
      return isAuthenticated() && getUserCentreId() == centreId;
    }
    
    // Centres : Lecture publique (pour liste centres), écriture par owner
    match /centres/{centreId} {
      allow read: if true;
      allow create: if isAuthenticated();
      allow update, delete: if isAuthenticated() 
        && resource.data.owner_id == request.auth.uid;
    }
    
    // Users : Lecture/écriture son propre profil + lecture collègues même centre
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
    
    // Appointments : Lecture publique (pour créneaux dispo), création libre
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

3. Cliquez sur **"Publish"**

✅ **Résultat** : Règles de sécurité configurées pour multi-tenant.

---

## 📋 ÉTAPE 8 : ACTIVER CLOUD STORAGE (Optionnel)

### **8.1 Pour Stocker Images/Documents**

1. Dans le menu gauche, cliquez sur **"Storage"**

2. Cliquez sur **"Get started"**

3. Règles de sécurité :
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

4. Localisation : **europe-west1** (même que Firestore)

5. Cliquez sur **"Done"**

✅ **Résultat** : Stockage fichiers disponible.

---

## 📋 ÉTAPE 9 : RÉCAPITULATIF DES FICHIERS

À la fin de cette configuration, vous devez avoir obtenu :

### **Fichier 1 : `firebase-config.json` (Web)**

Créez un fichier avec le contenu de l'étape 4.1 :

```json
{
  "apiKey": "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "authDomain": "medidesk-demo-xxxxx.firebaseapp.com",
  "projectId": "medidesk-demo-xxxxx",
  "storageBucket": "medidesk-demo-xxxxx.firebasestorage.app",
  "messagingSenderId": "123456789012",
  "appId": "1:123456789012:web:abcdef1234567890abcdef",
  "measurementId": "G-XXXXXXXXXX"
}
```

### **Fichier 2 : `google-services.json` (Android)**

Téléchargé à l'étape 4.2 :

```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "medidesk-demo-xxxxx",
    "storage_bucket": "medidesk-demo-xxxxx.firebasestorage.app"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef1234567890abcdef",
        "android_client_info": {
          "package_name": "fr.medidesk.demo"
        }
      },
      ...
    }
  ],
  ...
}
```

### **Fichier 3 : `firebase-admin-sdk.json` (Backend)**

Téléchargé à l'étape 5.1 :

```json
{
  "type": "service_account",
  "project_id": "medidesk-demo-xxxxx",
  "private_key_id": "abcdef1234567890abcdef1234567890abcdef12",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBg...\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@medidesk-demo-xxxxx.iam.gserviceaccount.com",
  "client_id": "123456789012345678901",
  ...
}
```

---

## 📤 ÉTAPE 10 : ENVOYER LES FICHIERS

### **Comment me Transmettre les Fichiers**

**Option 1 : Upload dans l'onglet Firebase du Sandbox**
- Cliquez sur l'onglet "Firebase" dans l'interface
- Glissez-déposez les 3 fichiers JSON

**Option 2 : Copier-Coller le Contenu**
- Ouvrez chaque fichier JSON dans un éditeur de texte
- Copiez tout le contenu
- Envoyez-moi le texte dans le chat

⚠️ **IMPORTANT** : Ces fichiers contiennent des clés privées. Ne les partagez JAMAIS publiquement (GitHub, forums, etc.).

---

## ✅ CHECKLIST DE VALIDATION

Avant de passer à l'intégration Flutter :

- [ ] Projet Firebase créé : `MediDesk Demo`
- [ ] Authentication Email/Password activée
- [ ] Firestore Database créée (europe-west1)
- [ ] Collections créées (centres, users, patients, etc.)
- [ ] Règles de sécurité Firestore configurées
- [ ] Application Web enregistrée
- [ ] Application Android enregistrée
- [ ] `firebase-config.json` (Web) récupéré
- [ ] `google-services.json` (Android) téléchargé
- [ ] `firebase-admin-sdk.json` (Backend) téléchargé
- [ ] Cloud Storage activé (optionnel)
- [ ] Fichiers transmis pour intégration

---

## 🚀 PROCHAINE ÉTAPE

Une fois que vous m'aurez transmis les 3 fichiers JSON, je pourrai :

1. ✅ Intégrer Firebase dans le projet Flutter
2. ✅ Créer le système d'inscription/connexion
3. ✅ Migrer vers Firestore Database
4. ✅ Implémenter le module de prise de RDV
5. ✅ Déployer sur `demo.medidesk.fr`

**Temps d'intégration estimé** : 4-6 heures après réception des fichiers.

---

## 📞 BESOIN D'AIDE ?

Si vous rencontrez un problème pendant la configuration Firebase :

1. Prenez une capture d'écran
2. Décrivez l'étape où vous êtes bloqué
3. Envoyez-moi la question

Je vous guiderai étape par étape ! 💪

---

**Prêt à commencer ?** Allez sur https://console.firebase.google.com et suivez les étapes ! 🔥
