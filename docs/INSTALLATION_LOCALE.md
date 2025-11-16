# 📦 Installation MediDesk - Serveur Local

## 🎯 Objectif

Installer MediDesk sur un PC dans la salle de soin avec accès depuis d'autres appareils sur le réseau local (PC, tablettes, smartphones).

---

## ✅ Avantages de cette solution

| Avantage | Description |
|----------|-------------|
| **💰 Coût zéro** | Pas d'hébergement cloud, pas d'abonnement HDS |
| **🔒 Sécurité maximale** | Données santé jamais sur Internet |
| **⚡ Performance** | Accès instantané réseau local |
| **📱 Multi-appareils** | PC + smartphones + tablettes sur même Wi-Fi |
| **⚖️ Conformité RGPD** | Maîtrise totale des données |

---

## 📋 Prérequis

### Matériel

- **PC principal** (Windows 10/11, macOS, ou Linux)
  - RAM: 4 GB minimum
  - Espace disque: 500 MB minimum
  - Réseau: Connexion Wi-Fi ou Ethernet

- **Réseau Wi-Fi interne** (recommandé)
  - Sécurisé WPA2/WPA3
  - Séparé du Wi-Fi visiteurs

### Logiciels

- **Python 3.8+** (gratuit)
  - Windows: https://www.python.org/downloads/
  - macOS: Préinstallé ou via `brew install python3`
  - Linux: `sudo apt install python3 python3-pip`

- **Navigateur Web moderne**
  - Chrome, Firefox, Safari, ou Edge

---

## 🚀 Installation Rapide (< 5 minutes)

### Étape 1: Télécharger MediDesk

**Option A: Depuis GitHub**
```bash
git clone https://github.com/RBSoftwareAI/kine.git
cd kine
```

**Option B: Depuis archive ZIP**
1. Télécharger: https://github.com/RBSoftwareAI/kine/archive/main.zip
2. Extraire dans un dossier (ex: `C:\MediDesk` ou `~/MediDesk`)
3. Ouvrir un terminal dans ce dossier

### Étape 2: Installer les dépendances

```bash
# Installer les packages Python requis
pip install -r backend/requirements.txt
```

**⏱️ Temps: 1-2 minutes**

### Étape 3: Générer des données de démonstration (optionnel)

```bash
# Créer des patients et séances de test
python3 backend/utils/generate_demo_data.py
```

**Cela créera:**
- 15 patients
- 3 kinésithérapeutes
- 2 coachs APA
- 50+ séances
- 200+ points de douleur

### Étape 4: Démarrer le serveur

```bash
# Lancer le serveur local
python3 backend/start_server.py
```

**Vous verrez:**
```
🏥 MediDesk Local Server Started
===============================================================

✅ Database: /path/to/data/medidesk.db
✅ API Endpoints: http://localhost:8080/api/
✅ Flutter Web: http://localhost:8080/

📱 Access from other devices on LAN:
   http://192.168.x.x:8080/

===============================================================
Press Ctrl+C to stop server
```

### Étape 5: Accéder à l'application

**Sur le PC principal:**
- Ouvrir un navigateur
- Aller sur: `http://localhost:8080/`

**Sur d'autres appareils (même Wi-Fi):**
- Noter l'adresse IP affichée (ex: `192.168.1.25`)
- Ouvrir un navigateur
- Aller sur: `http://192.168.1.25:8080/`

---

## 🔑 Comptes de Démonstration

Si vous avez généré les données de démonstration:

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Administrateur** | admin@medidesk.local | admin123 |
| **Kinésithérapeute** | marie.dubois@medidesk.demo | demo123 |
| **Coach APA** | pierre.leroy@medidesk.demo | demo123 |
| **Patient** | jean.dupont@email.demo | demo123 |

---

## 📱 Configuration Multi-Appareils

### PC Secondaires

1. Ouvrir un navigateur
2. Aller sur `http://<IP_PC_PRINCIPAL>:8080/`
3. Se connecter avec un compte kiné/coach
4. **Ajouter aux favoris** pour accès rapide

### Smartphones / Tablettes

1. Connecter au même Wi-Fi que le PC principal
2. Ouvrir Safari / Chrome
3. Aller sur `http://<IP_PC_PRINCIPAL>:8080/`
4. **Ajouter à l'écran d'accueil** (iOS) ou **Installer l'application** (Android)

**Sur iOS (iPhone/iPad):**
1. Appuyer sur le bouton **Partager** (carré avec flèche)
2. Choisir **Sur l'écran d'accueil**
3. L'icône MediDesk apparaît comme une app native

**Sur Android:**
1. Menu → **Installer l'application**
2. L'application apparaît dans le lanceur

---

## 🔧 Configuration Avancée

### Changer le Port (optionnel)

Par défaut, le serveur écoute sur le port 8080. Pour changer:

```bash
# Linux/macOS
export PORT=3000
python3 backend/start_server.py

# Windows
set PORT=3000
python3 backend/start_server.py
```

### Activer le Mode Debug (développement)

```bash
# Linux/macOS
export DEBUG=true
python3 backend/start_server.py

# Windows
set DEBUG=true
python3 backend/start_server.py
```

### Trouver l'Adresse IP du PC

**Windows:**
```bash
ipconfig
# Chercher "Adresse IPv4" dans la section Wi-Fi ou Ethernet
```

**macOS:**
```bash
ifconfig | grep "inet "
# ou
ipconfig getifaddr en0
```

**Linux:**
```bash
hostname -I
# ou
ip addr show
```

---

## 💾 Sauvegarde des Données

### Sauvegarde Automatique

Le système crée automatiquement des sauvegardes hebdomadaires dans:
- `data/backups/medidesk_backup_YYYYMMDD_HHMMSS.db`

### Sauvegarde Manuelle

**Via API (depuis n'importe quel navigateur connecté):**
```
POST http://localhost:8080/api/db/backup
```

**Via Script:**
```bash
python3 -c "from backend.database.db_manager import get_db; get_db().backup_database()"
```

### Restauration depuis Sauvegarde

1. Arrêter le serveur (Ctrl+C)
2. Remplacer `data/medidesk.db` par le fichier de sauvegarde
3. Redémarrer le serveur

---

## 🛡️ Sécurité

### Recommandations

1. **Réseau Wi-Fi sécurisé**
   - Utiliser WPA2 ou WPA3
   - Mot de passe fort
   - Réseau séparé pour le personnel (pas le Wi-Fi visiteurs)

2. **Accès physique**
   - Verrouiller le PC principal quand absent
   - Session Windows/macOS avec mot de passe

3. **Sauvegardes régulières**
   - Copier `data/backups/` sur clé USB hebdomadaire
   - Conserver 3 sauvegardes minimum

4. **Mots de passe**
   - Changer les mots de passe de démonstration
   - Utiliser des mots de passe forts pour les comptes réels

### Changer un Mot de Passe

```bash
# TODO: Script à créer pour changer les mots de passe
python3 backend/utils/change_password.py <email>
```

---

## 🔍 Dépannage

### Le serveur ne démarre pas

**Erreur: "Port 8080 already in use"**
- Un autre programme utilise le port 8080
- Solution: Changer le port (voir Configuration Avancée)

**Erreur: "Module not found"**
- Les dépendances ne sont pas installées
- Solution: `pip install -r backend/requirements.txt`

### Impossible d'accéder depuis un autre appareil

1. **Vérifier le pare-feu**
   - Windows: Autoriser Python dans le pare-feu
   - macOS: Préférences Système → Sécurité → Pare-feu
   - Linux: `sudo ufw allow 8080/tcp`

2. **Vérifier le réseau**
   - Tous les appareils sur le même Wi-Fi ?
   - Ping entre appareils fonctionne ?

3. **Vérifier l'adresse IP**
   - L'IP a peut-être changé (DHCP)
   - Refaire Étape "Trouver l'Adresse IP du PC"

### Données non sauvegardées

- **Cause probable:** Base de données corrompue
- **Solution:** Restaurer depuis sauvegarde
- **Prévention:** Arrêter proprement le serveur (Ctrl+C, pas fermeture brutale)

---

## 📊 Statistiques et Performances

### Capacité

- **Patients:** 1000+ sans ralentissement
- **Points de douleur:** 10000+ enregistrements
- **Taille base de données:** ~100 MB pour 1 an d'utilisation intensive

### Optimisation

**Si le système ralentit:**
```bash
# Optimiser la base de données
python3 -c "from backend.database.db_manager import get_db; get_db().vacuum()"
```

---

## 🆘 Support

### Logs du Serveur

Les logs sont affichés dans le terminal où le serveur a été lancé.

Pour sauvegarder les logs:
```bash
python3 backend/start_server.py 2>&1 | tee server.log
```

### Contact

- **GitHub Issues:** https://github.com/RBSoftwareAI/kine/issues
- **Documentation:** https://github.com/RBSoftwareAI/kine/tree/main/docs

---

## 📝 Notes Importantes

### ⚠️ Ce qui N'EST PAS inclus

- **Hébergement HDS certifié** (données locales uniquement)
- **Synchronisation multi-cabinets** (chaque cabinet = installation indépendante)
- **Accès distant via Internet** (réseau local uniquement)

### ✅ Ce qui EST inclus

- **Stockage local sécurisé** (SQLite)
- **Multi-utilisateurs** (kinés, coachs, patients)
- **Traçabilité RGPD complète** (audit logs)
- **Statistiques pathologies** avec temps de guérison
- **Interface responsive** (PC + mobile)
- **Sauvegardes automatiques**

---

## 🚀 Prochaines Étapes

Une fois l'installation terminée et testée:

1. **Créer les vrais comptes utilisateurs**
   - Via l'interface web (compte admin)
   - Supprimer les comptes de démonstration

2. **Former le personnel**
   - Navigation de base
   - Ajout de patients
   - Enregistrement des douleurs
   - Consultation des statistiques

3. **Configurer les sauvegardes**
   - Planifier sauvegarde hebdomadaire
   - Tester la restauration

4. **Documenter le réseau**
   - Noter l'IP du PC principal
   - Créer un mémo pour le personnel

---

## 📚 Documentation Complète

- **Architecture:** [docs/migration/PLAN_MIGRATION_HDS.md](migration/PLAN_MIGRATION_HDS.md)
- **RGPD:** [docs/rgpd/REGISTRE_TRAITEMENTS_RGPD.md](rgpd/REGISTRE_TRAITEMENTS_RGPD.md)
- **Test Pilote:** [docs/test_pilot/PROTOCOLE_TEST_PILOTE.md](test_pilot/PROTOCOLE_TEST_PILOTE.md)

---

**Version:** 1.0.0  
**Dernière mise à jour:** 2025-01-XX
