# 🚀 Installation Backend Local KinéCare

## 📋 Prérequis

### Logiciels nécessaires

| Logiciel | Version minimale | Installation |
|----------|------------------|--------------|
| **Python** | 3.8+ | [python.org](https://www.python.org/downloads/) |
| **pip** | Inclus avec Python | Vérifié avec `pip --version` |

### Vérification de l'installation

```bash
# Vérifier Python (doit afficher 3.8 ou supérieur)
python --version

# Ou sur certains systèmes
python3 --version

# Vérifier pip
pip --version
```

---

## ⚡ Installation Rapide (3 minutes)

### **Étape 1 : Télécharger le projet**

```bash
# Option A : Cloner depuis GitHub
git clone https://github.com/RBSoftwareAI/kine.git
cd kine/backend

# Option B : Télécharger le ZIP
# Extraire le fichier ZIP, puis :
cd chemin/vers/kine/backend
```

### **Étape 2 : Installer les dépendances**

```bash
# Installer les packages Python requis
pip install -r requirements.txt

# Ou avec python3 si nécessaire
python3 -m pip install -r requirements.txt
```

**Packages installés :**
- `Flask` - Framework web léger
- `Flask-CORS` - Gestion des requêtes cross-origin
- `PyJWT` - Authentification par tokens
- `bcrypt` - Hashage sécurisé des mots de passe
- `python-dateutil` - Manipulation des dates

### **Étape 3 : Démarrer le serveur**

```bash
# Démarrer l'API locale
python api/app.py

# Ou avec python3
python3 api/app.py
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

 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:8080
```

### **Étape 4 : Tester l'installation**

**Ouvrir dans le navigateur :**
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

## 🏢 Installation Cabinet Médical (Réseau Local)

### Configuration serveur principal

**Sur l'ordinateur qui sera le serveur (PC Salle 1) :**

1. **Installer Python et les dépendances** (comme ci-dessus)

2. **Créer les comptes demo initiaux** :
   ```bash
   python -c "from api.app import auth_service; auth_service.create_demo_accounts()"
   ```

3. **Démarrer le serveur en production** :
   ```bash
   # Mode production (sans debug)
   python api/app.py --no-debug
   ```

4. **Noter l'adresse IP du serveur** :
   ```bash
   # Windows
   ipconfig
   # Rechercher "Adresse IPv4" (ex: 192.168.1.10)
   
   # Linux/macOS
   ip addr show
   # ou
   ifconfig
   ```

### Configuration postes secondaires

**Sur les autres ordinateurs (PC Salle 2, 3...) :**

1. **Ouvrir un navigateur web**
2. **Accéder à l'application** :
   ```
   http://192.168.1.10:8080
   ```
   *(Remplacer `192.168.1.10` par l'IP du serveur)*

3. **Tester la connexion** :
   ```
   http://192.168.1.10:8080/api/health
   ```

### Configuration smartphones (Wi-Fi interne)

**Sur les smartphones des kinés/coachs :**

1. **Connecter au Wi-Fi du cabinet**
2. **Ouvrir le navigateur mobile**
3. **Accéder à l'application** :
   ```
   http://192.168.1.10:8080
   ```

**Installation raccourci bureau (optionnel) :**
- Sur Android : Menu navigateur → "Ajouter à l'écran d'accueil"
- Sur iOS : Bouton Partage → "Sur l'écran d'accueil"

---

## 🗄️ Structure Base de Données

La base de données SQLite est créée automatiquement au premier démarrage :

```
backend/data/kinecare.db
```

**Tables créées automatiquement :**
- `users` - Comptes utilisateurs (patients, kinés, coachs)
- `patients` - Informations patients
- `pain_points` - Points de douleur actuels
- `pain_history` - Historique temporel
- `pain_sessions` - Séances thérapeutiques
- `pathologies` - Pathologies diagnostiquées
- `pathology_stats` - Cache statistiques
- `audit_logs` - Traçabilité RGPD

**Vues SQL :**
- `v_pathology_healing_times` - Temps de guérison par pathologie
- `v_pain_evolution` - Évolution des douleurs

---

## 👥 Comptes Demo

**Créés automatiquement au premier démarrage :**

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Patient** | patient@demo.com | patient123 |
| **Kiné** | kine@demo.com | kine123 |
| **Coach APA** | coach@demo.com | coach123 |

---

## 🔧 Configuration Avancée

### Changer le port par défaut (8080)

**Éditer `backend/api/app.py` :**
```python
# Ligne finale du fichier
app.run(
    host='0.0.0.0',
    port=9000,  # Modifier ici (ex: 9000)
    debug=True
)
```

### Activer HTTPS (connexion sécurisée)

```bash
# Générer un certificat auto-signé
openssl req -x509 -newkey rsa:4096 -nodes \
  -out cert.pem -keyout key.pem -days 365
```

**Éditer `backend/api/app.py` :**
```python
# Ajouter à la fin
if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=8443,
        ssl_context=('cert.pem', 'key.pem')
    )
```

### Changer l'emplacement de la base de données

**Éditer `backend/database/db_manager.py` :**
```python
def __init__(self, db_path: str = None):
    if db_path is None:
        # Modifier le chemin ici
        db_path = "/chemin/personnalise/kinecare.db"
    # ...
```

---

## 🛠️ Dépannage

### Erreur : "Port 8080 already in use"

**Solution :**
```bash
# Trouver le processus utilisant le port
lsof -i :8080

# Tuer le processus
kill -9 <PID>

# Ou utiliser un autre port (voir Configuration Avancée)
```

### Erreur : "Module not found: flask"

**Solution :**
```bash
# Réinstaller les dépendances
pip install --force-reinstall -r requirements.txt
```

### Base de données corrompue

**Solution :**
```bash
# Sauvegarder l'ancienne base
mv backend/data/kinecare.db backend/data/kinecare.db.backup

# Redémarrer le serveur (créera une nouvelle base)
python api/app.py
```

### Accès refusé depuis un autre ordinateur

**Vérifications :**

1. **Pare-feu Windows** :
   - Ouvrir "Pare-feu Windows Defender"
   - "Paramètres avancés" → "Règles de trafic entrant"
   - Créer une nouvelle règle pour le port 8080

2. **Adresse IP correcte** :
   ```bash
   # Vérifier que le serveur écoute sur 0.0.0.0
   netstat -an | grep 8080
   ```

3. **Réseau local** :
   - Vérifier que tous les appareils sont sur le même réseau Wi-Fi
   - Essayer de ping le serveur : `ping 192.168.1.10`

---

## 📊 Vérification Statistiques

**Tester l'endpoint des statistiques :**

```bash
# Récupérer les statistiques de pathologies
curl http://localhost:8080/api/stats/pathologies

# Ou dans le navigateur
http://localhost:8080/api/stats/pathologies
```

**Réponse attendue :**
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
      }
    }
  ]
}
```

---

## 🔒 Sécurité

### Recommandations production

1. **Changer la clé secrète JWT** :
   ```python
   # Dans backend/services/auth_service.py
   def __init__(self, db_manager, secret_key='CHANGER_CETTE_CLE_SECRETE'):
   ```

2. **Désactiver le mode debug** :
   ```python
   app.run(debug=False)  # En production
   ```

3. **Configurer HTTPS** (voir Configuration Avancée)

4. **Sauvegardes régulières** :
   ```bash
   # Créer une sauvegarde quotidienne
   cp backend/data/kinecare.db backend/backups/kinecare_$(date +%Y%m%d).db
   ```

---

## 📞 Support

**Problème non résolu ?**

1. Vérifier les logs du serveur (affichés dans le terminal)
2. Consulter la documentation complète dans `docs/`
3. Contacter le support technique

---

## ✅ Checklist Installation Cabinet

- [ ] Python 3.8+ installé
- [ ] Dépendances installées (`pip install -r requirements.txt`)
- [ ] Serveur démarre sans erreur
- [ ] `/api/health` retourne "healthy"
- [ ] Comptes demo créés
- [ ] Accessible depuis navigateur local
- [ ] Accessible depuis autre PC du réseau local
- [ ] Pare-feu configuré si nécessaire
- [ ] IP du serveur notée et communiquée à l'équipe
- [ ] Raccourcis créés sur les postes secondaires

**Installation complète ! 🎉**
