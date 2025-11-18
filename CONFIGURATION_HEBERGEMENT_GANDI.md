# 🌐 CONFIGURATION HÉBERGEMENT GANDI - demo.medidesk.fr

**Date** : 18 novembre 2025  
**Domaine** : medidesk.fr (acheté chez Gandi)  
**Pack** : Simple Hosting Gandi  
**Emails** : 2 adresses incluses

---

## 📊 SITUATION ACTUELLE

### **Ce que vous avez chez Gandi**

✅ **Domaine medidesk.fr** acheté  
✅ **Pack Simple Hosting** (hébergement web intégré)  
✅ **2 emails inclus** :
   - `contact@medidesk.fr`
   - `support@medidesk.fr`

### **Ce que vous avez dans Firebase**

✅ **Projet Firebase créé** : `KinéCare`  
⏳ **À renommer** : `MediDesk-Demo`  
⏳ **Configuration à compléter** : Authentication, Firestore, etc.

---

## 🎯 RECOMMANDATION : NE PAS UTILISER L'HÉBERGEMENT GANDI

### **Pourquoi ?**

**❌ Simple Hosting Gandi n'est PAS adapté pour Flutter Web** :

1. **Limitations techniques** :
   - Conçu pour WordPress, Prestashop, Nextcloud
   - Pas de support natif pour applications Flutter compilées
   - Configuration Apache/PHP, pas optimisée pour SPA (Single Page Application)
   - Pas de configuration automatique des routes SPA
   - Pas de headers CORS optimisés pour Firebase

2. **Complexité inutile** :
   - Configuration manuelle complexe requise
   - Pas de SSL automatique facile
   - Pas de déploiement Git automatisé
   - Maintenance manuelle des mises à jour

3. **Coût/Bénéfice** :
   - Vous payez pour un hébergement que vous n'utiliserez pas pleinement
   - Netlify offre mieux gratuitement pour Flutter Web

---

## ✅ SOLUTION RECOMMANDÉE : NETLIFY + DNS GANDI

### **Architecture Optimale**

```
medidesk.fr (domaine Gandi)
    ↓
DNS configuré chez Gandi
    ↓
CNAME demo → [app-name].netlify.app
    ↓
Application Flutter hébergée sur Netlify (gratuit)
    ↓
Firebase (Backend, Auth, Database)
```

### **Avantages de cette approche**

✅ **Netlify** (hébergement Flutter) :
- Gratuit pour démo (100 Go/mois)
- Déploiement automatisé via Git
- SSL/HTTPS automatique
- CDN mondial ultra-rapide
- Configuration SPA automatique
- Build automatique Flutter
- Rollback facile

✅ **Gandi** (DNS + Emails) :
- Contrôle total DNS medidesk.fr
- 2 emails professionnels actifs
- Domaine professionnel

✅ **Firebase** (Backend) :
- Authentication
- Firestore Database
- Cloud Storage
- Cloud Functions (emails)

---

## 🛠️ UTILISATION OPTIMALE DE VOTRE PACK GANDI

### **Ce qu'on va utiliser chez Gandi**

1. **DNS Management** (gratuit avec le domaine) ✅
   - Configuration des sous-domaines
   - Pointage vers Netlify
   - Configuration emails

2. **Emails professionnels** (inclus dans le pack) ✅
   - `contact@medidesk.fr` → Support utilisateurs
   - `support@medidesk.fr` → Assistance technique

3. **Domaine medidesk.fr** ✅
   - Votre marque professionnelle

### **Ce qu'on ne va PAS utiliser (pour l'instant)**

4. **Simple Hosting Gandi** ❌
   - Gardé en réserve pour futur site vitrine medidesk.fr
   - Ou documentation publique
   - Ou blog d'actualités

---

## 📧 CONFIGURATION DES EMAILS GANDI

### **Étape 1 : Créer les 2 Adresses Email**

1. **Connexion Gandi** :
   ```
   https://admin.gandi.net
   ```

2. **Aller dans "Email"** :
   - Menu latéral → Email
   - Sélectionner medidesk.fr

3. **Créer les boîtes email** :

   **Email 1 : contact@medidesk.fr**
   ```
   Nom : Contact MediDesk
   Usage : Support général, demandes d'information
   Redirection possible vers votre email personnel
   ```

   **Email 2 : support@medidesk.fr**
   ```
   Nom : Support Technique MediDesk
   Usage : Assistance technique, bugs, problèmes
   Redirection possible vers votre email personnel
   ```

4. **Configuration SMTP (pour Cloud Functions)** :
   ```
   Serveur SMTP : mail.gandi.net
   Port : 587 (TLS)
   Authentification : contact@medidesk.fr / [votre_mot_de_passe]
   ```

---

## 🌐 CONFIGURATION DNS GANDI

### **Enregistrements DNS à Créer**

**Connexion** : https://admin.gandi.net → Domaines → medidesk.fr → DNS

**1. Sous-domaine démo (demo.medidesk.fr)**
```
Type : CNAME
Nom : demo
Valeur : [votre-app].netlify.app.
TTL : 3600
```
⚠️ **Note** : La valeur exacte sera fournie par Netlify après déploiement.

**2. Email MX Records (déjà configurés par Gandi)**
```
Type : MX
Priorité : 10, 50
Valeur : spool.mail.gandi.net, fb.mail.gandi.net
```
✅ Normalement déjà configuré automatiquement.

**3. SPF (anti-spam)**
```
Type : TXT
Nom : @
Valeur : v=spf1 include:_mailcust.gandi.net ?all
```
✅ Normalement déjà configuré automatiquement.

**4. Futur : www et domaine principal (quand site vitrine prêt)**
```
Type : CNAME
Nom : www
Valeur : demo.medidesk.fr

Type : A (ou CNAME)
Nom : @
Valeur : [IP Netlify ou CNAME]
```

---

## 🔥 CONFIGURATION FIREBASE - RENOMMAGE PROJET

### **Problème : Impossible de Renommer un Projet Firebase**

❌ Firebase ne permet PAS de renommer un projet après création.

### **Solutions**

**Option 1 : RECOMMANDÉE - Garder "KinéCare" comme Project ID**
```
Project Name : MediDesk Demo (modifiable dans settings)
Project ID : kinecare-xxxxx (NON modifiable)
```

**Avantages** :
- Pas de recréation nécessaire
- Configuration déjà commencée conservée
- Project ID n'est visible que dans l'URL Firebase Console

**Action** :
1. Firebase Console → Project Settings (⚙️)
2. Section "General"
3. Project Name → Modifier en **"MediDesk Demo"**
4. Project ID reste `kinecare-xxxxx` (peu importe)

---

**Option 2 : Créer un Nouveau Projet (si nécessaire)**
```
Project Name : MediDesk Demo
Project ID : medidesk-demo-xxxxx (auto-généré)
```

**Inconvénients** :
- Perte de la configuration déjà faite
- Nouveaux fichiers JSON à télécharger

**Recommandation** : ⚠️ Seulement si vous n'avez PAS encore configuré Authentication, Firestore, etc.

---

## 📋 PLAN D'ACTION COMPLET

### **Phase 1 : Configuration Firebase (AUJOURD'HUI - 30 min)**

**1.1 Renommer (cosmétique) le projet**
- [ ] Firebase Console → Settings
- [ ] Changer "Project Name" en **"MediDesk Demo"**
- [ ] Project ID reste `kinecare-xxxxx` (OK)

**1.2 Suivre le guide `GUIDE_CONFIGURATION_FIREBASE.md`**
- [ ] Activer Authentication Email/Password
- [ ] Créer Firestore Database (europe-west1)
- [ ] Configurer règles Firestore
- [ ] Enregistrer application Web
- [ ] Enregistrer application Android
- [ ] Télécharger 3 fichiers JSON

**1.3 M'envoyer les fichiers JSON**
- [ ] firebase-config.json (Web)
- [ ] google-services.json (Android)
- [ ] firebase-admin-sdk.json (Backend)

---

### **Phase 2 : Configuration Emails Gandi (AUJOURD'HUI - 15 min)**

**2.1 Créer les 2 adresses email**
- [ ] contact@medidesk.fr
- [ ] support@medidesk.fr

**2.2 Tester réception email**
- [ ] Envoyer un email de test à contact@medidesk.fr
- [ ] Vérifier réception dans webmail Gandi

**2.3 Noter identifiants SMTP**
```
Serveur : mail.gandi.net
Port : 587
User : contact@medidesk.fr
Password : [votre_mot_de_passe]
```
→ Nécessaire pour Cloud Functions (notifications)

---

### **Phase 3 : Intégration Flutter + Firebase (DEMAIN - 6-8h)**

**Moi, après réception des fichiers JSON** :
- [ ] Intégrer firebase_options.dart
- [ ] Créer système d'authentification
- [ ] Implémenter FirestoreRepository
- [ ] Tests multi-tenant

---

### **Phase 4 : Déploiement Netlify (JOUR 3 - 2h)**

**4.1 Build Flutter**
```bash
flutter build web --release
```

**4.2 Déploiement Netlify**
- [ ] Créer compte Netlify (avec GitHub)
- [ ] Connecter au repository `RBSoftwareAI/kine`
- [ ] Configurer build : `flutter build web --release`
- [ ] Publish directory : `build/web`
- [ ] Déployer

**4.3 Configuration domaine personnalisé**
- [ ] Netlify : Ajouter domaine `demo.medidesk.fr`
- [ ] Netlify affichera : `CNAME demo → [app-name].netlify.app`
- [ ] Copier cette valeur

---

### **Phase 5 : Configuration DNS Gandi (JOUR 3 - 10 min)**

**5.1 Ajouter enregistrement DNS**
- [ ] admin.gandi.net → medidesk.fr → DNS
- [ ] Ajouter CNAME : demo → [app-name].netlify.app.
- [ ] Sauvegarder

**5.2 Attendre propagation DNS (5-30 minutes)**
```bash
# Vérifier propagation
dig demo.medidesk.fr

# Résultat attendu :
demo.medidesk.fr. 3600 IN CNAME [app-name].netlify.app.
```

**5.3 Tester l'URL finale**
```
https://demo.medidesk.fr
```

---

## 📊 RÉCAPITULATIF DES SERVICES

| Service | Utilisation | Coût | Statut |
|---------|-------------|------|--------|
| **Gandi Domaine** | medidesk.fr (propriété) | Déjà payé | ✅ Actif |
| **Gandi DNS** | Configuration sous-domaines | Inclus | ✅ À configurer |
| **Gandi Emails** | contact@ + support@ | Inclus | ✅ À créer |
| **Gandi Simple Hosting** | Non utilisé (réservé futur) | Déjà payé | ⏸️ En attente |
| **Firebase** | Auth + Firestore + Storage | Gratuit (démo) | ⏳ À finaliser |
| **Netlify** | Hébergement Flutter Web | Gratuit | ⏳ À configurer |

---

## ✅ CHECKLIST FINALE

**Avant de passer à l'implémentation** :

**Firebase** :
- [ ] Projet renommé "MediDesk Demo" (cosmétique)
- [ ] Authentication activée
- [ ] Firestore Database créée
- [ ] Règles Firestore configurées
- [ ] 3 fichiers JSON téléchargés et envoyés

**Gandi** :
- [ ] 2 emails créés (contact@ + support@)
- [ ] Identifiants SMTP notés
- [ ] Accès DNS validé

**Prêt pour déploiement** :
- [ ] Fichiers Firebase reçus
- [ ] Intégration Flutter terminée
- [ ] Tests réussis
- [ ] DNS Gandi → Netlify configuré
- [ ] URL demo.medidesk.fr accessible

---

## 💰 OPTIMISATION COÛT

**Ce que vous économisez avec cette approche** :

```
Netlify (hébergement Flutter) : 0€ (gratuit jusqu'à 100 Go/mois)
Firebase (backend démo) : 0€ (gratuit jusqu'à 50K lectures/jour)
Cloudflare CDN : 0€ (inclus dans Netlify)

Total mensuel : 0€ pendant la phase démo

vs

Hébergement VPS alternatif : 5-10€/mois
```

**Ce que vous gardez de Gandi pour l'avenir** :

```
Simple Hosting : Utilisable pour :
  - Site vitrine medidesk.fr (WordPress)
  - Blog d'actualités
  - Documentation publique
  - Landing page marketing
```

---

## 🚀 PROCHAINE ÉTAPE IMMÉDIATE

**ACTION REQUISE DE VOTRE PART (30 minutes)** :

1. **Finaliser configuration Firebase** :
   - Suivre `GUIDE_CONFIGURATION_FIREBASE.md`
   - Télécharger les 3 fichiers JSON
   - Me les envoyer

2. **Créer les 2 emails Gandi** :
   - contact@medidesk.fr
   - support@medidesk.fr
   - Noter identifiants SMTP

3. **Confirmer** :
   - OK pour garder Project ID `kinecare-xxxxx` ?
   - OK pour déployer sur Netlify (gratuit) ?
   - Autres questions ?

**Dès réception des fichiers Firebase, je démarre l'intégration immédiatement !** 🚀

---

**Des questions sur cette configuration ?**
