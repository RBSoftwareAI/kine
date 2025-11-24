# 🚀 Déploiement MediDesk - Guide Express

## ⏱️ 3 Options de Déploiement (du plus rapide au plus complet)

---

## 🟢 Option A : Déploiement Express (15 minutes) - **RECOMMANDÉ POUR PILOTE**

### Architecture :
- **Frontend** : Netlify (gratuit, SSL automatique)
- **Backend** : Render (gratuit, SSL automatique)
- **Domaine** : app.medidesk.fr + api.medidesk.fr

### Avantages :
- ✅ Déploiement en 15 minutes
- ✅ SSL automatique (HTTPS)
- ✅ Gratuit pour commencer
- ✅ Scalabilité automatique
- ✅ Monitoring inclus

### Étapes :

#### 1️⃣ Déployer le Backend sur Render (5 minutes)

**A. Créer un compte sur Render.com**
- Aller sur https://render.com
- Se connecter avec GitHub
- Autoriser l'accès au repository `RBSoftwareAI/kine`

**B. Créer un nouveau Web Service**
```
1. Cliquer "New +" → "Web Service"
2. Sélectionner le repository "kine"
3. Configuration :
   - Name: medidesk-backend
   - Root Directory: backend
   - Environment: Python 3
   - Build Command: pip install -r requirements.txt
   - Start Command: python3 start_server.py
   - Instance Type: Free

4. Variables d'environnement (ajoutez-les) :
   PORT=8080
   FLASK_ENV=production
   SECRET_KEY=votre_clé_secrète_longue_et_aléatoire
   JWT_SECRET_KEY=autre_clé_secrète_pour_jwt

5. Cliquer "Create Web Service"
```

**C. Récupérer l'URL du backend**
```
Après déploiement, vous obtiendrez une URL :
https://medidesk-backend.onrender.com

Notez cette URL, elle sera utilisée pour le frontend.
```

#### 2️⃣ Configurer le Frontend Flutter (5 minutes)

**A. Mettre à jour l'URL de l'API**

Éditez `lib/repositories/local_repository.dart` :
```dart
class LocalRepository implements DataRepository {
  // Remplacer l'URL localhost par l'URL Render
  final String baseUrl = 'https://medidesk-backend.onrender.com';
  
  // ... reste du code
}
```

**B. Rebuild le frontend**
```bash
cd /home/user/flutter_app
flutter build web --release
```

#### 3️⃣ Déployer le Frontend sur Netlify (5 minutes)

**A. Créer un compte sur Netlify.com**
- Aller sur https://app.netlify.com
- Se connecter avec GitHub

**B. Déployer via Drag & Drop**
```
1. Cliquer "Add new site" → "Deploy manually"
2. Glisser-déposer le dossier build/web
3. Attendre la fin du déploiement (30 secondes)
4. Vous obtenez une URL : https://random-name-12345.netlify.app
```

**C. Configurer le domaine personnalisé**
```
1. Dans Netlify, aller dans "Domain settings"
2. Cliquer "Add custom domain"
3. Entrer : app.medidesk.fr
4. Netlify affichera les enregistrements DNS à configurer
```

#### 4️⃣ Configuration DNS medidesk.fr (5 minutes)

**A. Configurer les enregistrements DNS (chez votre registrar OVH/Gandi/etc.)**

**Pour le Frontend (app.medidesk.fr) :**
```
Type: CNAME
Nom: app
Valeur: random-name-12345.netlify.app.
TTL: 3600
```

**Pour le Backend (api.medidesk.fr) :**
```
Type: CNAME
Nom: api
Valeur: medidesk-backend.onrender.com.
TTL: 3600
```

**B. Attendre la propagation DNS (5-30 minutes)**

Vérifier avec :
```bash
dig app.medidesk.fr
dig api.medidesk.fr
```

#### 5️⃣ Mise à jour finale du Frontend

**A. Mettre à jour l'URL API avec le domaine personnalisé**

Éditez `lib/repositories/local_repository.dart` :
```dart
final String baseUrl = 'https://api.medidesk.fr';
```

**B. Rebuild et redéployer sur Netlify**
```bash
flutter build web --release
# Glisser-déposer build/web sur Netlify
```

### ✅ Résultat Final :
- **Frontend** : https://app.medidesk.fr
- **Backend API** : https://api.medidesk.fr
- **SSL** : Automatique (HTTPS)
- **Coût** : 0€ pendant le pilote

---

## 🟡 Option B : Déploiement VPS Simple (1 heure)

### Architecture :
- **Serveur** : VPS unique (OVH, DigitalOcean, Hetzner)
- **Reverse Proxy** : Nginx
- **Domaine** : app.medidesk.fr + api.medidesk.fr
- **Coût** : 5-10€/mois

### Prérequis :
- VPS Ubuntu 22.04 LTS (2 Go RAM minimum)
- Accès SSH root
- Domaine medidesk.fr configuré

### Script d'installation automatique :

```bash
#!/bin/bash
# Installation complète MediDesk sur VPS Ubuntu 22.04

# 1. Mise à jour système
sudo apt update && sudo apt upgrade -y

# 2. Installation dépendances
sudo apt install -y python3 python3-pip nginx certbot python3-certbot-nginx git

# 3. Cloner le repository
cd /opt
sudo git clone https://github.com/RBSoftwareAI/kine.git medidesk
cd medidesk

# 4. Installation backend
cd backend
python3 -m pip install -r requirements.txt

# 5. Configuration systemd pour le backend
sudo cat > /etc/systemd/system/medidesk-backend.service <<EOF
[Unit]
Description=MediDesk Backend Flask Server
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/medidesk/backend
Environment="PORT=8080"
Environment="FLASK_ENV=production"
ExecStart=/usr/bin/python3 /opt/medidesk/backend/start_server.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 6. Démarrer le backend
sudo systemctl daemon-reload
sudo systemctl enable medidesk-backend
sudo systemctl start medidesk-backend

# 7. Configuration Nginx
sudo cat > /etc/nginx/sites-available/medidesk <<EOF
# Backend API
server {
    listen 80;
    server_name api.medidesk.fr;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# Frontend Flutter Web
server {
    listen 80;
    server_name app.medidesk.fr;
    root /opt/medidesk/build/web;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
EOF

# 8. Activer la configuration Nginx
sudo ln -s /etc/nginx/sites-available/medidesk /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# 9. Installer SSL avec Let's Encrypt
sudo certbot --nginx -d app.medidesk.fr -d api.medidesk.fr --non-interactive --agree-tos -m contact@medidesk.fr

# 10. Configurer le renouvellement automatique SSL
sudo systemctl enable certbot.timer

echo "✅ Installation terminée !"
echo "🌐 Frontend: https://app.medidesk.fr"
echo "🔌 Backend API: https://api.medidesk.fr"
echo ""
echo "📝 Commandes utiles :"
echo "  sudo systemctl status medidesk-backend  # Statut du backend"
echo "  sudo systemctl restart medidesk-backend # Redémarrer le backend"
echo "  sudo journalctl -u medidesk-backend -f  # Logs en temps réel"
echo "  sudo nginx -t                            # Vérifier config Nginx"
echo "  sudo systemctl restart nginx             # Redémarrer Nginx"
```

### Sauvegardez ce script et exécutez :
```bash
chmod +x install_medidesk.sh
sudo ./install_medidesk.sh
```

---

## 🔴 Option C : Déploiement VPS Avancé avec Docker (2-3 heures)

### Architecture :
- **Containers** : Docker + Docker Compose
- **Base de données** : SQLite avec volumes persistants
- **Reverse Proxy** : Nginx + Let's Encrypt auto-renewal
- **Monitoring** : Prometheus + Grafana (optionnel)
- **Backups** : Automatisés avec cron

### Prérequis :
- VPS Ubuntu 22.04 LTS (4 Go RAM)
- Accès SSH root
- Docker et Docker Compose installés

### Fichier `docker-compose.yml` (à créer à la racine du projet) :

```yaml
version: '3.8'

services:
  # Backend Flask
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: medidesk-backend
    restart: always
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
      - FLASK_ENV=production
      - SECRET_KEY=${SECRET_KEY}
      - JWT_SECRET_KEY=${JWT_SECRET_KEY}
    volumes:
      - ./backend/data:/app/data
      - ./backend/backups:/app/backups
    networks:
      - medidesk-network

  # Frontend Flutter (Nginx static)
  frontend:
    image: nginx:alpine
    container_name: medidesk-frontend
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./build/web:/usr/share/nginx/html:ro
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - backend
    networks:
      - medidesk-network

  # Nginx Reverse Proxy
  nginx-proxy:
    image: nginx:alpine
    container_name: nginx-proxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/proxy.conf:/etc/nginx/nginx.conf:ro
      - ./certbot/conf:/etc/letsencrypt:ro
      - ./certbot/www:/var/www/certbot:ro
    networks:
      - medidesk-network

  # Certbot pour SSL
  certbot:
    image: certbot/certbot
    container_name: medidesk-certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

networks:
  medidesk-network:
    driver: bridge

volumes:
  backend_data:
  backend_backups:
```

### Déploiement Docker :

```bash
# 1. Créer le fichier .env
cat > .env <<EOF
SECRET_KEY=$(openssl rand -hex 32)
JWT_SECRET_KEY=$(openssl rand -hex 32)
EOF

# 2. Build et démarrer les containers
docker-compose up -d --build

# 3. Vérifier le statut
docker-compose ps

# 4. Logs en temps réel
docker-compose logs -f
```

---

## 📊 Comparaison des Options

| Critère | Option A (Express) | Option B (VPS Simple) | Option C (Docker) |
|---------|-------------------|----------------------|-------------------|
| **Temps déploiement** | 15 min | 1 heure | 2-3 heures |
| **Coût mensuel** | 0€ (pilote) | 5-10€ | 10-20€ |
| **Complexité** | Très facile | Facile | Avancé |
| **Scalabilité** | Automatique | Manuelle | Facile |
| **Maintenance** | Zéro | Faible | Moyenne |
| **SSL** | Auto | Auto | Auto |
| **Monitoring** | Inclus | Basique | Avancé |
| **Backups** | Manuel | À configurer | Automatisé |
| **Recommandé pour** | Pilote | Production | Entreprise |

---

## 🎯 Recommandation pour MediDesk - Tourcoing

### Phase 1 : Pilote (maintenant)
➡️ **Option A (Express)** - 15 minutes, gratuit, SSL auto

### Phase 2 : Production (après pilote réussi)
➡️ **Option B (VPS Simple)** - Contrôle total, coût maîtrisé

### Phase 3 : Scalabilité (plusieurs cabinets)
➡️ **Option C (Docker)** - Infrastructure professionnelle

---

## 🆘 Support

**Problème pendant le déploiement ?**
- 📧 Email : contact@medidesk.fr
- 💬 GitHub Issues : https://github.com/RBSoftwareAI/kine/issues
- 📚 Documentation complète : `DEPLOIEMENT_MEDIDESK_FR.md`

---

**Dernière mise à jour** : 18 novembre 2025
**Version MediDesk** : 1.0 (Pilote Tourcoing)
