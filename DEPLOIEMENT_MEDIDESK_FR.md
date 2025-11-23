# 🚀 GUIDE DÉPLOIEMENT - app.medidesk.fr

**Date** : 16 novembre 2025  
**Version** : 1.0 Production-Ready  
**Objectif** : Déployer MediDesk pour le pilote Tourcoing

---

## 📋 PRÉREQUIS

### **1. Domaine medidesk.fr**
✅ Domaine acheté et configuré  
📧 Accès au panneau DNS (registrar)

### **2. Hébergement Web**
Choix recommandés pour le pilote :

**Option A : VPS (Recommandé pour production)**
- 🏢 Hébergeur : OVH Cloud (HDS) ou Scaleway
- 💻 Config minimale : 2 vCPU, 4 GB RAM, 80 GB SSD
- 💰 Coût : 10-20€/mois
- ✅ Contrôle total, scalabilité

**Option B : Hébergement statique (Rapide pour démarrer)**
- 🌐 Netlify, Vercel, ou Cloudflare Pages
- 💰 Coût : Gratuit ou 5-10€/mois
- ✅ Déploiement instantané, SSL auto
- ⚠️ Limité à Flutter Web (pas de backend Flask)

---

## 🎯 ARCHITECTURE DÉPLOIEMENT

```
medidesk.fr
├── app.medidesk.fr        → Application Flutter Web (port 5060)
├── api.medidesk.fr        → Backend Flask API (port 5000)
├── www.medidesk.fr        → Redirection → medidesk.fr
└── medidesk.fr            → Site marketing (future)
```

---

## 🔧 MÉTHODE 1 : DÉPLOIEMENT RAPIDE (Netlify/Vercel)

### **Pour le Pilote Tourcoing (sans backend)**

**Étape 1 : Build Flutter Web**
```bash
cd /home/user/flutter_app
flutter build web --release
```

**Étape 2 : Configuration Netlify**
```toml
# netlify.toml (créer à la racine du projet)
[build]
  publish = "build/web"
  command = "flutter build web --release"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

**Étape 3 : Déploiement**
```bash
# Option A : Via interface web Netlify
# 1. Connecter le repository GitHub
# 2. Définir build command: flutter build web --release
# 3. Définir publish directory: build/web
# 4. Déployer

# Option B : Via CLI Netlify
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=build/web
```

**Étape 4 : Configuration DNS**
```
# Chez votre registrar (ex: OVH, Gandi)
Type: CNAME
Nom: app
Valeur: [votre-site].netlify.app
TTL: 3600
```

**Résultat** : https://app.medidesk.fr accessible en 10-15 minutes ✅

---

## 🏗️ MÉTHODE 2 : DÉPLOIEMENT COMPLET VPS (Production)

### **Avec Backend Flask + Base de données**

---

### **PARTIE A : Provisionner le VPS**

**1. Choisir et créer le VPS**
```
Hébergeur : OVH Cloud ou Scaleway
OS : Ubuntu Server 22.04 LTS
Config : 2 vCPU, 4 GB RAM, 80 GB SSD
Prix : ~15€/mois
```

**2. Première connexion**
```bash
ssh root@VOTRE_IP_VPS

# Créer utilisateur non-root
adduser medidesk
usermod -aG sudo medidesk
exit

# Se reconnecter
ssh medidesk@VOTRE_IP_VPS
```

---

### **PARTIE B : Installation des Dépendances**

```bash
# Mise à jour système
sudo apt update && sudo apt upgrade -y

# Installer Python 3.11+
sudo apt install python3 python3-pip python3-venv -y

# Installer Nginx
sudo apt install nginx -y

# Installer Certbot (SSL gratuit)
sudo apt install certbot python3-certbot-nginx -y

# Installer Git
sudo apt install git -y
```

---

### **PARTIE C : Déployer le Backend Flask**

```bash
# Cloner le repository
cd /home/medidesk
git clone https://github.com/RBSoftwareAI/kine.git medidesk
cd medidesk

# Créer environnement virtuel Python
python3 -m venv venv
source venv/bin/activate

# Installer dépendances Flask
pip install flask flask-cors werkzeug pysqlcipher3

# Créer fichier de configuration
cat > backend/api/.env << EOF
FLASK_ENV=production
SQLCIPHER_KEY=$(openssl rand -base64 32)
SECRET_KEY=$(openssl rand -hex 32)
EOF

# Initialiser la base de données
cd backend/database
python3 -c "import sqlite3; conn = sqlite3.connect('medidesk.db'); conn.close()"
sqlite3 medidesk.db < schema.sql
cd ../..

# Créer service systemd
sudo nano /etc/systemd/system/medidesk-api.service
```

**Contenu du service** :
```ini
[Unit]
Description=MediDesk Flask API
After=network.target

[Service]
User=medidesk
WorkingDirectory=/home/medidesk/medidesk/backend/api
Environment="PATH=/home/medidesk/medidesk/venv/bin"
ExecStart=/home/medidesk/medidesk/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

**Activer le service** :
```bash
sudo systemctl daemon-reload
sudo systemctl enable medidesk-api
sudo systemctl start medidesk-api
sudo systemctl status medidesk-api
```

---

### **PARTIE D : Déployer Flutter Web**

```bash
# Copier le build Flutter sur le VPS
# (Depuis votre machine locale)
scp -r build/web medidesk@VOTRE_IP_VPS:/home/medidesk/medidesk/
```

---

### **PARTIE E : Configurer Nginx**

```bash
# Créer configuration Nginx
sudo nano /etc/nginx/sites-available/medidesk
```

**Contenu Nginx** :
```nginx
# app.medidesk.fr - Application Flutter
server {
    server_name app.medidesk.fr;
    root /home/medidesk/medidesk/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-cache, must-revalidate";
    }

    # Assets statiques avec cache
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# api.medidesk.fr - Backend Flask
server {
    server_name api.medidesk.fr;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Activer la configuration** :
```bash
sudo ln -s /etc/nginx/sites-available/medidesk /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

### **PARTIE F : Configurer SSL (HTTPS)**

```bash
# Obtenir certificats SSL gratuits (Let's Encrypt)
sudo certbot --nginx -d app.medidesk.fr -d api.medidesk.fr

# Renouvellement automatique
sudo certbot renew --dry-run
```

---

### **PARTIE G : Configuration DNS**

**Chez votre registrar (OVH, Gandi, etc.)** :
```
Type: A
Nom: app
Valeur: VOTRE_IP_VPS
TTL: 3600

Type: A
Nom: api
Valeur: VOTRE_IP_VPS
TTL: 3600

Type: A
Nom: @
Valeur: VOTRE_IP_VPS
TTL: 3600
```

**Attendre propagation DNS** : 1-24 heures (souvent 1-2h)

---

## ✅ VÉRIFICATION POST-DÉPLOIEMENT

### **Tests à effectuer**

```bash
# 1. Tester le backend API
curl https://api.medidesk.fr/health
# Attendu: {"status": "ok", "timestamp": "..."}

# 2. Tester l'application Flutter
curl -I https://app.medidesk.fr
# Attendu: HTTP/2 200 OK

# 3. Tester SSL
curl -I https://app.medidesk.fr | grep -i "strict-transport-security"
# Attendu: strict-transport-security header présent
```

### **Checklist de Validation**

- [ ] ✅ https://app.medidesk.fr accessible
- [ ] ✅ Page de connexion s'affiche correctement
- [ ] ✅ Connexion avec compte démo fonctionne
- [ ] ✅ Navigation fluide entre les pages
- [ ] ✅ Certificat SSL valide (cadenas vert)
- [ ] ✅ Backend API répond aux requêtes
- [ ] ✅ Export CSV fonctionne
- [ ] ✅ Cartographie douleur interactive

---

## 🔄 MISES À JOUR FUTURES

### **Procédure de mise à jour**

```bash
# Sur le VPS
cd /home/medidesk/medidesk
git pull origin base

# Rebuild Flutter si nécessaire
flutter build web --release

# Redémarrer le backend
sudo systemctl restart medidesk-api

# Recharger Nginx
sudo systemctl reload nginx
```

---

## 🛡️ SÉCURITÉ & MAINTENANCE

### **Backup Automatique**

```bash
# Créer script de backup
nano /home/medidesk/backup.sh
```

**Contenu script** :
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/medidesk/backups"
mkdir -p $BACKUP_DIR

# Backup base de données
cp /home/medidesk/medidesk/backend/database/medidesk.db \
   $BACKUP_DIR/medidesk_$DATE.db

# Garder 30 derniers backups
ls -t $BACKUP_DIR/medidesk_*.db | tail -n +31 | xargs rm -f

echo "✅ Backup créé: medidesk_$DATE.db"
```

**Automatiser avec cron** :
```bash
chmod +x /home/medidesk/backup.sh
crontab -e

# Ajouter ligne (backup quotidien à 2h du matin)
0 2 * * * /home/medidesk/backup.sh >> /home/medidesk/backup.log 2>&1
```

---

### **Monitoring (recommandé)**

```bash
# Installer UptimeRobot (gratuit)
# https://uptimerobot.com

# Surveiller :
# - https://app.medidesk.fr (check HTTP toutes les 5 min)
# - https://api.medidesk.fr/health (check API)
```

---

## 📞 SUPPORT DÉPLOIEMENT

**Problèmes courants** :

**DNS ne se propage pas** :
```bash
# Vérifier propagation DNS
dig app.medidesk.fr
nslookup app.medidesk.fr
```

**Nginx erreur 502 Bad Gateway** :
```bash
# Vérifier que Flask tourne
sudo systemctl status medidesk-api
# Vérifier les logs
sudo journalctl -u medidesk-api -n 50
```

**SSL ne fonctionne pas** :
```bash
# Re-générer certificat
sudo certbot --nginx -d app.medidesk.fr --force-renew
```

---

## 🎯 RÉSUMÉ RAPIDE

**Pour le pilote Tourcoing, la solution la plus rapide** :

1. **Netlify/Vercel** (10-15 min) pour Flutter Web uniquement
2. Configuration DNS : `app.medidesk.fr` → Netlify
3. Application accessible immédiatement
4. Backend Flask déployable plus tard si besoin

**Pour la production complète** :

1. VPS OVH/Scaleway (~2h setup initial)
2. Flutter Web + Backend Flask + Base chiffrée
3. SSL automatique via Certbot
4. Backups quotidiens automatisés

---

**📅 Document créé le 16 novembre 2025**  
**🔄 Mise à jour à chaque déploiement majeur**  
**📧 Support : contact@medidesk.fr**
