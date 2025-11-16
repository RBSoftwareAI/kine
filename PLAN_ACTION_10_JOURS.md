# 📅 PLAN D'ACTION 10 JOURS - MediDesk v1.0

**Objectif :** Déploiement cabinet Tourcoing avec corrections critiques  
**Période :** 17-26 Janvier 2025  
**Méthodologie :** Agile - Sprint 10 jours

---

## 🎯 VISION & OBJECTIF FINAL

**État actuel :** MVP Phase 1 avec lacunes identifiées  
**État cible :** Application production-ready pour test pilote 3-6 mois

**Critères de succès :**
- ✅ Silhouette DOS clairement différenciée de FACE
- ✅ Système permissions MANAGER opérationnel
- ✅ 3 professionnels formés + cabinet équipé
- ✅ 0 bugs bloquants identifiés

---

## 📊 CALENDRIER DÉTAILLÉ

### 🔴 JOUR 1 - Vendredi 17 Janvier (AUJOURD'HUI)

**Focus :** Silhouettes anatomiques + Nettoyage code

#### Matin (4h)
- [ ] **08:00-09:00** : Audit complet terminé ✅ (ce document)
- [ ] **09:00-10:30** : Redessiner silhouette DOS avec ligne vertébrale
  - Fichier : `lib/views/pain/widgets/body_silhouette.dart`
  - Ajouter marqueurs C7, T12, L5
  - Courbure lombaire visible
- [ ] **10:30-11:00** : Tests visuels face vs dos
  - Vérifier différence visible
  - Screenshots avant/après
- [ ] **11:00-12:00** : Retirer système consentement
  - Fichier : `lib/models/pain_point.dart` (supprimer 3 champs)
  - Fichier : `lib/views/pain/pain_tracking_screen.dart` (nettoyer UI)
  - Fichier : `backend/database/schema.sql` (commentaires)

#### Après-midi (4h)
- [ ] **14:00-15:00** : Retirer bouton "Consentements"
  - Fichier : `lib/views/home/home_screen.dart` ligne 234-242
  - Supprimer card complète
- [ ] **15:00-17:00** : Améliorer détection zones anatomiques
  - Fichier : `lib/views/pain/pain_tracking_screen.dart` lignes 101-128
  - Implémenter zones polygonales (Path.contains)
  - Tester précision clics
- [ ] **17:00-18:00** : Tests manuels complet
  - Compte patient : saisie douleur face + dos
  - Vérifier enregistrement correct
  - Vérifier graphiques évolution

**Livrable J1 :** Silhouettes DOS opérationnelles + code nettoyé

---

### 🔴 JOUR 2 - Samedi 18 Janvier

**Focus :** Système permissions MANAGER (Backend)

#### Matin (4h)
- [ ] **09:00-10:00** : Modifier schéma base de données
  - Fichier : `backend/database/schema.sql`
  - Ajouter rôle 'manager' à enum
  - Créer trigger premier utilisateur = manager
  - Migration script SQL
- [ ] **10:00-11:30** : Endpoints API permissions
  - Fichier : `backend/api/app.py`
  - `GET /api/admin/users` (liste professionnels)
  - `PUT /api/admin/users/<id>/permissions` (attribuer/révoquer)
  - `POST /api/admin/users/create` (créer professionnel)
- [ ] **11:30-12:00** : Tests Postman/curl
  - Créer compte manager test
  - Tester création kiné/coach
  - Vérifier audit logs

#### Après-midi (4h)
- [ ] **14:00-16:00** : Service Flutter permissions
  - Fichier : `lib/services/admin_service.dart` (nouveau)
  - Méthodes : `getProfessionals()`, `createUser()`, `toggleUserStatus()`
- [ ] **16:00-17:00** : Modèle UserModel étendu
  - Fichier : `lib/models/user_model.dart`
  - Ajouter `UserRole.manager`
  - Extension `canManageUsers`, `canTreatPatients`
- [ ] **17:00-18:00** : Tests unitaires modèle
  - Fichier : `test/models/user_model_test.dart` (nouveau)
  - Tester conversions Firestore
  - Tester extensions rôles

**Livrable J2 :** Backend permissions fonctionnel + modèle Flutter

---

### 🔴 JOUR 3 - Dimanche 19 Janvier

**Focus :** Interface Flutter gestion permissions

#### Matin (4h)
- [ ] **09:00-11:00** : Écran gestion permissions
  - Fichier : `lib/views/admin/permissions_management_screen.dart` (nouveau)
  - Liste professionnels avec rôles
  - Boutons Activer/Désactiver
  - Badge statut (Actif/Inactif)
- [ ] **11:00-12:00** : Modal création professionnel
  - Widget : `ProfessionalCreationDialog` (nouveau)
  - Formulaire : email, nom, prénom, rôle
  - Validation champs

#### Après-midi (4h)
- [ ] **14:00-15:30** : Navigation et permissions UI
  - Ajouter menu "Gestion Permissions" (visible seulement manager)
  - Fichier : `lib/views/home/home_screen.dart`
  - Condition : `if (user.role == UserRole.manager)`
- [ ] **15:30-17:00** : Tests E2E permissions
  - Scénario 1 : Manager crée kiné ✅
  - Scénario 2 : Manager désactive coach ✅
  - Scénario 3 : Kiné tente accès gestion ❌
- [ ] **17:00-18:00** : Documentation utilisateur
  - Fichier : `docs/GUIDE_MANAGER.md` (nouveau)
  - Procédure création compte professionnel
  - Procédure révocation accès

**Livrable J3 :** Interface permissions complète + tests OK

---

### 🟡 JOUR 4 - Lundi 20 Janvier

**Focus :** Notes séances professionnelles

#### Matin (4h)
- [ ] **09:00-10:30** : Modèle SessionNote
  - Fichier : `lib/models/session_note.dart` (nouveau)
  - Champs : patientId, professionalId, sessionType, duration, notes, exercises
- [ ] **10:30-12:00** : Écran saisie notes
  - Fichier : `lib/views/professional/session_notes_screen.dart` (nouveau)
  - Formulaire notes multiligne
  - Liste exercices dynamique
  - Comparaison avant/après automatique

#### Après-midi (4h)
- [ ] **14:00-15:30** : Endpoints API sessions
  - Fichier : `backend/api/app.py`
  - `POST /api/sessions` (déjà existe - vérifier)
  - `PUT /api/sessions/<id>` (mise à jour notes)
  - `GET /api/sessions?patient_id=<id>` (historique)
- [ ] **15:30-17:00** : Tests saisie notes
  - Créer session avec notes
  - Modifier notes existantes
  - Vérifier persistance
- [ ] **17:00-18:00** : Intégration menu professionnel
  - Activer bouton "Notes de séance" (ligne 277 home_screen.dart)
  - Navigation vers SessionNotesScreen

**Livrable J4 :** Notes séances fonctionnelles

---

### 🟡 JOUR 5 - Mardi 21 Janvier

**Focus :** Sécurité & Configuration production

#### Matin (4h)
- [ ] **09:00-10:00** : Variables d'environnement
  - Fichier : `backend/.env.example` (nouveau)
  - Variables : SECRET_KEY, JWT_SECRET_KEY, DATABASE_PATH
  - Documentation configuration
- [ ] **10:00-11:30** : Rate limiting login
  - Fichier : `backend/api/app.py`
  - Installation : `pip install Flask-Limiter`
  - Configuration : 5 tentatives/minute
  - Tests échec rate limit
- [ ] **11:30-12:00** : Script génération secrets
  - Fichier : `backend/utils/generate_secrets.py` (nouveau)
  - Commande : `python3 generate_secrets.py`
  - Génère .env avec openssl rand

#### Après-midi (4h)
- [ ] **14:00-15:30** : Configuration cabinet Tourcoing
  - Fichier : `backend/config/tourcoing.env` (nouveau)
  - Secrets production générés
  - Backup initial base vide
- [ ] **15:30-17:00** : Tests sécurité
  - Vérifier JWT expiration
  - Vérifier rate limiting
  - Scan vulnérabilités basiques
- [ ] **17:00-18:00** : Documentation sécurité
  - Fichier : `docs/SECURITE_PRODUCTION.md` (nouveau)
  - Checklist déploiement
  - Procédure changement secrets

**Livrable J5 :** Configuration production sécurisée

---

### 🟢 JOUR 6 - Mercredi 22 Janvier

**Focus :** Tests utilisateur intensifs

#### Matin (4h)
- [ ] **09:00-10:00** : Création comptes test
  - 1 manager : patron@tourcoing.test
  - 3 kinés : kine1@, kine2@, kine3@
  - 10 patients : patient1@ à patient10@
- [ ] **10:00-12:00** : Tests workflow complet
  - **Scénario A : Premier jour cabinet**
    - Manager crée 3 kinés
    - Kine1 crée patient1
    - Patient1 saisit douleurs
    - Kine1 consulte graphique
  - **Scénario B : Séance traitement**
    - Kine2 ouvre dossier patient2
    - Patient2 saisit douleurs AVANT séance
    - Kine2 traite patient2
    - Patient2 saisit douleurs APRÈS séance
    - Kine2 rédige notes séance
    - Graphique amélioration visible

#### Après-midi (4h)
- [ ] **14:00-16:00** : Tests edge cases
  - Patient modifie ses propres douleurs
  - Kiné tente accéder gestion permissions (échec)
  - Manager révoque accès kine3
  - Kine3 tente connexion (échec)
  - Audit logs vérification
- [ ] **16:00-17:00** : Tests performance
  - 100 points douleur pour 1 patient
  - Graphique évolution 6 mois
  - Temps chargement < 2s
- [ ] **17:00-18:00** : Bugs identifiés
  - Liste complète bugs trouvés
  - Priorisation P0/P1/P2
  - Corrections rapides si < 30min

**Livrable J6 :** Liste bugs + application testée E2E

---

### 🟢 JOUR 7 - Jeudi 23 Janvier

**Focus :** Corrections bugs + Polish UI

#### Matin (4h)
- [ ] **09:00-11:00** : Corrections bugs P0
  - Fixer tous bugs bloquants identifiés J6
- [ ] **11:00-12:00** : Vérification régression
  - Re-tester scenarios J6
  - Confirmer bugs corrigés

#### Après-midi (4h)
- [ ] **14:00-15:30** : Polish interface utilisateur
  - Messages d'erreur clairs
  - Indicateurs chargement
  - Confirmations actions critiques (désactiver compte, etc.)
- [ ] **15:30-17:00** : Optimisations performance
  - Lazy loading listes patients
  - Cache images silhouettes
  - Compression réponses API
- [ ] **17:00-18:00** : Tests finaux
  - Run complet tous scénarios J6
  - Vérifier 0 bugs P0 restants

**Livrable J7 :** Application stable et polie

---

### 🚀 JOUR 8 - Vendredi 24 Janvier

**Focus :** Installation cabinet Tourcoing

#### Matin (4h)
- [ ] **09:00-10:00** : Préparation matériel
  - PC serveur : installation Ubuntu/Debian
  - Configuration réseau Wi-Fi cabinet
  - Adresse IP fixe serveur (ex: 192.168.1.100)
- [ ] **10:00-11:30** : Installation backend
  - Clone repository : `git clone https://github.com/RBSoftwareAI/kine.git`
  - Installation dépendances : `pip install -r backend/requirements.txt`
  - Configuration .env production
  - Génération base données : `python3 backend/database/init_db.py`
- [ ] **11:30-12:00** : Premier lancement
  - Démarrage serveur : `python3 backend/start_server.py`
  - Vérification http://192.168.1.100:8080
  - Création compte manager patron@tourcoing.com

#### Après-midi (4h)
- [ ] **14:00-15:30** : Tests réseau local
  - Connexion depuis smartphone professionnel
  - Connexion depuis tablette salle attente
  - Vérifier performance Wi-Fi
- [ ] **15:30-17:00** : Import comptes réels
  - 3 kinésithérapeutes cabinet
  - Premiers patients (si volontaires)
  - Configuration préférences cabinet
- [ ] **17:00-18:00** : Sauvegarde initiale
  - Backup base données : `backup_cabinet_tourcoing_initial.db.gz`
  - Copie sur clé USB + cloud
  - Documentation procédure restauration

**Livrable J8 :** MediDesk installé et opérationnel cabinet

---

### 🎓 JOUR 9 - Samedi 25 Janvier

**Focus :** Formation professionnels

#### Session Kiné #1 (1h30)
- [ ] **09:00-09:30** : Présentation générale
  - Vision MediDesk
  - Avantages vs papier (temps, graphiques, stats)
  - Tour interface
- [ ] **09:30-10:00** : Pratique guidée
  - Créer patient fictif
  - Saisir douleurs (face + dos)
  - Créer séance
  - Rédiger notes
- [ ] **10:00-10:30** : Cas réels
  - Import premier vrai patient
  - Saisie historique (si dispo)
  - Questions/réponses

#### Session Kiné #2 (1h30)
- [ ] **10:30-12:00** : Répéter formation
  - Même programme
  - Adapter selon questions Kiné #1

#### Après-midi
- [ ] **14:00-15:30** : Session Kiné #3
- [ ] **15:30-17:00** : Session récap + questions
  - Réponses toutes questions
  - Démonstration fonctionnalités avancées
  - Procédure support première semaine
- [ ] **17:00-18:00** : Formation manager (patron)
  - Gestion permissions
  - Création comptes
  - Consultation audit logs
  - Procédure backup
  - Hotline urgence

**Livrable J9 :** 3 kinés + 1 manager formés

---

### 🎉 JOUR 10 - Dimanche 26 Janvier

**Focus :** Support + Documentation finale

#### Matin (4h)
- [ ] **09:00-11:00** : Présence cabinet
  - Support sur place premier jour utilisation
  - Résolution problèmes temps réel
  - Ajustements configuration si besoin
- [ ] **11:00-12:00** : Documentation utilisateur finale
  - Fichier : `docs/GUIDE_UTILISATEUR_TOURCOING.pdf`
  - Captures écran workflows
  - FAQ questions formation J9

#### Après-midi (4h)
- [ ] **14:00-15:00** : Mise en place hotline
  - Numéro support : [NUMÉRO]
  - Email support : support@medidesk.fr
  - Horaires disponibilité semaine 1
- [ ] **15:00-16:30** : Rétrospective projet
  - Ce qui a bien fonctionné
  - Ce qui a pris plus de temps
  - Leçons pour prochains cabinets
- [ ] **16:30-17:30** : Planification suivi
  - RDV feedback semaine 2
  - RDV feedback mois 1
  - RDV feedback mois 3
- [ ] **17:30-18:00** : Commit final GitHub
  - Push toutes corrections
  - Tag version : `v1.0.0-tourcoing-pilot`
  - Release notes

**Livrable J10 :** Cabinet opérationnel + support actif

---

## 📊 SUIVI AVANCEMENT

### Indicateurs Clés (KPIs)

| Métrique | Cible | Jour Mesure |
|----------|-------|-------------|
| **Bugs P0 corrigés** | 100% | J7 |
| **Tests E2E passés** | 100% | J7 |
| **Professionnels formés** | 3 | J9 |
| **Premier patient réel** | 1+ | J10 |
| **Uptime serveur** | 99%+ | J10+ |

### Checklist Validation Déploiement

#### ✅ Technique
- [ ] Silhouette DOS visuellement différente FACE
- [ ] Système permissions MANAGER fonctionnel
- [ ] Notes séances opérationnelles
- [ ] Rate limiting login actif
- [ ] Secrets production configurés
- [ ] Backup automatique programmé
- [ ] 0 bugs P0 restants

#### ✅ Utilisateur
- [ ] 3 kinés formés (1h30 chacun)
- [ ] 1 manager formé (1h)
- [ ] Documentation utilisateur fournie
- [ ] Hotline support disponible
- [ ] Premier patient réel traité

#### ✅ Business
- [ ] Cabinet équipé (PC + Wi-Fi)
- [ ] Comptes réels créés
- [ ] Procédure backup testée
- [ ] Contrat test pilote 3-6 mois signé
- [ ] Planning feedback régulier établi

---

## 🔧 RESSOURCES & OUTILS

### Outils Développement

```bash
# IDE recommandé
Visual Studio Code + Extensions :
  - Flutter
  - Dart
  - Python
  - SQLite Viewer

# Tests
flutter test                    # Tests unitaires Flutter
flutter analyze                 # Analyse code Dart
python3 -m pytest backend/      # Tests Python
curl -X POST http://...         # Tests API

# Base de données
sqlite3 data/medidesk.db       # Explorer DB
DB Browser for SQLite          # GUI exploration

# Git
git log --oneline --graph      # Historique
git status                     # État actuel
git diff                       # Changements
```

### Documentation Référence

| Document | Usage |
|----------|-------|
| `AUDIT_PRE_DEPLOIEMENT.md` | Détails techniques complets |
| `SYNTHESE_AUDIT_VISUEL.md` | Vue d'ensemble visuelle |
| `README.md` | Documentation générale |
| `CONTRIBUTING.md` | Standards développement |
| `docs/ARCHITECTURE_HYBRIDE.md` | Architecture système |

---

## 🚨 GESTION RISQUES

### Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| **Bugs découverts J6-J7** | Élevée | Moyen | Buffer 2 jours corrections |
| **Formation trop technique** | Moyenne | Faible | Adapter langage utilisateur |
| **Problème réseau Wi-Fi** | Faible | Élevé | Tester J8 matin en priorité |
| **Résistance changement** | Moyenne | Moyen | Emphase gains temps/qualité |
| **Indisponibilité serveur** | Faible | Élevé | Backup + procédure restauration |

### Plan de Contingence

**Si retard développement (>2j) :**
- Option A : Reporter déploiement 1 semaine
- Option B : Déployer avec fonctionnalités P1 manquantes (workaround papier)
- Option C : Demander aide communauté open source

**Si bug critique découvert après J10 :**
- Hotfix immédiat < 4h
- Déplacement sur site si nécessaire
- Communication transparente cabinet

---

## 📞 CONTACTS

**Développeur Principal :**  
📧 dev@medidesk.fr  
📱 [NUMÉRO_DEV]

**Support Utilisateur :**  
📧 support@medidesk.fr  
📱 [NUMÉRO_SUPPORT] (disponible 9h-19h)

**Cabinet Tourcoing :**  
📧 contact@cabinet-tourcoing.fr  
📍 [ADRESSE_CABINET]  
📱 [NUMÉRO_CABINET]

---

## 🎯 CITATION MOTIVATION

> *"Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte."*  
> — Winston Churchill

> *"Un projet commence par une vision, se construit jour après jour, et se valide par l'usage."*  
> — MediDesk Team

---

**🏥 MediDesk - Déploiement Tourcoing**  
**10 Jours pour Changer la Pratique Professionnelle ! 🚀**

**Version :** 1.0.0-tourcoing-pilot  
**Date création plan :** 17 Janvier 2025  
**Révision :** 1.0
