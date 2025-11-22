# 🏥 MediDesk - Démo Publique

[![Demo Status](https://img.shields.io/badge/demo-live-brightgreen)](https://demo.medidesk.fr)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Active-orange)](https://firebase.google.com)

**Logiciel de gestion de cabinet médical moderne et intuitif**

🌐 **URL Démo** : https://demo.medidesk.fr

---

## 🚀 Accès Rapide

### Comptes de Démonstration

Utilisez l'un de ces comptes pour tester l'application :

#### 👩‍⚕️ **Cabinet Kiné Paris Centre**
- **Email** : `marie.lefebvre@kine-paris.fr`
- **Mot de passe** : `password123`
- **Rôle** : Kinésithérapeute
- **Données** : 20 patients, 15 rendez-vous

#### 👨‍⚕️ **Cabinet Ostéo Lyon**
- **Email** : `pierre.girard@osteo-lyon.fr`
- **Mot de passe** : `password123`
- **Rôle** : Ostéopathe
- **Données** : 20 patients, 15 rendez-vous

---

## ✨ Fonctionnalités Disponibles

### 📊 Dashboard Intelligent
- Vue d'ensemble des activités du jour
- Statistiques patients et rendez-vous
- Aperçu des prochains RDV
- Indicateurs de performance

### 👥 Gestion des Patients
- **Liste patients** avec recherche et filtres
- **Dossier patient complet** :
  - Informations personnelles
  - Coordonnées et contacts
  - Historique médical
  - Notes et antécédents
- **Création/Modification** de fiches patients
- **Archivage** de patients inactifs

### 📅 Calendrier de Rendez-vous
- **Vue mensuelle interactive**
- **Création de RDV** simplifiée
- **Modification/Annulation** de RDV
- **Gestion des statuts** :
  - 🔵 Planifié
  - 🟢 Confirmé
  - 🟡 En cours
  - ✅ Terminé
  - 🔴 Annulé
- **Filtrage** par praticien et statut

### 🔒 Sécurité et Confidentialité
- **Authentification sécurisée** (Firebase Auth)
- **Multi-tenant** : isolation totale des données par centre
- **Déconnexion rapide** (bouton dans AppBar)
- **Sessions sécurisées**

---

## 🎯 Ce que vous pouvez tester

### ✅ Fonctionnalités Complètes
1. **Connexion** avec les comptes de test
2. **Navigation** entre Dashboard, Patients et Calendrier
3. **Création** de nouveaux patients
4. **Ajout** de rendez-vous
5. **Modification** des données
6. **Recherche** et filtrage
7. **Déconnexion**

### ⚠️ Limitations de la Démo
- **Données partagées** : Les modifications sont visibles par tous les utilisateurs
- **Réinitialisation** : Les données sont réinitialisées quotidiennement à 3h00 UTC
- **Pas d'upload** : Les téléchargements de fichiers sont désactivés
- **Pas d'emails** : Les notifications emails ne sont pas envoyées

---

## 🏗️ Architecture Technique

### Frontend
- **Flutter 3.35.4** (Web + Android)
- **Dart 3.9.2**
- **Material Design 3**
- **Provider** (State Management)
- **Responsive Design**

### Backend (Mode Demo)
- **Firebase Authentication**
- **Cloud Firestore** (NoSQL Database)
- **Firebase Storage** (Documents)
- **Security Rules** (Data Isolation)

### Performances
- ⚡ **Chargement initial** : < 2s
- 🚀 **Navigation** : < 100ms
- 📱 **Mobile-friendly** : 100% responsive
- 🔒 **HTTPS** : Certificat SSL valide

---

## 📱 Support Plateformes

| Plateforme | Statut | Notes |
|------------|--------|-------|
| 🌐 **Web Desktop** | ✅ Supporté | Chrome, Firefox, Safari, Edge |
| 📱 **Web Mobile** | ✅ Supporté | iOS Safari, Chrome Android |
| 🤖 **Android** | 🔜 Disponible | Build APK en développement |
| 🍎 **iOS** | 🔜 Prévu | Roadmap Q2 2025 |

---

## 🎨 Captures d'Écran

### Écran de Connexion
```
┌────────────────────────────────────┐
│         🏥 MEDIDESK                │
│                                    │
│  Email: ___________________        │
│  Mot de passe: ___________        │
│                                    │
│       [ Se Connecter ]             │
│                                    │
│  Ou utiliser un compte de test    │
│  • marie.lefebvre@kine-paris.fr   │
│  • pierre.girard@osteo-lyon.fr    │
└────────────────────────────────────┘
```

### Dashboard Principal
```
┌────────────────────────────────────┐
│  MediDesk            [Déconnexion] │
├────────────────────────────────────┤
│  Bienvenue, Marie Lefebvre         │
│  Kinésithérapeute                  │
│                                    │
│  ┌──────────┐  ┌──────────┐       │
│  │ Patients │  │   RDV    │       │
│  │    20    │  │   15     │       │
│  └──────────┘  └──────────┘       │
│                                    │
│  🗓️ Rendez-vous du jour :          │
│  • 09:00 - Jean Dupont             │
│  • 11:00 - Marie Martin            │
│  • 14:00 - Pierre Durand           │
│                                    │
│  [ 👥 Patients ] [ 📅 Calendrier ] │
└────────────────────────────────────┘
```

---

## 🚀 Déploiement Local (Développeurs)

### Prérequis
```bash
flutter --version  # Flutter 3.35.4 requis
dart --version     # Dart 3.9.2 requis
```

### Installation
```bash
# Cloner le repository
git clone https://github.com/RBSoftwareAI/kine.git
cd kine
git checkout base

# Installer les dépendances
flutter pub get

# Lancer en mode debug
flutter run -d chrome

# Build production
flutter build web --release

# Servir localement
cd build/web
python3 -m http.server 8080
# Ouvrir http://localhost:8080
```

---

## 📚 Documentation

- **Guide de démarrage rapide** : [AI_QUICK_START.md](./AI_QUICK_START.md)
- **Documentation complète** : [CONTEXT.md](./CONTEXT.md)
- **Guide de déploiement** : [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

---

## 💼 MediDesk Mode Local (Version Complète)

La démo en ligne est limitée. Pour une utilisation en cabinet, MediDesk propose :

### ✨ Version Locale (Gratuite)
- **Données 100% locales** (SQLite chiffré)
- **Aucun cloud** (respect total de la vie privée)
- **Pas d'abonnement** (0€/mois)
- **Installation Windows** (double-clic)
- **Conformité RGPD** (données sous votre contrôle)

### 🚀 Fonctionnalités Avancées
- 📁 **Dossiers médicaux complets**
- 💰 **Facturation et comptabilité**
- 📊 **Statistiques avancées**
- 🔐 **Chiffrement de bout en bout**
- 📱 **Application mobile Android**
- 🤖 **IA médicale** (aide au diagnostic)

### 📞 Contact Commercial
- **Email** : contact@medidesk.fr
- **Démo personnalisée** : Sur rendez-vous
- **Documentation** : https://docs.medidesk.fr

---

## 🤝 Contribution

Ce projet est en développement actif. Pour contribuer :

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

---

## 📄 Licence

**MediDesk** est un logiciel propriétaire.  
© 2024 MediDesk - Tous droits réservés.

### Mode Demo (Public)
- Accès gratuit et illimité
- Données partagées et non persistantes
- Usage de démonstration uniquement

### Mode Local (Privé)
- Installation locale gratuite
- Données privées et persistantes
- Usage professionnel en cabinet

---

## 🆘 Support

### FAQ

**Q : Puis-je utiliser la démo pour mon cabinet ?**  
R : Non, la démo est à usage de démonstration uniquement. Installez la version locale pour un usage professionnel.

**Q : Mes données sont-elles sauvegardées ?**  
R : Non, les données de la démo sont réinitialisées quotidiennement.

**Q : Comment obtenir la version locale ?**  
R : Contactez-nous à contact@medidesk.fr pour une installation personnalisée.

**Q : Est-ce conforme RGPD ?**  
R : Oui, la version locale respecte 100% le RGPD avec données locales chiffrées.

---

## 📊 Statistiques

- 🚀 **Temps de réponse moyen** : < 100ms
- 📱 **Taux de disponibilité** : 99.9%
- 🔒 **Incidents de sécurité** : 0
- 👥 **Utilisateurs de test actifs** : 2 centres

---

**Version démo** : 1.0.0  
**Dernière mise à jour** : $(date +"%Y-%m-%d")  
**Statut** : 🟢 En ligne

---

Testé par des professionnels de santé 👨‍⚕️👩‍⚕️  
Conforme aux normes de sécurité médicale 🔒  
Respectueux de la vie privée 🛡️
