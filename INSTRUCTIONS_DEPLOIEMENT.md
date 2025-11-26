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

- **Firebase principale** : https://kinecare-81f52.web.app
- **Domaine personnalisé** : https://demo.medidesk.fr

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

1. Ouvrir https://demo.medidesk.fr
2. Vérifier que le site vitrine est à jour
3. Cliquer sur "Essayer la Démo Guidée"
4. Tester la visite guidée interactive
5. Vérifier la page de connexion (clic sur carte = connexion auto)

## 📝 Notes

- Build déjà prêt dans `build/web/`
- Configuration Firebase dans `firebase.json`
- Script automatisé dans `deploy.sh`

---

**Dernière mise à jour** : 27 Novembre 2025  
**Commits** : 5d7fe31, 8954bde  
**Branche** : base
