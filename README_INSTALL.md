# 🏥 MediDesk - Guide d'Installation Locale

**Installation complète en 10 minutes** pour votre centre de soins.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :

- **Ordinateur** : Windows 10/11, macOS 10.15+, ou Linux (Ubuntu 20.04+)
- **RAM** : Minimum 4 GB (8 GB recommandé)
- **Espace disque** : 10 GB disponibles
- **Docker** : Version 20.10+ (installation ci-dessous si nécessaire)

---

## 🚀 Installation Rapide (3 Étapes)

### Étape 1 : Installer Docker

#### **Windows**
1. Télécharger Docker Desktop : [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Exécuter l'installateur
3. Redémarrer l'ordinateur
4. Vérifier l'installation :
   ```cmd
   docker --version
   ```

#### **macOS**
1. Télécharger Docker Desktop : [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Glisser Docker dans Applications
3. Lancer Docker depuis Applications
4. Vérifier l'installation :
   ```bash
   docker --version
   ```

#### **Linux (Ubuntu/Debian)**
```bash
# Installation Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Installation Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Vérification
docker --version
docker-compose --version

# Redémarrer la session (ou reboot)
```

---

### Étape 2 : Télécharger MediDesk

#### Option A : Avec Git (recommandé)
```bash
git clone https://github.com/RBSoftwareAI/kine.git medidesk
cd medidesk
```

#### Option B : Sans Git
1. Aller sur : [https://github.com/RBSoftwareAI/kine/archive/refs/heads/base.zip](https://github.com/RBSoftwareAI/kine/archive/refs/heads/base.zip)
2. Télécharger et décompresser
3. Ouvrir un terminal dans le dossier décompressé

---

### Étape 3 : Configuration et Démarrage

#### 1. Copier et personnaliser la configuration
```bash
# Copier le fichier de configuration exemple
cp .env.example .env

# Éditer avec votre éditeur préféré
# Windows: notepad .env
# macOS: open -e .env
# Linux: nano .env
```

#### 2. **⚠️ IMPORTANT** : Modifier ces valeurs dans `.env`
```bash
DB_PASSWORD=votre_mot_de_passe_securise_ici
SECRET_KEY=cle_secrete_minimum_32_caracteres_aleatoires

# Personnalisation (optionnel)
CENTER_NAME=Votre Cabinet de Kinésithérapie
CENTER_ADDRESS=Votre adresse complète
CENTER_PHONE=Votre numéro de téléphone
CENTER_EMAIL=contact@votre-domaine.fr
```

#### 3. Build du frontend Flutter
```bash
# Si vous avez Flutter installé localement
flutter build web --release

# Sinon, un build web est déjà inclus dans le repository
```

#### 4. Démarrer MediDesk
```bash
# Démarrer tous les services
docker-compose up -d

# Vérifier que tout fonctionne
docker-compose ps
```

**Sortie attendue :**
```
NAME                   STATUS              PORTS
medidesk_db            Up                  5432/tcp
medidesk_backend       Up (healthy)        0.0.0.0:5000->5000/tcp
medidesk_frontend      Up (healthy)        0.0.0.0:8080->80/tcp
```

---

## 🌐 Accès à l'Application

Une fois démarré, ouvrir votre navigateur et aller à :

**🔗 http://localhost:8080**

### Comptes par défaut
- **Administrateur** : `admin@medidesk.local` / `admin123`
- **Praticien** : `kine@medidesk.local` / `kine123`
- **Patient** : `patient@medidesk.local` / `patient123`

**⚠️ Changez ces mots de passe après la première connexion !**

---

## 📖 Commandes Utiles

### Démarrage et Arrêt
```bash
# Démarrer
docker-compose up -d

# Arrêter
docker-compose down

# Redémarrer
docker-compose restart

# Voir les logs
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f backend
```

### Maintenance
```bash
# Sauvegarder la base de données
docker exec medidesk_db pg_dump -U medidesk_user medidesk > backup_$(date +%Y%m%d).sql

# Restaurer une sauvegarde
docker exec -i medidesk_db psql -U medidesk_user medidesk < backup_20251125.sql

# Voir l'espace disque utilisé
docker system df

# Nettoyer les ressources inutilisées
docker system prune -a
```

---

## 🔧 Dépannage

### Problème : Port déjà utilisé
**Erreur** : `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Solution** : Changer le port dans `.env`
```bash
FRONTEND_PORT=8081
```
Puis redémarrer : `docker-compose down && docker-compose up -d`

---

### Problème : Services ne démarrent pas
**Vérifier les logs** :
```bash
docker-compose logs
```

**Solutions courantes** :
1. Vérifier que Docker Desktop est bien lancé
2. Vérifier les permissions : `sudo chmod -R 755 .`
3. Vérifier l'espace disque : `df -h`

---

### Problème : Impossible de se connecter
1. Vérifier que tous les services sont "Up (healthy)" : `docker-compose ps`
2. Vérifier la connexion réseau : `curl http://localhost:8080`
3. Vérifier les logs backend : `docker-compose logs backend`

---

## 🔒 Sécurité en Production

### Checklist de sécurité
- [ ] Changer tous les mots de passe par défaut
- [ ] Générer une clé SECRET_KEY sécurisée (32+ caractères)
- [ ] Activer HTTPS avec certificats SSL
- [ ] Configurer le pare-feu (autoriser uniquement ports nécessaires)
- [ ] Activer les sauvegardes automatiques
- [ ] Restreindre l'accès réseau (VPN ou réseau local uniquement)
- [ ] Mettre à jour régulièrement : `docker-compose pull && docker-compose up -d`

### Configuration HTTPS (recommandé)
```bash
# Générer un certificat auto-signé (développement)
mkdir certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/key.pem -out certs/cert.pem

# Activer HTTPS dans .env
ENABLE_HTTPS=true
SSL_CERT_PATH=./certs/cert.pem
SSL_KEY_PATH=./certs/key.pem
```

---

## 📦 Mise à Jour

```bash
# Sauvegarder d'abord la base
docker exec medidesk_db pg_dump -U medidesk_user medidesk > backup_avant_maj.sql

# Télécharger la dernière version
git pull origin base

# Reconstruire les images
docker-compose build --no-cache

# Redémarrer avec la nouvelle version
docker-compose down && docker-compose up -d

# Vérifier que tout fonctionne
docker-compose ps
docker-compose logs
```

---

## 💾 Sauvegardes Automatiques

### Configuration sauvegarde automatique
```bash
# Créer un script de sauvegarde
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/var/backups/medidesk"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
docker exec medidesk_db pg_dump -U medidesk_user medidesk | gzip > "$BACKUP_DIR/medidesk_$DATE.sql.gz"

# Garder seulement les 30 derniers jours
find "$BACKUP_DIR" -name "medidesk_*.sql.gz" -mtime +30 -delete
EOF

chmod +x backup.sh

# Ajouter au crontab (tous les jours à 2h)
crontab -e
# Ajouter la ligne :
0 2 * * * /chemin/vers/backup.sh
```

---

## 📞 Support

### Documentation
- **Guide utilisateur** : `README.md`
- **Documentation technique** : `CONTEXT.md`
- **Feuille de route** : `ROADMAP.md`

### Ressources
- **Site Web** : https://demo.medidesk.fr
- **GitHub** : https://github.com/RBSoftwareAI/kine
- **Email Support** : support@medidesk.fr

---

## 🎯 Prochaines Étapes

Après l'installation réussie :

1. **Changer les mots de passe** (sécurité)
2. **Créer des comptes praticiens** (paramètres → utilisateurs)
3. **Importer les données patients** (si migration)
4. **Configurer les sauvegardes** (automatiques)
5. **Former l'équipe** (tutoriels intégrés)

---

**✅ Installation terminée !** Bienvenue dans MediDesk 🏥

*Version: 1.3 | Date: 25 Novembre 2025 | Équipe: RBSoftwareAI*
