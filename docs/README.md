# 📚 DOCUMENTATION TEST PILOTE KINECARE

Ce dossier contient toute la documentation nécessaire pour le **test pilote** de l'application KinéCare à Tourcoing.

---

## 📋 DOCUMENTS ESSENTIELS

### 🔴 OBLIGATOIRES AVANT LE TEST

| Document | Emplacement | À remettre à |
|----------|-------------|--------------|
| **Protocole de Test Pilote** | `test_pilot/PROTOCOLE_TEST_PILOTE.md` | Tous les participants |
| **Formulaire de Consentement** | `test_pilot/FORMULAIRE_CONSENTEMENT.md` | Chaque patient (signé) |
| **Mentions Légales Firebase** | `legal/MENTIONS_LEGALES_FIREBASE.md` | Affichage dans l'app |

### 🟡 GESTION INTERNE

| Document | Emplacement | Usage |
|----------|-------------|-------|
| **Registre RGPD** | `rgpd/REGISTRE_TRAITEMENTS_RGPD.md` | Cabinet (conforme Art. 30 RGPD) |
| **Plan Migration HDS** | `migration/PLAN_MIGRATION_HDS.md` | Développeur + Cabinet |

---

## 📁 STRUCTURE DES DOSSIERS

```
docs/
├── README.md (ce fichier)
│
├── test_pilot/
│   ├── PROTOCOLE_TEST_PILOTE.md ⭐ ESSENTIEL
│   └── FORMULAIRE_CONSENTEMENT.md ⭐ ESSENTIEL
│
├── legal/
│   └── MENTIONS_LEGALES_FIREBASE.md ⭐ ESSENTIEL
│
├── rgpd/
│   └── REGISTRE_TRAITEMENTS_RGPD.md
│
└── migration/
    └── PLAN_MIGRATION_HDS.md
```

---

## ✅ CHECKLIST AVANT LANCEMENT TEST

### 1️⃣ **Documents à Préparer**

- [ ] Imprimer Protocole de Test (1 exemplaire par participant)
- [ ] Imprimer Formulaire Consentement (2 exemplaires par participant)
- [ ] Créer dossier physique "Test Pilote KinéCare"
- [ ] Intégrer Mentions Légales dans l'application

### 2️⃣ **Informations à Compléter**

Les documents contiennent des placeholders `[Nom]`, `[Email]`, etc. à remplacer :

| Placeholder | À remplacer par |
|-------------|-----------------|
| `[Nom du Kinésithérapeute Principal]` | Votre nom complet |
| `[Adresse complète du cabinet]` | Adresse cabinet Tourcoing |
| `[Email professionnel]` | Email contact |
| `[Téléphone]` | Numéro cabinet |
| `[N° SIRET]` | Numéro SIRET cabinet |
| `[N° RPPS/ADELI]` | Numéro identification |

### 3️⃣ **Validation Légale**

- [ ] Faire relire par DPO (si applicable)
- [ ] Consulter assurance RC Professionnelle
- [ ] Informer Ordre des Kinésithérapeutes (recommandé)
- [ ] Vérifier conformité avec règlement intérieur cabinet

---

## 📖 RÉSUMÉ PAR DOCUMENT

### 📄 PROTOCOLE DE TEST PILOTE

**Objectif:** Cadre légal et organisationnel du test  
**Contenu:**
- Contexte et objectifs du test (validation fonctionnelle)
- Critères de participation (inclusion/exclusion)
- Protection des données (pseudonymisation obligatoire)
- Déroulement du test (3 phases sur 3-6 mois)
- Droits des participants (RGPD)
- Responsabilités (cabinet, développeur, participants)

**À remettre à:** Tous les participants avant signature

---

### 📄 FORMULAIRE DE CONSENTEMENT ÉCLAIRÉ

**Objectif:** Recueil du consentement explicite des patients  
**Contenu:**
- Information claire sur hébergement non-HDS (Firebase)
- Données collectées (pseudonymisées uniquement)
- Droits RGPD détaillés (accès, rectification, effacement, etc.)
- Mesures de sécurité mises en place
- Signature patient + professionnel témoin

**À conserver:** Original dans dossier test + Copie remise au participant

**⚠️ IMPORTANT:** Signature OBLIGATOIRE avant toute utilisation de l'app

---

### 📄 MENTIONS LÉGALES FIREBASE

**Objectif:** Transparence sur l'hébergement des données  
**Contenu:**
- Identité éditeur et hébergeur (Firebase/Google)
- Nature des données hébergées (liste précise)
- Mesures de sécurité techniques (chiffrement, auth, etc.)
- Droits des participants (procédures d'exercice)
- Cookies et traceurs utilisés
- Responsabilités et limitations

**À intégrer:** Dans l'application (page accessible depuis le login)

---

### 📄 REGISTRE RGPD DES TRAITEMENTS

**Objectif:** Conformité Article 30 RGPD  
**Contenu:**
- 5 traitements documentés :
  1. Gestion comptes utilisateurs
  2. Suivi douleurs patients (données santé)
  3. Traçabilité modifications (audit logs)
  4. Statistiques anonymisées
  5. Sauvegardes Firebase
- Analyse d'impact (PIA simplifiée)
- Sous-traitants (Firebase/Google)
- Procédures droits des personnes
- Gestion violations de données

**À conserver:** Cabinet (accessible sur demande CNIL)

---

### 📄 PLAN DE MIGRATION HDS

**Objectif:** Roadmap vers hébergeur certifié HDS  
**Contenu:**
- Justification migration (obligations légales)
- Choix hébergeur (OVHcloud Health Data recommandé)
- Architecture technique cible (PostgreSQL + API REST)
- Plan détaillé 6 phases (13 semaines)
- Budget estimé (7,200€ migration + 140€/mois hosting)
- Timeline visuelle et checklist validation

**À utiliser:** Après validation test pilote (Mois 6)

---

## ⚠️ POINTS D'ATTENTION CRITIQUES

### 1. PSEUDONYMISATION OBLIGATOIRE

**❌ INTERDIT dans le test:**
- Nom complet + Prénom
- Numéro de sécurité sociale
- Adresse postale complète
- Numéro de téléphone
- Email personnel
- Photos identifiantes

**✅ AUTORISÉ:**
- Initiales (J.D.)
- Tranche d'âge (30-40 ans)
- Zones de douleur (cartographie)
- Intensité/fréquence (chiffres)

### 2. DURÉE MAXIMALE : 6 MOIS

Le test pilote **NE PEUT PAS DÉPASSER 6 MOIS** sur Firebase.  
Au-delà → Obligation migration HDS.

### 3. MAXIMUM 30 PARTICIPANTS

Pour rester dans un cadre R&D acceptable.

### 4. FIREBASE = TEST UNIQUEMENT

⚠️ Firebase n'est PAS certifié HDS.  
⚠️ Commercialisation INTERDITE sans migration HDS.  
⚠️ Mention explicite "Test Pilote" obligatoire.

---

## 📞 CONTACTS

### Support Technique
📧 Email: support-test@kinecare.fr  
📱 Téléphone: [À compléter]

### RGPD / Protection Données
📧 Email: rgpd@cabinet-tourcoing.fr  
📱 Téléphone: [À compléter]

### Autorités
**CNIL:** 01 53 73 22 22 | https://www.cnil.fr  
**ARS Hauts-de-France:** 03 62 72 86 00

---

## 📅 TIMELINE RECOMMANDÉE

```
Semaine -2  : Finaliser documentation (remplacer placeholders)
Semaine -1  : Imprimer documents + créer dossiers
Semaine 0   : Information patients + remise documents
Semaine 1   : Signature consentements + inscriptions
Semaine 2-12: Utilisation active + feedback mensuel
Semaine 13+ : Évaluation finale + migration HDS
```

---

## 🔄 MISES À JOUR

| Version | Date | Modifications |
|---------|------|---------------|
| 1.0 | 14/11/2025 | Création initiale documentation complète |

**Prochaine révision:** 14/02/2026 (Mois 3 - point mi-parcours)

---

## ✅ VALIDATION DOCUMENTS

**Créés par:** RBSoftware AI  
**Date:** 14 Novembre 2025  
**Conformité:** RGPD, Loi Informatique et Libertés, Code Santé Publique

**À valider par:**
- [ ] Kinésithérapeute responsable
- [ ] DPO (si applicable)
- [ ] Assurance RC Professionnelle
- [ ] Ordre des Kinésithérapeutes (recommandé)

---

**📧 Pour toute question sur ces documents:** support-test@kinecare.fr

**🎯 Objectif:** Tester KinéCare dans un cadre légal sécurisé, puis migrer vers HDS pour commercialisation conforme.
