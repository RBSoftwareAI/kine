# REGISTRE DES TRAITEMENTS DE DONNÉES PERSONNELLES
## Application MediDesk - Test Pilote

**Organisme:** Cabinet de Kinésithérapie Tourcoing  
**Responsable de traitement:** [Nom du Kinésithérapeute Principal]  
**Version:** 1.0  
**Date:** 14 Novembre 2025

*Conformément à l'article 30 du RGPD (Règlement UE 2016/679)*

---

## TRAITEMENT N°1 : GESTION DES COMPTES UTILISATEURS

### 1.1 Identification du Traitement

| Élément | Description |
|---------|-------------|
| **Nom du traitement** | Gestion des comptes utilisateurs test pilote |
| **Finalité** | Authentification et gestion des accès à l'application |
| **Base légale** | Article 6.1.a RGPD - Consentement éclairé |
| **Responsable** | Cabinet Kinésithérapie Tourcoing |
| **DPO** | [Nom si applicable] |

### 1.2 Catégories de Personnes Concernées

- ✅ Patients participants au test (20-30 personnes)
- ✅ Kinésithérapeutes (2-5 professionnels)
- ✅ Coachs APA (0-2 professionnels)

### 1.3 Données Traitées

| Catégorie | Données Collectées | Durée Conservation |
|-----------|-------------------|--------------------|
| **Identification** | Initiales, Tranche d'âge | Durée test + 3 mois |
| **Connexion** | Email test, Mot de passe hashé | Durée test |
| **Technique** | ID compte, Date création | Durée test + 3 mois |
| **Logs** | Dates connexions, IP | 6 mois max |

### 1.4 Destinataires des Données

| Destinataire | Accès | Justification |
|--------------|-------|---------------|
| **Professionnels autorisés** | Complet | Suivi thérapeutique |
| **Développeur technique** | Pseudonymisé | Maintenance app |
| **Hébergeur (Firebase)** | Technique | Hébergement |

### 1.5 Transfert Hors UE

❌ **AUCUN** - Données stockées en EU (Belgique)

### 1.6 Mesures de Sécurité

- ✅ Chiffrement SSL/TLS en transit
- ✅ Chiffrement AES-256 au repos
- ✅ Authentification forte (8+ caractères)
- ✅ Firestore Security Rules par rôle
- ✅ Logs d'accès complets

---

## TRAITEMENT N°2 : SUIVI DES DOULEURS PATIENTS

### 2.1 Identification du Traitement

| Élément | Description |
|---------|-------------|
| **Nom du traitement** | Suivi et cartographie des douleurs |
| **Finalité** | Suivi thérapeutique, analyse progression |
| **Base légale** | Article 9.2.a RGPD - Consentement explicite données santé |
| **Responsable** | Cabinet Kinésithérapie Tourcoing |
| **Catégorie données** | 🔴 Données de santé (Art. 9 RGPD) |

### 2.2 Catégories de Personnes Concernées

- ✅ Patients participants au test uniquement

### 2.3 Données Traitées (Données de Santé)

| Catégorie | Données Collectées | Sensibilité | Durée Conservation |
|-----------|-------------------|-------------|--------------------|
| **Douleur** | Zones corporelles (18 zones) | 🔴 Santé | Durée test + 3 mois |
| **Intensité** | Échelle 0-10 | 🔴 Santé | Durée test + 3 mois |
| **Fréquence** | Occasionnel/Quotidien/Fréquent/Constant | 🔴 Santé | Durée test + 3 mois |
| **Coordonnées** | Position X,Y sur silhouette | 🔴 Santé | Durée test + 3 mois |
| **Temporelle** | Dates enregistrements | Normal | Durée test + 3 mois |

### 2.4 Destinataires des Données

| Destinataire | Accès | Justification | Base Légale |
|--------------|-------|---------------|-------------|
| **Patient lui-même** | Ses données | Droit d'accès | Art. 15 RGPD |
| **Kinésithérapeute traitant** | Données patient | Suivi thérapeutique | Consentement explicite |
| **Développeur** | Pseudonymisé | Support technique | Sous-traitance (Art. 28) |

### 2.5 Transfert Hors UE

❌ **AUCUN** - Stockage Firebase EU uniquement

### 2.6 Mesures de Sécurité Spécifiques

**Données de santé (Art. 32 RGPD) :**
- ✅ Pseudonymisation obligatoire
- ✅ Chiffrement renforcé (AES-256)
- ✅ Accès restreint par authentification
- ✅ Journalisation exhaustive (audit logs)
- ✅ Firewall applicatif (Firestore Rules)
- ✅ Tests sécurité réguliers
- ✅ Procédure gestion incidents

---

## TRAITEMENT N°3 : TRAÇABILITÉ DES MODIFICATIONS (Audit Logs)

### 3.1 Identification du Traitement

| Élément | Description |
|---------|-------------|
| **Nom du traitement** | Traçabilité complète des modifications |
| **Finalité** | Conformité RGPD, Transparence, Sécurité |
| **Base légale** | Article 6.1.c RGPD - Obligation légale (transparence) |
| **Responsable** | Cabinet Kinésithérapie Tourcoing |

### 3.2 Catégories de Personnes Concernées

- ✅ Patients (sujets des modifications)
- ✅ Professionnels (auteurs des modifications)

### 3.3 Données Traitées

| Catégorie | Données Collectées | Durée Conservation |
|-----------|-------------------|--------------------|
| **Action** | Type (création, modification, consultation, etc.) | 3 ans (obligation légale) |
| **Auteur** | ID utilisateur, Rôle | 3 ans |
| **Cible** | ID patient concerné | 3 ans |
| **Valeurs** | Avant/Après modification | 3 ans |
| **Horodatage** | Date et heure précises | 3 ans |

### 3.4 Destinataires des Données

| Destinataire | Accès | Justification |
|--------------|-------|---------------|
| **Patient concerné** | Son historique | Droit d'accès Art. 15 |
| **Responsable test** | Complet | Contrôle conformité |
| **Autorités (CNIL)** | Sur demande | Obligation légale |

### 3.5 Mesures de Sécurité

- ✅ Logs immuables (append-only)
- ✅ Horodatage certifié
- ✅ Intégrité cryptographique
- ✅ Accès restreint lecture seule

---

## TRAITEMENT N°4 : STATISTIQUES ANONYMISÉES

### 4.1 Identification du Traitement

| Élément | Description |
|---------|-------------|
| **Nom du traitement** | Statistiques d'usage agrégées |
| **Finalité** | Amélioration application, Analyse performances |
| **Base légale** | Article 6.1.f RGPD - Intérêt légitime |
| **Responsable** | RBSoftware AI (développeur) |

### 4.2 Catégories de Personnes Concernées

- ✅ Tous les participants (anonymisés)

### 4.3 Données Traitées

| Catégorie | Données Collectées | État | Durée Conservation |
|-----------|-------------------|------|--------------------|
| **Usage** | Fréquence utilisation | Anonymisé | Illimitée |
| **Fonctionnalités** | Écrans consultés | Anonymisé | Illimitée |
| **Performance** | Temps chargement | Anonymisé | Illimitée |
| **Erreurs** | Bugs techniques | Pseudonymisé | 1 an |

### 4.4 Anonymisation

**Technique appliquée:**  
Agrégation sur cohortes de 5+ participants minimum (k-anonymat ≥ 5)

**Exemple:**
```
❌ "Patient J.D. utilise l'app 3x/semaine"
✅ "70% des patients utilisent l'app 2-4x/semaine"
```

### 4.5 Destinataires

| Destinataire | Accès | Justification |
|--------------|-------|---------------|
| **Équipe développement** | Statistiques agrégées | Amélioration produit |
| **Participants (rapport final)** | Statistiques globales | Transparence |

---

## TRAITEMENT N°5 : SAUVEGARDE ET ARCHIVAGE

### 5.1 Identification du Traitement

| Élément | Description |
|---------|-------------|
| **Nom du traitement** | Backup quotidien Firebase |
| **Finalité** | Sécurité, Restauration en cas d'incident |
| **Base légale** | Article 6.1.f RGPD - Intérêt légitime (sécurité) |
| **Responsable** | Firebase (Google) - Sous-traitant |

### 5.2 Données Traitées

**Copie complète de tous les traitements ci-dessus**

### 5.3 Durée de Rétention

| Type de Backup | Durée Conservation |
|----------------|---------------------|
| **Quotidien** | 7 jours glissants |
| **Hebdomadaire** | 4 semaines |
| **Mensuel** | 3 mois |

### 5.4 Localisation

**Firebase Cloud Storage** - europe-west9 (Paris, France) 🇫🇷

### 5.5 Mesures de Sécurité

- ✅ Chiffrement AES-256
- ✅ Accès restreint (clés cryptographiques)
- ✅ Suppression automatique selon politique

---

## ANALYSE D'IMPACT (PIA) - Article 35 RGPD

### Nécessité d'une PIA ?

**Critères d'évaluation :**

| Critère | Présent | Justification |
|---------|---------|---------------|
| **Évaluation systématique** | ✅ Oui | Analyse douleurs patients |
| **Données sensibles (santé)** | ✅ Oui | Zones douleur, intensité |
| **Grande échelle** | ❌ Non | 20-30 participants seulement |
| **Croisement données** | ❌ Non | Pas de croisement externe |
| **Personnes vulnérables** | ❌ Non | Patients adultes consentants |
| **Usage innovant** | ✅ Oui | Silhouettes anatomiques cliquables |
| **Exclusion accès service** | ❌ Non | Pas d'obligation participation |

**CONCLUSION :** ⚠️ **PIA RECOMMANDÉE** (2 critères sur 9 de la CNIL)

### PIA Simplifiée Réalisée

**Risques identifiés :**

| Risque | Probabilité | Impact | Mesures d'Atténuation |
|--------|-------------|--------|------------------------|
| **Fuite données santé** | Faible | Élevé | Chiffrement + pseudonymisation |
| **Accès non autorisé** | Moyenne | Élevé | Authentification forte + Rules |
| **Perte de données** | Très faible | Moyen | Backups quotidiens |
| **Mauvaise anonymisation** | Faible | Moyen | K-anonymat ≥ 5 |

**Validation :** Risques résiduels acceptables pour un test pilote de 6 mois.

---

## SOUS-TRAITANTS (Article 28 RGPD)

### Sous-Traitant Principal : Firebase (Google)

| Information | Détail |
|-------------|--------|
| **Nom** | Google Ireland Limited |
| **Service** | Firebase (Auth, Firestore, Storage, Functions) |
| **Rôle** | Hébergement et infrastructure |
| **Localisation** | Union Européenne (Belgique, France) |
| **DPA Signé** | ✅ OUI (Data Processing Addendum) |
| **Certifications** | ISO 27001, SOC 2, SOC 3 |
| **Certification HDS** | ❌ NON |
| **Sous-traitance ultérieure** | ✅ Autorisée (liste disponible) |

**Lien DPA Firebase:**  
https://firebase.google.com/support/privacy/data-processing-terms

### Clause Contractuelle

**Garanties exigées :**
- ✅ Respect des instructions du responsable de traitement
- ✅ Confidentialité des personnes autorisées
- ✅ Sécurité des traitements (Art. 32 RGPD)
- ✅ Assistance pour répondre aux droits des personnes
- ✅ Notification des violations de données sous 48h
- ✅ Suppression/restitution des données en fin de contrat

---

## DROITS DES PERSONNES (Articles 15-22 RGPD)

### Procédures Mises en Place

| Droit | Procédure | Délai | Responsable |
|-------|-----------|-------|-------------|
| **Accès (Art. 15)** | Demande écrite + vérification identité | 1 mois | Responsable test |
| **Rectification (Art. 16)** | Via app ou demande écrite | Immédiat | Kiné + Dev |
| **Effacement (Art. 17)** | Demande écrite + confirmation | 48h | Dev technique |
| **Portabilité (Art. 20)** | Export JSON via email | 7 jours | Dev technique |
| **Opposition (Art. 21)** | Demande orale ou écrite | Immédiat | Responsable test |
| **Limitation (Art. 18)** | Demande écrite | 48h | Responsable test |

### Registre des Demandes

**Suivi obligatoire de chaque demande :**
- 📅 Date de réception
- 👤 Identité du demandeur
- 📋 Nature de la demande
- ✅ Actions entreprises
- 📅 Date de réponse
- 📄 Copie de la réponse

**Modèle de réponse disponible :** docs/rgpd/MODELE_REPONSE_DROITS.md

---

## VIOLATIONS DE DONNÉES (Article 33-34 RGPD)

### Procédure de Gestion des Incidents

**1. Détection (0-2h)**
- 🔍 Monitoring automatique Firebase
- 🚨 Alerte email responsable test
- 📊 Analyse logs

**2. Évaluation (2-8h)**
- 📋 Nature de la violation
- 👥 Nombre de personnes concernées
- 🔐 Données compromises
- ⚖️ Risque pour les droits et libertés

**3. Notification (8-72h)**

| Si risque ÉLEVÉ | Si risque FAIBLE |
|-----------------|------------------|
| ✅ Notification CNIL < 72h | ℹ️ Documentation interne uniquement |
| ✅ Information participants | ❌ Pas de notification externe |

**4. Mesures Correctives (Immédiat)**
- 🔧 Correction de la faille
- 🔒 Renforcement sécurité
- 📋 Documentation complète

### Registre des Violations

**Suivi obligatoire :**
- 📅 Date et heure de l'incident
- 📝 Description détaillée
- 👥 Personnes concernées (nombre)
- 🔐 Données affectées
- ⚠️ Conséquences probables
- ✅ Mesures prises ou envisagées

**Modèle disponible :** docs/rgpd/REGISTRE_VIOLATIONS.xlsx

---

## FORMATION ET SENSIBILISATION

### Personnel Autorisé

| Personne | Rôle | Formation RGPD | Date |
|----------|------|----------------|------|
| [Nom Kiné 1] | Responsable test | ✅ Complétée | [Date] |
| [Nom Kiné 2] | Professionnel | ✅ Complétée | [Date] |
| [Nom Coach] | Coach APA | ⏳ Prévue | [Date] |

### Contenu de la Formation

- ✅ Principes RGPD (6 principes fondamentaux)
- ✅ Droits des personnes (procédures)
- ✅ Sécurité des données (bonnes pratiques)
- ✅ Gestion des incidents (procédure escalade)
- ✅ Confidentialité (secret professionnel)

**Support disponible :** docs/formation/FORMATION_RGPD_KINECARE.pdf

---

## RÉVISION ET MISE À JOUR

### Fréquence de Révision

- ✅ **Mensuelle** pendant le test pilote
- ✅ **À chaque modification** de l'application
- ✅ **À chaque demande** de droit d'une personne
- ✅ **En cas d'incident** de sécurité

### Historique des Versions

| Version | Date | Modifications | Auteur |
|---------|------|---------------|--------|
| 1.0 | 14/11/2025 | Création initiale | [Nom] |

---

## CONTACTS

### Contacts Internes

| Rôle | Nom | Email | Téléphone |
|------|-----|-------|-----------|
| **Responsable de traitement** | [Nom] | rgpd@cabinet-tourcoing.fr | [Tél] |
| **DPO (si applicable)** | [Nom] | dpo@cabinet-tourcoing.fr | [Tél] |
| **Support technique** | RBSoftware AI | support-test@medidesk.fr | - |

### Autorité de Contrôle

**CNIL** (Commission Nationale de l'Informatique et des Libertés)  
📍 3 Place de Fontenoy, TSA 80715, 75334 Paris Cedex 07  
📞 01 53 73 22 22  
🌐 https://www.cnil.fr  
📧 Formulaire en ligne : https://www.cnil.fr/fr/plaintes

---

**Version :** 1.0  
**Date de création :** 14 Novembre 2025  
**Dernière mise à jour :** 14 Novembre 2025  
**Prochaine révision :** 14 Décembre 2025

---

*Ce registre est conforme à l'article 30 du RGPD et aux recommandations de la CNIL pour les responsables de traitement.*

**Signature du Responsable de Traitement :**

Nom : _____________________________  
Date : _____________________________  
Signature : 

