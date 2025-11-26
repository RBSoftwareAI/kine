# 📦 Instructions de Déploiement Firebase - MediDesk

## ✅ Prérequis
- Firebase CLI installé (`npm install -g firebase-tools`)
- Accès au projet Firebase `kinecare-81f52`

## 🚀 Étapes de Déploiement

### 1. Télécharger le Code

Le code source complet est sur GitHub :
```bash
git clone https://github.com/RBSoftwareAI/kine.git
cd kine
git checkout base
```

### 2. Installer les Dépendances Flutter

```bash
flutter pub get
```

### 3. Builder l'Application Web

```bash
flutter build web --release

# Copier le site vitrine dans le build
cp -r website build/web/
```

### 4. Se Connecter à Firebase

```bash
firebase login
```

### 5. Déployer sur Firebase Hosting

```bash
firebase deploy --only hosting
```

OU utiliser le script automatisé :
```bash
./deploy.sh
```

## 🌐 URLs après Déploiement

- **📱 Application Flutter** : https://demo.medidesk.fr
- **🌐 Site Vitrine** : https://demo.medidesk.fr/website/
- **Firebase URL principale** : https://kinecare-81f52.web.app
- **Firebase URL alternative** : https://kinecare-81f52.firebaseapp.com

## ✨ Nouveautés de cette Version

### Site Vitrine (`/website/index.html`)
- ✅ Nouveau wording : "Solution de suivi médical pour professionnels de santé"
- ✅ Section Démo Interactive avec bouton "Essayer la Démo Guidée"
- ✅ 3 CTAs dans Hero section
- ✅ Animations fluides et design moderne

### Application Flutter
- ✅ Page connexion améliorée (connexion 1-clic)
- ✅ Visite guidée avec animations (FadeTransition + ScaleTransition)
- ✅ 6 étapes guidées interactives

## 🔍 Vérification Post-Déploiement

### Site Vitrine
1. Ouvrir https://demo.medidesk.fr/website/
2. Vérifier le nouveau wording "Solution de suivi médical pour professionnels de santé"
3. Vérifier les 3 badges dans Hero (Gratuit, RGPD, RDV)
4. Vérifier la section "Démo Interactive"
5. Cliquer sur "Essayer la Démo Guidée" → doit rediriger vers l'application

### Application Flutter
6. Ouvrir https://demo.medidesk.fr
7. Vérifier la page de connexion avec cartes cliquables
8. Cliquer sur une carte de compte test → connexion automatique
9. Vérifier que la visite guidée démarre automatiquement
10. Parcourir les 6 étapes avec animations fluides

## 📝 Notes

- Build déjà prêt dans `build/web/`
- Configuration Firebase dans `firebase.json`
- Script automatisé dans `deploy.sh`

---

**Dernière mise à jour** : 27 Novembre 2025  
**Commits** : 5d7fe31, 8954bde, [nouveau commit avec script de déploiement amélioré]  
**Branche** : base

## 🎯 Important

Le script `deploy-simple.sh` a été mis à jour pour automatiquement copier le site vitrine dans `build/web/website/` lors du déploiement. Cela garantit que le site vitrine et l'application Flutter sont toujours déployés ensemble.
