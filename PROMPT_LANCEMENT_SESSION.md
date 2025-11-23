# 🚀 Prompt de Lancement - Prochaine Session MediDesk

**Version :** 1.0  
**Date :** 21 novembre 2025  
**Statut :** Prêt pour Phase B (Authentification UI)

---

## 📋 PROMPT À COPIER-COLLER

```
Bonjour ! Je continue le développement de l'application MediDesk.

📂 Repository : https://github.com/RBSoftwareAI/kine
🌿 Branche : base
📄 Documentation : Lis d'abord les fichiers dans cet ordre :
   1. AI_QUICK_START.md (guide express)
   2. CONTEXT.md (documentation complète)

🎯 Ma demande pour cette session :
Phase B: Créer les écrans d'authentification (signup et login) pour l'application Flutter MediDesk.

📊 État actuel :
- Infrastructure Firebase : ✅ 100% (configurée)
- Backend Services : ✅ 100% (FirebaseAuthService, AuthProvider, modèles)
- Base de données : ✅ 100% (58 documents de test dans 2 centres)
- Documentation : ✅ 100% (AI_QUICK_START.md, CONTEXT.md)
- UI Flutter : ⏳ 0% (à développer)

🔗 Firebase Console : https://console.firebase.google.com/project/kinecare-81f52

💡 Note : La version beta du site web a été archivée dans website/archive-beta/. 
La version retenue pour production est website/index.html (version complète avec tarifs).
```

---

## 📝 VARIANTES DU PROMPT

### Variante Courte (Minimaliste)
```
Bonjour ! Je continue MediDesk.

Repository : https://github.com/RBSoftwareAI/kine (branche: base)
Documentation : AI_QUICK_START.md + CONTEXT.md

🎯 Demande : Phase B - Écrans d'authentification Flutter (signup/login)

État : Infrastructure ✅ | Backend ✅ | UI ⏳ 0%
```

### Variante Détaillée (Avec Contexte)
```
Bonjour ! Je continue le développement de MediDesk, application de gestion de cabinet pour professionnels de santé.

📂 Repository GitHub : https://github.com/RBSoftwareAI/kine
🌿 Branche : base
📄 Documentation principale :
   - AI_QUICK_START.md (guide express 30 secondes)
   - CONTEXT.md (documentation technique complète)
   - DEPLOYMENT_STRATEGY.md (stratégie de déploiement)

🎯 Ma demande pour cette session :
Développer la Phase B du projet : Écrans d'authentification Flutter

Créer les écrans suivants :
1. lib/screens/auth/signup_screen.dart
   - Formulaire inscription avec création automatique de centre
   - Champs : nom, prénom, email, password, spécialité, nom du centre
   - Validation des champs
   - Intégration FirebaseAuthService.signup()

2. lib/screens/auth/login_screen.dart
   - Formulaire connexion email/password
   - Validation des champs
   - Gestion des erreurs
   - Intégration FirebaseAuthService.login()

3. Mise à jour de lib/main.dart
   - Intégration AuthProvider
   - Navigation conditionnelle (authentifié → Dashboard, sinon → Login)
   - Gestion de l'état de chargement

📊 État actuel du projet :
- ✅ Infrastructure Firebase complète (Auth, Firestore, Storage)
- ✅ Backend Services (FirebaseAuthService, AuthProvider)
- ✅ Modèles de données (Centre, User, Patient, Appointment)
- ✅ Base de données initialisée (58 documents dans 2 centres)
- ✅ Règles de sécurité Firestore (créées, à publier)
- ⏳ UI Flutter à développer (Phase B actuelle)

🔗 Firebase Console : https://console.firebase.google.com/project/kinecare-81f52

💡 Notes importantes :
- Package Android : fr.medidesk.demo (synchronisé partout)
- Firebase configuration : lib/firebase_options.dart (Web + Android)
- Version site web retenue : website/index.html (complète avec tarifs)
- Version beta archivée : website/archive-beta/ (pour référence)

🎨 Design :
- Utiliser Material Design 3
- SafeArea pour éviter overlaps système
- Responsive pour mobile + web
- Loading states et error handling

📚 Références code disponibles dans CONTEXT.md
```

---

## 🎯 CHOIX DU PROMPT SELON LE CONTEXTE

### Utiliser le Prompt COURT si :
- Vous avez déjà travaillé sur ce projet récemment
- L'IA assistant a accès à l'historique récent
- Vous voulez aller vite

### Utiliser le Prompt STANDARD (recommandé) si :
- C'est une nouvelle session après quelques jours
- Vous voulez donner un contexte complet
- Vous voulez maximiser les chances de compréhension

### Utiliser le Prompt DÉTAILLÉ si :
- C'est une session après une longue pause
- Vous avez un assistant IA sans historique
- Vous voulez être très précis sur les attentes

---

## 📚 FICHIERS À MENTIONNER SELON LE BESOIN

### Pour Développement UI (Phase B, C, D)
```
Documentation principale :
- AI_QUICK_START.md (commandes essentielles)
- CONTEXT.md (exemples de code, architecture)
```

### Pour Déploiement
```
Documentation principale :
- DEPLOYMENT_STRATEGY.md (guide Netlify + DNS)
- AI_QUICK_START.md (commandes essentielles)
```

### Pour Comprendre Architecture
```
Documentation principale :
- CONTEXT.md (architecture complète)
- lib/firebase_options.dart (configuration Firebase)
- firestore.rules (règles de sécurité)
```

---

## 🔄 PROMPT POUR SESSIONS SUIVANTES

### Après Phase B (Authentification)
```
🎯 Ma demande pour cette session :
Phase C: Créer le dashboard et la gestion des patients

Développer :
1. Dashboard avec statistiques (nombre patients, RDV du jour, etc.)
2. Liste des patients avec recherche et filtres
3. Formulaire création/modification patient
4. Détail d'un patient avec historique

État : Infrastructure ✅ | Backend ✅ | Auth UI ✅ | Dashboard ⏳
```

### Après Phase C (Dashboard & Patients)
```
🎯 Ma demande pour cette session :
Phase D: Créer le système de gestion des rendez-vous

Développer :
1. Calendrier des rendez-vous (vue jour/semaine/mois)
2. Formulaire création/modification rendez-vous
3. Gestion des créneaux et disponibilités
4. Écran réservation publique (sans compte)

État : Infrastructure ✅ | Backend ✅ | Auth ✅ | Dashboard ✅ | Appointments ⏳
```

### Pour Déploiement Final
```
🎯 Ma demande pour cette session :
Déployer MediDesk en production

Actions :
1. Publier règles Firestore dans Firebase Console
2. Build Flutter web (flutter build web --release)
3. Déployer site web sur medidesk.fr (Netlify)
4. Déployer app Flutter sur demo.medidesk.fr (Netlify)
5. Configurer DNS Gandi pour les deux domaines

État : Développement ✅ | Tests ✅ | Déploiement ⏳
```

---

## 💡 CONSEILS D'UTILISATION

### ✅ Bonnes Pratiques
1. **Toujours mentionner le repository GitHub** (facilite l'accès au code)
2. **Indiquer la branche** (évite les confusions)
3. **Référer aux fichiers de documentation** (AI_QUICK_START.md, CONTEXT.md)
4. **Préciser l'état actuel** (ce qui est fait vs à faire)
5. **Être spécifique sur la demande** (Phase B, C, D, etc.)

### ❌ À Éviter
1. ~~Prompt trop vague~~ → Être précis sur ce qu'on veut développer
2. ~~Oublier le repository~~ → Toujours inclure le lien GitHub
3. ~~Ne pas mentionner la doc~~ → Référer à AI_QUICK_START.md et CONTEXT.md
4. ~~Demandes multiples~~ → Focus sur une phase à la fois

### 🎯 Structurer Votre Demande
```
1. Salutation + contexte projet
2. Lien repository + branche
3. Documentation à consulter
4. Demande spécifique (Phase X)
5. État actuel (ce qui est fait)
6. Liens Firebase/autres ressources
7. Notes importantes (si besoin)
```

---

## 🔗 LIENS DE RÉFÉRENCE RAPIDE

### GitHub
```
Repository : https://github.com/RBSoftwareAI/kine
Branche : base
Documentation : AI_QUICK_START.md, CONTEXT.md, DEPLOYMENT_STRATEGY.md
```

### Firebase
```
Console : https://console.firebase.google.com/project/kinecare-81f52
Firestore : Database avec 58 documents de test
Authentication : Email/Password activé
```

### Domaines
```
Site web : medidesk.fr (à déployer)
App démo : demo.medidesk.fr (à déployer)
Version beta : Archivée dans website/archive-beta/
```

---

## 📅 HISTORIQUE DES SESSIONS

### Session 1 (19 Nov 2025)
- ✅ Configuration Firebase complète
- ✅ Backend services (Auth, Firestore)
- ✅ Modèles de données
- ✅ Base de données initialisée
- ✅ Documentation complète

### Session 2 (21 Nov 2025)
- ✅ Version beta site web créée et archivée
- ✅ Décision : Version complète retenue
- ✅ Organisation fichiers (archive-beta/)
- ✅ Vérification préparation prochaine session

### Session 3 (À venir)
- ⏳ Phase B : Écrans authentification
- ⏳ Phase C : Dashboard + Patients
- ⏳ Phase D : Système rendez-vous
- ⏳ Déploiement production

---

**📅 Document créé le 21 novembre 2025**  
**🔄 Dernière mise à jour : 21 novembre 2025**  
**✅ Statut : PRÊT POUR UTILISATION**

---

## 🚀 PRÊT À COMMENCER ?

**Copiez le prompt standard ci-dessus et lancez votre prochaine session de développement !**

Le projet MediDesk est 100% prêt pour la Phase B (Authentification UI). Tous les fichiers de documentation sont à jour sur GitHub, et la base de données Firebase contient déjà 58 documents de test pour faciliter le développement.

**Bon développement ! 🎉**
