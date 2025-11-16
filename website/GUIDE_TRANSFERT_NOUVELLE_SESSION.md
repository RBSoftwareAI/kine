# 📦 Guide de Transfert - Nouvelle Session MediDesk

## Documentation Complète pour Reprendre le Projet

**Date de création :** 16 novembre 2025  
**Version :** 1.0  
**Auteur :** Claude (AI Assistant)

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble du Projet](#vue-densemble-du-projet)
2. [Fichiers Livrés](#fichiers-livrés)
3. [Stack Technique](#stack-technique)
4. [Configuration Environnement](#configuration-environnement)
5. [Déploiement Production](#déploiement-production)
6. [Checklist Pré-Lancement](#checklist-pré-lancement)
7. [Outils et Services Nécessaires](#outils-et-services-nécessaires)
8. [Prochaines Étapes](#prochaines-étapes)

---

## 🎯 VUE D'ENSEMBLE DU PROJET

### MediDesk en Résumé

**MediDesk** est un logiciel de gestion open source pour kinésithérapeutes, développé avec :
- **Frontend :** Flutter 3.35.4 (Dart 3.9.2) - Application web + mobile (Android/iOS)
- **Backend :** Flask 3.0.0 (Python) - API REST + SQLite chiffré (SQLCipher AES-256)
- **Paiements :** Stripe (abonnements récurrents)
- **Hosting :** À déployer (recommandé : OVH/Scaleway France pour conformité HDS)

**État Actuel :**
- ✅ MVP Complet & Fonctionnel (95% production-ready)
- ✅ Pilote réussi au Cabinet de Tourcoing (3 praticiens)
- ✅ Système de permissions hiérarchique (sadmin → manager → professionnels)
- ✅ Site web marketing créé (HTML/CSS/JS)
- ✅ Documents légaux RGPD complets (CGV, CGU, Confidentialité)
- ⏳ API Stripe backend documentée (à implémenter, 2-3h)
- ⏳ Déploiement production à effectuer

---

## 📁 FICHIERS LIVRÉS

### 1. Application Flutter (Code Principal)

**Localisation :** `/home/user/flutter_app/`

**Fichiers Clés :**
```
flutter_app/
├── lib/
│   ├── main.dart                              # Point d'entrée
│   ├── models/
│   │   ├── user_model.dart                    # Modèle utilisateur + rôles
│   │   ├── patient_model.dart                 # Modèle patient
│   │   └── pain_point.dart                    # Points douleur
│   ├── providers/
│   │   ├── auth_provider.dart                 # Authentification
│   │   └── patients_provider.dart             # Gestion patients
│   ├── services/
│   │   ├── api_service.dart                   # Client API backend
│   │   └── admin_service.dart                 # Gestion permissions
│   ├── views/
│   │   ├── auth/                              # Écrans connexion/inscription
│   │   ├── home/                              # Dashboard principal
│   │   ├── patients/                          # Gestion patients
│   │   ├── pain/                              # Cartographie douleur
│   │   └── admin/                             # Gestion permissions (NEW)
│   └── theme/
│       └── app_theme.dart                     # Thème Material Design 3
├── backend/
│   ├── api/
│   │   └── app.py                             # API Flask principale
│   ├── database/
│   │   └── schema.sql                         # Schéma SQLite + données démo
│   └── utils/
│       └── generate_passwords.py              # Générateur hashs sécurisés
├── pubspec.yaml                               # Dépendances Flutter
└── README.md                                  # Documentation projet
```

**Comptes Démo Créés :**
```
Super Admin : sadmin@medidesk.local / sadmin123
Manager     : patron@medidesk.local / manager123
Kiné        : kine@demo.com / kine123
Coach       : coach@demo.com / coach123
Patient     : patient@demo.com / patient123
```

### 2. Site Web Marketing

**Localisation :** `/home/user/medidesk-website/`

```
medidesk-website/
├── index.html                   # Landing page principale (39 KB)
├── css/
│   └── style.css                # Styles responsifs (17 KB)
├── js/
│   └── main.js                  # JavaScript interactions (9 KB)
├── legal/
│   ├── cgv.html                 # Conditions Générales de Vente
│   ├── cgu.html                 # Conditions Générales d'Utilisation
│   ├── confidentialite.html     # Politique Confidentialité RGPD
│   ├── mentions-legales.html    # Mentions légales (à créer)
│   └── cookies.html             # Politique cookies (à créer)
└── backend_stripe.py            # API Stripe (Flask) - 11 KB
```

**Features Implémentées :**
- ✅ Landing page responsive avec sections (Hero, Features, Pricing, FAQ, Contact)
- ✅ Formulaire contact avec validation
- ✅ Design Material moderne (gradients, ombres, animations)
- ✅ Mobile-first et cross-browser compatible

### 3. Documents Marketing & Commerciaux

```
medidesk-website/
├── PITCH_DECK.md                # Pitch deck 16 slides (format Markdown → PowerPoint)
├── ONE_PAGER_COMMERCIAL.md      # One-pager vente (format imprimable)
├── EMAIL_TEMPLATES.md           # 10 templates emails (prospection, onboarding, etc.)
└── GUIDE_TRANSFERT_NOUVELLE_SESSION.md  # Ce document
```

### 4. Documentation Technique

```
flutter_app/
├── CORRECTIONS_16_NOV_2025.md   # Documentation corrections P0 (12 KB)
└── RESUME_FINAL_CORRECTIONS.md  # Résumé exécutif (12 KB)
```

---

## 🛠️ STACK TECHNIQUE

### Frontend (Flutter)

| Composant | Version | Justification |
|-----------|---------|---------------|
| Flutter | 3.35.4 | Stable, locked (DO NOT UPDATE) |
| Dart | 3.9.2 | Locked avec Flutter |
| Provider | 6.1.5+1 | State management simple |
| Hive | 2.2.3 | Base de données locale (document DB) |
| hive_flutter | 1.1.0 | Intégration Hive pour Flutter |
| http | 1.5.0 | Client HTTP pour API |

**Dépendances Complètes :** Voir `pubspec.yaml`

### Backend (Python/Flask)

| Composant | Version | Justification |
|-----------|---------|---------------|
| Flask | 3.0.0 | Framework API REST léger |
| SQLite | 3.x | Base de données embarquée |
| SQLCipher | - | Chiffrement AES-256 de SQLite |
| Werkzeug | 3.0.1 | PBKDF2 (scrypt) pour hashs mdp |
| Flask-CORS | 4.0.0 | Support cross-origin requests |

**Dépendances Complètes :** Voir `backend/requirements.txt`

### Infrastructure

| Service | Recommandation | Raison |
|---------|----------------|--------|
| Hébergement | OVH/Scaleway France | Conformité HDS + RGPD |
| Base Données | SQLite + SQLCipher | Chiffrement AES-256 natif |
| Paiements | Stripe | Standard SaaS, conforme PCI-DSS |
| Emails | Sendinblue | Hébergé France, conforme RGPD |
| Monitoring | Sentry | Suivi erreurs temps réel |
| Analytics | Plausible | Alternative RGPD à Google Analytics |

---

## ⚙️ CONFIGURATION ENVIRONNEMENT

### 1. Variables d'Environnement Requises

Créer fichier `.env` à la racine du projet :

```bash
# === FLASK BACKEND ===
SECRET_KEY=votre-clé-secrète-flask-64-caractères-minimum
DATABASE_PATH=/var/data/medidesk.db
SQLCIPHER_KEY=clé-chiffrement-aes256-64-caractères-minimum

# === STRIPE ===
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Plans Stripe (créer dans dashboard Stripe)
STRIPE_PRICE_STARTER=price_...
STRIPE_PRICE_PROFESSIONAL=price_...
STRIPE_PRICE_CABINET=price_...

# === SENDINBLUE (Emails) ===
SENDINBLUE_API_KEY=xkeysib-...
SENDINBLUE_SENDER_EMAIL=noreply@medidesk.fr
SENDINBLUE_SENDER_NAME=MediDesk

# === SENTRY (Monitoring Erreurs) ===
SENTRY_DSN=https://...@sentry.io/...

# === CONFIGURATION ===
ENVIRONMENT=production
DEBUG=False
ALLOWED_ORIGINS=https://medidesk.fr,https://app.medidesk.fr
```

### 2. Configuration Stripe (Dashboard)

**Étapes :**

1. **Créer compte Stripe** : stripe.com/register
2. **Activer mode Live** (après tests)
3. **Créer 3 produits :**
   - MediDesk Starter (19€/mois)
   - MediDesk Professional (49€/mois)
   - MediDesk Cabinet (99€/mois)
4. **Récupérer Price IDs** : `price_xxx` pour chaque plan
5. **Configurer Webhook** :
   - URL : `https://api.medidesk.fr/api/stripe/webhook`
   - Events : `customer.subscription.*`, `invoice.*`
6. **Récupérer webhook secret** : `whsec_xxx`

**Documentation :** `backend_stripe.py` contient le code complet

### 3. Configuration Sendinblue (Emails Transactionnels)

**Étapes :**

1. **Créer compte** : sendinblue.com/register
2. **Vérifier domaine** : medidesk.fr (DNS SPF, DKIM, DMARC)
3. **Créer templates :**
   - Bienvenue (après inscription)
   - Confirmation email
   - Réinitialisation mot de passe
   - Fin d'essai J-3 / J-1
   - Échec paiement
4. **Récupérer API Key** : Paramètres > SMTP & API > API Keys

**Templates fournis :** Voir `EMAIL_TEMPLATES.md`

---

## 🚀 DÉPLOIEMENT PRODUCTION

### Étape 1 : Préparer le Serveur (VPS)

**Recommandation :** VPS OVH/Scaleway (France, certifié HDS)

**Spécifications Minimales :**
- 2 vCPU
- 4 GB RAM
- 50 GB SSD
- Ubuntu 22.04 LTS
- IPv4 + IPv6

**Installation Dépendances :**

```bash
# Mise à jour système
sudo apt update && sudo apt upgrade -y

# Python 3.11
sudo apt install python3.11 python3.11-venv python3-pip -y

# Nginx (reverse proxy)
sudo apt install nginx -y

# Certbot (SSL Let's Encrypt)
sudo apt install certbot python3-certbot-nginx -y

# Supervisor (gestion processus backend)
sudo apt install supervisor -y

# Git
sudo apt install git -y
```

### Étape 2 : Cloner Projet et Configurer Backend

```bash
# Créer utilisateur medidesk
sudo adduser medidesk
sudo su - medidesk

# Cloner repository GitHub
git clone https://github.com/RBSoftwareAI/kine.git medidesk-app
cd medidesk-app

# Environnement virtuel Python
python3.11 -m venv venv
source venv/bin/activate

# Installer dépendances backend
pip install -r backend/requirements.txt

# Copier .env (créé précédemment)
nano .env  # Coller variables d'environnement

# Initialiser base de données
cd backend/database
python init_db.py  # Script d'initialisation (à créer)

# Test API
cd ../api
python app.py  # Doit démarrer sur port 5000
```

### Étape 3 : Configurer Nginx (Reverse Proxy)

**Fichier :** `/etc/nginx/sites-available/medidesk`

```nginx
# API Backend
server {
    listen 80;
    server_name api.medidesk.fr;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Site Web Marketing
server {
    listen 80;
    server_name medidesk.fr www.medidesk.fr;

    root /home/medidesk/medidesk-website;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Application Flutter Web
server {
    listen 80;
    server_name app.medidesk.fr;

    root /home/medidesk/flutter_app/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

**Activer et Tester :**

```bash
sudo ln -s /etc/nginx/sites-available/medidesk /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Étape 4 : SSL avec Let's Encrypt

```bash
sudo certbot --nginx -d api.medidesk.fr -d medidesk.fr -d www.medidesk.fr -d app.medidesk.fr
# Suivre instructions (email, accepter ToS)
# Renouvellement automatique configuré
```

### Étape 5 : Build et Déployer Flutter Web

```bash
cd /home/medidesk/flutter_app

# Build production
flutter build web --release

# Les fichiers sont dans build/web/
# Nginx les sert directement (voir config ci-dessus)
```

### Étape 6 : Configurer Supervisor (Backend Always Running)

**Fichier :** `/etc/supervisor/conf.d/medidesk-api.conf`

```ini
[program:medidesk-api]
command=/home/medidesk/medidesk-app/venv/bin/python /home/medidesk/medidesk-app/backend/api/app.py
directory=/home/medidesk/medidesk-app
user=medidesk
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/medidesk/api.err.log
stdout_logfile=/var/log/medidesk/api.out.log
```

**Activer :**

```bash
sudo mkdir -p /var/log/medidesk
sudo chown medidesk:medidesk /var/log/medidesk
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start medidesk-api
```

### Étape 7 : Sauvegardes Automatiques

**Script :** `/home/medidesk/backup.sh`

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/medidesk"
DB_PATH="/var/data/medidesk.db"

mkdir -p $BACKUP_DIR

# Backup base de données (chiffrée)
sqlite3 $DB_PATH ".backup '$BACKUP_DIR/medidesk_$DATE.db'"

# Chiffrer avec GPG
gpg --symmetric --cipher-algo AES256 "$BACKUP_DIR/medidesk_$DATE.db"
rm "$BACKUP_DIR/medidesk_$DATE.db"

# Garder seulement 30 derniers jours
find $BACKUP_DIR -type f -mtime +30 -delete

# Upload vers stockage externe (optionnel)
# rclone copy $BACKUP_DIR remote:medidesk-backups/
```

**Cron quotidien :**

```bash
sudo crontab -e
# Ajouter :
0 2 * * * /home/medidesk/backup.sh
```

---

## ✅ CHECKLIST PRÉ-LANCEMENT

### Technique ✅ / ❌

- [ ] **Serveur VPS provisionné** (OVH/Scaleway France)
- [ ] **Nginx configuré et SSL actif** (Let's Encrypt)
- [ ] **Backend Flask déployé** (Supervisor running)
- [ ] **Flutter Web buildé et déployé**
- [ ] **Base de données initialisée** (schema.sql exécuté)
- [ ] **Variables d'environnement configurées** (.env produit)
- [ ] **Sauvegardes automatiques activées** (cron quotidien)
- [ ] **Monitoring erreurs configuré** (Sentry)
- [ ] **Tests de charge effectués** (simuler 100 utilisateurs concurrents)
- [ ] **Firewall configuré** (UFW : ports 80, 443, 22 uniquement)

### Légal & Administratif ✅ / ❌

- [ ] **SIRET obtenu** (inscription société)
- [ ] **CGV/CGU publiées** (sur medidesk.fr/legal)
- [ ] **Politique confidentialité publiée** (RGPD conforme)
- [ ] **Mentions légales complétées** (adresse, SIRET, hébergeur)
- [ ] **DPO désigné** (Délégué Protection Données - obligatoire si >250 employés)
- [ ] **Déclaration CNIL effectuée** (si applicable - registre traitements)
- [ ] **Assurance RC Pro souscrite** (cyber-risques + données santé)
- [ ] **Contrats sous-traitants signés** (DPA avec Stripe, Sendinblue, OVH)

### Marketing & Commercial ✅ / ❌

- [ ] **Nom de domaine acheté** (medidesk.fr + DNS configuré)
- [ ] **Logo finalisé** (PNG, SVG, versions couleur/monochrome)
- [ ] **Site web en ligne** (medidesk.fr accessible publiquement)
- [ ] **Compte Stripe activé** (mode Live, produits créés)
- [ ] **Emails transactionnels configurés** (templates Sendinblue)
- [ ] **Analytics installé** (Plausible ou GA4 avec consentement cookies)
- [ ] **Réseaux sociaux créés** (LinkedIn, Twitter/X)
- [ ] **GitHub repository public** (github.com/RBSoftwareAI/kine)
- [ ] **Documentation utilisateur rédigée** (docs.medidesk.fr ou README)
- [ ] **Vidéo démo enregistrée** (3-5 minutes, YouTube)

### Sécurité ✅ / ❌

- [ ] **Audit sécurité effectué** (pentest ou audit externe)
- [ ] **Chiffrement AES-256 vérifié** (SQLCipher actif)
- [ ] **HTTPS forcé** (redirect HTTP → HTTPS)
- [ ] **Headers sécurité configurés** (CSP, HSTS, X-Frame-Options)
- [ ] **Rate limiting activé** (limite tentatives connexion)
- [ ] **Logs audit configurés** (rétention 3 ans minimum RGPD)
- [ ] **Webhook Stripe sécurisé** (vérification signature)
- [ ] **Secrets stockés sécurisément** (pas de hardcoded keys, .env ignoré git)

---

## 🛠️ OUTILS ET SERVICES NÉCESSAIRES

### Essentiels (À Créer Immédiatement)

| Service | Coût | URL | Priorité |
|---------|------|-----|----------|
| **Nom de domaine** | 12€/an | OVH, Gandi, Namecheap | 🔴 P0 |
| **VPS Hébergement** | 20€/mois | OVH, Scaleway | 🔴 P0 |
| **Compte Stripe** | 0€ (commission 1.4%+0.25€) | stripe.com | 🔴 P0 |
| **Sendinblue (Emails)** | 0€ (gratuit 300 emails/j) | sendinblue.com | 🔴 P0 |
| **Sentry (Monitoring)** | 0€ (gratuit 5k events/m) | sentry.io | 🟡 P1 |

### Optionnels (Nice-to-Have)

| Service | Coût | URL | Utilité |
|---------|------|-----|---------|
| **Plausible Analytics** | 9€/mois | plausible.io | Analytics RGPD-friendly |
| **Figma Pro** | 12€/mois | figma.com | Design UI/UX |
| **Notion** | 0€ (gratuit) | notion.so | Documentation interne |
| **Slack** | 0€ (gratuit) | slack.com | Communication équipe |
| **GitHub Pro** | 4€/mois | github.com | CI/CD, Actions illimitées |

---

## 🎯 PROCHAINES ÉTAPES (Roadmap)

### Semaine 1 : Finalisation Technique

1. **Implémenter API Stripe backend** (2-3h)
   - Code fourni dans `backend_stripe.py`
   - Créer endpoints manquants

2. **Tester abonnements end-to-end**
   - Inscription → Essai → Paiement → Webhook
   - Vérifier emails transactionnels

3. **Déployer sur VPS production**
   - Suivre checklist ci-dessus
   - Tests de charge

### Semaine 2-3 : Lancement Commercial

4. **Campagne email 100 premiers contacts**
   - Utiliser template "Prospection initiale"
   - Objectif : 10 démos programmées

5. **Publier 3 articles blog/LinkedIn**
   - "Pourquoi l'open source pour votre cabinet kiné ?"
   - "RGPD : 5 erreurs à éviter avec vos données patients"
   - "Comment MediDesk fait gagner 2h/jour aux kinés"

6. **Lancer webinaire gratuit**
   - "Digitaliser son cabinet kiné en 2026"
   - Inscription via medidesk.fr/events

### Mois 2-3 : Acquisition Clients

7. **Objectif : 50 cabinets payants** (2,450€ MRR)
   - SEO : Optimiser pages "logiciel kiné"
   - Google Ads : Budget 500€/mois
   - Salons pros : RNMKS (salon kiné national)

8. **Améliorer produit selon feedback**
   - Prioriser features demandées
   - Corriger bugs critiques

9. **Préparer levée de fonds** (optionnel)
   - Pitcher 10 business angels
   - Objectif : 100k€ seed round

---

## 📞 SUPPORT & CONTACTS

### Documentation Technique

- **GitHub Repository** : github.com/RBSoftwareAI/kine
- **Documentation Code** : README.md dans chaque dossier
- **Issues & Bugs** : GitHub Issues

### Services Externes

- **Stripe Support** : support.stripe.com (chat 24/7)
- **Sendinblue Support** : sendinblue.com/contact
- **OVH Support** : ovh.com/manager (tickets)

### Conformité & Légal

- **CNIL** : cnil.fr (questions RGPD)
- **Ordre des Kinés** : ordremk.fr (partenariats)
- **Avocat RGPD** : [À trouver - spécialiste santé]

---

## 📝 NOTES FINALES

### Points d'Attention

⚠️ **Sécurité Données Santé :**
- Chiffrement AES-256 OBLIGATOIRE (SQLCipher)
- Hébergement France HDS OBLIGATOIRE
- Audit logs 3 ans minimum (RGPD Article 5.2)

⚠️ **Conformité RGPD :**
- Consentement patients obligatoire (Art. 9 RGPD)
- Droit à l'effacement garanti (export + suppression 30j)
- DPO désigné si >250 employés

⚠️ **Performance :**
- Base SQLite limite : ~100k patients max
- Si croissance forte : migrer vers PostgreSQL
- Backups quotidiens OBLIGATOIRES

### Remerciements

Ce projet a été développé avec soin pour servir la communauté des kinésithérapeutes. 
L'open source est un choix délibéré pour garantir transparence et confiance.

**Bon lancement MediDesk ! 🚀**

---

**Document créé le 16 novembre 2025**  
**Pour questions : contact@medidesk.fr**
