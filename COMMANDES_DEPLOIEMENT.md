# ⚡ Commandes de Déploiement - Guide Rapide

Ce fichier contient **toutes les commandes** nécessaires pour déployer MediDesk sur Firebase Hosting avec le domaine demo.medidesk.fr.

---

## 🚀 Déploiement Rapide (3 étapes)

### Étape 1 : Obtenir le Token Firebase

**Sur votre machine locale** :

```bash
firebase login:ci
```

👉 Copiez le token généré (commence par `1//0g...`)

---

### Étape 2 : Déployer avec le Script

**Dans cet environnement ou votre machine** :

```bash
cd /home/user/flutter_app
./deploy.sh VOTRE_TOKEN_ICI
```

**Exemple** :
```bash
./deploy.sh 1//0gXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Ou avec variable d'environnement** :
```bash
export FIREBASE_TOKEN='1//0gXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
./deploy.sh
```

---

### Étape 3 : Configurer le Domaine (Firebase Console)

1. **Aller sur** : https://console.firebase.google.com/project/kinecare-81f52/hosting
2. **Onglet** : "Domaines" ou "Domains"
3. **Cliquer** : "Ajouter un domaine personnalisé"
4. **Entrer** : `demo.medidesk.fr`
5. **Noter** les enregistrements DNS fournis

---

## 🌐 Configuration DNS (Sur votre registrar)

### Option A : Type A (Recommandé)

**Sur Gandi, OVH, Cloudflare, etc. :**

```
Type: A
Nom: demo
Valeur: 151.101.1.195
TTL: 3600
```

```
Type: A
Nom: demo
Valeur: 151.101.65.195
TTL: 3600
```

### Option B : Type CNAME

```
Type: CNAME
Nom: demo
Valeur: kinecare-81f52.web.app.
TTL: 3600
```

**⚠️ Important** : Utilisez les valeurs **exactes** fournies par Firebase Console !

---

## 🔍 Vérification & Tests

### Vérifier la propagation DNS

```bash
# Linux/Mac
dig demo.medidesk.fr

# Windows
nslookup demo.medidesk.fr
```

### Tester l'accès HTTP

```bash
curl -I http://demo.medidesk.fr
```

**Attendu** : Redirection 301 vers HTTPS

### Tester l'accès HTTPS

```bash
curl -I https://demo.medidesk.fr
```

**Attendu** : Statut 200 OK

### Tester dans le navigateur

```bash
# Ouvrir dans le navigateur
https://demo.medidesk.fr
```

**Vérifier** :
- ✅ Cadenas vert 🔒
- ✅ Application MediDesk s'affiche
- ✅ Pas d'erreur SSL

---

## 🔧 Commandes de Maintenance

### Rebuild et Redéployer

```bash
cd /home/user/flutter_app

# Rebuild Flutter
flutter clean
flutter pub get
flutter build web --release

# Redéployer
firebase deploy --only hosting --token "$FIREBASE_TOKEN"
```

### Voir les Logs Firebase

```bash
# Via Firebase CLI
firebase hosting:channel:list --token "$FIREBASE_TOKEN"

# Voir l'historique des déploiements
# Firebase Console → Hosting → Release history
```

### Rollback (Retour Arrière)

**Via Firebase Console** :

1. Firebase Console → Hosting → Release history
2. Trouver la version précédente
3. Cliquer "Rollback"

**Durée** : Instantané

---

## 🛠️ Commandes de Dépannage

### Vérifier l'installation Firebase CLI

```bash
firebase --version
```

**Attendu** : Version 13.x ou supérieure

### Réinstaller Firebase CLI (si besoin)

```bash
curl -sL https://firebase.tools | bash
```

### Vérifier le projet Firebase

```bash
cd /home/user/flutter_app
cat .firebaserc
```

**Attendu** :
```json
{
  "projects": {
    "default": "kinecare-81f52"
  }
}
```

### Vérifier la configuration Hosting

```bash
cat firebase.json
```

**Attendu** : `"public": "build/web"`

### Nettoyer le cache Flutter

```bash
cd /home/user/flutter_app
flutter clean
flutter pub get
flutter pub cache repair
```

### Vider le cache DNS (sur votre machine locale)

**Linux** :
```bash
sudo systemd-resolve --flush-caches
```

**Mac** :
```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

**Windows** :
```bash
ipconfig /flushdns
```

---

## 📊 Commandes de Monitoring

### Vérifier l'utilisation Firebase

```bash
# Via Firebase Console
# https://console.firebase.google.com/project/kinecare-81f52/usage

# Voir les quotas
# Hosting → Usage
```

### Tester la performance

```bash
# Test de vitesse
curl -o /dev/null -s -w "Time: %{time_total}s\n" https://demo.medidesk.fr

# Test avec headers complets
curl -I -H "User-Agent: Mozilla/5.0" https://demo.medidesk.fr
```

### Vérifier le certificat SSL

```bash
openssl s_client -connect demo.medidesk.fr:443 -servername demo.medidesk.fr | grep -A 2 "Verify return code"
```

**Attendu** : `Verify return code: 0 (ok)`

---

## 🔄 Workflow CI/CD (Optionnel)

### Créer le Secret GitHub

**Via GitHub Web** :

1. Repository → Settings → Secrets and variables → Actions
2. New repository secret
3. Name : `FIREBASE_SERVICE_ACCOUNT`
4. Value : Votre token Firebase CI

### Déclencher un Déploiement Automatique

```bash
# Après configuration du workflow
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin base
```

👉 GitHub Actions déploie automatiquement !

---

## 🎯 Commandes Utiles Complémentaires

### Voir l'état du Build

```bash
cd /home/user/flutter_app
ls -lh build/web/
```

### Voir la taille du Build

```bash
du -sh build/web/
```

### Compresser le Build (pour analyse)

```bash
tar -czf medidesk-build.tar.gz build/web/
ls -lh medidesk-build.tar.gz
```

### Tester le Build localement (avant déploiement)

```bash
cd build/web
python3 -m http.server 8080 --bind 0.0.0.0
```

Puis ouvrir : http://localhost:8080

### Comparer deux Builds

```bash
# Build actuel
du -sh build/web/

# Rebuild
flutter clean
flutter build web --release
du -sh build/web/
```

---

## 📱 Commandes pour Android (Bonus)

### Build APK (optionnel)

```bash
cd /home/user/flutter_app
flutter build apk --release
```

**Output** : `build/app/outputs/flutter-apk/app-release.apk`

### Vérifier la configuration Android

```bash
cat android/app/google-services.json | grep package_name
```

**Attendu** : `"package_name":"fr.medidesk.demo"`

---

## 🆘 Commandes d'Urgence

### Problème : Port 8080 déjà utilisé

```bash
# Trouver le processus
lsof -i :8080

# Tuer le processus
kill -9 $(lsof -t -i:8080)
```

### Problème : Firebase CLI ne répond pas

```bash
# Réinstaller
curl -sL https://firebase.tools | bash

# Vérifier
firebase --version
```

### Problème : Build Flutter échoue

```bash
# Nettoyage complet
cd /home/user/flutter_app
flutter clean
rm -rf build/
rm -rf .dart_tool/
flutter pub get
flutter build web --release
```

### Problème : Token Firebase expiré

```bash
# Régénérer sur votre machine locale
firebase login:ci

# Copier le nouveau token et redéployer
./deploy.sh NOUVEAU_TOKEN
```

---

## 📋 Checklist de Commandes

### Première fois

- [ ] `firebase login:ci` (sur votre machine locale)
- [ ] `cd /home/user/flutter_app`
- [ ] `./deploy.sh VOTRE_TOKEN`
- [ ] Configurer DNS sur registrar
- [ ] Vérifier : `curl -I https://demo.medidesk.fr`

### Déploiements suivants

- [ ] `cd /home/user/flutter_app`
- [ ] `git pull origin base` (récupérer derniers changements)
- [ ] `flutter build web --release`
- [ ] `./deploy.sh VOTRE_TOKEN`

### Tests réguliers

- [ ] `curl -I https://demo.medidesk.fr`
- [ ] `dig demo.medidesk.fr`
- [ ] Ouvrir navigateur : https://demo.medidesk.fr

---

## 🔗 Commandes de Liens Utiles

### Ouvrir Firebase Console

```bash
# Linux/Mac
xdg-open https://console.firebase.google.com/project/kinecare-81f52/hosting
# ou
open https://console.firebase.google.com/project/kinecare-81f52/hosting

# Windows
start https://console.firebase.google.com/project/kinecare-81f52/hosting
```

### Ouvrir l'application déployée

```bash
xdg-open https://demo.medidesk.fr
# ou
open https://demo.medidesk.fr
# ou
start https://demo.medidesk.fr
```

---

## 💡 Astuces

### Créer un Alias de Déploiement

Ajoutez à votre `~/.bashrc` ou `~/.zshrc` :

```bash
alias medidesk-deploy='cd /home/user/flutter_app && ./deploy.sh $FIREBASE_TOKEN'
```

Puis :
```bash
source ~/.bashrc  # ou source ~/.zshrc
medidesk-deploy
```

### Variable d'Environnement Permanente

Ajoutez à votre `~/.bashrc` ou `~/.zshrc` :

```bash
export FIREBASE_TOKEN='votre_token_ici'
```

Puis :
```bash
source ~/.bashrc
./deploy.sh  # Plus besoin de passer le token !
```

---

## ✅ Résumé des Commandes Essentielles

```bash
# 1. Token (machine locale)
firebase login:ci

# 2. Déploiement (environnement build)
cd /home/user/flutter_app
./deploy.sh VOTRE_TOKEN

# 3. Vérification
curl -I https://demo.medidesk.fr
dig demo.medidesk.fr

# 4. Tests
open https://demo.medidesk.fr
```

---

**🎉 Vous avez maintenant toutes les commandes pour déployer et maintenir MediDesk ! 🚀**

---

**Créé le : Novembre 2025**  
**Dernière mise à jour : Novembre 2025**  
**Version : 1.0.0**
