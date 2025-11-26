# 🌐 Architecture des Domaines MediDesk

## 📋 Architecture Cible

**🎯 Objectif** : Séparer le site vitrine marketing de l'application Flutter

### Domaines
- **`medidesk.fr`** → Site vitrine marketing (HTML/CSS/JS statique)
- **`demo.medidesk.fr`** → Application Flutter (interface utilisateur)

---

## 🏗️ Option 1 : Firebase Hosting Multi-Sites (RECOMMANDÉ)

### Avantages
✅ Séparation propre entre marketing et application  
✅ Déploiements indépendants  
✅ Cache et optimisations séparés  
✅ URLs claires et professionnelles

### Configuration

#### Étape 1 : Créer un Deuxième Site Firebase

```bash
# Créer un site pour l'application
firebase hosting:sites:create medidesk-demo --project kinecare-81f52

# Vérifier les sites créés
firebase hosting:sites:list --project kinecare-81f52
```

#### Étape 2 : Modifier `firebase.json`

```json
{
  "firestore": {
    "rules": "firestore.rules"
  },
  "hosting": [
    {
      "target": "website",
      "public": "website",
      "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
      "headers": [
        {
          "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "**/*.@(js|css)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        }
      ],
      "cleanUrls": true,
      "trailingSlash": false
    },
    {
      "target": "app",
      "public": "build/web",
      "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
      "rewrites": [
        {
          "source": "**",
          "destination": "/index.html"
        }
      ],
      "headers": [
        {
          "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "**/*.@(js|css)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "/",
          "headers": [{"key": "Cache-Control", "value": "no-cache, no-store, must-revalidate"}]
        }
      ],
      "cleanUrls": true,
      "trailingSlash": false
    }
  ]
}
```

#### Étape 3 : Configurer les Targets dans `.firebaserc`

```json
{
  "projects": {
    "default": "kinecare-81f52"
  },
  "targets": {
    "kinecare-81f52": {
      "hosting": {
        "website": [
          "kinecare-81f52"
        ],
        "app": [
          "medidesk-demo"
        ]
      }
    }
  }
}
```

#### Étape 4 : Configurer les Domaines Personnalisés dans Firebase Console

1. **Aller sur Firebase Console** → Hosting
2. **Pour le site `kinecare-81f52` (website)** :
   - Cliquer "Add custom domain"
   - Entrer `medidesk.fr`
   - Suivre les instructions DNS

3. **Pour le site `medidesk-demo` (app)** :
   - Cliquer "Add custom domain"
   - Entrer `demo.medidesk.fr`
   - Suivre les instructions DNS

#### Étape 5 : Déploiement

```bash
# Déployer le site vitrine uniquement
firebase deploy --only hosting:website

# Déployer l'application uniquement
flutter build web --release
firebase deploy --only hosting:app

# Déployer les deux
./deploy-multi-sites.sh
```

---

## 🔄 Option 2 : Serveur Unique avec Rewrites (SOLUTION ACTUELLE)

### Configuration Actuelle

```
demo.medidesk.fr/          → Application Flutter
demo.medidesk.fr/website/  → Site vitrine
```

### Avantages
✅ Simple à configurer  
✅ Un seul déploiement  
✅ Fonctionne immédiatement

### Inconvénients
❌ URLs pas idéales (`/website/` dans l'URL)  
❌ Pas de séparation propre  
❌ Cache et optimisations partagés

### Pour Migrer vers Option 1

Actuellement, vous utilisez cette option. Pour passer à l'Option 1 (multi-sites), suivez les étapes ci-dessus.

---

## 🛠️ Scripts de Déploiement

### Script Multi-Sites (`deploy-multi-sites.sh`)

```bash
#!/bin/bash

set -e

echo "🚀 Déploiement Multi-Sites MediDesk"
echo "===================================="
echo ""

# Build Flutter
echo "📦 Build Flutter Web..."
flutter build web --release
echo "✅ Build réussi"
echo ""

# Déployer le site vitrine
echo "🌐 Déploiement du site vitrine (medidesk.fr)..."
firebase deploy --only hosting:website --project kinecare-81f52
echo "✅ Site vitrine déployé"
echo ""

# Déployer l'application
echo "📱 Déploiement de l'application (demo.medidesk.fr)..."
firebase deploy --only hosting:app --project kinecare-81f52
echo "✅ Application déployée"
echo ""

echo "===================================="
echo "✅ Déploiement terminé !"
echo "===================================="
echo ""
echo "🌐 URLs :"
echo "   Site vitrine : https://medidesk.fr"
echo "   Application  : https://demo.medidesk.fr"
echo ""
```

---

## 📊 Comparaison des Options

| Critère | Option 1 (Multi-Sites) | Option 2 (Rewrites) |
|---------|------------------------|---------------------|
| **URLs** | ✅ Propres | ❌ `/website/` |
| **Séparation** | ✅ Complète | ❌ Partagée |
| **Configuration** | ⚠️ Complexe | ✅ Simple |
| **Déploiements** | ✅ Indépendants | ❌ Unique |
| **SEO** | ✅ Optimal | ⚠️ Acceptable |

---

## 🎯 Recommandation

**Pour production** : Utiliser l'Option 1 (Multi-Sites)  
**Pour développement/test** : L'Option 2 actuelle fonctionne

---

## 📝 Configuration DNS Requise

### Pour `medidesk.fr`
```
Type: A
Nom: @
Valeur: 151.101.1.195, 151.101.65.195

Type: A
Nom: www
Valeur: 151.101.1.195, 151.101.65.195
```

### Pour `demo.medidesk.fr`
```
Type: A
Nom: demo
Valeur: 151.101.1.195, 151.101.65.195
```

*Note : Les IPs peuvent varier, Firebase Console vous donnera les valeurs exactes.*

---

**Dernière mise à jour** : 27 Novembre 2025  
**Statut** : Option 2 active, migration vers Option 1 recommandée
