# 📋 README Session - MediDesk

**Résumé exécutif pour développeurs IA - Démarrage rapide**

---

## 🎯 Qu'est-ce que MediDesk ?

**MediDesk** = Logiciel de gestion de cabinet médical (kinésithérapeutes, ostéopathes).

**Architecture hybride** :
- **Mode Démo** : Firebase (cloud, démo en ligne)
- **Mode Local** : Flask API + SQLite (100% offline, installation cabinet)

**Conformité RGPD obligatoire** (données sensibles de santé).

---

## 📁 Accès Rapide

| Ressource | Lien |
|-----------|------|
| **Repository GitHub** | `https://github.com/RBSoftwareAI/kine` |
| **Branche** | `base` |
| **Firebase Console** | `https://console.firebase.google.com/project/kinecare-81f52` |
| **Web Preview** | Port 5060 (sandbox) |
| **API Backend** | Port 5000 (http://localhost:5000) |

---

## 📚 Documentation (Ordre de Lecture)

**OBLIGATOIRE pour démarrage session** :
1. ✅ **`AI_QUICK_START.md`** - Guide express (10min lecture)
   - Statut projet
   - Commandes essentielles
   - Code structure
   - Issues communes

2. ✅ **`CONTEXT.md`** - Vision complète (15min lecture)
   - Architecture hybride
   - Obligations RGPD
   - Roadmap développement

3. ✅ **`PROMPT_PROCHAINE_SESSION.md`** - État actuel + prochaines étapes
   - Travaux terminés
   - Tâches en cours
   - Priorités

**Documentation additionnelle** :
- `DEPLOYMENT_GUIDE.md` - 4 méthodes de déploiement (Firebase, Cloudflare, Vercel, Netlify)
- `README_DEMO.md` - Documentation publique pour utilisateurs

---

## ✅ État Actuel (Résumé Ultra-Rapide)

### **Frontend Flutter** ✅ PRODUCTION-READY
- ✅ Authentification Firebase Auth
- ✅ Dashboard multi-rôles (admin, praticien, assistant)
- ✅ Gestion patients (CRUD, archivage RGPD)
- ✅ Gestion rendez-vous (calendrier, états)
- ✅ Build production optimisé (17.2s)
- ✅ PWA configurée (SEO, manifest.json)
- ✅ Déploiement préparé (firebase.json)

### **Backend Flask API** ✅ TERMINÉ
- ✅ 5 routes REST (auth, patients, appointments, centres, audit)
- ✅ 5 modèles SQLAlchemy (User, Patient, Appointment, Centre, AuditLog)
- ✅ JWT authentication (access + refresh tokens)
- ✅ Sécurité : bcrypt, verrouillage compte, validation données
- ✅ RGPD : audit logs automatiques, archivage patients
- ✅ Multi-tenant (centres isolés)
- ✅ Testé et fonctionnel (port 5000)

### **À Faire** 🔄
- ⚠️ **Architecture hybride** : `DataService` abstrait (Firebase + Flask)
- ⚠️ **Documentation RGPD** : 6 documents juridiques (CGU, consentement, registre, etc.)
- ⚠️ **Déploiement final** : demo.medidesk.fr (DNS + Firebase Hosting)

---

## 🚀 Démarrage Rapide (4 commandes)

### **1. Vérifier état Git**
```bash
cd /home/user/flutter_app && git status
```

### **2. Démarrer Flutter (preview web)**
```bash
cd /home/user/flutter_app && flutter run -d web-server --web-port 5060
```

### **3. Démarrer Flask API**
```bash
cd /home/user/medidesk_backend && source venv/bin/activate && python run.py
```

### **4. Tester connectivité**
```bash
curl http://localhost:5000/health  # Backend
curl http://localhost:5060         # Frontend
```

---

## 📂 Arborescence Simplifiée

```
/home/user/flutter_app/          # Frontend Flutter
├── lib/
│   ├── models/                  # 11 modèles Dart
│   ├── providers/               # AuthProvider, etc.
│   ├── services/                # ⚠️ À CRÉER : DataService abstrait
│   ├── views/                   # Écrans UI
│   └── main.dart
├── firebase.json                # Config Firebase Hosting
├── AI_QUICK_START.md            # ⚠️ LIRE EN 1ER
└── CONTEXT.md                   # ⚠️ LIRE EN 2ème

/home/user/medidesk_backend/     # Backend Flask API
├── app/
│   ├── models/                  # 5 modèles SQLAlchemy
│   ├── routes/                  # 5 routes REST
│   └── utils/                   # decorators, validators
├── run.py                       # Script démarrage
└── .env                         # Config (DATABASE_URL, JWT_SECRET, etc.)
```

---

## 🎯 Prochaines Étapes (Priorités)

**Session actuelle recommandée** :

### **1. Phase F : Architecture Hybride** 🔥 (3-4h)
**Objectif** : Permettre à Flutter d'utiliser soit Firebase, soit Flask API.

**Tâches** :
- [ ] Créer `lib/services/data_service.dart` (interface abstraite)
- [ ] Créer `lib/services/firebase_data_service.dart` (implémentation Firebase)
- [ ] Créer `lib/services/flask_data_service.dart` (implémentation Flask API)
- [ ] Modifier `lib/providers/auth_provider.dart` (injection DataService)
- [ ] Ajouter toggle UI "Mode Démo / Mode Local"
- [ ] Tests d'intégration

### **2. Option C : Documentation RGPD** 🔥 (2-3h)
**Objectif** : Conformité légale complète pour cabinets.

**Livrables** :
- [ ] `GUIDE_PRATICIEN_RGPD.md` (responsabilités, procédures)
- [ ] `CGU_CGV.md` (conditions utilisation + vente)
- [ ] `CONSENTEMENT_PATIENT.md` (template formulaire)
- [ ] `PROCEDURE_DROITS_PATIENTS.md` (accès, rectification, effacement)
- [ ] `REGISTRE_TRAITEMENT.md` (registre RGPD pré-rempli)
- [ ] `NOTICE_INFORMATION_CNIL.md` (affichage cabinet)

### **3. Déploiement demo.medidesk.fr** (30-45min)
**Prérequis** : Phase F terminée.

**Étapes** :
- [ ] `firebase deploy --only hosting`
- [ ] Config DNS demo.medidesk.fr
- [ ] Tests Lighthouse (Performance/Accessibilité >90)

---

## 🔧 Commandes Critiques (Copier-Coller)

### **Git**
```bash
# Commit + Push
cd /home/user/flutter_app
git add -A
git commit -m "feat(hybrid): Implémentation DataService abstrait"
git push origin base
```

### **Flutter**
```bash
# Analyse code
cd /home/user/flutter_app && flutter analyze

# Build production
cd /home/user/flutter_app && flutter build web --release
```

### **Flask**
```bash
# Redémarrer API
cd /home/user/medidesk_backend
source venv/bin/activate
python run.py
```

---

## 🐛 Issues Résolues (Session Précédente)

✅ **Authentification** : Compatibilité nommage (`currentUser` → `appUser`)  
✅ **User Model** : Ajout propriétés manquantes (`isAdmin`, `fullName`, etc.)  
✅ **Flutter Analyze** : Correction 25 issues → 13 warnings bénins  
✅ **Backend Flask** : Correction import `timedelta` dans `user.py`  
✅ **SQLite** : Remplacement SQLCipher par SQLite standard (compatibilité)  
✅ **Config production** : Ajout validation `DATABASE_ENCRYPTION_KEY`  
✅ **Routes Flask** : Correction syntaxe `patients.py`  

---

## 💡 Conseils IA

**Points d'attention** :
- ✅ Backend Flask 100% fonctionnel (6 endpoints actifs)
- ✅ Build Flutter production opérationnel (17.2s)
- ⚠️ Versions sandbox : Flutter 3.35.4, Dart 3.9.2 (NE PAS upgrader)
- ⚠️ Packages compatibles : `http: 1.5.0`, `provider: 6.1.5+1`, `firebase_core: 3.6.0`
- ⚠️ RGPD = contrainte légale absolue (consentement, droits patients, audit logs)

**Best Practices** :
- Toujours lire `AI_QUICK_START.md` et `CONTEXT.md` avant de coder
- Tester API Flask (`curl http://localhost:5000/health`) avant intégration Flutter
- Utiliser `.env` pour config sensible (jamais commit secrets)
- Commenter code (docs futures praticiens)
- Valider données côté client ET serveur

---

## 📞 Contacts Support

**En cas de blocage** :
1. Consulter `AI_QUICK_START.md` → Section "Résolution problèmes fréquents"
2. Consulter `CONTEXT.md` → Section "Contraintes techniques"
3. Vérifier logs :
   - Flutter : `flutter run -v`
   - Flask : `tail -f /home/user/medidesk_backend/logs/medidesk.log`

---

## 📊 Métriques Projet

| Métrique | Valeur |
|----------|--------|
| **Fichiers Flutter** | ~50 fichiers Dart |
| **Fichiers Backend** | ~40 fichiers Python |
| **Modèles Données** | 11 Flutter + 5 SQLAlchemy |
| **Routes API** | 5 REST (auth, patients, appointments, centres, audit) |
| **Tests** | À créer (Phase F) |
| **Couverture RGPD** | 80% (manque docs juridiques) |
| **Déploiement** | Préparé (pas encore déployé) |

---

**Dernière mise à jour** : Session précédente  
**Statut** : Production-ready (Firebase) / Backend Flask terminé / Hybrid arch + RGPD docs EN COURS

---

**🚀 Bon développement !**
