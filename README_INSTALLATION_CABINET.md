# 🏥 KinéCare - Installation Cabinet de Kinésithérapie

> **Solution 100% locale - Zéro coût - Données sécurisées**

---

## 🎯 Qu'est-ce que KinéCare ?

KinéCare est une application de suivi des douleurs pour cabinets de kinésithérapie et coachs APA.

**✅ Ce que vous obtenez :**
- Suivi des zones de douleur sur silhouettes anatomiques
- Historique complet des séances
- Graphiques d'évolution des douleurs
- Statistiques par pathologie avec temps de guérison
- Traçabilité RGPD complète (qui a modifié quoi et quand)
- Accès multi-appareils (PC + smartphones + tablettes)

**💰 Coût : 0€**
- Pas d'hébergement cloud
- Pas d'abonnement
- Pas de certification HDS nécessaire
- Données 100% locales (jamais sur Internet)

---

## 🚀 Installation Ultra-Rapide (< 5 minutes)

### Étape 1 : Télécharger l'application

**Lien GitHub :** https://github.com/RBSoftwareAI/kine

Cliquez sur **"Code"** → **"Download ZIP"**  
Extraire dans un dossier (ex: `C:\KinéCare`)

### Étape 2 : Installer Python

Si pas déjà installé :
- **Windows :** https://www.python.org/downloads/ (cocher "Add to PATH")
- **Mac :** Préinstallé
- **Linux :** `sudo apt install python3 python3-pip`

### Étape 3 : Installer les dépendances

Ouvrir un terminal dans le dossier KinéCare :

```bash
pip install -r backend/requirements.txt
```

**⏱️ Temps : 1-2 minutes**

### Étape 4 : Générer des données de test (optionnel)

```bash
python3 backend/utils/generate_demo_data.py
```

Cela créera 15 patients, 3 kinés, 2 coachs et 100+ séances pour tester.

### Étape 5 : Démarrer le serveur

```bash
python3 backend/start_server.py
```

**Vous verrez :**
```
🏥 KinéCare Local Server Started
===============================================================

✅ Database: /path/to/data/kinecare.db
✅ API Endpoints: http://localhost:8080/api/
✅ Flutter Web: http://localhost:8080/

📱 Access from other devices on LAN:
   http://192.168.1.25:8080/

===============================================================
```

### Étape 6 : Ouvrir l'application

**Sur ce PC :**  
Ouvrir navigateur → `http://localhost:8080/`

**Sur autres appareils (même Wi-Fi) :**  
Noter l'IP affichée (ex: `192.168.1.25`)  
Ouvrir navigateur → `http://192.168.1.25:8080/`

---

## 🔑 Comptes de Démonstration

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Administrateur** | admin@kinecare.local | admin123 |
| **Kinésithérapeute** | marie.dubois@kinecare.demo | demo123 |
| **Coach APA** | pierre.leroy@kinecare.demo | demo123 |
| **Patient** | jean.dupont@email.demo | demo123 |

**⚠️ À faire après installation :**
1. Créer vos vrais comptes professionnels
2. Supprimer les comptes de démonstration

---

## 📱 Accès Smartphones & Tablettes

### iOS (iPhone / iPad)

1. Ouvrir Safari
2. Aller sur `http://192.168.x.x:8080/`
3. Appuyer sur le bouton **Partager** (carré avec flèche)
4. Choisir **"Sur l'écran d'accueil"**
5. L'icône KinéCare apparaît comme une app native !

### Android

1. Ouvrir Chrome
2. Aller sur `http://192.168.x.x:8080/`
3. Menu (⋮) → **"Installer l'application"**
4. L'app apparaît dans le lanceur

**💡 Astuce :** Une fois installée, l'app fonctionne comme une application native (plein écran, pas de barre d'URL).

---

## 📊 Fonctionnalités Incluses

### Pour les Kinésithérapeutes & Coachs

✅ **Tableau de bord :**
- Vue d'ensemble patients actifs
- Séances du jour
- Statistiques temps réel

✅ **Suivi des douleurs :**
- Silhouettes anatomiques interactives (18 zones)
- Échelle 0-10 pour chaque zone
- Comparaison avant/après séance
- Historique complet

✅ **Graphiques d'évolution :**
- Courbes intensité sur 7j, 30j, 3m, 6m, 1 an
- Points de sessions (avant/après)
- Tendance amélioration
- Zones les plus touchées

✅ **Statistiques par pathologie :**
- Temps moyen amélioration 30% / 50%
- Temps moyen guérison (< 2/10)
- Taux de succès
- Distribution zones affectées

✅ **Traçabilité RGPD :**
- Qui a modifié quoi et quand
- Logs conservés 3 ans
- Accès consultation historique

### Pour les Patients

✅ **Consultation :**
- Voir ses propres douleurs
- Graphiques d'évolution
- Historique séances
- Prochains rendez-vous

---

## 🔒 Sécurité & Conformité

### Données 100% Locales

| ✅ Avantage | Description |
|-------------|-------------|
| **Zéro Internet** | Données santé jamais transmises sur Internet |
| **Maîtrise totale** | Vous contrôlez physiquement les données |
| **Pas de piratage cloud** | Impossible d'accéder depuis l'extérieur |
| **Conformité RGPD** | Traçabilité complète + droit à l'oubli |

### Pas Besoin Certification HDS

**Pourquoi ?**  
L'hébergement de données de santé (HDS) est obligatoire uniquement pour les données hébergées sur Internet.

**Données locales = Pas d'hébergeur tiers = Pas besoin HDS**

**💰 Économie :** 1 200 à 2 400€/an de certification + hébergement

---

## 💾 Sauvegardes Automatiques

### Où sont les données ?

```
KinéCare/
├── data/
│   ├── kinecare.db          ← Base de données principale
│   └── backups/             ← Sauvegardes automatiques
│       ├── kinecare_backup_20250115_120000.db
│       ├── kinecare_backup_20250108_120000.db
│       └── ...
```

### Sauvegarde Manuelle

```bash
python3 -c "from backend.database.db_manager import get_db; get_db().backup_database()"
```

### Restauration

1. Arrêter le serveur (Ctrl+C)
2. Remplacer `data/kinecare.db` par le fichier de sauvegarde
3. Redémarrer : `python3 backend/start_server.py`

**💡 Recommandation :** Copier le dossier `data/backups/` sur clé USB chaque semaine.

---

## 🌐 Configuration Réseau

### Réseau Wi-Fi Recommandé

**✅ Bonnes pratiques :**
- Wi-Fi sécurisé WPA2 ou WPA3
- Mot de passe fort
- Réseau séparé du Wi-Fi visiteurs/patients

**⚠️ À éviter :**
- Wi-Fi public non sécurisé
- Partage mot de passe Wi-Fi avec patients

### Trouver l'Adresse IP du PC Serveur

**Windows :**
```bash
ipconfig
```
Chercher "Adresse IPv4" dans la section Wi-Fi

**Mac :**
```bash
ifconfig | grep "inet "
```

**Linux :**
```bash
hostname -I
```

**L'IP ressemble à :** `192.168.1.25` ou `10.0.0.15`

---

## 🔧 Dépannage

### Le serveur ne démarre pas

**Erreur : "Port 8080 already in use"**

Solution : Changer le port
```bash
# Linux/Mac
export PORT=3000
python3 backend/start_server.py

# Windows
set PORT=3000
python3 backend/start_server.py
```

### Impossible d'accéder depuis smartphone

**1. Vérifier que tous les appareils sont sur le même Wi-Fi**

**2. Vérifier le pare-feu du PC :**
- Windows : Autoriser Python dans le pare-feu
- Mac : Préférences Système → Sécurité → Pare-feu
- Linux : `sudo ufw allow 8080/tcp`

**3. Vérifier l'IP du serveur :**
L'IP a peut-être changé (DHCP automatique).  
Refaire : `ipconfig` (Windows) ou `hostname -I` (Linux/Mac)

### Données perdues

**Cause probable :** Fermeture brutale du PC (coupure électricité, crash)

**Solution :** Restaurer depuis sauvegarde (voir section Sauvegardes)

**Prévention :** Toujours arrêter le serveur proprement (Ctrl+C)

---

## 📈 Statistiques Temps de Guérison

### Comment ça marche ?

Le système calcule automatiquement pour chaque pathologie :

✅ **Temps amélioration 30%** : Combien de jours en moyenne pour atteindre 30% d'amélioration  
✅ **Temps amélioration 50%** : Combien de jours pour 50% d'amélioration  
✅ **Temps guérison** : Combien de jours pour descendre sous 2/10  
✅ **Taux de succès** : % de patients atteignant ces objectifs  

**Exemple :**
```
Lombalgie chronique:
- Temps moyen amélioration 30% : 18 jours
- Temps moyen guérison : 42 jours
- Taux de succès : 85%
- Zones affectées : Bas du dos (85%), Bassin (15%)
```

**📊 Utilité :**
- Orienter les patients vers la bonne spécialisation
- Évaluer l'efficacité des traitements
- Comparer avec les standards du cabinet

**🔒 Confidentialité :**
- Statistiques calculées uniquement si >= 5 patients (k-anonymat)
- Pas d'identification possible des patients individuels

---

## 📞 Support & Documentation

### Documentation Complète

📄 **Installation détaillée :** [docs/INSTALLATION_LOCALE.md](docs/INSTALLATION_LOCALE.md)  
🏗️ **Architecture technique :** [docs/ARCHITECTURE_HYBRIDE.md](docs/ARCHITECTURE_HYBRIDE.md)  
📋 **Test pilote :** [docs/test_pilot/PROTOCOLE_TEST_PILOTE.md](docs/test_pilot/PROTOCOLE_TEST_PILOTE.md)  
⚖️ **RGPD :** [docs/rgpd/REGISTRE_TRAITEMENTS_RGPD.md](docs/rgpd/REGISTRE_TRAITEMENTS_RGPD.md)  

### GitHub

**Dépôt :** https://github.com/RBSoftwareAI/kine  
**Issues :** https://github.com/RBSoftwareAI/kine/issues

---

## ✅ Checklist Post-Installation

- [ ] Serveur démarre correctement
- [ ] Connexion depuis PC principal OK
- [ ] Connexion depuis smartphone OK
- [ ] Comptes de démonstration testés
- [ ] Comptes professionnels réels créés
- [ ] Comptes demo supprimés
- [ ] Sauvegarde testée
- [ ] Personnel formé navigation de base
- [ ] IP du serveur notée et partagée
- [ ] Planification sauvegarde hebdomadaire

---

## 🚀 Prochaines Étapes

### Semaine 1 : Test & Formation

- Tester l'application avec quelques patients volontaires
- Former les kinés et coachs
- Ajuster les workflows si nécessaire

### Semaine 2-4 : Déploiement Progressif

- Intégrer progressivement tous les patients
- Collecter les retours d'expérience
- Affiner l'utilisation

### Mois 2-6 : Utilisation Normale

- Utilisation quotidienne
- Génération premières statistiques
- Évaluation amélioration prise en charge

### Si Besoin : Migration Cloud (Optionnel)

Si vous souhaitez ultérieurement :
- Partager données entre plusieurs cabinets
- Accès distant sécurisé
- Synchronisation multi-sites

→ Plan migration OVHcloud HDS disponible : [docs/migration/PLAN_MIGRATION_HDS.md](docs/migration/PLAN_MIGRATION_HDS.md)  
**Coût estimé :** 100-200€/mois + migration 13 semaines

---

## 🎉 Félicitations !

Votre cabinet est maintenant équipé d'un système moderne de suivi des douleurs, **sans coût**, **sans risque cloud**, et **conforme RGPD**.

**Questions ? Problèmes ?**  
→ Ouvrir une issue GitHub : https://github.com/RBSoftwareAI/kine/issues

---

**Version :** 1.0.0  
**Date :** 2025-01-15  
**Licence :** MIT (libre utilisation)
