# PROTOCOLE DE TEST PILOTE - Application MediDesk

**Version:** 1.0  
**Date:** 14 Novembre 2025  
**Responsable:** [Nom Cabinet Kinésithérapie Tourcoing]  
**Lieu:** Cabinet de kinésithérapie, Tourcoing (59200)  
**Durée:** 3 à 6 mois maximum

---

## 1. CONTEXTE ET OBJECTIF DU TEST

### 1.1 Présentation du Projet

**MediDesk** est une application mobile en cours de développement destinée à améliorer le suivi des patients en kinésithérapie et coaching APA (Activité Physique Adaptée).

### 1.2 Objectifs du Test Pilote

- ✅ Valider l'ergonomie de l'interface utilisateur
- ✅ Tester la fiabilité du suivi des douleurs avec silhouettes anatomiques
- ✅ Évaluer l'utilité des courbes d'évolution graphiques
- ✅ Recueillir les retours des professionnels et patients
- ✅ Identifier les améliorations nécessaires avant déploiement commercial

### 1.3 Cadre Légal du Test

⚠️ **IMPORTANT** : Ce test est réalisé dans un **cadre de recherche et développement**.

- 🔴 L'application **N'EST PAS** certifiée HDS (Hébergement de Données de Santé)
- 🔴 Les données sont hébergées sur **Firebase (Google Cloud Platform)**
- 🔴 Ce test est **strictement limité** à la validation fonctionnelle
- 🟢 Conformité RGPD complète (traçabilité, droits des personnes)
- 🟢 Pseudonymisation obligatoire des données

---

## 2. CRITÈRES DE PARTICIPATION

### 2.1 Critères d'Inclusion

**Pour les Patients:**
- ✅ Majeur (18 ans et plus)
- ✅ Patient régulier du cabinet de Tourcoing
- ✅ Suivi kinésithérapie en cours ou prévu
- ✅ Possession d'un smartphone (Android ou accès Web)
- ✅ Compréhension du français écrit et oral
- ✅ Acceptation des conditions du test pilote

**Pour les Professionnels:**
- ✅ Kinésithérapeute ou Coach APA diplômé(e)
- ✅ Exercice au cabinet de Tourcoing
- ✅ Accès à un ordinateur ou tablette (interface Web)

### 2.2 Critères d'Exclusion

- ❌ Mineurs (moins de 18 ans)
- ❌ Patients sous tutelle ou curatelle
- ❌ Impossibilité d'utiliser un smartphone
- ❌ Refus de participation au test

### 2.3 Nombre de Participants

- 🎯 **Objectif:** 20 à 30 patients maximum
- 🎯 **Professionnels:** 2 à 5 kinésithérapeutes/coachs

---

## 3. PROTECTION DES DONNÉES

### 3.1 Pseudonymisation Obligatoire

**Données AUTORISÉES dans le test:**
```
✅ Initiales du patient (ex: J.D.)
✅ Âge (tranche: 20-30, 30-40, etc.)
✅ Zones de douleur (cartographie anatomique)
✅ Intensité douleur (échelle 0-10)
✅ Fréquence douleur (occasionnel, quotidien, etc.)
✅ Évolution temporelle (graphiques)
✅ Dates de séances
```

**Données INTERDITES dans le test:**
```
❌ Nom complet + Prénom
❌ Numéro de sécurité sociale
❌ Adresse postale complète
❌ Numéro de téléphone
❌ Email personnel (utiliser email test: patient001@test-medidesk.local)
❌ Diagnostic médical précis
❌ Prescriptions médicales
❌ Photos identifiantes
```

### 3.2 Mesures de Sécurité Techniques

| Mesure | Description | Statut |
|--------|-------------|--------|
| **Chiffrement** | SSL/TLS en transit + Firebase au repos | ✅ Actif |
| **Authentification** | Email + Mot de passe (min 8 caractères) | ✅ Actif |
| **Firestore Rules** | Accès restreint par rôle utilisateur | ✅ Actif |
| **Audit Logs** | Traçabilité complète des modifications | ✅ Actif |
| **Backup** | Sauvegarde quotidienne automatique | ✅ Actif |
| **Accès limité** | Seuls professionnels autorisés | ✅ Actif |

### 3.3 Droits des Participants (RGPD)

Chaque participant dispose des droits suivants :

| Droit | Description | Modalité |
|-------|-------------|----------|
| **Accès** | Consulter ses données personnelles | Demande écrite au responsable test |
| **Rectification** | Corriger des données inexactes | Via l'application ou demande |
| **Effacement** | Suppression complète des données | Demande écrite, effectif sous 48h |
| **Opposition** | Refuser le traitement de données | Arrêt immédiat de participation |
| **Portabilité** | Récupérer ses données (format JSON) | Demande écrite, export sous 7 jours |
| **Retrait** | Retirer son consentement à tout moment | Sans justification, sans préjudice |

**Contact RGPD:**  
Email: [rgpd@cabinet-kine-tourcoing.fr]  
Téléphone: [Numéro du cabinet]

---

## 4. DÉROULEMENT DU TEST

### 4.1 Phase 1 : Inscription (Semaine 1)

**Étape 1 - Information du Patient**
- ✅ Remise du document d'information complet
- ✅ Explication orale du protocole de test
- ✅ Réponses aux questions éventuelles
- ✅ Délai de réflexion de 48h minimum

**Étape 2 - Consentement**
- ✅ Signature du formulaire de consentement éclairé
- ✅ Création du compte test (email pseudonyme)
- ✅ Remise des identifiants de connexion

**Étape 3 - Formation Initiale**
- ✅ Démonstration de l'application (15 minutes)
- ✅ Guide d'utilisation papier remis
- ✅ Test en présence du kiné

### 4.2 Phase 2 : Utilisation (Semaines 2 à 12-24)

**Fréquence d'utilisation recommandée:**
- 📱 **Patient:** 2 à 3 fois par semaine (suivi douleur)
- 🏥 **Professionnel:** Après chaque séance (mise à jour)

**Suivi et Support:**
- ✅ Point mensuel avec chaque participant
- ✅ Hotline test: [Numéro support]
- ✅ Email support: support-test@medidesk-pilot.fr

**Collecte de Feedback:**
- 📋 Questionnaire satisfaction à M1, M3, M6
- 💬 Entretiens individuels (optionnels)
- 📊 Statistiques d'usage anonymisées

### 4.3 Phase 3 : Clôture (Semaine finale)

**Étape 1 - Évaluation Finale**
- ✅ Questionnaire de satisfaction complet
- ✅ Entretien de retour d'expérience (30 min)
- ✅ Recueil des suggestions d'amélioration

**Étape 2 - Gestion des Données**
- ✅ Export personnel des données (si demandé)
- ✅ Anonymisation complète des données de test
- ✅ Suppression des comptes test Firebase

**Étape 3 - Information sur la Suite**
- ✅ Communication sur la migration HDS
- ✅ Proposition de participation version production
- ✅ Remerciements et attestation de participation

---

## 5. CRITÈRES D'ARRÊT DU TEST

Le test peut être interrompu dans les cas suivants :

| Critère | Action |
|---------|--------|
| **Incident sécurité** | Arrêt immédiat + information participants |
| **Bug bloquant** | Suspension temporaire le temps de correction |
| **Demande CNIL** | Arrêt immédiat + mise en conformité |
| **Retrait > 50% participants** | Arrêt et analyse des causes |
| **Fin période test (6 mois)** | Clôture normale du protocole |

---

## 6. RESPONSABILITÉS

### 6.1 Responsable du Test

**Cabinet de Kinésithérapie Tourcoing**
- Responsable: [Nom du kinésithérapeute principal]
- Fonction: Kinésithérapeute responsable
- Contact: [Email] / [Téléphone]

**Missions:**
- ✅ Information et recueil des consentements
- ✅ Formation des participants
- ✅ Suivi du bon déroulement du test
- ✅ Gestion des incidents
- ✅ Respect du protocole et de la réglementation

### 6.2 Développeur / Éditeur

**RBSoftware AI**
- Contact technique: [Email support technique]
- Responsabilités:
  - ✅ Maintenance technique de l'application
  - ✅ Corrections de bugs
  - ✅ Support utilisateurs
  - ✅ Sécurité des données
  - ✅ Conformité RGPD technique

### 6.3 Participants

**Patients et Professionnels:**
- ✅ Respect des consignes d'utilisation
- ✅ Signalement des bugs ou problèmes
- ✅ Utilisation confidentielle des identifiants
- ✅ Participation aux évaluations

---

## 7. ASPECTS FINANCIERS

### 7.1 Gratuité du Test

⚠️ **Le test pilote est TOTALEMENT GRATUIT pour tous les participants.**

- ✅ Aucun frais d'inscription
- ✅ Aucun abonnement requis
- ✅ Pas de publicité dans l'application
- ✅ Aucune obligation d'achat futur

### 7.2 Compensation

- ℹ️ Aucune compensation financière n'est prévue
- ✅ Attestation de participation remise en fin de test
- ✅ Accès prioritaire à la version commerciale (tarif préférentiel)

---

## 8. PUBLICATION DES RÉSULTATS

### 8.1 Exploitation des Données de Test

Les données anonymisées du test pourront être utilisées pour :

- ✅ Amélioration de l'application MediDesk
- ✅ Communication scientifique (congrès, articles)
- ✅ Documentation commerciale (anonyme)

**Engagement de confidentialité:**
- ❌ Aucune donnée identifiante ne sera publiée
- ❌ Aucune photo ou vidéo sans autorisation expresse
- ✅ Statistiques agrégées uniquement

### 8.2 Communication aux Participants

- ✅ Rapport de synthèse du test envoyé à tous les participants
- ✅ Présentation des résultats lors d'une réunion de clôture
- ✅ Information sur les suites du projet

---

## 9. CONTACTS ET INFORMATIONS

### 9.1 Contacts Principaux

| Contact | Fonction | Coordonnées |
|---------|----------|-------------|
| **Responsable Test** | Kinésithérapeute | [Email] / [Tél] |
| **Support Technique** | Développeur | support-test@medidesk.fr |
| **RGPD** | DPO / Responsable | rgpd@cabinet-tourcoing.fr |

### 9.2 Autorités de Contrôle

**CNIL (Commission Nationale de l'Informatique et des Libertés)**
- Adresse: 3 Place de Fontenoy, TSA 80715, 75334 Paris Cedex 07
- Téléphone: 01 53 73 22 22
- Site web: https://www.cnil.fr

**ARS Hauts-de-France (Agence Régionale de Santé)**
- Téléphone: 03 62 72 86 00
- Site web: https://www.hauts-de-france.ars.sante.fr

---

## 10. SIGNATURES

### 10.1 Validation du Protocole

**Responsable du Test Pilote:**

Nom: ___________________________  
Fonction: Kinésithérapeute responsable  
Date: ___________________________  
Signature: 


**Développeur / Éditeur:**

Nom: RBSoftware AI  
Date: 14 Novembre 2025  
Signature: 


### 10.2 Approbations (si applicable)

☐ Comité d'Éthique consulté  
☐ Ordre des Kinésithérapeutes informé  
☐ Assurance responsabilité civile professionnelle à jour

---

## ANNEXES

- **Annexe A:** Formulaire de Consentement Éclairé (voir document séparé)
- **Annexe B:** Notice d'Information Patient (voir document séparé)
- **Annexe C:** Questionnaires d'Évaluation (M1, M3, M6)
- **Annexe D:** Guide d'Utilisation Application
- **Annexe E:** Procédure Gestion des Incidents

---

**Version:** 1.0  
**Date de création:** 14 Novembre 2025  
**Dernière mise à jour:** 14 Novembre 2025  
**Prochaine révision:** 14 Février 2026 (ou avant si nécessaire)

---

*Ce protocole est conforme à la réglementation française en vigueur (RGPD, Loi Informatique et Libertés, Code de la Santé Publique).*
