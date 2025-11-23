# 🚀 Guide de Déploiement - MediDesk Demo

**URL cible** : https://demo.medidesk.fr  
**Build date** : $(date +"%Y-%m-%d %H:%M:%S")  
**Firebase Project** : kinecare-81f52

---

## 📦 Option 1 : Firebase Hosting (Recommandé)

### Prérequis
```bash
npm install -g firebase-tools
firebase login
```

### Déploiement
```bash
# Depuis /home/user/flutter_app/

# 1. Build production (déjà fait)
flutter build web --release

# 2. Initialiser Firebase Hosting (première fois uniquement)
firebase init hosting
# Sélectionner : kinecare-81f52
# Public directory : build/web
# Configure as single-page app : Yes
# Set up automatic builds : No

# 3. Déployer
firebase deploy --only hosting

# 4. Configurer le domaine personnalisé
# Aller dans : Firebase Console > Hosting > Add custom domain
# Domaine : demo.medidesk.fr
# Suivre les instructions DNS (CNAME ou A record)
```

### Configuration DNS (chez votre registrar)
```
Type: CNAME
Nom: demo
Valeur: kinecare-81f52.web.app
TTL: 3600
```

---

## 📦 Option 2 : Cloudflare Pages

### Déploiement via CLI
```bash
# Installer Wrangler CLI
npm install -g wrangler

# Connexion
wrangler login

# Déployer
cd /home/user/flutter_app/build/web
wrangler pages deploy . --project-name=medidesk-demo

# Configurer le domaine personnalisé dans Cloudflare Dashboard
# Pages > medidesk-demo > Custom domains > Add domain > demo.medidesk.fr
```

### Déploiement via GitHub Actions (automatique)
```yaml
# .github/workflows/deploy.yml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [ main, base ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.4'
          
      - name: Build Flutter Web
        run: |
          flutter pub get
          flutter build web --release
          
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: medidesk-demo
          directory: build/web
          gitHubToken: ${{ secrets.GITHUB_TOKEN }}
```

---

## 📦 Option 3 : Vercel

### Déploiement via CLI
```bash
# Installer Vercel CLI
npm install -g vercel

# Déployer
cd /home/user/flutter_app
vercel --prod

# Configuration :
# - Framework Preset: Other
# - Build Command: flutter build web --release
# - Output Directory: build/web
# - Install Command: flutter pub get

# Configurer le domaine
vercel domains add demo.medidesk.fr medidesk-demo
```

---

## 📦 Option 4 : Netlify

### Déploiement via CLI
```bash
# Installer Netlify CLI
npm install -g netlify-cli

# Connexion
netlify login

# Déployer
cd /home/user/flutter_app/build/web
netlify deploy --prod --dir=.

# Configurer le domaine dans Netlify Dashboard
# Site settings > Domain management > Add custom domain
```

### Configuration netlify.toml
```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

---

## 🔧 Configuration Serveur Custom (VPS/Nginx)

### nginx.conf
```nginx
server {
    listen 80;
    server_name demo.medidesk.fr;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name demo.medidesk.fr;
    
    # SSL Certificates (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/demo.medidesk.fr/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/demo.medidesk.fr/privkey.pem;
    
    root /var/www/medidesk/build/web;
    index index.html;
    
    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # SPA routing (redirect all to index.html)
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Déploiement
```bash
# Sur le serveur
cd /var/www
git clone https://github.com/RBSoftwareAI/kine.git medidesk
cd medidesk
git checkout base

# Build
flutter build web --release

# Redémarrer nginx
sudo systemctl reload nginx

# Configurer SSL avec Certbot
sudo certbot --nginx -d demo.medidesk.fr
```

---

## ✅ Checklist Post-Déploiement

### Tests Fonctionnels
- [ ] Page de connexion accessible
- [ ] Connexion avec compte test fonctionne
- [ ] Dashboard charge correctement
- [ ] Liste patients s'affiche
- [ ] Calendrier RDV fonctionne
- [ ] Création RDV opérationnelle
- [ ] Déconnexion fonctionne

### Tests Techniques
- [ ] HTTPS activé (cadenas vert)
- [ ] Aucune erreur console (F12)
- [ ] Temps de chargement < 3s
- [ ] Responsive mobile (tester sur smartphone)
- [ ] Firebase Auth fonctionne
- [ ] Firestore queries fonctionnent
- [ ] PWA installable (si applicable)

### Performance
```bash
# Tester avec Lighthouse
npm install -g lighthouse
lighthouse https://demo.medidesk.fr --output html --output-path ./lighthouse-report.html
```

**Objectifs** :
- Performance : > 90
- Accessibilité : > 90
- Best Practices : > 90
- SEO : > 80

---

## 🔑 Comptes de Test (démo publique)

| Email | Mot de passe | Centre | Rôle |
|-------|--------------|--------|------|
| `marie.lefebvre@kine-paris.fr` | `password123` | Kiné Paris Centre | Kinésithérapeute |
| `pierre.girard@osteo-lyon.fr` | `password123` | Ostéo Lyon | Ostéopathe |

**Données** : 20 patients + 15 RDV par centre

---

## 📊 Monitoring et Analytics

### Firebase Analytics
```bash
# Activer dans Firebase Console
# Analytics > Dashboard

# Événements personnalisés déjà trackés :
# - login, logout
# - patient_created, patient_viewed
# - appointment_created, appointment_updated
```

### Google Analytics (optionnel)
Ajouter dans `web/index.html` :
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

---

## 🆘 Dépannage

### Erreur : "Firebase Auth not initialized"
```bash
# Vérifier firebase_options.dart
flutter pub get
flutter clean
flutter build web --release
```

### Erreur : "CORS policy"
```bash
# Configurer CORS dans Firebase Storage Rules
# Storage > Rules > Ajouter :
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Page blanche après déploiement
```bash
# Vérifier :
# 1. Base path dans index.html
# 2. Firebase config
# 3. Console browser (F12) pour erreurs JS
```

---

## 📞 Support

**Documentation** : [AI_QUICK_START.md](./AI_QUICK_START.md)  
**Repository** : https://github.com/RBSoftwareAI/kine  
**Firebase Console** : https://console.firebase.google.com/project/kinecare-81f52  

---

**Version** : 1.0.0  
**Date de build** : $(date +"%Y-%m-%d")  
**Statut** : ✅ Production-Ready
