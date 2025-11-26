# 🚀 Prompt Détaillé - Prochaine Session MediDesk

## ✅ **CORRECTIONS SESSION 26 NOVEMBRE 2025 - 15h00 (COMPLÉTÉES)**

### **🐛 Correction Critique #1 : Navigation Patient depuis Menu Gauche**
**Problème** : Clic depuis "Liste des patients" (menu gauche) → Message "Patient introuvable"  
**Cause** : Incohérence des IDs entre `PatientService` (mock: patient_001) et Firebase (IDs réels)  
**Solution** : Remplacement de `PatientService` par `PatientProvider` dans `PatientsDashboardScreen`  
**Fichier modifié** : `lib/views/professional/patients_dashboard_screen.dart` (réécriture complète)  
**Commit** : `73d5611` - "🐛 Fix(Critical): Corriger 'Patient introuvable'"

### **📝 Correction #2 : Wording Site Web Inclusif**
**Objectif** : Garder focus "Kinésithérapeute" + signaler ouverture tous professionnels de santé  
**Modifications** (5 emplacements dans `website/index.html`) :
1. Meta description SEO : + "ostéopathes et professionnels de santé"
2. Keywords : + "ostéopathe, centre de soins"
3. Hero subtitle : + mention discrète "(ostéopathes, centres de soins, professionnels de santé)"
4. Section Features : "conçus par kinés, pour tous les professionnels de santé"
5. CTA : "(kinés, ostéos, centres de soins)"
6. Footer : "kinésithérapeutes et tous les professionnels de santé"

**Commits** :
- `2cd6d18` - "🐛 Fix(Navigation): Navigation patient + Wording inclusif"
- `73d5611` - "🐛 Fix(Critical): Corriger 'Patient introuvable'"

**Tests** : ✅ Build Flutter Web 52.1s | ✅ Serveur PID 7111 | ✅ HTTP 200 OK

---

## 📋 **Contexte du Projet**

**Application** : MediDesk - Plateforme de gestion de cabinet médical pour kinésithérapeutes et ostéopathes  
**Repository GitHub** : `https://github.com/RBSoftwareAI/kine` (branche `base`)  
**URLs** :
- **Site vitrine** : `https://medidesk.fr` (à refaire)
- **Application démo** : `https://demo.medidesk.fr` 
- **Serveur de développement** : `https://5060-iuehxdwgw560d171fo2tx-5634da27.sandbox.novita.ai`

**Chemin projet** : `/home/user/medidesk`  
**Technologies** : 
- Application principale : Flutter 3.35.4 + Dart 3.9.2 (Web + Android)
- Site vitrine : HTML/CSS/JavaScript pur (dossier `/home/user/medidesk/website`)
- Backend : Firebase (Firestore, Auth, Storage, Functions)

**État actuel du projet** :
- ✅ MVP Phase 1 complété (authentification, cartographie douleurs, dashboard, RGPD)
- ✅ Visite guidée 100% cohérente (6 étapes corrigées)
- ✅ Historique consultations par patient
- ✅ Cartographie professionnelle des douleurs avec comparatif patient vs professionnel
- ✅ Session du 26 novembre 2025 - 10h00 : Toutes demandes satisfaites
- ✅ Session du 26 novembre 2025 - 15h00 : Bug navigation corrigé + Wording site web inclusif

**Comptes de test disponibles** :
- **Praticien (Ostéo)** : `pierre.durand@osteo-lyon.fr` / `password123`
- **Praticien (Kiné)** : `marie.lefebvre@kine-paris.fr` / `password123`
- **Patient** : `test.patient@medidesk.fr` / `password123`
- **Manager** : `manager@medidesk.fr` / `password123`
- **Admin** : `admin@medidesk.fr` / `password123`

**Configuration Firebase** :
- Admin SDK : `/opt/flutter/firebase-admin-sdk.json`
- Google Services : `/opt/flutter/google-services.json`
- Project ID : `kinecare-81f52`
- Package Android : `fr.medidesk.demo`

**💰 MODÈLE ÉCONOMIQUE (Défini Session 26 Nov 2025 - 15h30)** :

**🆓 VERSION GRATUITE & OPEN SOURCE (À VIE)** :
- Santé + Suivi Patients (cartographie, notes, historique)
- Gestion RDV Locale (calendrier intégré, planning)
- Conformité RGPD complète
- Installation locale (données sur votre machine)
- Licence MIT (code source sur GitHub)

**💎 MODULES PROFESSIONNELS (SUR DEVIS - OPTIONNELS)** :

**Options Disponibles** (Prêtes à installer) :
- 📅 RDV en ligne synchronisés (widget web + sync bidirectionnelle local ↔ online)
- ☁️ Cloud Sync & Backup avancé
- 📄 Export PDF Pro (rapports personnalisés, e-signature)
- 🌐 Multi-Centres (réseau de cabinets)

**Options en Développement** (Roadmap) :
- 🔗 Sync Doctolib / Maiia / APIs tierces (Q2 2026)
- 💳 Facturation automatique (Q3 2026)
- 📊 Analytics & Statistiques Nationales IA (Q4 2026)
- 🤖 Conseils IA de suivi patients (Q1 2027)
- 🔔 Notifications Push multi-canal (Q2 2026)

**Processus Commercial** :
1. Professionnel remplit formulaire de demande de devis
2. Analyse des besoins par équipe MediDesk
3. Proposition commerciale personnalisée (sous 48h)
4. Installation + Formation incluses dans le devis

---

## 🎯 **Demandes Prioritaires pour Cette Session**

### **1️⃣ PRIORITÉ HAUTE : Refonte du Site Vitrine medidesk.fr**

**📂 Emplacement** : `/home/user/medidesk/website/`

**🎨 Objectif** : Créer un site vitrine moderne, professionnel et optimisé SEO

**📋 Structure actuelle du dossier website/** :
```
website/
├── index.html (39 771 caractères - à refaire complètement)
├── css/
│   └── style.css (à refaire)
├── js/
│   └── main.js (à refaire)
├── legal/
│   ├── mentions-legales.html
│   ├── politique-confidentialite.html
│   └── cgu.html
├── backend_stripe.py (backend paiements Stripe)
└── README.md (documentation technique)
```

**✅ Exigences du nouveau site** :

**Design & UX** :
- Design moderne, épuré, professionnel (inspiration : Doctolib, Calendly)
- Palette de couleurs : Bleu primaire (`#2563eb`), Orange accent (`#FF6B35`), gris neutres
- Responsive design : Mobile-first (smartphone → tablette → desktop)
- Animations fluides et transitions élégantes (scroll reveal, hover effects)
- Typographie : Inter (Google Fonts), hiérarchie claire
- Accessibilité WCAG 2.1 niveau AA minimum

**Structure de Navigation** :
```
Nav principale :
- Accueil
- Fonctionnalités (ancre #fonctionnalites)
- Tarifs (ancre #tarifs)
- FAQ (ancre #faq)
- Contact (ancre #contact)
- Bouton CTA : "Essai Gratuit 14j" (lien vers demo.medidesk.fr)
```

**Sections à Créer** :

1. **Hero Section** (Above the fold) :
   - Titre accrocheur : "Le logiciel de gestion pensé pour les professionnels de santé"
   - Sous-titre : Cartographie interactive, suivi patients, gestion RDV locale, conformité RGPD - Pour kinés, ostéos, médecins, infirmiers, coachs sportifs
   - 2 CTA : "Télécharger Gratuitement" (primary, bleu) + "Demander un Devis Pro" (secondary, orange outline)
   - Badges : 
     - "🆓 100% Gratuit & Open Source"
     - "🔒 Conforme RGPD"
     - "📅 Gestion RDV Incluse"
   - Stats visuelles : 
     - "Santé + RDV Local : Gratuit"
     - "Open Source (GitHub)"
     - "Modules Pro : Sur Devis"
   - Mockup visuel : Interface de cartographie des douleurs (silhouette + points)

2. **Section Problème/Solution** :
   - ❌ Problèmes actuels : Dossiers papier, cartographies main levée, traçabilité RGPD complexe
   - ✅ Solution MediDesk : Cartographie digitale, historique automatique, RGPD intégré

3. **Section Fonctionnalités** (#fonctionnalites) :
   
   **🆓 Fonctionnalités Gratuites (Version Open Source)** :
   - 🎯 **Cartographie interactive des douleurs** (silhouette anatomique cliquable)
   - 📊 **Graphiques d'évolution temporelle** (progression patients)
   - 📝 **Notes de séances et historique complet** (dossiers sécurisés)
   - 👥 **Gestion multi-patients illimitée** (aucune limite)
   - 📅 **Calendrier de rendez-vous local** (planning intégré)
   - 🔒 **Conformité RGPD automatique** (chiffrement, audit logs)
   - 💻 **Installation locale** (vos données restent chez vous)
   - 🌐 **Accessible Web + Mobile** (responsive design)
   
   **💎 Modules Professionnels (Sur Devis)** :
   - 🌍 **RDV en ligne synchronisés** (widget web + sync calendrier local)
   - ☁️ **Cloud Sync & Backup** (sauvegarde automatique)
   - 📄 **Export PDF Pro** (rapports personnalisés)
   - 🏢 **Multi-Centres** (réseau de cabinets)
   - 🔗 **Intégrations APIs** (Doctolib, Maiia - en développement)
   - 💳 **Facturation automatique** (en développement)
   - 📊 **Analytics IA** (statistiques nationales - en développement)
   - 🤖 **Conseils IA patients** (recommandations - en développement)
   
   - Chaque fonctionnalité : Icône + Titre + Description + Badge (Gratuit / Sur Devis) + Screenshot/illustration

4. **Section Tarifs** (#tarifs) :
   
   **🆓 MODÈLE ÉCONOMIQUE** : **Gratuit & Open Source + Upsells Professionnels**
   
   ---
   
   ### **✅ VERSION GRATUITE & OPEN SOURCE** (Installation Locale - Toujours Gratuite)
   
   **🎯 Fonctionnalités Incluses** :
   - ✅ **Santé & Suivi Patients** :
     - Cartographie interactive des douleurs (silhouettes anatomiques)
     - Graphiques d'évolution temporelle
     - Notes de séances + historique complet
     - Gestion multi-patients illimitée
     - Dossiers patients sécurisés (chiffrement AES-256)
   
   - ✅ **Gestion Rendez-vous Locale** :
     - Calendrier de rendez-vous intégré
     - Prise de RDV manuelle en cabinet
     - Vue journalière / hebdomadaire / mensuelle
     - Notifications locales (rappels)
   
   - ✅ **Conformité & Sécurité** :
     - 100% Conforme RGPD
     - Hébergement local (données sur votre machine)
     - Chiffrement des données patients
     - Audit logs complets
   
   - ✅ **Open Source** :
     - Code source disponible sur GitHub
     - Licence MIT (libre utilisation commerciale)
     - Communauté active
     - Pas de télémétrie, pas de tracking
   
   **📥 CTA Principal** : "Télécharger Gratuitement" (lien vers GitHub Releases)
   
   ---
   
   ### **💎 UPSELLS PROFESSIONNELS** (Optionnels - Sur Devis)
   
   **📋 Processus** : Formulaire de demande de devis → Contact commercial → Installation personnalisée
   
   #### **🟢 OPTIONS DISPONIBLES** (Prêtes à être installées)
   
   1. **📅 Gestion Rendez-vous en Ligne Synchronisée**
      - Prise de RDV en ligne via widget web
      - **Synchronisation bidirectionnelle** avec calendrier local
      - Page de réservation personnalisée (votre domaine)
      - Notifications SMS/Email automatiques
      - Gestion des créneaux disponibles
      - Protection contre les doublons (local ↔ online)
      - **💰 Prix** : Sur devis (selon volume de RDV)
   
   2. **☁️ Cloud Sync & Backup Avancé**
      - Sauvegarde automatique chiffrée
      - Synchronisation multi-appareils (cabinet + domicile)
      - Restauration en 1 clic
      - Historique des versions (30 jours)
      - **💰 Prix** : Sur devis
   
   3. **📄 Export PDF Professionnel**
      - Rapports personnalisés (logo, en-tête)
      - E-signature électronique légale
      - Templates modifiables
      - Export massif
      - **💰 Prix** : Sur devis
   
   4. **🌐 Solution Multi-Centres**
      - Gestion réseau de cabinets
      - Partage sécurisé de patients
      - Statistiques consolidées
      - Facturation centralisée
      - **💰 Prix** : Sur devis (selon nombre de centres)
   
   #### **🟡 OPTIONS EN DÉVELOPPEMENT** (Roadmap - Disponibilité Future)
   
   1. **🔗 Synchronisation Doctolib / Maiia / Autres APIs**
      - Import automatique RDV Doctolib → MediDesk local
      - Import automatique RDV Maiia → MediDesk local
      - Support APIs tierces (selon disponibilité)
      - Synchronisation temps réel
      - **📅 Disponibilité** : Q2 2026 (estimation)
      - **💰 Prix** : Sur devis (selon plateformes intégrées)
   
   2. **💳 Facturation Automatique**
      - Génération factures conforme loi française
      - Numérotation automatique
      - Export comptable (CSV, Excel)
      - Relances automatiques
      - Intégration logiciels comptables
      - **📅 Disponibilité** : Q3 2026
      - **💰 Prix** : Sur devis
   
   3. **📊 Statistiques & Analyse Nationale**
      - Dashboard KPIs avancés
      - Benchmarking anonymisé (comparaison nationale)
      - Prédictions IA (taux de remplissage, tendances)
      - Export rapports analytiques
      - **📅 Disponibilité** : Q4 2026
      - **💰 Prix** : Sur devis
   
   4. **🤖 IA - Conseils de Suivi Patients**
      - Suggestions personnalisées par patient
      - Détection automatique anomalies
      - Recommandations exercices adaptés
      - Alertes préventives (risque aggravation)
      - **📅 Disponibilité** : Q1 2027 (recherche en cours)
      - **💰 Prix** : Sur devis
   
   5. **🔔 Notifications Push Multi-Canal**
      - Rappels SMS patients
      - Notifications Email automatiques
      - Push notifications mobile (app iOS/Android)
      - **📅 Disponibilité** : Q2 2026
      - **💰 Prix** : Sur devis
   
   ---
   
   ### **📋 DEMANDE DE DEVIS**
   
   **Formulaire de Contact Professionnel** :
   - Nom & Prénom
   - Email professionnel
   - Téléphone
   - Type de cabinet (solo / groupe / centre)
   - Modules souhaités (checkboxes)
   - Volume estimé (nombre RDV/mois, nombre praticiens)
   - Message / Besoins spécifiques
   
   **CTA Formulaire** : "Demander un Devis Personnalisé"
   
   **Processus** :
   1. Professionnel remplit le formulaire
   2. Équipe MediDesk analyse les besoins
   3. Proposition commerciale sur mesure (sous 48h)
   4. Installation & formation incluses
   
   ---
   
   ### **🎁 AVANTAGES**
   
   - ✅ **Version gratuite à vie** (pas de piège, pas d'expiration)
   - ✅ **Pas d'abonnement forcé** (upsells 100% optionnels)
   - ✅ **Données locales** (souveraineté complète)
   - ✅ **Tarification transparente** (devis personnalisé, pas de frais cachés)
   - ✅ **Support prioritaire** pour clients upsells
   - ✅ **Mises à jour gratuites** de la version open source
   
   ---
   
   **Badge Principal** : "🆓 Gratuit & Open Source à Vie - Upsells Professionnels Sur Devis"
   
   **CTAs Section Tarifs** :
   - **CTA Principal** : "Télécharger la Version Gratuite" (bouton bleu, prominent)
   - **CTA Secondaire** : "Demander un Devis pour Modules Pro" (bouton orange, outline)

5. **Section Témoignages** (optionnel - factices pour V1) :
   - 3 témoignages de praticiens (photos + nom + rôle + citation)
   - Note moyenne : ⭐⭐⭐⭐⭐ 4.8/5

6. **Section FAQ** (#faq) :
   - Accordion/Collapsible
   - 10-12 questions fréquentes :
     - "MediDesk est-il vraiment gratuit ?"
       → Réponse : Oui, la version open source avec santé + RDV local est 100% gratuite à vie. Les modules pro sont optionnels et sur devis.
     - "Qu'est-ce qui est inclus dans la version gratuite ?"
       → Réponse : Cartographie douleurs, graphiques, notes, gestion patients, calendrier RDV local, RGPD.
     - "Comment fonctionnent les modules payants ?"
       → Réponse : Sur devis personnalisé via formulaire. Installation et formation incluses.
     - "La gestion des RDV en ligne est-elle payante ?"
       → Réponse : Oui, la synchronisation avec widget web de prise de RDV en ligne est un module pro sur devis.
     - "Puis-je synchroniser avec Doctolib ?"
       → Réponse : En développement (Q2 2026). Module pro sur devis une fois disponible.
     - "MediDesk est-il conforme RGPD ?"
       → Réponse : Oui, 100% conforme. Données locales, chiffrement AES-256, audit logs.
     - "Mes données sont-elles sécurisées ?"
       → Réponse : Oui, hébergement local sur votre machine, chiffrement, aucune télémétrie.
     - "Y a-t-il une version mobile ?"
       → Réponse : Interface web responsive (mobile/tablette). Apps natives iOS/Android en roadmap.
     - "Le logiciel est-il Open Source ?"
       → Réponse : Oui, licence MIT sur GitHub. Code source transparent et auditable.
     - "Quel support est disponible ?"
       → Réponse : Documentation + communauté (gratuit). Support prioritaire pour clients modules pro.
     - "Puis-je tester avant d'acheter des modules ?"
       → Réponse : Oui, démo en ligne disponible. Modules pro testables après devis.
     - "Comment demander un devis ?"
       → Réponse : Formulaire de contact sur la page Tarifs. Réponse sous 48h.

7. **Section Contact** (#contact) :
   
   **Deux formulaires distincts** :
   
   **A) Formulaire de Demande de Devis (Modules Pro)** :
   - Nom & Prénom *
   - Email professionnel *
   - Téléphone
   - Type de cabinet * (dropdown : Solo / Groupe / Centre de soins / Réseau)
   - Nombre de praticiens
   - Volume RDV estimé/mois
   - **Modules souhaités** (checkboxes) :
     - [ ] RDV en ligne synchronisés
     - [ ] Cloud Sync & Backup
     - [ ] Export PDF Pro
     - [ ] Multi-Centres
     - [ ] Sync Doctolib/Maiia (en développement)
     - [ ] Facturation automatique (en développement)
     - [ ] Analytics IA (en développement)
     - [ ] Conseils IA patients (en développement)
     - [ ] Autre (préciser)
   - Message / Besoins spécifiques (textarea)
   - Checkbox : "J'accepte d'être contacté par l'équipe MediDesk" *
   - **CTA** : "Demander un Devis Personnalisé" (bouton orange)
   - Temps de réponse : "📧 Réponse sous 48h ouvrées"
   
   **B) Formulaire de Contact Général** :
   - Nom, Email, Message
   - **CTA** : "Envoyer" (bouton bleu)
   - Temps de réponse : "Nous répondons sous 24h"
   
   - Email direct : `contact@medidesk.fr`
   - Email commercial : `devis@medidesk.fr`

8. **Footer** :
   - Logo + Slogan
   - Liens : Fonctionnalités, Tarifs, FAQ, Contact
   - Liens légaux : Mentions légales, Politique de confidentialité, CGU
   - Réseaux sociaux (placeholders)
   - Copyright : "© 2025 MediDesk. Tous droits réservés."

**🔧 Aspects Techniques** :
- HTML5 sémantique (`<header>`, `<main>`, `<section>`, `<article>`, `<footer>`)
- CSS3 moderne (Flexbox, Grid, CSS Variables, animations)
- JavaScript vanilla (pas de frameworks - léger et rapide)
- Performance : Lighthouse score > 90
- SEO optimisé :
  - Meta tags (title, description, keywords)
  - Open Graph (partage réseaux sociaux)
  - Schema.org (SoftwareApplication)
  - Sitemap.xml
- Formulaire de contact : Backend Python (backend_stripe.py à adapter) ou service externe (Formspree)

**📦 Assets nécessaires** :
- Logo MediDesk SVG (à créer si nécessaire)
- Icônes : Font Awesome ou Heroicons
- Screenshots : Utiliser captures d'écran de l'app Flutter (ou mockups)
- Images : Illustrations SVG ou photos professionnelles (Unsplash OK)

**🚫 Ce qui N'EST PAS demandé** :
- Pas de système de paiement en ligne (les modules pro sont sur devis uniquement)
- Pas de backend authentification (lien vers demo.medidesk.fr pour la démo)
- Pas de chatbot (peut être ajouté plus tard)
- Pas de prix affichés (tout sur devis personnalisé)
- Pas de tarifs fixes mensuels (modèle B2B sur mesure)

---

### **2️⃣ PRIORITÉ HAUTE : Amélioration de la Page de Connexion demo.medidesk.fr**

**📂 Fichier** : `/home/user/medidesk/lib/screens/auth/login_screen.dart`

**❌ Problème actuel** :
- La page de connexion affiche 5 comptes de test avec boutons "Copier email" et "Copier mot de passe"
- Ces boutons copie-coller occupent beaucoup d'espace et ne sont pas ergonomiques
- L'utilisateur doit faire 2 actions (copier email → coller → copier mdp → coller)

**✅ Solution à implémenter** :

**Nouveau Design** :
- **Panneau gauche (écrans larges)** :
  - Titre : "Comptes de test disponibles"
  - Sous-titre : "Cliquez sur un compte pour vous connecter automatiquement"
  - Liste de 5 cartes compactes (pas de boutons copier) :
    ```
    [CARTE COMPTE]
    🎭 Icône du rôle
    Rôle + Nom
    Email (police réduite, gris)
    Description du rôle (1 ligne)
    
    [Au clic sur la carte entière] → Remplissage automatique + connexion
    ```

- **Panneau droit** : Formulaire de connexion (inchangé)

**Comportement au clic sur une carte de compte** :
1. Remplir automatiquement les champs email et mot de passe
2. **Option A (recommandée)** : Connexion automatique immédiate (sans clic sur "Se connecter")
3. **Option B** : Remplir les champs + highlight du bouton "Se connecter" pour validation manuelle

**Avantages** :
- ✅ Expérience utilisateur améliorée (1 clic au lieu de 4)
- ✅ Interface plus épurée et professionnelle
- ✅ Économie d'espace vertical (cartes plus compactes)
- ✅ Plus intuitif pour les testeurs et démonstrateurs

**Mobile (écrans < 900px)** :
- Formulaire en haut
- Cartes comptes en dessous (scrollable)
- Comportement identique au clic

**Code à modifier** :
- Fonction `_buildTestAccountCard()` → Transformer en InkWell/GestureDetector
- Supprimer boutons "Copier email" et "Copier mot de passe"
- Ajouter `onTap: () => _fillAndLogin(email, password)` sur toute la carte
- Fonction `_fillAndLogin()` :
  ```dart
  void _fillAndLogin(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
    // Option A : Connexion automatique
    _handleLogin();
    // OU Option B : Juste remplir et attendre validation manuelle
  }
  ```

**Design des cartes** :
- Padding réduit : `EdgeInsets.all(12)` (au lieu de 24)
- Border radius : `12`
- Hover effect : `elevation: 2` → `elevation: 6`
- Ripple effect Flutter au clic
- Badge coloré par rôle (Patient: bleu, Praticien: vert/teal, Manager: orange, Admin: rouge)

---

## 🎯 **Priorités Suggérées par l'IA (Après les 2 tâches ci-dessus)**

### **3️⃣ PRIORITÉ MOYENNE : Connexion au Serveur de Production**

**Objectif** : Déployer l'application Flutter Web sur le serveur de production `demo.medidesk.fr`

**Étapes** :
1. Vérifier la configuration Firebase pour l'environnement de production
2. Builder l'application Flutter : `flutter build web --release`
3. Déployer sur le serveur (méthode à déterminer : Firebase Hosting, Vercel, VPS custom)
4. Configurer le domaine `demo.medidesk.fr` (DNS, certificat SSL)
5. Tester l'authentification et toutes les fonctionnalités en production

**Fichiers de configuration à vérifier** :
- `firebase.json` (hosting config)
- `vercel.json` (si Vercel)
- `netlify.toml` (si Netlify)
- Voir `deploy.sh` et `install_vps.sh` pour scripts existants

---

### **4️⃣ PRIORITÉ MOYENNE : Amélioration de la Visite Guidée**

**Objectifs** :
- Rendre la visite guidée accessible **sans connexion préalable** (actuellement nécessite login)
- Ajouter un bouton "Lancer la visite guidée" sur la page d'accueil du site vitrine
- Permettre de relancer la visite depuis le HomeScreen (déjà implémenté : bouton "Découvrir MediDesk")

**Améliorations UX** :
- Animations plus fluides entre les étapes
- Possibilité de passer une étape (bouton "Suivant" toujours visible)
- Barre de progression (1/6, 2/6, etc.)
- Option "Ne plus afficher cette visite" (sauvegarde localStorage)

**Fichier** : `/home/user/medidesk/lib/widgets/guided_tour_v2.dart`

---

### **5️⃣ PRIORITÉ BASSE : Export PDF des Rapports**

**Objectif** : Générer des comptes-rendus professionnels en PDF (Roadmap v2.0)

**Fonctionnalités** :
- Export de la cartographie des douleurs
- Export des graphiques d'évolution
- Export de l'historique des consultations
- Export du rapport complet patient

**Package Flutter recommandé** : `pdf` (https://pub.dev/packages/pdf)

**Format** : A4, avec logo du cabinet, coordonnées, signature numérique

---

### **6️⃣ PRIORITÉ BASSE : Notifications Push**

**Objectif** : Système de rappels et alertes (Roadmap v2.0)

**Types de notifications** :
- Rappel de rendez-vous (J-1, H-2)
- Nouveaux messages praticien
- Évolution significative détectée

**Technologies** :
- Firebase Cloud Messaging (FCM) pour Web et Android
- Package Flutter : `firebase_messaging` (déjà dans pubspec.yaml)

---

### **7️⃣ PRIORITÉ BASSE : Tableaux de Bord Avancés**

**Objectif** : Analytics et KPIs pour centres de soin (Roadmap v2.0)

**Métriques à afficher** :
- Nombre de patients actifs
- Taux d'amélioration moyen par praticien
- Zones corporelles les plus traitées
- Durée moyenne des traitements
- Statistiques par praticien

**Visualisations** :
- Graphiques en radar (zones corporelles)
- Heat maps (intensité par zone)
- Timelines interactives

---

### **8️⃣ PRIORITÉ BASSE : Mode Hors-Ligne**

**Objectif** : Permettre l'utilisation de l'application sans connexion Internet

**Fonctionnalités** :
- Cache local des données patients (Hive/SharedPreferences)
- Synchronisation automatique à la reconnexion
- Indicateur de statut de connexion
- Queue de synchronisation des modifications

---

### **9️⃣ PRIORITÉ BASSE : Thème Sombre**

**Objectif** : Ajouter un mode sombre pour réduire la fatigue visuelle

**Implémentation** :
- Définir `darkTheme` dans `app_theme.dart`
- Toggle dans les paramètres utilisateur
- Sauvegarde de la préférence (SharedPreferences)
- Application automatique au démarrage

---

### **🔟 PRIORITÉ BASSE : Module de Facturation**

**Objectif** : Gestion comptable intégrée (Roadmap v2.1)

**Fonctionnalités** :
- Création de factures automatiques
- Suivi des paiements
- Export comptable (CSV, Excel)
- Télétransmission CPAM (si applicable)

**Backend** : `backend_stripe.py` (déjà présent dans `/website/`) à adapter

---

## 📂 **Structure du Projet (Rappel)**

```
/home/user/medidesk/
├── lib/                          # Code Flutter principal
│   ├── main.dart
│   ├── models/                   # Modèles de données
│   ├── providers/                # State management (Provider)
│   ├── screens/                  # Écrans de l'application
│   │   ├── auth/
│   │   │   └── login_screen.dart # ← À MODIFIER (Tâche 2)
│   │   ├── consultations/
│   │   │   └── patient_consultation_history_screen.dart
│   │   ├── pain/
│   │   │   └── professional_pain_assessment_screen.dart
│   │   └── patients/
│   ├── views/                    # Composants UI
│   ├── widgets/                  # Widgets réutilisables
│   │   └── guided_tour_v2.dart   # Visite guidée
│   ├── services/                 # Services métier
│   └── utils/                    # Utilitaires
│       └── app_theme.dart        # Thème de l'application
├── website/                      # Site vitrine ← À REFAIRE (Tâche 1)
│   ├── index.html                # Page d'accueil
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── main.js
│   ├── legal/                    # Pages légales
│   └── backend_stripe.py         # Backend paiements
├── android/                      # Configuration Android
├── web/                          # Configuration Web
├── assets/                       # Ressources (images, fonts)
├── pubspec.yaml                  # Dépendances Flutter
├── ROADMAP.md                    # Feuille de route
├── README.md                     # Documentation principale
└── firebase.json                 # Configuration Firebase
```

---

## 🛠️ **Commandes Utiles**

```bash
# Analyser le code Flutter
cd /home/user/medidesk && flutter analyze

# Builder l'application Web
cd /home/user/medidesk && flutter build web --release

# Démarrer le serveur de développement
cd /home/user/medidesk/build/web && python3 -m http.server 5060 --bind 0.0.0.0 &

# Vérifier le serveur
curl -I http://localhost:5060

# Git : Commit et push
cd /home/user/medidesk
git add -A
git commit -m "feat: Refonte site vitrine + amélioration page connexion"
git push origin base

# Tester l'URL publique
# https://5060-iuehxdwgw560d171fo2tx-5634da27.sandbox.novita.ai
```

---

## 📝 **Checklist de Validation**

Avant de considérer la session comme terminée, vérifier :

**✅ Tâche 1 - Site Vitrine** :
- [ ] Nouveau `website/index.html` créé et conforme aux specs
- [ ] CSS moderne et responsive (mobile-first)
- [ ] Toutes les sections présentes (Hero, Fonctionnalités, Tarifs, FAQ, Contact, Footer)
- [ ] SEO optimisé (meta tags, Open Graph, Schema.org)
- [ ] Performance Lighthouse > 90
- [ ] Formulaire de contact fonctionnel
- [ ] Liens vers demo.medidesk.fr testés
- [ ] Pages légales (mentions, CGU, confidentialité) accessibles

**✅ Tâche 2 - Page de Connexion** :
- [ ] Cartes de test compactes et cliquables (sans boutons copier/coller)
- [ ] Connexion automatique au clic sur une carte (ou remplissage + highlight)
- [ ] Hover effects et transitions fluides
- [ ] Responsive (desktop + mobile)
- [ ] Aucune régression sur le formulaire de connexion standard
- [ ] Build Flutter Web réussi sans erreurs
- [ ] Tests manuels des 5 comptes fonctionnels

**✅ Général** :
- [ ] Code committé sur GitHub (branche `base`)
- [ ] Serveur de développement actif et accessible
- [ ] Documentation mise à jour si nécessaire
- [ ] Rapport de session fourni (fichiers créés/modifiés, tests effectués)

---

## 🚀 **Instructions de Démarrage pour l'IA**

1. **Lire ce prompt en entier** avant de commencer
2. **Prioriser les tâches 1 et 2** (site vitrine + page connexion)
3. **Créer des TodoWrite** pour suivre la progression
4. **Demander confirmation** avant de faire des choix de design majeurs
5. **Tester chaque modification** (build + serveur web)
6. **Committer régulièrement** (au moins 1 commit par tâche majeure complétée)
7. **Fournir un rapport final** : URL de test, fichiers modifiés, screenshots (si possible)

---

## 💡 **Notes Importantes**

- **Versions verrouillées** : Flutter 3.35.4, Dart 3.9.2 - NE PAS METTRE À JOUR
- **Firebase** : Configurations dans `/opt/flutter/` - NE PAS MODIFIER
- **Android Package** : `fr.medidesk.demo` - Cohérence critique
- **Branch Git** : Toujours travailler sur `base`
- **Langue** : Interface Flutter en français, code/commentaires en anglais/français mixte acceptable

---

## 📞 **Contact & Support**

Si des questions surviennent pendant le développement :
- Vérifier `README.md`, `CONTEXT.md`, `ROADMAP.md`, `STRATEGY.md`
- Consulter les templates dans `backend/templates/flutter_sandbox/`
- Analyser le code existant pour comprendre les patterns utilisés

---

**Dernière mise à jour** : 26 Novembre 2025  
**Version du prompt** : 1.0  
**Préparé pour la session** : 27+ Novembre 2025

---

**🎯 Bon développement ! N'oublie pas de prioriser les tâches 1 et 2, puis de me proposer les priorités suivantes basées sur ROADMAP.md et l'état actuel du projet.**
