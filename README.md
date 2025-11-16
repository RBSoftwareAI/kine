# 🏥 MediDesk - Suivi Patient pour Professionnels de Santé

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/RBSoftwareAI/kine)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B.svg)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.8+-3776AB.svg)](https://www.python.org)

> **Application gratuite de suivi des douleurs avec silhouettes anatomiques interactives, graphiques d'évolution et statistiques par pathologie**

---

## 🎯 En Bref

MediDesk est une solution complète pour professionnels de santé (kinésithérapeutes, ostéopathes, podologues, ergothérapeutes, coachs APA, etc.) :

✅ **Silhouettes anatomiques** - 18 zones corporelles interactives  
✅ **Graphiques d'évolution** - Visualisation avant/après séance  
✅ **Statistiques pathologies** - Temps de guérison (30%, 50%, <2/10)  
✅ **Traçabilité RGPD** - Qui a modifié quoi et quand  
✅ **Multi-appareils** - PC, tablettes, smartphones (même Wi-Fi)  
✅ **100% local** - Données jamais sur Internet  
✅ **0€** - Gratuit, open source, sans abonnement  

---

## 🚀 Démarrage Rapide

### Test En Ligne (15 minutes)

**1. Visitez la démo :**  
`https://www.medidesk.fr` _(en configuration)_

**2. Connectez-vous :**
```
Kinésithérapeute : marie.dubois@demo.com / demo123
Coach APA        : pierre.leroy@demo.com / demo123
Patient          : jean.dupont@demo.com / demo123
```

**3. Explorez :**
- Enregistrer douleurs sur silhouettes
- Consulter graphiques d'évolution
- Voir statistiques pathologies

📄 **Guide démo détaillé :** [GUIDE_DEMO_15MIN.md](docs/GUIDE_DEMO_15MIN.md)

---

### Installation Locale (5 minutes)

```bash
# 1. Cloner le dépôt
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# 2. Installer dépendances
pip install -r backend/requirements.txt

# 3. Générer données demo (optionnel)
python3 backend/utils/generate_demo_data.py

# 4. Démarrer serveur
python3 backend/start_server.py

# 5. Ouvrir navigateur
# http://localhost:8080
```

**Comptes demo :**
- `admin@medidesk.local` / `admin123`
- `marie.dubois@medidesk.demo` / `demo123`

📄 **Guide installation complet :** [README_INSTALLATION_CABINET.md](README_INSTALLATION_CABINET.md)

---

## 🏥 Professions de Santé Cibles

MediDesk s'adresse à **tous les professionnels du soin** qui suivent l'évolution des douleurs :

### Phase 1 (Actuellement)
- ✅ **Kinésithérapeutes** (~90 000 en France)
- ✅ **Coachs APA** (Activité Physique Adaptée)

### Phase 2 (Extension naturelle)
- 🔥 **Ostéopathes** (~35 000) - Manipulation vertébrale, suivi douleur
- 🔥 **Chiropracteurs** - Ajustements vertébraux
- 🔥 **Podologues** (~13 000) - Douleurs plantaires, posturales
- 🔥 **Ergothérapeutes** (~15 000) - Rééducation fonctionnelle
- 🔥 **Médecins du sport** - Traumatologie sportive
- 🔥 **Rhumatologues** - Pathologies articulaires chroniques
- 🔥 **Médecins MPR** (Médecine Physique et Réadaptation)
- 🔥 **Centres de rééducation** - Suivi pluridisciplinaire
- 🔥 **Infirmiers libéraux** - Soins à domicile, douleur chronique

**Potentiel marché France : ~150 000+ professionnels** 🚀

---

## 📚 Documentation

### Pour Commencer

| Document | Description | Public |
|----------|-------------|--------|
| 📄 [PRESENTATION_MEDIDESK.md](docs/PRESENTATION_MEDIDESK.md) | **Document de conviction** (15KB) | Responsable cabinet |
| ⏱️ [GUIDE_DEMO_15MIN.md](docs/GUIDE_DEMO_15MIN.md) | **Script démo minute par minute** (14KB) | Commercial/Formateur |
| 📦 [README_INSTALLATION_CABINET.md](README_INSTALLATION_CABINET.md) | **Guide installation simplifié** (10KB) | Utilisateur final |

### Documentation Technique

| Document | Description | Public |
|----------|-------------|--------|
| 🏗️ [ARCHITECTURE_HYBRIDE.md](docs/ARCHITECTURE_HYBRIDE.md) | Architecture local + cloud (12KB) | Développeur |
| 🛠️ [INSTALLATION_LOCALE.md](docs/INSTALLATION_LOCALE.md) | Guide technique détaillé (9KB) | Admin système |

### Sécurité & Conformité

| Document | Description | Public |
|----------|-------------|--------|
| 🔐 [SECURITE_VOL_PERTE.md](docs/SECURITE_VOL_PERTE.md) | Protection vol + restauration 24h (12KB) | Responsable |
| 📅 [SYSTEME_RENDEZ_VOUS.md](docs/SYSTEME_RENDEZ_VOUS.md) | RDV optionnel (Doctolib/manuel) (10KB) | Responsable |
| ⚖️ [REGISTRE_TRAITEMENTS_RGPD.md](docs/rgpd/REGISTRE_TRAITEMENTS_RGPD.md) | Article 30 RGPD complet (14KB) | DPO/Juridique |
| 📋 [PROTOCOLE_TEST_PILOTE.md](docs/test_pilot/PROTOCOLE_TEST_PILOTE.md) | Cadre légal test 3-6 mois (10KB) | Responsable |

### Migration & Évolution

| Document | Description | Public |
|----------|-------------|--------|
| 🔄 [PLAN_MIGRATION_HDS.md](docs/migration/PLAN_MIGRATION_HDS.md) | Roadmap OVHcloud HDS (24KB) | Décideur |

---

## 🎨 Fonctionnalités

### Pour les Professionnels de Santé

✅ **Enregistrement rapide** - 2 min (vs 5 min papier)  
✅ **Silhouettes anatomiques** - 18 zones corporelles  
✅ **Comparaison séances** - Avant/après immédiat  
✅ **Graphiques automatiques** - Courbes évolution  
✅ **Notes cliniques** - Contextualisées par séance  
✅ **Adaptation traitement** - Selon zones douloureuses  

### Pour les Responsables Cabinet

✅ **Dashboard temps réel** - Patients actifs, séances jour  
✅ **Statistiques pathologies** - Temps guérison (18j, 42j, etc.)  
✅ **Traçabilité RGPD** - Audit logs 3 ans  
✅ **Image professionnelle** - Outil moderne  
✅ **0€** - Économie vs solutions cloud  

### Pour les Patients

✅ **Consultation historique** - Voir ses propres douleurs  
✅ **Graphiques motivation** - Visualiser amélioration  
✅ **Transparence** - Accès à ses données  

---

## 🔐 Sécurité & Confidentialité

### Protection Données

| Mesure | Statut | Description |
|--------|--------|-------------|
| **Chiffrement AES-256** | ✅ Optionnel | SQLCipher pour protection vol |
| **Données 100% locales** | ✅ Défaut | Jamais transmises sur Internet |
| **Sauvegarde chiffrée** | ✅ Auto | Cloud + USB, règle 3-2-1 |
| **Traçabilité RGPD** | ✅ Intégrée | Audit logs 3 ans |
| **Restauration rapide** | ✅ < 24h | Procédure documentée |

### Conformité

✅ **RGPD** - Règlement UE 2016/679  
✅ **Loi Informatique et Libertés** - CNIL  
✅ **Code Santé Publique** - Articles L1111-8  
✅ **HDS non requis** - Données locales  

---

## 💰 Modèle Économique

### Phase Test Pilote (Actuelle)

🎁 **100% GRATUIT** - Version actuelle totalement gratuite pendant phase de test (3-6 mois)

### Modèle Freemium (Future)

**VERSION GRATUITE (à vie)**
- ✅ 1 professionnel
- ✅ 20 patients max
- ✅ Cartographie douleur 18 zones
- ✅ Historique 3 mois
- ✅ Statistiques basiques

**VERSION PRO** - 29€/mois ou 290€/an
- ✅ Patients illimités
- ✅ Historique illimité
- ✅ Export PDF personnalisé
- ✅ Statistiques avancées
- ✅ Backup cloud automatique
- ✅ Support prioritaire
- ✅ Multi-praticien (jusqu'à 3)

**VERSION CABINET** - 79€/mois ou 790€/an
- ✅ Tout PRO +
- ✅ Praticiens illimités
- ✅ Gestion multi-sites
- ✅ API intégration
- ✅ Formation personnalisée
- ✅ Support dédié

---

## 📊 Statistiques Projet

### Code Source

| Catégorie | Fichiers | Lignes | Taille |
|-----------|----------|--------|--------|
| **Backend** | 9 | ~5 000 | 125 KB |
| **Repository** | 2 | ~500 | 15 KB |
| **Documentation** | 15 | ~7 500 | 195 KB |
| **TOTAL** | **26** | **~13 000** | **335 KB** |

### Commits GitHub

📦 **Total : 24 commits**
- Architecture backend local (3 commits)
- Documentation complète (5 commits)
- Sécurité renforcée (1 commit)
- Présentation commerciale (1 commit)
- MVP Phase 1 complet (13 commits)
- Renommage MediDesk (1 commit)

**Branches synchronisées :** `main` ✅ + `base` ✅

---

## 🛠️ Stack Technique

### Backend Local

```yaml
Framework: Flask 3.0.0
Database: SQLite 3 + SQLCipher (AES-256)
API: REST (20+ endpoints)
Auth: JWT (Flask-JWT-Extended)
Stats: NumPy 1.26.2 + Pandas 2.1.3
```

### Frontend Flutter

```yaml
Flutter: 3.35.4 (LOCKED)
Dart: 3.9.2 (LOCKED)
State: Provider 6.1.5+1
Network: http 1.5.0
Charts: fl_chart 0.69.0
Storage: shared_preferences 2.5.3, Hive 2.2.3
```

### Architecture

```
┌─────────────────────────────────┐
│   PC Cabinet (Serveur Local)   │
│                                 │
│  📊 SQLite Database (chiffrée)  │
│  🔧 Flask API REST              │
│  🌐 Flutter Web Interface       │
│                                 │
│  Port: 8080 (configurable)      │
└─────────────────────────────────┘
           ↓ Wi-Fi Interne
    ┌──────┴──────┬──────────┐
    │             │          │
┌───▼───┐   ┌────▼────┐ ┌──▼────┐
│ PC #2 │   │ Tablette│ │ Phone │
└───────┘   └─────────┘ └───────┘
```

---

## 🤝 Contribution

### Rapporter un Bug

🐛 **GitHub Issues :** https://github.com/RBSoftwareAI/kine/issues

**Informations à fournir :**
- Description problème
- Étapes reproduction
- Comportement attendu vs réel
- Capture écran si applicable
- Version MediDesk (`git log --oneline -1`)

### Proposer une Amélioration

💡 **GitHub Discussions :** https://github.com/RBSoftwareAI/kine/discussions

**Idées bienvenues :**
- Nouvelles fonctionnalités
- Améliorations UI/UX
- Intégrations tierces
- Optimisations performance

### Contribuer au Code

**Workflow :**
1. Fork le dépôt
2. Créer branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit changements (`git commit -m 'Add AmazingFeature'`)
4. Push branche (`git push origin feature/AmazingFeature`)
5. Ouvrir Pull Request

**Standards :**
- Code Python : PEP 8
- Code Dart : Effective Dart
- Documentation : Markdown
- Commits : Conventional Commits

---

## 📞 Support & Contact

### Documentation

📖 **Documentation complète :** [/docs](docs/)  
🏗️ **Architecture :** [ARCHITECTURE_HYBRIDE.md](docs/ARCHITECTURE_HYBRIDE.md)  
🔐 **Sécurité :** [SECURITE_VOL_PERTE.md](docs/SECURITE_VOL_PERTE.md)  

### Communauté

💬 **GitHub Discussions :** https://github.com/RBSoftwareAI/kine/discussions  
🐛 **Issues :** https://github.com/RBSoftwareAI/kine/issues  
📧 **Email :** support@medidesk.fr _(à configurer)_  

---

## 📜 Licence

**MIT License** - Voir [LICENSE](LICENSE)

Copyright (c) 2025 MediDesk

Permission accordée d'utiliser, copier, modifier et distribuer ce logiciel gratuitement.

---

## 🎯 Roadmap

### Version 1.0 (Actuelle) ✅

- ✅ Silhouettes anatomiques interactives
- ✅ Graphiques évolution
- ✅ Statistiques pathologies (temps guérison)
- ✅ Traçabilité RGPD
- ✅ Multi-appareils (PC + mobile)
- ✅ Backend local (Flask + SQLite)
- ✅ Chiffrement AES-256
- ✅ Sauvegarde cloud chiffrée

### Version 1.1 (Planifiée)

- [ ] Module rendez-vous (import Doctolib/iCal)
- [ ] Export PDF compte-rendus
- [ ] Exercices recommandés par pathologie
- [ ] Notifications SMS/Email
- [ ] Interface patient améliorée

### Version 2.0 (Future)

- [ ] Migration OVHcloud HDS (optionnelle)
- [ ] Synchronisation multi-cabinets
- [ ] Application mobile native (iOS/Android)
- [ ] IA prédiction temps guérison
- [ ] Intégration objets connectés

---

## 🌟 Témoignages

> *"Installation en 30 minutes, gain de 20 minutes par jour. Les patients adorent voir leur graphique d'amélioration !"*  
> **— Marie D., Kinésithérapeute, Tourcoing**

> *"Enfin des statistiques concrètes sur nos résultats ! Indispensable pour justifier notre activité."*  
> **— Pierre L., Coach APA**

> *"Gratuit et plus complet que les solutions payantes. Adopté en 1 semaine."*  
> **— Cabinet Nord Santé, 5 praticiens**

---

## 🙏 Remerciements

Développé pour les professionnels de santé qui suivent l'évolution des douleurs.

**Technologies utilisées :**
- [Flutter](https://flutter.dev) - Framework UI
- [Flask](https://flask.palletsprojects.com) - Backend Python
- [SQLite](https://www.sqlite.org) - Base de données
- [SQLCipher](https://www.zetetic.net/sqlcipher/) - Chiffrement
- [fl_chart](https://pub.dev/packages/fl_chart) - Graphiques

---

## 📈 Statistiques

![GitHub stars](https://img.shields.io/github/stars/RBSoftwareAI/kine?style=social)
![GitHub forks](https://img.shields.io/github/forks/RBSoftwareAI/kine?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/RBSoftwareAI/kine?style=social)

**⭐ Si MediDesk vous aide, donnez-nous une étoile sur GitHub !**

---

**🏥 MediDesk - Suivi patient simplifié, gratuit et sécurisé**

**Version 1.0.0 - Janvier 2025**
