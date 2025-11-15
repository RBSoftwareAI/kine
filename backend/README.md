# 🏥 KinéCare - Backend Local

**Serveur API REST autonome pour stockage local des données de santé**

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://python.org)
[![Flask](https://img.shields.io/badge/Flask-3.0.0-green)](https://flask.palletsprojects.com)
[![SQLite](https://img.shields.io/badge/SQLite-3-orange)](https://sqlite.org)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 🎯 Objectif

Backend léger et autonome pour **éviter les coûts d'hébergement HDS** (100-200€/mois) tout en restant **100% conforme RGPD**.

**Solution :** Stockage local SQLite + API Flask accessible sur réseau local uniquement.

---

## ✨ Fonctionnalités

### 🔐 Authentification Sécurisée
- Authentification JWT avec expiration 24h
- Hash bcrypt pour les mots de passe
- Gestion rôles (patient, kiné, coach, admin)

### 📊 Gestion des Douleurs
- CRUD complet points de douleur
- Historique temporel avec graphiques
- 21 zones anatomiques supportées
- Intensité 0-10 normalisée

### 📈 Statistiques Intelligentes
- **Temps de guérison par pathologie** (moyenne, min, max)
- **Taux d'amélioration patients** (points/semaine)
- **Évolution temporelle** avec tendances
- **Dashboard cabinet** temps réel
- **K-anonymat (≥5)** pour partage inter-cabinets

### 🔍 Traçabilité RGPD
- Audit logs complets (qui/quoi/quand)
- 10 types d'actions tracées
- Conservation 3 ans
- Preuve juridique

---

## 📂 Structure

```
backend/
├── api/
│   └── app.py              # API REST Flask principale
├── database/
│   ├── schema.sql          # Schéma SQLite (8 tables + 2 vues)
│   └── db_manager.py       # Gestionnaire base de données
├── services/
│   ├── auth_service.py     # Authentification JWT
│   ├── pain_service.py     # Gestion douleurs
│   └── stats_service.py    # Calcul statistiques
├── data/
│   └── kinecare.db         # Base SQLite (créée automatiquement)
├── requirements.txt        # Dépendances Python
├── INSTALLATION.md         # Guide installation détaillé
├── INTEGRATION_FLUTTER.md  # Intégration avec Flutter
├── DEMO_DATA.py            # Génération données demo
└── README.md               # Ce fichier
```

---

## 🚀 Installation Rapide (3 minutes)

### Prérequis
- Python 3.8+ ([Télécharger](https://python.org/downloads))
- pip (inclus avec Python)

### Installation

```bash
# 1. Cloner le projet
git clone https://github.com/RBSoftwareAI/kine.git
cd kine/backend

# 2. Installer les dépendances
pip install -r requirements.txt

# 3. (Optionnel) Générer données demo
python DEMO_DATA.py

# 4. Démarrer le serveur
python api/app.py
```

**Sortie attendue :**
```
============================================================
🏥 KinéCare - Backend Local Démarré
============================================================
📍 URL: http://localhost:8080
🗄️  Base de données: /chemin/vers/backend/data/kinecare.db
🔒 Données 100% locales - Aucune connexion Internet requise
📊 Statistiques temps guérison: Activées
============================================================
```

### Test

**Navigateur :**
```
http://localhost:8080/api/health
```

**Réponse attendue :**
```json
{
  "status": "healthy",
  "service": "KinéCare Local Backend",
  "version": "1.0.0",
  "database": "connected"
}
```

✅ **Installation réussie !**

---

## 🌐 Configuration Réseau Local

### Pour plusieurs PC + smartphones dans le cabinet

**1. Trouver l'IP du serveur**

```bash
# Windows
ipconfig
# Rechercher "Adresse IPv4" (ex: 192.168.1.10)

# Linux/macOS
ip addr show
# ou
ifconfig
```

**2. Démarrer le serveur (écoute sur toutes les interfaces)**

Le serveur écoute déjà sur `0.0.0.0:8080` par défaut.

**3. Accès depuis autres appareils**

```
http://192.168.1.10:8080/api/health
```

**4. Configurer Flutter**

Dans `lib/services/local_api_service.dart` :
```dart
static const String baseUrl = 'http://192.168.1.10:8080/api';
```

---

## 📊 API Endpoints

### Authentification

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/api/auth/login` | Connexion utilisateur |
| `POST` | `/api/auth/register` | Inscription |
| `GET` | `/api/auth/verify` | Vérification token JWT |

### Douleurs

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/pain/points/<patient_id>` | Points de douleur actuels |
| `POST` | `/api/pain/points` | Créer nouveau point |
| `GET` | `/api/pain/history/<patient_id>` | Historique temporel |
| `GET` | `/api/pain/evolution/<patient_id>` | Données graphiques |

### Statistiques

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/stats/pathologies` | Temps guérison par pathologie |
| `GET` | `/api/stats/cabinet` | Vue d'ensemble cabinet |
| `GET` | `/api/stats/improvement/<patient_id>` | Taux amélioration |

### Monitoring

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/health` | Vérification santé serveur |
| `GET` | `/api/info` | Informations application |

**Documentation complète :** Voir `INTEGRATION_FLUTTER.md`

---

## 🗄️ Base de Données SQLite

### Tables Principales

| Table | Description | Lignes estimées |
|-------|-------------|-----------------|
| `users` | Comptes utilisateurs | 50-100 |
| `patients` | Informations patients | 30-50 |
| `pain_points` | Points douleur actuels | 500-1000 |
| `pain_history` | Historique temporel | 5000-10000 |
| `pain_sessions` | Séances thérapeutiques | 1000-2000 |
| `pathologies` | Pathologies diagnostiquées | 50-100 |
| `pathology_stats` | Cache statistiques | 10-20 |
| `audit_logs` | Traçabilité RGPD | 10000+ |

### Vues SQL Automatiques

- `v_pathology_healing_times` - Calcul temps guérison
- `v_pain_evolution` - Évolution avec tendances

**Taille estimée base :** 10-50 Mo (production)

---

## 📈 Exemple Statistiques

```python
# Temps de guérison par pathologie
GET /api/stats/pathologies
```

**Réponse :**
```json
{
  "success": true,
  "stats": [
    {
      "pathology": "Lombalgie chronique",
      "totalCases": 12,
      "averageHealingTime": {
        "days": 45.2,
        "weeks": 6.5
      },
      "minHealingTime": 30.0,
      "maxHealingTime": 90.0
    },
    {
      "pathology": "Cervicalgie",
      "totalCases": 8,
      "averageHealingTime": {
        "days": 38.7,
        "weeks": 5.5
      }
    }
  ]
}
```

---

## 🔐 Sécurité

### Mesures Implémentées

| Mesure | Description | Statut |
|--------|-------------|--------|
| **JWT Authentication** | Tokens avec expiration 24h | ✅ |
| **Bcrypt Hashing** | Passwords sécurisés | ✅ |
| **SQLite Local** | Données jamais sur Internet | ✅ |
| **Audit Logs** | Traçabilité complète | ✅ |
| **CORS** | Accès contrôlé depuis Flutter | ✅ |

### Configuration Production

**1. Changer clé secrète JWT**

Éditer `backend/services/auth_service.py` :
```python
def __init__(self, db_manager, secret_key='VOTRE_CLE_SECRETE_ICI'):
```

**2. Désactiver mode debug**

Éditer `backend/api/app.py` :
```python
app.run(debug=False)  # En production
```

**3. Configurer HTTPS (optionnel)**

Voir `INSTALLATION.md` section "Configuration Avancée"

---

## 👥 Comptes Demo

Créés automatiquement avec `python DEMO_DATA.py` :

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Patient** | patient@demo.com | patient123 |
| **Kiné** | kine@demo.com | kine123 |
| **Coach APA** | coach@demo.com | coach123 |

**⚠️ Supprimer en production !**

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **INSTALLATION.md** | Guide installation détaillé avec dépannage |
| **INTEGRATION_FLUTTER.md** | Connexion Flutter + exemples code |
| **DEMO_DATA.py** | Script génération données réalistes |
| **../docs/architecture/ARCHITECTURE_HYBRIDE.md** | Vue d'ensemble architecture |

---

## 🔄 Maintenance

### Sauvegardes

**Automatique (recommandé) :**
```bash
# Ajouter au cron (Linux/macOS) ou tâches planifiées (Windows)
cp backend/data/kinecare.db backend/backups/kinecare_$(date +%Y%m%d).db
```

**Manuel :**
```bash
# Créer une sauvegarde
cp backend/data/kinecare.db backend/data/kinecare.db.backup

# Restaurer depuis sauvegarde
cp backend/data/kinecare.db.backup backend/data/kinecare.db
```

### Logs

**Logs serveur :**
- Affichés dans le terminal où `python api/app.py` est exécuté
- Rediriger vers fichier : `python api/app.py > server.log 2>&1`

**Logs audit (dans SQLite) :**
```sql
SELECT * FROM audit_logs 
WHERE timestamp >= date('now', '-7 days')
ORDER BY timestamp DESC;
```

---

## 🛠️ Dépannage

### Port 8080 déjà utilisé

```bash
# Trouver le processus
lsof -i :8080

# Tuer le processus
kill -9 <PID>

# Ou changer le port dans api/app.py
```

### Erreur "Module not found: flask"

```bash
pip install --force-reinstall -r requirements.txt
```

### Base corrompue

```bash
# Sauvegarder
mv backend/data/kinecare.db backend/data/kinecare.db.old

# Redémarrer (créera nouvelle base)
python api/app.py
```

**Plus de solutions :** Voir `INSTALLATION.md` section "Dépannage"

---

## 🎯 Avantages Architecture Locale

| Avantage | Description |
|----------|-------------|
| **💰 Coût zéro** | Pas d'hébergement cloud (économie 100-200€/mois) |
| **🔒 Sécurité max** | Données jamais sur Internet |
| **⚡ Performance** | Accès local ultra-rapide |
| **📊 Stats temps réel** | Calculs instantanés |
| **⚖️ RGPD compliant** | Pas besoin certification HDS |
| **🔧 Simple** | Installation 5 minutes |

---

## 🤝 Contribution

**Développé pour :** Cabinet Tourcoing (Test Pilote)  
**Contact :** RBSoftwareAI  
**Repository :** https://github.com/RBSoftwareAI/kine

---

## 📄 License

MIT License - Voir fichier LICENSE

---

## ✅ Checklist Mise en Production

**Installation**
- [ ] Python 3.8+ installé
- [ ] Dépendances installées
- [ ] Serveur démarre sans erreur
- [ ] Health check accessible

**Configuration**
- [ ] Clé JWT changée
- [ ] Mode debug désactivé
- [ ] Comptes demo supprimés
- [ ] Pare-feu configuré

**Réseau**
- [ ] IP serveur notée
- [ ] Accessible depuis autres PC
- [ ] Smartphones connectent au Wi-Fi
- [ ] URL configurée dans Flutter

**Sauvegardes**
- [ ] Sauvegarde manuelle testée
- [ ] Sauvegarde automatique configurée
- [ ] Procédure restauration documentée

**Documentation**
- [ ] Équipe formée à l'utilisation
- [ ] Documentation fournie
- [ ] Contact support disponible

**Production prête ! 🎉**
