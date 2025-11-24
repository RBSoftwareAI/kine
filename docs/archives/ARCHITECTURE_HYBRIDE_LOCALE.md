# 🏥 ARCHITECTURE HYBRIDE LOCALE - MediDesk

**Date** : 16 novembre 2025  
**Version** : 2.0 (Architecture redéfinie)  
**Modèle** : Installation locale + SaaS léger

---

## 🎯 PRINCIPE FONDAMENTAL

**MediDesk = Application locale installée dans les salles de soins**

### **Séparation des Données**

```
┌─────────────────────────────────────────────────────────────┐
│                   SALLE DE SOIN (LOCAL)                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  DONNÉES SENSIBLES (Dossiers patients complets)        │ │
│  │  • Identité patients (nom, prénom, date naissance)     │ │
│  │  • Antécédents médicaux                                │ │
│  │  • Points de douleur détaillés (localisation précise)  │ │
│  │  • Notes de séances (observations cliniques)           │ │
│  │  • Photos et documents médicaux                        │ │
│  │  • Évolution thérapeutique complète                    │ │
│  │  ────────────────────────────────────────────────────  │ │
│  │  STOCKAGE : SQLite local chiffré (AES-256)             │ │
│  │  LOCALISATION : Ordinateur du cabinet                  │ │
│  │  BACKUP : Disque dur externe local ou NAS local        │ │
│  │  ✅ PAS de connexion internet requise                  │ │
│  │  ✅ PAS d'hébergement cloud HDS nécessaire             │ │
│  │  ✅ RGPD conforme par design (data locale)             │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘

                            ▼
                    (Synchronisation sélective)
                            ▼

┌─────────────────────────────────────────────────────────────┐
│              CLOUD SAAS (NON-HDS) - medidesk.fr             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  DONNÉES ANONYMISÉES / NON-SENSIBLES                   │ │
│  │  • Statistiques globales (sans identité)               │ │
│  │  • Rendez-vous (dates, créneaux disponibles)           │ │
│  │  • Planning praticiens                                 │ │
│  │  • Gestion administratif cabinet                       │ │
│  │  • Facturation et comptabilité                         │ │
│  │  • Communication patients (rappels RDV)                │ │
│  │  ────────────────────────────────────────────────────  │ │
│  │  STOCKAGE : Base de données cloud standard             │ │
│  │  LOCALISATION : France (OVH, Scaleway)                 │ │
│  │  ✅ PAS de données médicales sensibles                 │ │
│  │  ✅ PAS besoin certification HDS                       │ │
│  │  ✅ RGPD simplifié (données non-sensibles)             │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 💼 RÔLE DU SAAS MEDIDESK

### **1. Gestion des Rendez-vous** 📅

**Fonctionnalités SaaS** :
- ✅ Agenda en ligne partagé (praticiens + patients)
- ✅ Prise de RDV par les patients (site web/app mobile)
- ✅ Synchronisation planning entre praticiens
- ✅ Rappels automatiques (SMS/Email)
- ✅ Gestion annulations et reprogrammations
- ✅ Disponibilités en temps réel

**Données stockées SaaS** :
```json
{
  "rendez_vous_id": "rdv_20251116_001",
  "patient_id_anonymise": "PT_7a3f9c",  // Hash anonyme
  "praticien_id": "DR_001",
  "date": "2025-11-20T14:00:00Z",
  "duree_minutes": 45,
  "type_seance": "Suivi kinésithérapie",
  "statut": "confirmé",
  "rappel_envoye": true
}
```

**⚠️ PAS stocké** : Nom patient, diagnostic, notes médicales

---

### **2. Gestion Administrative Cabinet** 🏢

**Fonctionnalités SaaS** :
- ✅ Gestion équipe (praticiens, secrétaires)
- ✅ Planning horaires de travail
- ✅ Gestion permissions et rôles
- ✅ Statistiques cabinet (nombre séances, taux occupation)
- ✅ Facturation et comptabilité (montants anonymisés)
- ✅ Télétransmission CPAM (codes actes uniquement)

**Données stockées SaaS** :
```json
{
  "cabinet_id": "CAB_001",
  "praticiens": [
    {
      "id": "DR_001",
      "nom": "Dr. Martin",
      "specialite": "Kinésithérapeute",
      "horaires_travail": {...},
      "seances_mois": 120,
      "chiffre_affaires_mois": 4800
    }
  ],
  "statistiques_anonymes": {
    "total_patients_mois": 85,  // Compteur uniquement
    "moyenne_seances_patient": 1.4,
    "taux_occupation": 0.78
  }
}
```

**⚠️ PAS stocké** : Identité patients, dossiers médicaux

---

### **3. Communication Patients** 📧

**Fonctionnalités SaaS** :
- ✅ Envoi rappels RDV automatiques
- ✅ Notifications changements horaires
- ✅ Satisfaction post-séance (NPS)
- ✅ Newsletter cabinet (actualités, fermetures)
- ✅ Portail patient web (consulter RDV à venir)

**Données stockées SaaS** :
```json
{
  "patient_contact_id": "CT_89bc2d",  // Hash anonyme
  "email": "patient@example.com",
  "telephone": "+33612345678",
  "preferences_contact": {
    "rappels_rdv": true,
    "newsletter": false,
    "canal_prefere": "email"
  },
  "prochains_rdv": [
    {
      "date": "2025-11-20T14:00:00Z",
      "praticien": "Dr. Martin",
      "lieu": "Cabinet Tourcoing"
    }
  ]
}
```

**⚠️ PAS stocké** : Raison consultation, notes médicales, historique soins

---

### **4. Statistiques Globales Anonymisées** 📊

**Fonctionnalités SaaS** :
- ✅ Tableaux de bord cabinet (non-médicaux)
- ✅ Benchmarking anonyme entre cabinets
- ✅ Tendances secteur (pathologies fréquentes par région)
- ✅ Indicateurs performance business
- ✅ Rapports d'activité comptables

**Données stockées SaaS** :
```json
{
  "statistiques_region_nord": {
    "nombre_cabinets_actifs": 142,
    "moyenne_seances_jour": 8.5,
    "pathologies_frequentes": [
      {"type": "Lombalgies", "pourcentage": 32},
      {"type": "Cervicalgies", "pourcentage": 18},
      {"type": "Post-opératoire", "pourcentage": 15}
    ]
  },
  "cabinet_anonyme_xyz": {
    "seances_mois": 120,
    "taux_croissance": "+12%",
    "taux_satisfaction": 4.7/5
  }
}
```

**⚠️ Toutes données agrégées, aucune identification possible**

---

### **5. Outils de Gestion Business** 💰

**Fonctionnalités SaaS** :
- ✅ Facturation et devis
- ✅ Suivi paiements (CPAM, mutuelles, patients)
- ✅ Déclarations fiscales simplifiées
- ✅ Gestion stocks (matériel, consommables)
- ✅ Marketing digital (site web, réseaux sociaux)

**Données stockées SaaS** :
```json
{
  "facture_id": "FAC_2025_11_001",
  "patient_anonyme": "PT_7a3f9c",  // Hash
  "montant_total": 45.00,
  "actes": [
    {
      "code_cpam": "AMK7",
      "libelle": "Rééducation membre inférieur",
      "montant": 45.00
    }
  ],
  "statut_paiement": "payé",
  "date_encaissement": "2025-11-16"
}
```

**⚠️ PAS stocké** : Diagnostic, notes cliniques, détails médicaux

---

### **6. Portail Patient Web/Mobile** 📱

**Fonctionnalités SaaS** :
- ✅ Prise RDV en ligne
- ✅ Consultation planning personnel
- ✅ Accès factures et devis
- ✅ Messagerie sécurisée (administrative uniquement)
- ✅ Formulaires pré-remplissage (consentement, coordonnées)

**Données stockées SaaS** :
```json
{
  "patient_compte": {
    "id_anonyme": "PT_7a3f9c",
    "email": "patient@example.com",
    "nom": "Dupont Jean",  // Identité civile OK (non-médicale)
    "telephone": "+33612345678",
    "adresse": "123 Rue Example",
    "rdv_a_venir": [...],
    "factures_impayees": [...]
  }
}
```

**⚠️ PAS stocké** : Dossier médical, notes praticien, historique soins

---

## 🔄 SYNCHRONISATION LOCALE ↔ CLOUD

### **Flux de Données Unidirectionnel**

```
INSTALLATION LOCALE (Cabinet)
  ↓
  1. Séance terminée
  ↓
  2. Praticien clôture dossier
  ↓
  3. Génération données anonymisées
  ↓
  4. Envoi sélectif vers SaaS :
     • Code acte (AMK7) ✅
     • Durée séance (45 min) ✅
     • Montant (45€) ✅
     • Patient hash (PT_7a3f9c) ✅
     • Satisfaction (4/5) ✅
  ↓
CLOUD SAAS (medidesk.fr)
  ↓
  5. Mise à jour statistiques globales
  6. Facturation automatique
  7. Envoi rappel prochain RDV
```

**🔒 Données médicales sensibles : JAMAIS synchronisées**

---

## 🏗️ ARCHITECTURE TECHNIQUE DÉTAILLÉE

### **Installation Locale (Cabinet)**

**Matériel recommandé** :
- 💻 PC Windows/Mac/Linux ou tablette
- 💾 Stockage : 20 GB minimum
- 🔒 Chiffrement disque activé (BitLocker, FileVault)

**Logiciel** :
```
MediDesk Desktop App
├── Flutter Desktop (Windows/Mac/Linux)
├── SQLite local chiffré (AES-256)
├── Backend Flask embarqué (optionnel)
└── Synchronisation sélective (optionnelle)

Installation :
- Double-clic setup.exe (Windows)
- .dmg (Mac)
- .deb/.rpm (Linux)
```

**Backup local** :
- Automatique sur disque externe USB
- Ou NAS local du cabinet
- Ou cloud personnel chiffré (Google Drive crypté)

---

### **Cloud SaaS (medidesk.fr)**

**Infrastructure** :
- 🌐 Frontend : Flutter Web (agenda, portail patient)
- ⚙️ Backend : Flask API (gestion RDV, stats)
- 💾 Base données : PostgreSQL standard (non-HDS)
- 📧 Emails : SendGrid/Mailgun
- 📱 SMS : Twilio

**Hébergement** :
- 🇫🇷 France (OVH, Scaleway, AWS Paris)
- ✅ RGPD conforme (données non-sensibles)
- ❌ PAS besoin certification HDS
- 💰 Coût réduit (15-30€/mois)

---

## 💰 MODÈLE ÉCONOMIQUE SAAS

### **Offres Tarifaires**

**🆓 Gratuit (Local Only)**
- Installation locale illimitée
- 0 synchronisation cloud
- Backup manuel utilisateur
- Support communautaire

**💼 Essentiel (19€/mois/praticien)**
- ✅ Agenda en ligne partagé
- ✅ Prise RDV patients web
- ✅ Rappels automatiques (email)
- ✅ Portail patient basique
- ✅ Statistiques cabinet
- ✅ Support email

**🚀 Professionnel (49€/mois/praticien)**
- ✅ Tout Essentiel +
- ✅ Rappels SMS automatiques
- ✅ Messagerie sécurisée patients
- ✅ Facturation automatisée CPAM
- ✅ Télétransmission feuilles soins
- ✅ Statistiques avancées
- ✅ Multi-cabinets
- ✅ Support prioritaire

**🏢 Cabinet (99€/mois forfait)**
- ✅ Tout Professionnel +
- ✅ Jusqu'à 5 praticiens
- ✅ Site web cabinet personnalisé
- ✅ Marketing digital (newsletter)
- ✅ Accès API (intégrations)
- ✅ Backup cloud automatique (chiffré)
- ✅ Support téléphone dédié

---

## 🎯 VALEUR AJOUTÉE SAAS (Sans Données Médicales)

### **Pour les Praticiens** 👨‍⚕️

1. **Gain de temps administratif** (2h/jour économisées)
   - Agenda automatisé
   - Rappels RDV automatiques
   - Facturation simplifiée
   - Télétransmission CPAM

2. **Amélioration expérience patient**
   - Prise RDV 24/7 en ligne
   - Rappels proactifs
   - Portail consultation factures
   - Communication fluide

3. **Optimisation business**
   - Statistiques performance
   - Réduction no-shows (-40%)
   - Taux remplissage optimisé
   - Benchmark secteur

---

### **Pour les Patients** 👥

1. **Autonomie et confort**
   - Prise RDV en ligne (vs téléphone)
   - Consultation planning personnel
   - Rappels automatiques
   - Accès factures en ligne

2. **Communication simplifiée**
   - Messagerie cabinet (admin)
   - Notifications importantes
   - Newsletter cabinet

---

### **Pour le Cabinet** 🏢

1. **Gestion multi-praticiens**
   - Planning centralisé
   - Coordination équipe
   - Statistiques globales
   - Gestion permissions

2. **Croissance business**
   - Visibilité en ligne (SEO)
   - Marketing digital
   - Satisfaction mesurée (NPS)
   - Fidélisation patients

---

## 🔒 CONFORMITÉ RGPD SIMPLIFIÉE

### **Avantages Modèle Hybride**

**Données locales (cabinet)** :
- ✅ Responsable traitement = Praticien
- ✅ Pas de sous-traitant cloud
- ✅ Droit accès/rectification immédiat
- ✅ Droit effacement garanti
- ✅ Portabilité simple (export CSV)
- ✅ Pas de transfert hors UE

**Données SaaS (medidesk.fr)** :
- ✅ Données non-sensibles uniquement
- ✅ RGPD standard (pas santé)
- ✅ Anonymisation native
- ✅ Consentement simplifié
- ✅ DPO non-obligatoire (< 250 salariés)

---

## 📋 CHECKLIST DÉPLOIEMENT

### **Installation Cabinet (1-2h)**

- [ ] Télécharger MediDesk Desktop (Windows/Mac/Linux)
- [ ] Installer sur PC praticien
- [ ] Créer compte praticien (local)
- [ ] Configurer planning horaires
- [ ] Importer patients existants (CSV)
- [ ] Configurer backup local automatique
- [ ] Former équipe (30 min)

### **Activation SaaS Optionnelle**

- [ ] S'inscrire sur medidesk.fr
- [ ] Choisir forfait (Essentiel/Pro/Cabinet)
- [ ] Configurer agenda en ligne
- [ ] Activer prise RDV patients web
- [ ] Personnaliser emails/SMS rappels
- [ ] Intégrer site web cabinet (iframe)
- [ ] Tester flux complet patient

---

## 🎯 AVANTAGES MODÈLE HYBRIDE

### **✅ Sécurité Maximale**
- Données médicales jamais exposées sur internet
- Pas de risque piratage cloud HDS
- Conformité RGPD par design

### **✅ Coûts Réduits**
- Pas d'hébergement HDS (300-500€/mois)
- Pas de certification HDS (10-20k€)
- Pas de DPO obligatoire
- Infrastructure cloud simple (15-30€/mois)

### **✅ Performance**
- Application locale ultra-rapide
- Pas de latence réseau
- Fonctionne offline
- Backup instantané

### **✅ Adoption Facilitée**
- Version gratuite locale (pas de risque)
- SaaS optionnel (activation progressive)
- Pas de formation cloud complexe
- Migration données simple

---

## 🚀 DÉPLOIEMENT PILOTE TOURCOING

### **Phase 1 : Installation Locale Uniquement**

**Objectif** : Valider usage quotidien sans SaaS

**Actions** :
1. Installer MediDesk Desktop sur 3 PC praticiens
2. Former équipe (1h)
3. Tester 4-6 semaines intensives
4. Collecter feedback

**Données collectées** :
- Dossiers patients complets (local)
- Notes séances (local)
- Cartographie douleur (local)
- **RIEN synchronisé cloud**

---

### **Phase 2 : Activation SaaS Progressive** (Optionnelle)

**Objectif** : Tester valeur ajoutée agenda en ligne

**Actions** :
1. Activer forfait Essentiel (19€/mois test)
2. Configurer agenda en ligne
3. Tester prise RDV patients web
4. Mesurer impact (réduction appels)

**Données synchronisées** :
- Créneaux disponibles ✅
- RDV confirmés (date/heure uniquement) ✅
- Statistiques séances (compteurs) ✅
- **PAS de données médicales** ❌

---

## 📞 SUPPORT & QUESTIONS

**Questions fréquentes** :

**Q1 : Les données patients sont-elles vraiment sécurisées ?**  
R : Oui, 100% en local sur PC cabinet. Jamais sur internet.

**Q2 : Que se passe-t-il en cas de panne internet ?**  
R : Application locale fonctionne normalement. SaaS optionnel indisponible temporairement.

**Q3 : Puis-je utiliser MediDesk sans abonnement SaaS ?**  
R : Oui ! Version locale 100% gratuite et complète.

**Q4 : Le SaaS est-il obligatoire ?**  
R : Non, totalement optionnel. Ajout progressif selon besoins.

**Q5 : Puis-je résilier le SaaS sans perdre mes données ?**  
R : Oui, données locales toujours accessibles.

---

## 📧 CONTACT

**Support technique** : support@medidesk.fr  
**Commercial** : commercial@medidesk.fr  
**Site web** : https://medidesk.fr  

---

**📅 Document créé le 16 novembre 2025**  
**🔄 Architecture redéfinie (v2.0)**  
**🎯 Modèle : Installation locale + SaaS optionnel**
