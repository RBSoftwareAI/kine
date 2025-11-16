# MENTIONS LÉGALES - Test Pilote MediDesk
## ⚠️ Hébergement Firebase (Non-HDS)

**Version:** 1.0  
**Date:** 14 Novembre 2025  
**Application:** MediDesk Test Pilote

---

## ⚠️ AVERTISSEMENT IMPORTANT

```
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║   🔴 ATTENTION - APPLICATION EN PHASE DE TEST PILOTE      ║
║                                                            ║
║   Cette application N'EST PAS hébergée sur un serveur     ║
║   certifié HDS (Hébergement de Données de Santé).         ║
║                                                            ║
║   Les données sont stockées sur Firebase                  ║
║   (Google Cloud Platform) dans un cadre de                ║
║   recherche et développement.                             ║
║                                                            ║
║   ✅ Conformité RGPD complète                              ║
║   ❌ Non conforme HDS (hébergement données de santé)      ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

## 1. ÉDITEUR DE L'APPLICATION

### 1.1 Identité

**Responsable du Test Pilote:**
- **Nom:** Cabinet de Kinésithérapie Tourcoing
- **Responsable:** [Nom du Kinésithérapeute Principal]
- **Adresse:** [Adresse complète du cabinet, Tourcoing 59200]
- **Téléphone:** [Numéro de téléphone]
- **Email:** [Email professionnel]
- **N° SIRET:** [Numéro SIRET]
- **N° RPPS/ADELI:** [Numéro d'identification professionnelle]

### 1.2 Développeur Technique

**RBSoftware AI**
- **Statut:** Développeur indépendant / Micro-entreprise
- **Email technique:** support-test@medidesk.fr
- **Rôle:** Développement, maintenance technique, support

---

## 2. HÉBERGEMENT DES DONNÉES

### 2.1 Hébergeur Principal

**Firebase (Google Cloud Platform)**

| Information | Détail |
|-------------|--------|
| **Fournisseur** | Google LLC / Google Ireland Limited |
| **Service utilisé** | Firebase Authentication, Cloud Firestore, Cloud Storage |
| **Localisation** | europe-west1 (Belgique) - Union Européenne |
| **Certifications** | ISO 27001, SOC 2, SOC 3 |
| **Certification HDS** | ❌ **NON** (hébergeur non certifié HDS) |
| **Conformité RGPD** | ✅ OUI (Google est conforme RGPD) |
| **DPA Signé** | ✅ OUI (Data Processing Addendum) |

**Adresse légale (Google Ireland Limited) :**
Gordon House, Barrow Street  
Dublin 4, D04 E5W5  
Irlande

**Site web:** https://firebase.google.com  
**Confidentialité:** https://policies.google.com/privacy

### 2.2 Justification de l'Utilisation de Firebase

**Cadre légal applicable:**

🔬 **Contexte Recherche & Développement**
- Test pilote à des fins de validation fonctionnelle
- Hébergement temporaire limité à 3-6 mois maximum
- Pas de déploiement commercial
- Pseudonymisation obligatoire des données

📋 **Base légale RGPD:**
- Article 6.1.a - Consentement éclairé des participants
- Article 9.2.a - Consentement explicite pour données de santé
- Article 32 - Mesures de sécurité techniques appropriées

---

## 3. NATURE DES DONNÉES HÉBERGÉES

### 3.1 Données Collectées (Pseudonymisées)

✅ **Données AUTORISÉES durant le test:**

| Catégorie | Exemples | Justification |
|-----------|----------|---------------|
| **Identification** | Initiales (J.D.), Tranche d'âge | Suivi patient |
| **Santé** | Zones douleur, Intensité 0-10 | Objectif thérapeutique |
| **Temporelle** | Dates séances, Évolution | Analyse progression |
| **Technique** | ID compte, Logs connexion | Sécurité et audit |

❌ **Données EXCLUES du test:**

| Catégorie | Exemples | Raison Exclusion |
|-----------|----------|------------------|
| **Identité complète** | Nom, Prénom, NSS | Protection vie privée |
| **Contact** | Téléphone, Adresse postale | Non nécessaire |
| **Médicale précise** | Diagnostics, Prescriptions | Hors scope test |
| **Biométrique** | Photos identifiantes | Protection données sensibles |

### 3.2 Minimisation des Données

**Principe appliqué:** Seules les données **strictement nécessaires** au test sont collectées.

**Durée de conservation:**
- **Pendant le test:** 3 à 6 mois maximum
- **Après le test:** 
  - Suppression complète des comptes Firebase
  - OU Conservation anonymisée pour statistiques (avec consentement)

---

## 4. SÉCURITÉ DES DONNÉES

### 4.1 Mesures Techniques Mises en Place

| Mesure | Description | Statut |
|--------|-------------|--------|
| **Chiffrement en Transit** | SSL/TLS 1.3 (HTTPS) | ✅ Actif |
| **Chiffrement au Repos** | AES-256 (Firebase) | ✅ Actif |
| **Authentification** | Email + Mot de passe fort (8+ chars) | ✅ Actif |
| **Firestore Security Rules** | Accès par rôle (patient/kiné/coach) | ✅ Actif |
| **Audit Logs** | Traçabilité complète (qui/quoi/quand) | ✅ Actif |
| **Backup Automatique** | Sauvegarde quotidienne Firebase | ✅ Actif |
| **Limitation Accès** | Seuls professionnels autorisés | ✅ Actif |
| **Firewall** | Google Cloud Armor | ✅ Actif |
| **Monitoring** | Surveillance 24/7 par Google | ✅ Actif |

### 4.2 Mesures Organisationnelles

| Mesure | Description |
|--------|-------------|
| **Formation** | Professionnels formés aux bonnes pratiques RGPD |
| **Accès restreint** | Comptes nominatifs, mots de passe individuels |
| **Journalisation** | Historique complet des modifications |
| **Procédures** | Gestion des incidents, violations de données |
| **Revue régulière** | Audit mensuel des accès et logs |

### 4.3 Gestion des Incidents

**En cas de violation de données personnelles:**

1. ⏱️ **Notification CNIL** sous 72 heures (si risque pour les droits)
2. 📧 **Information participants** concernés sans délai
3. 🔧 **Mesures correctives** immédiates
4. 📋 **Documentation** complète de l'incident

**Contact incident sécurité:**  
Email: incident-security@cabinet-tourcoing.fr  
Téléphone: [Numéro d'urgence]

---

## 5. DROITS DES PARTICIPANTS (RGPD)

### 5.1 Droits Garantis

Conformément au RGPD (Règlement UE 2016/679), chaque participant dispose de :

| Droit | Article RGPD | Modalité d'Exercice | Délai |
|-------|--------------|---------------------|-------|
| **Accès** | Art. 15 | Demande écrite | 1 mois |
| **Rectification** | Art. 16 | Via app ou demande | Immédiat |
| **Effacement** | Art. 17 | Demande écrite | 48 heures |
| **Portabilité** | Art. 20 | Demande écrite | 7 jours |
| **Opposition** | Art. 21 | Demande orale/écrite | Immédiat |
| **Limitation** | Art. 18 | Demande écrite | 48 heures |
| **Retrait consentement** | Art. 7 | Tout moment | Immédiat |

### 5.2 Contact Pour Exercer Vos Droits

**Responsable du Traitement:**  
📧 Email RGPD: rgpd@cabinet-kine-tourcoing.fr  
📞 Téléphone: [Numéro cabinet]  
✉️ Courrier: [Adresse cabinet, Tourcoing 59200]

**Délégué à la Protection des Données (si applicable):**  
[Nom du DPO]  
Email: dpo@cabinet-tourcoing.fr

### 5.3 Réclamation CNIL

Si vous estimez que vos droits ne sont pas respectés, vous pouvez introduire une réclamation auprès de la **CNIL** :

**Commission Nationale de l'Informatique et des Libertés**  
📍 Adresse: 3 Place de Fontenoy, TSA 80715, 75334 Paris Cedex 07  
📞 Téléphone: 01 53 73 22 22  
🌐 Site web: https://www.cnil.fr  
📧 Contact: https://www.cnil.fr/fr/plaintes

---

## 6. COOKIES ET TRACEURS

### 6.1 Cookies Utilisés

| Type de Cookie | Finalité | Durée | Obligatoire |
|----------------|----------|-------|-------------|
| **Session Firebase** | Authentification | Session | ✅ Oui |
| **Token Auth** | Sécurité connexion | 1 heure | ✅ Oui |
| **Analytics (optionnel)** | Statistiques usage | 13 mois | ❌ Non |

### 6.2 Gestion des Cookies

✅ **Cookies strictement nécessaires:** Pas de consentement requis (sécurité)  
❌ **Cookies analytics:** Refusé par défaut dans le test pilote

**Navigateurs supportés:**
- Chrome 90+ (recommandé)
- Firefox 88+
- Safari 14+
- Edge 90+

---

## 7. TRANSFERT DE DONNÉES HORS UE

### 7.1 Localisation des Données

**Stockage principal:** europe-west1 (Belgique) 🇧🇪  
**Stockage secondaire (backup):** europe-west9 (France) 🇫🇷

✅ **Toutes les données restent dans l'Union Européenne**

### 7.2 Sous-Traitants Google

Google peut faire appel à des sous-traitants situés **hors UE** pour :
- Support technique de niveau 3
- Maintenance infrastructure globale

**Garanties en place:**
- ✅ **Clauses Contractuelles Types** (CCT) de la Commission Européenne
- ✅ **Data Processing Addendum** (DPA) Firebase
- ✅ **Engagement contractuel** Google de respecter le RGPD

**Documentation:**  
https://firebase.google.com/support/privacy/data-processing-terms

---

## 8. PROPRIÉTÉ INTELLECTUELLE

### 8.1 Application MediDesk

**Droits d'auteur:**  
© 2025 RBSoftware AI - Tous droits réservés

**Licence d'utilisation:**  
Licence temporaire accordée aux participants du test pilote uniquement, non cessible, non commerciale.

### 8.2 Marques et Logos

- **"MediDesk"** : Marque déposée (en cours)
- **Logo MediDesk** : Propriété de RBSoftware AI
- **Thème Workout Warrior** : Inspiration visuelle (non commerciale)

### 8.3 Données Générées par les Utilisateurs

**Vos données vous appartiennent.**

L'éditeur se réserve le droit d'utiliser des **statistiques agrégées anonymisées** pour :
- Amélioration de l'application
- Communication scientifique
- Documentation commerciale (sans données identifiantes)

---

## 9. RESPONSABILITÉS ET LIMITATIONS

### 9.1 Responsabilité de l'Éditeur

L'éditeur s'engage à :
✅ Maintenir la disponibilité de l'application (best effort)  
✅ Corriger les bugs signalés  
✅ Assurer la sécurité des données  
✅ Respecter la confidentialité des participants

### 9.2 Limitations de Responsabilité

⚠️ **L'éditeur ne peut être tenu responsable de:**
- Interruptions de service liées à Firebase/Google
- Perte de données due à des cas de force majeure
- Mauvaise utilisation de l'application par les utilisateurs
- Décisions thérapeutiques basées uniquement sur l'application

### 9.3 Utilisation Médicale

```
╔══════════════════════════════════════════════════════════╗
║  ⚠️  AVERTISSEMENT MÉDICAL                              ║
║                                                          ║
║  MediDesk est un OUTIL D'AIDE au suivi, pas un          ║
║  dispositif médical certifié.                           ║
║                                                          ║
║  ❌ NE REMPLACE PAS une consultation médicale           ║
║  ❌ NE constitue PAS un diagnostic                      ║
║  ❌ NE prescrit PAS de traitement                       ║
║                                                          ║
║  ✅ Toujours consulter un professionnel de santé        ║
╚══════════════════════════════════════════════════════════╝
```

---

## 10. DURÉE ET FIN DU TEST PILOTE

### 10.1 Durée Maximale

**Test limité à 6 mois maximum** à compter du premier participant.

### 10.2 Fin du Test

À l'issue du test pilote :

1. ✉️ **Information participants** de la fin du test (préavis 1 mois)
2. 💾 **Export personnel** des données (si demandé)
3. 🗑️ **Suppression comptes** Firebase
4. 🔄 **Anonymisation** des données (si accepté pour statistiques)
5. 📊 **Rapport final** envoyé aux participants

### 10.3 Après le Test

**Option A - Version Commerciale HDS:**
- Migration vers hébergeur certifié HDS
- Nouvelle inscription requise
- Conditions commerciales applicables

**Option B - Fin de Participation:**
- Suppression définitive des données
- Fin de l'accès à l'application

---

## 11. MODIFICATION DES MENTIONS LÉGALES

### 11.1 Révisions

Ces mentions légales peuvent être modifiées à tout moment pour :
- ✅ Mise en conformité réglementaire
- ✅ Évolution technique de l'application
- ✅ Amélioration de la protection des données

### 11.2 Notification des Changements

**Toute modification sera notifiée aux participants par:**
- 📧 Email de notification
- 🔔 Notification dans l'application
- 📋 Acceptation requise pour modifications substantielles

---

## 12. LOI APPLICABLE ET JURIDICTION

### 12.1 Droit Applicable

**Droit français** et réglementation européenne (RGPD)

### 12.2 Juridiction Compétente

En cas de litige, les **tribunaux de Lille** (France) seront compétents.

**Tentative de résolution amiable** préalable recommandée.

---

## 13. CONTACTS

### 13.1 Contacts Principaux

| Contact | Fonction | Coordonnées |
|---------|----------|-------------|
| **Support Test** | Assistance technique | support-test@medidesk.fr |
| **RGPD** | Protection données | rgpd@cabinet-tourcoing.fr |
| **Responsable Test** | Cabinet Tourcoing | [Téléphone] |
| **Incident Sécurité** | Urgence | incident-security@cabinet-tourcoing.fr |

### 13.2 Autorités de Contrôle

**CNIL** (Données personnelles)
- 🌐 https://www.cnil.fr
- 📞 01 53 73 22 22

**ARS Hauts-de-France** (Santé)
- 🌐 https://www.hauts-de-france.ars.sante.fr
- 📞 03 62 72 86 00

**Ordre des Masseurs-Kinésithérapeutes**
- 🌐 https://www.ordremk.fr
- 📞 01 56 88 46 44

---

## 14. ANNEXES TECHNIQUES

### 14.1 Firebase Services Utilisés

| Service | Utilisation | Localisation |
|---------|-------------|--------------|
| **Firebase Authentication** | Connexion sécurisée | EU (Belgique) |
| **Cloud Firestore** | Base de données | EU (Belgique) |
| **Cloud Storage** | Fichiers (futurs exports) | EU (France) |
| **Cloud Functions** | Traitements serveur | EU (Belgique) |

### 14.2 Versioning des Données

**Format de stockage:** JSON (Firebase Firestore)  
**Chiffrement:** AES-256  
**Backup:** Quotidien automatique  
**Rétention backup:** 30 jours

---

**Version:** 1.0  
**Date de création:** 14 Novembre 2025  
**Dernière mise à jour:** 14 Novembre 2025  
**Prochaine révision:** 14 Février 2026 (ou avant si nécessaire)

---

*Ces mentions légales sont conformes au RGPD (UE 2016/679), à la Loi Informatique et Libertés (modifiée 2019), et au Code de la Santé Publique français.*

**Pour toute question:** support-test@medidesk.fr
