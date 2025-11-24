# 🚀 Prompt pour Prochaine Session - MediDesk

**Contexte complet pour la prochaine session d'IA**

---

## 📁 Repository et Documentation

**Repository GitHub** : `https://github.com/RBSoftwareAI/kine`  
**Branche active** : `base`

**Documentation à lire EN PRIORITÉ** (dans cet ordre) :
1. **`AI_QUICK_START.md`** - Guide express, statut projet, commandes essentielles
2. **`CONTEXT.md`** - Vision stratégique, architecture hybride, obligations légales RGPD

---

## ✅ État Actuel du Projet (Session Précédente)

### 🎯 **Option B : Déploiement demo.medidesk.fr** ✅ TERMINÉ

**Livrables créés** :
- ✅ `DEPLOYMENT_GUIDE.md` - 4 méthodes de déploiement (Firebase, Cloudflare, Vercel, Netlify)
- ✅ `README_DEMO.md` - Documentation publique pour démo
- ✅ Firebase Hosting configuré (`firebase.json`, `.firebaserc` projet `kinecare-81f52`)
- ✅ Optimisations web : SEO, PWA, manifest.json avec couleurs MediDesk (#FF6B35)
- ✅ Build production réussi : `flutter build web --release` (17.2s)
- ✅ Code commit + push vers GitHub : `feat(deployment): Préparer déploiement demo.medidesk.fr`

**🔗 Ressources** :
- Firebase Console : `https://console.firebase.google.com/project/kinecare-81f52`
- Web Preview : Port 5060 (sandbox)
- **Prêt pour déploiement** : `firebase deploy --only hosting`

---

### 🎯 **Option A : Backend Flask REST API** ✅ TERMINÉ

**Livrables créés** (40+ fichiers) :

**Configuration** :
- ✅ `requirements.txt` - Flask 3.0.0, SQLAlchemy, JWT, bcrypt, CORS
- ✅ `config.py` - Configuration multi-environnements (dev/staging/production)
- ✅ `.env` + `.env.example` - Variables d'environnement
- ✅ `run.py` - Script de démarrage Flask

**Modèles SQLAlchemy** (5) :
- ✅ `app/models/user.py` - Professionnels de santé (auth, rôles, sécurité)
- ✅ `app/models/centre.py` - Cabinets médicaux (multi-tenant)
- ✅ `app/models/patient.py` - Patients (RGPD compliant, archivage)
- ✅ `app/models/appointment.py` - Rendez-vous (statuts, annulations)
- ✅ `app/models/audit_log.py` - Traçabilité RGPD (logs automatiques)

**Routes REST** (5) :
- ✅ `app/routes/auth.py` - JWT : login, register, refresh, logout
- ✅ `app/routes/patients.py` - CRUD patients + archivage RGPD
- ✅ `app/routes/appointments.py` - CRUD rendez-vous + filtres
- ✅ `app/routes/centres.py` - CRUD centres (multi-tenant)
- ✅ `app/routes/audit.py` - Consultation logs RGPD

**Sécurité & Utils** :
- ✅ `app/utils/decorators.py` - `@token_required`, `@admin_required`, `@log_audit`
- ✅ `app/utils/validators.py` - Validation données (email, tel, SIRET, etc.)

**Fonctionnalités clés** :
- ✅ Authentification JWT (access + refresh tokens)
- ✅ Hashage bcrypt (mots de passe)
- ✅ Verrouillage compte (5 tentatives = 15min lock)
- ✅ Audit logs automatiques (RGPD)
- ✅ Multi-tenant (centres isolés)
- ✅ Validation données robuste
- ✅ Base SQLite opérationnelle

**Backend testé et fonctionnel** :
```bash
cd /home/user/medidesk_backend
source venv/bin/activate
python run.py
# ✅ Démarre sur http://0.0.0.0:5000
# ✅ 6 endpoints disponibles : /health, /api/auth, /api/patients, /api/appointments, /api/centres, /api/audit
```

**Code commit + push vers GitHub** : `feat(backend): Backend Flask REST API complet`

---

## 🎯 Prochaines Étapes (Priorisation)

### **Phase F : Architecture Hybride** 🔥 PRIORITÉ HAUTE

**Objectif** : Permettre à l'app Flutter d'utiliser **soit Firebase (démo), soit Flask API (local)**.

**Tâches** :
1. **Créer `DataService` abstrait** (interface commune)
   - Méthodes : `auth()`, `getPatients()`, `createAppointment()`, etc.
2. **Implémenter `FirebaseDataService`** (existant à adapter)
3. **Implémenter `FlaskDataService`** (nouveau, utilise API Flask)
4. **Ajouter sélecteur de mode** (UI toggle "Mode Démo" / "Mode Local")
5. **Tests d'intégration** (vérifier cohérence Firebase ↔ Flask)

**Fichiers Flutter à modifier** :
- `lib/services/data_service.dart` (interface abstraite)
- `lib/services/firebase_data_service.dart` (implémentation Firebase)
- `lib/services/flask_data_service.dart` (implémentation Flask API)
- `lib/providers/auth_provider.dart` (injection DataService)
- `lib/views/settings/settings_screen.dart` (toggle mode)

**Estimation** : 3-4 heures

---

### **Option C : Documentation Juridique RGPD** 🔥 PRIORITÉ HAUTE

**Objectif** : Conformité RGPD complète pour installation cabinets (obligation légale).

**Livrables à créer** (6 documents) :
1. **Guide Praticien** (`GUIDE_PRATICIEN_RGPD.md`)
   - Responsabilités du praticien
   - Procédures de consentement
   - Gestion des droits patients (accès, rectification, effacement)
   - Durées de conservation
   - Sécurité des données

2. **CGU/CGV** (`CGU_CGV.md`)
   - Conditions générales d'utilisation (praticiens)
   - Conditions générales de vente (licence logiciel)
   - Propriété intellectuelle
   - Limitation de responsabilité

3. **Modèle Consentement Patient** (`CONSENTEMENT_PATIENT.md`)
   - Template de formulaire patient
   - Finalités du traitement
   - Durée de conservation
   - Droits RGPD (accès, rectification, portabilité, effacement)
   - Coordonnées du DPO

4. **Procédure Gestion Droits Patients** (`PROCEDURE_DROITS_PATIENTS.md`)
   - Procédure accès aux données
   - Procédure rectification
   - Procédure portabilité
   - Procédure effacement ("droit à l'oubli")
   - Délais de réponse (1 mois max)

5. **Registre Activités Traitement** (`REGISTRE_TRAITEMENT.md`)
   - Template pré-rempli pour cabinets
   - Traitements : patients, rendez-vous, facturation
   - Catégories de données
   - Mesures de sécurité
   - Durées de conservation

6. **Notice d'information CNIL** (`NOTICE_INFORMATION_CNIL.md`)
   - Information patients (affichage cabinet)
   - Mentions légales app
   - Coordonnées DPO
   - Exercice des droits

**Estimation** : 2-3 heures

---

### **Phase G : Déploiement Final demo.medidesk.fr** (Après Phase F)

**Prérequis** : Option B déjà prête (code commit + build production).

**Étapes restantes** :
1. Déployer vers Firebase Hosting : `firebase deploy --only hosting`
2. Configurer DNS `demo.medidesk.fr` (CNAME vers `kinecare-81f52.web.app`)
3. Tests fonctionnels + Lighthouse audit (objectif Performance/Accessibilité >90)
4. Configurer monitoring (Firebase Analytics + Crashlytics)

**Estimation** : 30-45 minutes

---

## 📂 Arborescence Projet

```
/home/user/flutter_app/          # 🎯 Frontend Flutter
├── lib/
│   ├── models/                  # 11 modèles (User, Patient, Appointment, etc.)
│   ├── providers/               # AuthProvider, etc.
│   ├── services/                # ⚠️ À CRÉER : DataService (abstrait)
│   │   ├── data_service.dart               # Interface abstraite
│   │   ├── firebase_data_service.dart       # Implémentation Firebase
│   │   └── flask_data_service.dart          # Implémentation Flask API
│   ├── views/                   # Écrans (auth, home, patients, appointments)
│   └── main.dart
├── firebase.json                # Config Firebase Hosting
├── .firebaserc                  # Projet : kinecare-81f52
├── DEPLOYMENT_GUIDE.md          # Guide déploiement 4 méthodes
├── README_DEMO.md               # Doc publique démo
├── AI_QUICK_START.md            # ⚠️ LIRE EN PRIORITÉ
└── CONTEXT.md                   # ⚠️ LIRE EN PRIORITÉ

/home/user/medidesk_backend/     # 🎯 Backend Flask API (TERMINÉ)
├── app/
│   ├── models/                  # 5 modèles SQLAlchemy
│   ├── routes/                  # 5 routes REST (auth, patients, appointments, centres, audit)
│   └── utils/                   # decorators, validators
├── config.py                    # Config multi-env
├── run.py                       # Script démarrage
├── requirements.txt             # Dépendances Python
├── .env                         # Variables d'environnement
└── instance/medidesk.db         # Base SQLite
```

---

## 🔧 Commandes Essentielles

### **Flutter (Frontend)**
```bash
# Démarrer preview web (port 5060)
cd /home/user/flutter_app && flutter run -d web-server --web-port 5060

# Build production
cd /home/user/flutter_app && flutter build web --release

# Analyse code
cd /home/user/flutter_app && flutter analyze

# Tests
cd /home/user/flutter_app && flutter test
```

### **Flask (Backend)**
```bash
# Démarrer API (port 5000)
cd /home/user/medidesk_backend
source venv/bin/activate
python run.py

# Test endpoint
curl http://localhost:5000/health

# Logs
tail -f logs/medidesk.log
```

### **Git**
```bash
# Statut branche base
cd /home/user/flutter_app && git status

# Commit + Push
git add -A
git commit -m "feat(hybrid): Implémentation DataService abstrait"
git push origin base
```

### **Déploiement**
```bash
# Firebase Hosting (quand prêt)
cd /home/user/flutter_app
firebase login  # Si nécessaire
firebase deploy --only hosting

# URL finale : https://kinecare-81f52.web.app
# Alias DNS : demo.medidesk.fr
```

---

## 🔗 Ressources Importantes

- **GitHub Repository** : `https://github.com/RBSoftwareAI/kine`
- **Firebase Console** : `https://console.firebase.google.com/project/kinecare-81f52`
- **Web Preview** : Port 5060 (sandbox)
- **API Backend** : Port 5000 (http://localhost:5000)
- **Documentation** :
  - `AI_QUICK_START.md` (statut projet, commandes)
  - `CONTEXT.md` (architecture, RGPD, roadmap)
  - `DEPLOYMENT_GUIDE.md` (déploiement 4 méthodes)
  - `README_DEMO.md` (doc publique)

---

## 🎯 Ordre de Traitement Recommandé

**Pour maximiser l'impact et la cohérence** :

1. **Phase F : Architecture Hybride** (3-4h)
   - Créer `DataService` abstrait
   - Implémenter `FlaskDataService`
   - Ajouter toggle UI "Mode Démo/Local"
   - Tests intégration

2. **Option C : Documentation Juridique** (2-3h)
   - 6 documents RGPD complets
   - Templates praticiens
   - Conformité légale

3. **Phase G : Déploiement Final** (30-45min)
   - `firebase deploy --only hosting`
   - Config DNS demo.medidesk.fr
   - Tests Lighthouse

---

## 💡 Conseils pour l'IA

**Points d'attention** :
- ✅ Backend Flask **100% fonctionnel** (testé, ports actifs)
- ✅ Build Flutter production **opérationnel** (17.2s)
- ⚠️ **Compatibilité Flutter 3.35.4 / Dart 3.9.2** (versions sandbox)
- ⚠️ Utiliser packages compatibles : `http: 1.5.0`, `provider: 6.1.5+1`
- ⚠️ RGPD = contrainte légale absolue (audit logs, consentement, droits patients)

**Best Practices** :
- Toujours tester API Flask avant intégration Flutter
- Utiliser `.env` pour config sensible (jamais commit)
- Commenter code (docs futures praticiens)
- Valider données côté client ET serveur

---

## 📝 Template Résumé Session (pour l'IA)

À la fin de la session, mettre à jour ce document avec :
- ✅ Tâches terminées
- 🔄 Tâches en cours
- 📋 Prochaines étapes
- 🐛 Bugs résolus/non résolus
- 📦 Nouveaux fichiers créés
- 🔗 Commits Git réalisés

---

**Dernière mise à jour** : Session précédente  
**Statut global** : Production-ready (Firebase) / Backend Flask terminé / Architecture hybride + docs RGPD à implémenter
