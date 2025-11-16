# 🚀 Guide de Déploiement MediDesk

Ce guide explique comment déployer **MediDesk** sur **www.medidesk.fr** avec :
- **Frontend Flutter** sur **Vercel** (gratuit)
- **Backend Flask** sur **Railway.app** (gratuit 500h/mois)

---

## 📋 Prérequis

✅ Domaine `medidesk.fr` acheté sur Gandi.net  
✅ Compte GitHub avec dépôt : https://github.com/RBSoftwareAI/kine  
✅ Compte Vercel (gratuit) : https://vercel.com  
✅ Compte Railway (gratuit) : https://railway.app  

---

## 🎯 ÉTAPE 1 : Déployer le Frontend Flutter sur Vercel

### 1.1 Connexion GitHub → Vercel

1. **Aller sur Vercel** : https://vercel.com/login
2. **Se connecter avec GitHub**
3. **Importer le projet** :
   - Cliquer "Add New..." → "Project"
   - Sélectionner le dépôt : `RBSoftwareAI/kine`
   - Cliquer "Import"

### 1.2 Configuration Vercel

**Build Settings :**
```
Framework Preset: Other
Build Command: (laisser vide - déjà compilé)
Output Directory: build/web
Install Command: (laisser vide)
```

**Root Directory :** Laisser `./` (racine du projet)

**Environment Variables :** Aucune nécessaire pour le frontend

Cliquer **"Deploy"** ✅

### 1.3 Récupérer l'URL Vercel

Une fois déployé, Vercel vous donnera une URL type :
```
https://medidesk-xxxx.vercel.app
```

**Notez cette URL** - on va configurer le domaine custom ensuite.

---

## 🔧 ÉTAPE 2 : Déployer le Backend Flask sur Railway

### 2.1 Connexion GitHub → Railway

1. **Aller sur Railway** : https://railway.app/new
2. **Se connecter avec GitHub**
3. **Deploy from GitHub repo** :
   - Sélectionner `RBSoftwareAI/kine`
   - Railway détecte automatiquement le backend Python

### 2.2 Configuration Railway

Railway va :
- ✅ Détecter `backend/requirements.txt`
- ✅ Installer les dépendances Python
- ✅ Lancer `python3 start_server.py` (via Procfile)

**Variables d'environnement à configurer :**

```bash
PORT=8080
FLASK_ENV=production
DATABASE_PATH=/app/data/medidesk.db
SECRET_KEY=[générer une clé aléatoire]
```

Pour générer SECRET_KEY :
```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

### 2.3 Récupérer l'URL Railway

Une fois déployé, Railway vous donnera une URL type :
```
https://medidesk-backend-production.up.railway.app
```

**Notez cette URL** - c'est l'URL de votre API backend.

### 2.4 Tester l'API Backend

Vérifier que l'API fonctionne :
```bash
curl https://medidesk-backend-production.up.railway.app/api/health
```

Devrait retourner :
```json
{"status": "ok", "version": "1.0.0"}
```

---

## 🌐 ÉTAPE 3 : Configurer le Domaine medidesk.fr

### 3.1 Configuration DNS sur Gandi

Connectez-vous sur **Gandi.net** → Domaines → `medidesk.fr` → DNS

**Supprimer les enregistrements existants** (sauf MX si vous avez des emails)

**Ajouter ces enregistrements DNS :**

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| **A** | @ | `76.76.21.21` | 10800 |
| **CNAME** | www | `cname.vercel-dns.com.` | 10800 |
| **CNAME** | api | `medidesk-backend-production.up.railway.app.` | 10800 |

**Explication :**
- `@` (domaine racine) → Vercel IP
- `www` → Alias vers Vercel
- `api` → Pointe vers le backend Railway

### 3.2 Ajouter le Domaine dans Vercel

1. **Dans Vercel** → Projet MediDesk → **Settings** → **Domains**
2. **Add Domain** :
   - `medidesk.fr`
   - `www.medidesk.fr`
3. Vercel vérifie automatiquement la configuration DNS
4. Attendre 5-10 minutes pour propagation DNS

### 3.3 Vérifier la Configuration

**Tester le frontend :**
```bash
https://www.medidesk.fr
https://medidesk.fr  (redirection automatique vers www)
```

**Tester le backend :**
```bash
https://api.medidesk.fr/api/health
```

---

## 🔄 ÉTAPE 4 : Configurer les URLs dans Flutter

Mettre à jour l'URL du backend dans Flutter :

**Fichier : `lib/repositories/local_repository.dart`**

```dart
class LocalRepository implements DataRepository {
  // Changer de localhost vers l'URL Railway
  String baseUrl;
  
  LocalRepository({this.baseUrl = 'https://api.medidesk.fr'});
  
  // Reste du code...
}
```

**Rebuild et redéployer :**

```bash
# 1. Reconstruire Flutter
flutter build web --release

# 2. Commit les changements
git add .
git commit -m "config: URL backend production Railway"
git push origin main

# 3. Vercel redéploie automatiquement
```

---

## ✅ ÉTAPE 5 : Tests de Production

### 5.1 Test Frontend

1. **Aller sur** : https://www.medidesk.fr
2. **Vérifier** :
   - Page de login s'affiche correctement
   - Design orange/noir intact
   - Silhouettes anatomiques chargées

### 5.2 Test Backend (Comptes Demo)

**Connexion Kinésithérapeute :**
```
Email: marie.dubois@demo.com
Mot de passe: demo123
```

**Connexion Coach APA :**
```
Email: pierre.leroy@demo.com
Mot de passe: demo123
```

**Connexion Patient :**
```
Email: jean.dupont@demo.com
Mot de passe: demo123
```

### 5.3 Checklist Fonctionnelle

- [ ] Connexion fonctionne
- [ ] Dashboard s'affiche
- [ ] Silhouettes anatomiques cliquables
- [ ] Graphiques d'évolution affichés
- [ ] Statistiques pathologies accessibles
- [ ] Navigation entre pages fluide

---

## 🔐 ÉTAPE 6 : Sécurité Production

### 6.1 Variables Sensibles

**Railway Environment Variables** (déjà configuré) :
- `SECRET_KEY` : Clé JWT aléatoire
- `ENCRYPTION_KEY` : Pour SQLCipher (si activé)
- `ALLOWED_ORIGINS` : `https://www.medidesk.fr,https://medidesk.fr`

### 6.2 CORS Backend

**Fichier : `backend/api/app.py`**

```python
from flask_cors import CORS

# Configuration CORS production
CORS(app, resources={
    r"/api/*": {
        "origins": [
            "https://www.medidesk.fr",
            "https://medidesk.fr",
            "http://localhost:*"  # Pour tests locaux
        ],
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"]
    }
})
```

---

## 📊 Monitoring & Logs

### Railway Logs

**Voir les logs backend :**
```bash
# Dans Railway Dashboard → Deployments → View Logs
```

**Ou via Railway CLI :**
```bash
npm install -g @railway/cli
railway login
railway logs
```

### Vercel Logs

**Dashboard Vercel** → Projet MediDesk → **Deployments** → Logs

---

## 💰 Coûts Mensuels

| Service | Plan | Coût |
|---------|------|------|
| **Vercel** | Hobby (gratuit) | 0€ |
| **Railway** | 500h/mois gratuit | 0€ |
| **Domaine medidesk.fr** | Gandi | 1€/mois (~12€/an) |
| **TOTAL** | - | **~1€/mois** |

**Si dépassement Railway (>500h) :**
- Passer au plan Developer : 5$/mois (~5€)
- **Total : ~6€/mois**

---

## 🔄 Déploiements Futurs

### Mise à jour automatique

**Workflow actuel :**
1. Faire des modifications en local
2. `git commit -m "description"`
3. `git push origin main`
4. **Vercel** redéploie automatiquement le frontend ✅
5. **Railway** redéploie automatiquement le backend ✅

**Temps de déploiement :**
- Vercel : 30 secondes - 2 minutes
- Railway : 2-5 minutes

---

## 🆘 Dépannage

### Problème : "Cannot connect to backend"

**Solution :**
1. Vérifier que Railway backend est déployé : https://api.medidesk.fr/api/health
2. Vérifier les logs Railway pour erreurs
3. Vérifier CORS configuration dans `backend/api/app.py`

### Problème : "Domain not configured"

**Solution :**
1. Attendre 10-30 minutes propagation DNS
2. Vérifier enregistrements DNS sur Gandi :
   ```bash
   dig www.medidesk.fr
   dig api.medidesk.fr
   ```
3. Re-vérifier domaine dans Vercel Settings

### Problème : "Database not found"

**Solution :**
1. Railway crée une base SQLite éphémère
2. Pour persistance, utiliser Railway Volumes :
   - Railway Dashboard → Service → Variables → Add Volume
   - Mount Path : `/app/data`
3. Ou utiliser PostgreSQL Railway (plan payant)

---

## 📞 Support Déploiement

**Documentation Vercel :** https://vercel.com/docs  
**Documentation Railway :** https://docs.railway.app  
**Documentation Gandi DNS :** https://docs.gandi.net/fr/domaines/  

**GitHub Issues :** https://github.com/RBSoftwareAI/kine/issues  

---

## ✅ Résumé Final

Une fois tous les déploiements terminés :

✅ **Frontend** : https://www.medidesk.fr (Vercel)  
✅ **Backend** : https://api.medidesk.fr (Railway)  
✅ **Domaine** : medidesk.fr (Gandi DNS)  
✅ **Coût** : ~1€/mois  
✅ **Déploiement** : Automatique via Git push  

**🎉 Votre application MediDesk est maintenant en ligne !**

---

**Version 1.0.0 - Janvier 2025**
