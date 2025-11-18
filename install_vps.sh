#!/bin/bash
################################################################################
# MediDesk - Script d'Installation Automatique VPS
# Ubuntu 22.04 LTS recommandé
# Nécessite : 2 Go RAM minimum, 20 Go disque
################################################################################

set -e  # Arrêter en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage
print_step() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Vérifier si lancé en tant que root
if [[ $EUID -ne 0 ]]; then
   print_error "Ce script doit être exécuté en tant que root (sudo)"
   exit 1
fi

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          MediDesk - Installation VPS Automatique              ║"
echo "║                    Version 1.0                                 ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Variables de configuration
DOMAIN_FRONTEND="${FRONTEND_DOMAIN:-app.medidesk.fr}"
DOMAIN_BACKEND="${BACKEND_DOMAIN:-api.medidesk.fr}"
EMAIL="${ADMIN_EMAIL:-contact@medidesk.fr}"
INSTALL_DIR="/opt/medidesk"
REPO_URL="https://github.com/RBSoftwareAI/kine.git"

print_step "📋 Configuration :"
echo "   - Frontend : https://$DOMAIN_FRONTEND"
echo "   - Backend  : https://$DOMAIN_BACKEND"
echo "   - Email    : $EMAIL"
echo "   - Dossier  : $INSTALL_DIR"
echo ""

read -p "Continuer l'installation ? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation annulée"
    exit 0
fi

# ============================================
# 1. MISE À JOUR SYSTÈME
# ============================================
print_step "1️⃣  Mise à jour du système..."
apt update && apt upgrade -y
print_success "Système mis à jour"

# ============================================
# 2. INSTALLATION DÉPENDANCES
# ============================================
print_step "2️⃣  Installation des dépendances..."
apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    nginx \
    certbot \
    python3-certbot-nginx \
    git \
    ufw \
    fail2ban
print_success "Dépendances installées"

# ============================================
# 3. CONFIGURATION FIREWALL
# ============================================
print_step "3️⃣  Configuration du firewall UFW..."
ufw --force enable
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
print_success "Firewall configuré"

# ============================================
# 4. CLONAGE DU REPOSITORY
# ============================================
print_step "4️⃣  Clonage du repository MediDesk..."
if [ -d "$INSTALL_DIR" ]; then
    print_warning "Le répertoire $INSTALL_DIR existe déjà"
    rm -rf "$INSTALL_DIR"
fi
git clone "$REPO_URL" "$INSTALL_DIR"
cd "$INSTALL_DIR"
print_success "Repository cloné"

# ============================================
# 5. INSTALLATION BACKEND PYTHON
# ============================================
print_step "5️⃣  Installation du backend Flask..."
cd "$INSTALL_DIR/backend"
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
print_success "Backend installé"

# ============================================
# 6. GÉNÉRATION CLÉS SECRÈTES
# ============================================
print_step "6️⃣  Génération des clés secrètes..."
SECRET_KEY=$(openssl rand -hex 32)
JWT_SECRET_KEY=$(openssl rand -hex 32)

cat > "$INSTALL_DIR/backend/.env" <<EOF
# Configuration Production MediDesk
PORT=8080
FLASK_ENV=production
DEBUG=False
SECRET_KEY=$SECRET_KEY
JWT_SECRET_KEY=$JWT_SECRET_KEY
EOF

chmod 600 "$INSTALL_DIR/backend/.env"
print_success "Clés générées et sauvegardées dans .env"

# ============================================
# 7. CONFIGURATION SYSTEMD (BACKEND)
# ============================================
print_step "7️⃣  Configuration du service systemd..."
cat > /etc/systemd/system/medidesk-backend.service <<EOF
[Unit]
Description=MediDesk Backend Flask Server
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=$INSTALL_DIR/backend
EnvironmentFile=$INSTALL_DIR/backend/.env
ExecStart=/usr/bin/python3 $INSTALL_DIR/backend/start_server.py
Restart=always
RestartSec=10

# Sécurité
NoNewPrivileges=true
PrivateTmp=true

# Logs
StandardOutput=journal
StandardError=journal
SyslogIdentifier=medidesk-backend

[Install]
WantedBy=multi-user.target
EOF

# Créer les répertoires de données
mkdir -p "$INSTALL_DIR/backend/data" "$INSTALL_DIR/backend/backups"
chown -R www-data:www-data "$INSTALL_DIR/backend"

# Démarrer le service
systemctl daemon-reload
systemctl enable medidesk-backend
systemctl start medidesk-backend

# Vérifier le statut
sleep 3
if systemctl is-active --quiet medidesk-backend; then
    print_success "Service backend démarré"
else
    print_error "Erreur au démarrage du backend"
    journalctl -u medidesk-backend -n 20 --no-pager
    exit 1
fi

# ============================================
# 8. BUILD FRONTEND FLUTTER WEB
# ============================================
print_step "8️⃣  Build du frontend Flutter Web..."
# Le frontend sera déployé via Netlify ou build localement si Flutter installé
if command -v flutter &> /dev/null; then
    cd "$INSTALL_DIR"
    flutter build web --release
    print_success "Frontend Flutter buildé"
else
    print_warning "Flutter non installé, le frontend doit être déployé via Netlify"
    print_warning "Ou installez Flutter et lancez : cd $INSTALL_DIR && flutter build web --release"
fi

# ============================================
# 9. CONFIGURATION NGINX
# ============================================
print_step "9️⃣  Configuration de Nginx..."

# Backend API
cat > /etc/nginx/sites-available/medidesk-backend <<EOF
server {
    listen 80;
    server_name $DOMAIN_BACKEND;

    # Logs
    access_log /var/log/nginx/medidesk-backend-access.log;
    error_log /var/log/nginx/medidesk-backend-error.log;

    # Proxy vers Flask
    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        
        # Headers
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Cache bypass
        proxy_cache_bypass \$http_upgrade;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:8080/health;
        access_log off;
    }
}
EOF

# Frontend Flutter (seulement si buildé localement)
if [ -d "$INSTALL_DIR/build/web" ]; then
    cat > /etc/nginx/sites-available/medidesk-frontend <<EOF
server {
    listen 80;
    server_name $DOMAIN_FRONTEND;

    # Logs
    access_log /var/log/nginx/medidesk-frontend-access.log;
    error_log /var/log/nginx/medidesk-frontend-error.log;

    # Root directory
    root $INSTALL_DIR/build/web;
    index index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # SPA routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # No cache for index.html
    location = /index.html {
        add_header Cache-Control "no-cache, must-revalidate";
    }

    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
}
EOF
    ln -sf /etc/nginx/sites-available/medidesk-frontend /etc/nginx/sites-enabled/
fi

# Activer la configuration backend
ln -sf /etc/nginx/sites-available/medidesk-backend /etc/nginx/sites-enabled/

# Désactiver le site par défaut
rm -f /etc/nginx/sites-enabled/default

# Tester la configuration
nginx -t
if [ $? -eq 0 ]; then
    systemctl restart nginx
    print_success "Nginx configuré et redémarré"
else
    print_error "Erreur dans la configuration Nginx"
    exit 1
fi

# ============================================
# 10. INSTALLATION SSL LET'S ENCRYPT
# ============================================
print_step "🔟 Installation des certificats SSL..."
certbot --nginx \
    -d "$DOMAIN_BACKEND" \
    $([ -d "$INSTALL_DIR/build/web" ] && echo "-d $DOMAIN_FRONTEND") \
    --non-interactive \
    --agree-tos \
    -m "$EMAIL" \
    --redirect

if [ $? -eq 0 ]; then
    print_success "Certificats SSL installés"
    
    # Renouvellement automatique
    systemctl enable certbot.timer
    print_success "Renouvellement automatique activé"
else
    print_warning "Erreur SSL - Vérifiez que les DNS pointent vers ce serveur"
fi

# ============================================
# 11. CONFIGURATION DES BACKUPS
# ============================================
print_step "1️⃣1️⃣  Configuration des backups automatiques..."
cat > /usr/local/bin/medidesk-backup.sh <<'EOF'
#!/bin/bash
# Backup MediDesk Database
BACKUP_DIR="/opt/medidesk/backend/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_FILE="/opt/medidesk/backend/data/medidesk.db"

mkdir -p "$BACKUP_DIR"

# Créer le backup
if [ -f "$DB_FILE" ]; then
    cp "$DB_FILE" "$BACKUP_DIR/medidesk_$DATE.db"
    
    # Compresser
    gzip "$BACKUP_DIR/medidesk_$DATE.db"
    
    # Garder seulement les 30 derniers backups
    ls -t "$BACKUP_DIR"/*.gz | tail -n +31 | xargs -r rm
    
    echo "✅ Backup créé : medidesk_$DATE.db.gz"
else
    echo "❌ Base de données non trouvée : $DB_FILE"
    exit 1
fi
EOF

chmod +x /usr/local/bin/medidesk-backup.sh

# Ajouter au cron (tous les jours à 3h du matin)
(crontab -l 2>/dev/null; echo "0 3 * * * /usr/local/bin/medidesk-backup.sh >> /var/log/medidesk-backup.log 2>&1") | crontab -
print_success "Backups automatiques configurés (quotidiens à 3h)"

# ============================================
# 12. RÉCAPITULATIF
# ============================================
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                ✅ INSTALLATION TERMINÉE                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
print_success "MediDesk est maintenant installé et en fonctionnement !"
echo ""
echo "🌐 URLs d'accès :"
echo "   - Backend API : https://$DOMAIN_BACKEND"
echo "   - Frontend    : https://$DOMAIN_FRONTEND"
if [ ! -d "$INSTALL_DIR/build/web" ]; then
    echo "     (Déployez le frontend via Netlify ou buildez Flutter localement)"
fi
echo ""
echo "📊 Commandes utiles :"
echo "   sudo systemctl status medidesk-backend   # Statut du backend"
echo "   sudo systemctl restart medidesk-backend  # Redémarrer"
echo "   sudo journalctl -u medidesk-backend -f   # Logs en temps réel"
echo "   sudo systemctl status nginx              # Statut Nginx"
echo "   sudo certbot renew --dry-run             # Tester renouvellement SSL"
echo "   /usr/local/bin/medidesk-backup.sh        # Backup manuel"
echo ""
echo "📁 Fichiers importants :"
echo "   - Backend         : $INSTALL_DIR/backend"
echo "   - Base de données : $INSTALL_DIR/backend/data/medidesk.db"
echo "   - Backups         : $INSTALL_DIR/backend/backups"
echo "   - Configuration   : $INSTALL_DIR/backend/.env"
echo "   - Logs Backend    : sudo journalctl -u medidesk-backend"
echo "   - Logs Nginx      : /var/log/nginx/medidesk-*"
echo ""
echo "🔐 Sécurité :"
echo "   - Clés secrètes générées : $INSTALL_DIR/backend/.env"
echo "   - Firewall UFW activé (ports 22, 80, 443)"
echo "   - SSL Let's Encrypt configuré"
echo "   - Fail2ban activé"
echo ""
echo "📧 Support : $EMAIL"
echo ""
