# 🚀 Guide de Déploiement Firebase Hosting - MediDesk

Ce guide explique comment déployer **MediDesk** sur **demo.medidesk.fr** avec **Firebase Hosting**.

---

## 📋 Prérequis

✅ Projet Firebase : `kinecare-81f52`  
✅ Domaine `medidesk.fr` configuré sur votre registrar (Gandi, etc.)  
✅ Compte GitHub avec dépôt : https://github.com/RBSoftwareAI/kine  
✅ Firebase CLI installé localement

---

## 🎯 ÉTAPE 1 : Authentification Firebase

### 1.1 Générer un Token CI Firebase

Sur votre **machine locale**, exécutez :

```bash
firebase login:ci
```

Cela ouvrira votre navigateur pour l'authentification Google. Une fois connecté, un token sera généré.

**Exemple de token :**
```
1//0gXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**⚠️ IMPORTANT : Conservez ce token de manière sécurisée !**

### 1.2 Configuration dans l'environnement de build

Le token sera utilisé pour déployer automatiquement :

```bash
export FIREBASE_TOKEN="votre-token-ici"
firebase deploy --token "$FIREBASE_TOKEN"
```

---

## 🔧 ÉTAPE 2 : Configuration Firebase Hosting

### 2.1 Fichiers de configuration déjà prêts

Les fichiers suivants sont déjà configurés dans le projet :

**`.firebaserc`** - Définit le projet Firebase
```json
{
  "projects": {
    "default": "kinecare-81f52"
  }
}
```

**`firebase.json`** - Configuration du hosting
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "/",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "no-cache, no-store, must-revalidate"
          }
        ]
      }
    ],
    "cleanUrls": true,
    "trailingSlash": false
  }
}
```

### 2.2 Build Flutter pour le Web

```bash
cd /home/user/flutter_app
flutter pub get
flutter build web --release
```

**✅ Build réussi !** Les fichiers sont dans `build/web/`

---

## 🚀 ÉTAPE 3 : Déploiement sur Firebase Hosting

### 3.1 Déploiement avec Token CI

```bash
cd /home/user/flutter_app
firebase deploy --only hosting --token "$FIREBASE_TOKEN"
```

### 3.2 URL par défaut

Après déploiement, votre app sera accessible sur :
```
https://kinecare-81f52.web.app
https://kinecare-81f52.firebaseapp.com
```

---

## 🌐 ÉTAPE 4 : Configuration du Domaine Personnalisé

### 4.1 Ajouter le domaine dans Firebase Console

1. **Aller sur Firebase Console** : https://console.firebase.google.com/
2. Sélectionner le projet : **kinecare-81f52**
3. Menu latéral → **Hosting**
4. Onglet **"Domaines personnalisés"** ou **"Custom domains"**
5. Cliquer **"Ajouter un domaine personnalisé"**
6. Entrer : `demo.medidesk.fr`

### 4.2 Configuration DNS requise

Firebase vous donnera des enregistrements DNS à configurer sur votre registrar (Gandi, etc.) :

**Type A (pour demo.medidesk.fr) :**
```
Type: A
Nom: demo
Valeur: (IP fournie par Firebase, typiquement 151.101.1.195 ou 151.101.65.195)
TTL: 3600
```

**Ou Type CNAME (alternative) :**
```
Type: CNAME
Nom: demo
Valeur: kinecare-81f52.web.app.
TTL: 3600
```

### 4.3 Configuration DNS sur Gandi (Exemple)

1. **Connexion Gandi** : https://admin.gandi.net/
2. Domaines → `medidesk.fr`
3. **Enregistrements DNS**
4. **Ajouter un enregistrement** :

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| **A** ou **CNAME** | demo | (valeur fournie par Firebase) | 3600 |

### 4.4 Vérification DNS

Firebase vérifiera automatiquement la configuration DNS. Cela peut prendre **10 à 24 heures** pour la propagation complète.

**Vérifier la propagation DNS :**
```bash
# Sur Linux/Mac
dig demo.medidesk.fr

# Sur Windows
nslookup demo.medidesk.fr
```

---

## 🔄 ÉTAPE 5 : Activation HTTPS et SSL

Firebase gère automatiquement les certificats SSL via **Let's Encrypt**.

**Une fois le domaine vérifié :**
- ✅ Certificat SSL généré automatiquement
- ✅ HTTPS activé par défaut
- ✅ Redirection HTTP → HTTPS automatique
- ✅ Renouvellement automatique du certificat

**Délai d'activation SSL :** 10-30 minutes après vérification DNS

---

## ✅ ÉTAPE 6 : Tests de Production

### 6.1 Test Frontend

1. **Aller sur** : https://demo.medidesk.fr
2. **Vérifier** :
   - Page de login s'affiche correctement
   - Design orange/noir intact
   - Connexion Firebase fonctionne
   - Certificat SSL valide (cadenas vert 🔒)

### 6.2 Test Firebase Authentication

**Vérifier que Firebase Auth fonctionne :**
- Création de compte
- Connexion utilisateur
- Réinitialisation mot de passe

### 6.3 Test Firestore

**Vérifier que Firestore fonctionne :**
- Lecture des données patients
- Écriture des nouveaux rendez-vous
- Synchronisation en temps réel

---

## 📊 Surveillance et Logs

### 7.1 Firebase Console - Monitoring

**Dashboard Firebase Hosting :**
- Trafic et nombre de requêtes
- Utilisation de la bande passante
- Temps de réponse
- Erreurs HTTP

**Accès :** https://console.firebase.google.com/ → Hosting → Usage

### 7.2 Firebase Analytics

**Si Firebase Analytics est activé :**
- Nombre d'utilisateurs actifs
- Sessions par pays
- Pages les plus visitées
- Taux de conversion

---

## 💰 Coûts Firebase Hosting

| Service | Plan Gratuit | Dépassement |
|---------|--------------|-------------|
| **Stockage** | 10 GB | $0.026/GB/mois |
| **Bande passante** | 360 MB/jour | $0.15/GB |
| **Déploiements** | Illimités | Gratuit |
| **Domaines personnalisés** | Illimités | Gratuit |
| **SSL** | Gratuit | Gratuit |

**Pour une petite app (100-500 utilisateurs/jour) :**
- **Coût estimé : 0€/mois** (dans le plan gratuit)

**Domaine medidesk.fr :**
- **~12€/an** (Gandi ou autre registrar)

**TOTAL : ~1€/mois**

---

## 🔄 Déploiements Futurs (CI/CD)

### 8.1 Déploiement Manuel

```bash
# 1. Build Flutter
flutter build web --release

# 2. Deploy Firebase
firebase deploy --only hosting --token "$FIREBASE_TOKEN"
```

### 8.2 Déploiement Automatique avec GitHub Actions

**Créer `.github/workflows/firebase-deploy.yml` :**

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches:
      - base

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.4'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build Flutter Web
        run: flutter build web --release
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: kinecare-81f52
```

**Configuration GitHub Secrets :**
1. GitHub → Repository → Settings → Secrets → Actions
2. Ajouter : `FIREBASE_SERVICE_ACCOUNT` avec votre token CI

**Résultat :**
- Push sur `base` → Déploiement automatique ✅
- **Temps de déploiement : 3-5 minutes**

---

## 🆘 Dépannage

### Problème : "Domain not verified"

**Solution :**
1. Vérifier les enregistrements DNS sur votre registrar
2. Attendre 10-24h pour propagation DNS
3. Vérifier avec `dig demo.medidesk.fr`

### Problème : "SSL certificate pending"

**Solution :**
1. Attendre 30 minutes après vérification DNS
2. Vérifier que le domaine pointe correctement
3. Firebase génère automatiquement le certificat

### Problème : "Build failed"

**Solution :**
1. Vérifier que `flutter build web --release` fonctionne localement
2. Vérifier les dépendances dans `pubspec.yaml`
3. Nettoyer le cache : `flutter clean && flutter pub get`

### Problème : "404 Not Found"

**Solution :**
1. Vérifier que `firebase.json` pointe vers `build/web`
2. Vérifier que les rewrites sont configurés
3. Redéployer : `firebase deploy --only hosting`

---

## 📞 Support

**Documentation Firebase Hosting :** https://firebase.google.com/docs/hosting  
**Firebase Status :** https://status.firebase.google.com/  
**GitHub Issues :** https://github.com/RBSoftwareAI/kine/issues  

---

## ✅ Résumé Final

Une fois le déploiement terminé :

✅ **URL de production** : https://demo.medidesk.fr  
✅ **URL Firebase** : https://kinecare-81f52.web.app  
✅ **SSL/HTTPS** : Automatique et gratuit  
✅ **Domaine personnalisé** : Configuré  
✅ **Coût** : ~1€/mois (domaine uniquement)  
✅ **CI/CD** : Optionnel avec GitHub Actions  

**🎉 Votre application MediDesk est prête pour la production !**

---

**Version 1.0.0 - Novembre 2025**
