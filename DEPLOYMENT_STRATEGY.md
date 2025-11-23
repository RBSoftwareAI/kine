# 🚀 Stratégie de Déploiement MediDesk

**Date de création :** 19 novembre 2025  
**Version :** 1.0  
**Statut :** Phase Beta en cours

---

## 🌐 Architecture des Domaines

### **Vue d'Ensemble**

```
medidesk.fr (Site Marketing)
├── Phase Beta (Nov 2025 - Fév 2026)
│   └── index-beta.html
│       ├── Programme Accès Anticipé
│       ├── Liste d'attente
│       ├── Partenaire exclusif : Tourcoing
│       └── Tarifs masqués (à définir)
│
└── Phase Lancement (Mars 2026)
    └── index.html
        ├── Tarifs définitifs
        ├── Essais gratuits 14j
        ├── Témoignages clients
        └── Inscription directe

demo.medidesk.fr (Application Flutter)
├── Application démo fonctionnelle
├── Firebase Backend
├── Multi-tenant (isolation par centre_id)
└── Données de test (2 centres)
```

---

## 📅 Timeline de Déploiement

### **Phase 1 : Beta Préparation (Nov 2025)** ✅ ACTUEL
**Status :** En cours  
**Domaines :**
- ✅ medidesk.fr → **index-beta.html** (à déployer)
- 🔄 demo.medidesk.fr → Application Flutter (en développement)

**Actions Complétées :**
- ✅ Infrastructure Firebase configurée
- ✅ Backend services (Auth, Firestore)
- ✅ Modèles de données (Centre, User, Patient, Appointment)
- ✅ Base de données initialisée (58 documents test)
- ✅ Règles de sécurité multi-tenant
- ✅ Site web beta créé (index-beta.html)

**Actions Restantes :**
- [ ] Développer écrans UI Flutter (Phases B, C, D)
- [ ] Publier règles Firestore dans Firebase Console
- [ ] Déployer index-beta.html sur medidesk.fr
- [ ] Configurer DNS Gandi pour demo.medidesk.fr
- [ ] Déployer app Flutter sur Netlify

**Livrables :**
- Site web beta avec formulaire liste d'attente
- Application démo accessible publiquement
- Documentation technique complète

---

### **Phase 2 : Pilote Tourcoing (Déc 2025 - Fév 2026)**
**Status :** À venir  
**Domaines :** Inchangés

**Objectifs :**
- Tester MediDesk avec utilisateurs réels (Centre Tourcoing)
- Collecter feedback utilisateur
- Valider tarifs et fonctionnalités
- Corriger bugs et améliorer UX

**Actions :**
- [ ] Onboarding Centre Tourcoing
- [ ] Formation équipe Tourcoing
- [ ] Suivi hebdomadaire utilisation
- [ ] Collecte feedback structuré
- [ ] Itérations produit rapides

**KPIs à Suivre :**
- Taux d'adoption par les praticiens
- Nombre de patients enregistrés
- Nombre de rendez-vous créés
- Temps de saisie par séance
- Satisfaction utilisateurs (NPS)
- Bugs critiques remontés

---

### **Phase 3 : Pré-Lancement (Mars 2026)**
**Status :** À venir  
**Domaines :** Transition vers version production

**Actions :**
- [ ] Finaliser tarifs définitifs (basés sur retours Tourcoing)
- [ ] Basculer medidesk.fr vers **index.html** (version complète)
- [ ] Activer essais gratuits 14 jours
- [ ] Configurer Stripe pour paiements
- [ ] Envoyer email à liste d'attente beta (offre -30%)
- [ ] Publier témoignage Tourcoing (avec autorisation)

**Livrables :**
- Site web production avec tarifs
- Application Flutter stable
- Système de paiement opérationnel
- Documentation utilisateur complète

---

### **Phase 4 : Lancement Commercial (Avril 2026)**
**Status :** À venir  
**Domaines :** Production complète

**Actions :**
- [ ] Campagne marketing (emails, LinkedIn, publicités)
- [ ] SEO optimisation (référencement naturel)
- [ ] Partenariats professionnels (ordres, syndicats)
- [ ] Support client actif
- [ ] Monitoring performances

**KPIs à Suivre :**
- Visiteurs mensuels medidesk.fr
- Taux de conversion (visiteurs → inscriptions)
- MRR (Monthly Recurring Revenue)
- Churn rate mensuel
- NPS (Net Promoter Score)

---

## 🛠️ Guide de Déploiement Détaillé

### **Déploiement medidesk.fr (Site Marketing)**

#### **Option 1 : Netlify (Recommandé)**

**Prérequis :**
- Compte Netlify gratuit
- Repository GitHub connecté

**Étapes :**

1. **Connecter Repository GitHub**
```bash
# Se connecter à Netlify
netlify login

# Initialiser le site depuis le dossier website
cd /home/user/flutter_app/website
netlify init

# Configuration
Site name: medidesk
Build command: (laisser vide)
Publish directory: .
```

2. **Configurer DNS Gandi**
```
# Dans Gandi, ajouter les DNS suivants pour medidesk.fr:

Type: A
Name: @
Value: 75.2.60.5 (Netlify Load Balancer)

Type: CNAME  
Name: www
Value: medidesk.netlify.app
```

3. **Configurer SSL dans Netlify**
```
Settings → Domain Management → HTTPS
→ Activer "Force HTTPS"
→ Certificat Let's Encrypt automatique
```

4. **Déployer la Version Beta**
```bash
# Copier la version beta comme index principal
cp index-beta.html index.html

# Déployer
netlify deploy --prod
```

**Résultat :** Site accessible sur https://medidesk.fr

---

#### **Option 2 : VPS (Alternative)**

**Prérequis :**
- VPS Linux (OVH, Scaleway, etc.)
- Nginx installé
- Certificat SSL Let's Encrypt

**Configuration Nginx :**
```nginx
# /etc/nginx/sites-available/medidesk.fr

server {
    listen 80;
    server_name medidesk.fr www.medidesk.fr;
    return 301 https://medidesk.fr$request_uri;
}

server {
    listen 443 ssl http2;
    server_name www.medidesk.fr;
    return 301 https://medidesk.fr$request_uri;
}

server {
    listen 443 ssl http2;
    server_name medidesk.fr;

    ssl_certificate /etc/letsencrypt/live/medidesk.fr/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/medidesk.fr/privkey.pem;

    root /var/www/medidesk;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Cache static assets
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

**Déploiement :**
```bash
# Sur votre machine locale
rsync -avz website/ user@medidesk.fr:/var/www/medidesk/

# Sur le VPS
sudo systemctl reload nginx
```

---

### **Déploiement demo.medidesk.fr (Application Flutter)**

#### **Option 1 : Netlify (Recommandé)**

**Prérequis :**
- Application Flutter buildée (`flutter build web --release`)

**Étapes :**

1. **Build Flutter Web**
```bash
cd /home/user/flutter_app
flutter build web --release
```

2. **Configurer Netlify**
```bash
# Depuis le dossier Flutter
netlify init

# Configuration
Site name: medidesk-demo
Build command: flutter build web --release
Publish directory: build/web
```

3. **Configurer DNS Gandi**
```
# Dans Gandi, ajouter le sous-domaine demo.medidesk.fr:

Type: CNAME
Name: demo
Value: medidesk-demo.netlify.app
```

4. **Déployer**
```bash
netlify deploy --prod
```

**Résultat :** Application accessible sur https://demo.medidesk.fr

---

#### **Option 2 : Firebase Hosting (Alternative)**

**Avantages :** Intégration native avec Firebase Backend

**Étapes :**

1. **Installer Firebase CLI**
```bash
npm install -g firebase-tools
firebase login
```

2. **Initialiser Firebase Hosting**
```bash
cd /home/user/flutter_app
firebase init hosting

# Configuration
Public directory: build/web
Single-page app: Yes
```

3. **Build et Déployer**
```bash
flutter build web --release
firebase deploy --only hosting
```

4. **Configurer Domaine Personnalisé**
```
Firebase Console → Hosting → Add custom domain
→ demo.medidesk.fr
→ Suivre instructions DNS
```

**Résultat :** Application accessible sur https://demo.medidesk.fr

---

## 📊 Checklist de Déploiement

### **Pre-Deployment (Avant Mise en Ligne)**

**Site Marketing (medidesk.fr) :**
- [ ] Choisir version correcte (index-beta.html pour beta, index.html pour prod)
- [ ] Vérifier tous les liens (internes et externes)
- [ ] Tester formulaires (contact, waitlist)
- [ ] Vérifier responsive design (mobile, tablette)
- [ ] Optimiser images (compression, lazy loading)
- [ ] Configurer Google Analytics / Plausible
- [ ] Tester performance (PageSpeed Insights >90)
- [ ] Vérifier SSL et HTTPS redirect

**Application Flutter (demo.medidesk.fr) :**
- [ ] Build production (`flutter build web --release`)
- [ ] Tester application en local (Python server)
- [ ] Vérifier Firebase connexion
- [ ] Tester authentification (signup/login)
- [ ] Vérifier isolation multi-tenant
- [ ] Tester sur différents navigateurs
- [ ] Publier règles Firestore dans Console
- [ ] Configurer Firebase Analytics

---

### **Post-Deployment (Après Mise en Ligne)**

**Validation Technique :**
- [ ] Tester medidesk.fr depuis différents pays/réseaux
- [ ] Vérifier demo.medidesk.fr accessible
- [ ] Tester inscription liste d'attente (email confirmation)
- [ ] Vérifier Firebase fonctionnel
- [ ] Tester création compte démo
- [ ] Vérifier logs d'erreurs (Firebase, Netlify)

**SEO & Marketing :**
- [ ] Soumettre sitemap à Google Search Console
- [ ] Configurer Google My Business
- [ ] Créer page LinkedIn MediDesk
- [ ] Publier annonce sur réseaux sociaux
- [ ] Envoyer newsletter aux contacts existants

**Monitoring :**
- [ ] Configurer alertes uptime (UptimeRobot)
- [ ] Configurer alertes erreurs (Sentry, Firebase)
- [ ] Suivre analytics quotidiennement
- [ ] Répondre aux inscriptions beta sous 24h

---

## 🔐 Sécurité & Conformité

### **HTTPS Obligatoire**
- Tous les domaines doivent être en HTTPS
- Certificats SSL Let's Encrypt automatiques
- Force HTTPS redirect (HTTP → HTTPS)

### **RGPD**
- Politique de confidentialité publiée
- CGU/CGV accessibles
- Consentement cookies (si analytics)
- Droit à l'oubli implémenté

### **Firebase Security**
- Règles Firestore publiées (isolation multi-tenant)
- Authentification email/password uniquement
- Pas de mode anonyme en production
- Backup automatique Firebase activé

---

## 📞 Support & Contacts

### **Problèmes Déploiement**
- **Netlify :** support@netlify.com
- **Firebase :** https://firebase.google.com/support
- **Gandi DNS :** https://docs.gandi.net/fr/

### **Questions Techniques**
- **Email :** support@medidesk.fr
- **GitHub Issues :** https://github.com/RBSoftwareAI/kine/issues

---

## 📚 Ressources Additionnelles

### **Documentation Complète**
- **AI_QUICK_START.md** : Guide express 30 secondes
- **CONTEXT.md** : Documentation technique complète
- **VERSION_COMPARISON.md** : Comparaison versions site web
- **website/README.md** : Package marketing complet

### **Liens Utiles**
- **Repository GitHub :** https://github.com/RBSoftwareAI/kine
- **Firebase Console :** https://console.firebase.google.com/project/kinecare-81f52
- **Gandi Domaines :** https://admin.gandi.net/

---

## 🎯 Résumé Exécutif

**État Actuel (19 Nov 2025) :**
- ✅ Infrastructure Firebase complète
- ✅ Backend services opérationnels
- ✅ Site web beta créé (index-beta.html)
- ✅ Documentation technique complète
- ⏳ UI Flutter à développer (Phases B, C, D)
- ⏳ Déploiement medidesk.fr et demo.medidesk.fr à effectuer

**Prochaines Étapes Immédiates :**
1. Développer écrans authentification Flutter (Phase B)
2. Déployer index-beta.html sur medidesk.fr (Netlify)
3. Compléter développement UI et déployer sur demo.medidesk.fr
4. Commencer phase pilote avec Tourcoing (Décembre 2025)

**Objectif Mars 2026 :**
- Site production avec tarifs (index.html)
- Application Flutter stable et complète
- Lancement commercial avec liste d'attente beta convertie

---

**📅 Document créé le 19 novembre 2025**  
**🔄 Dernière mise à jour : 19 novembre 2025**  
**📧 Questions ? contact@medidesk.fr**

---

**🚀 MediDesk - Transformez votre pratique, en toute transparence**
