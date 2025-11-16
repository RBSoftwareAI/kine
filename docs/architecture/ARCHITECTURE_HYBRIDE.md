# 🏗️ Architecture Hybride Locale + Cloud

## 📋 Vue d'ensemble

MediDesk utilise une **architecture hybride intelligente** qui combine :
- **Stockage local SQLite** pour les données de santé sensibles
- **Firebase Cloud (optionnel)** pour les données non-sensibles (rendez-vous, messagerie)

**Avantages :**
✅ **Zéro coût HDS** - Pas d'hébergement santé certifié requis  
✅ **Conformité RGPD** - Données santé jamais sur Internet  
✅ **Performance** - Accès local ultra-rapide  
✅ **Flexibilité** - Cloud pour services non-critiques  
✅ **Simplicité** - Installation plug & play

---

## 🏛️ Architecture Technique

```
┌─────────────────────────────────────────────────────────────┐
│                    CABINET TOURCOING                        │
│                                                             │
│  ┌──────────────┐      ┌──────────────┐                   │
│  │   PC Salle 1 │      │   PC Salle 2 │                   │
│  │ (Serveur)    │◄────►│              │                   │
│  │              │      │              │                   │
│  │ ┌──────────┐ │      │ ┌──────────┐ │                   │
│  │ │ SQLite   │ │      │ │ Browser  │ │                   │
│  │ │ Database │ │      │ │ Flutter  │ │                   │
│  │ └──────────┘ │      │ │ Web App  │ │                   │
│  │              │      │ └──────────┘ │                   │
│  │ ┌──────────┐ │      └──────────────┘                   │
│  │ │ Flask    │ │              ▲                          │
│  │ │ API      │ │              │                          │
│  │ └──────────┘ │              │                          │
│  └──────────────┘              │                          │
│         ▲                       │                          │
│         │                       │                          │
│         │  Wi-Fi Interne        │                          │
│         │                       │                          │
│  ┌──────┴───────┐      ┌───────┴──────┐                   │
│  │ Smartphone   │      │ Smartphone   │                   │
│  │ Kiné         │      │ Coach APA    │                   │
│  │              │      │              │                   │
│  │ ┌──────────┐ │      │ ┌──────────┐ │                   │
│  │ │ Flutter  │ │      │ │ Flutter  │ │                   │
│  │ │ Mobile   │ │      │ │ Mobile   │ │                   │
│  │ └──────────┘ │      │ └──────────┘ │                   │
│  └──────────────┘      └──────────────┘                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ Internet (optionnel)
                           ▼
                  ┌─────────────────┐
                  │  Firebase Cloud │
                  │  (Non-sensible) │
                  │                 │
                  │  - Rendez-vous  │
                  │  - Messagerie   │
                  │  - Stats agrégées│
                  └─────────────────┘
```

---

## 📊 Séparation des Données

### 🔒 Données LOCALES (SQLite - Jamais sur Internet)

| Type de donnée | Localisation | Raison |
|----------------|--------------|--------|
| **Zones de douleur** | SQLite local | Données santé Art. 9 RGPD |
| **Intensités 0-10** | SQLite local | Données santé sensibles |
| **Historique séances** | SQLite local | Suivi médical personnel |
| **Notes cliniques** | SQLite local | Secret médical |
| **Identité patient** | SQLite local | Données personnelles |
| **Photos avant/après** | SQLite local | Image médicale |
| **Pathologies** | SQLite local | Diagnostic médical |
| **Logs audit RGPD** | SQLite local | Traçabilité locale |

### ☁️ Données CLOUD (Firebase - Optionnel)

| Type de donnée | Localisation | Raison |
|----------------|--------------|--------|
| **Rendez-vous** | Firebase | Pas d'info santé, juste horaires |
| **Disponibilités** | Firebase | Planning partagé |
| **Messagerie pro** | Firebase | Communication équipe (pas cas cliniques) |
| **Stats anonymisées** | Firebase | Agrégation k-anonymat ≥ 5 |
| **Authentification** | Firebase Auth | Gestion comptes professionnels |

---

## 🗄️ Structure Base de Données Locale

### Tables SQLite

```sql
-- Utilisateurs (professionnels)
users (id, email, password_hash, first_name, last_name, role, phone)

-- Patients
patients (id, user_id, birth_year, gender, notes)

-- Points de douleur
pain_points (id, patient_id, zone, intensity, description, created_at)

-- Historique temporel
pain_history (id, patient_id, timestamp, average_intensity, zone_intensities)

-- Séances thérapeutiques
pain_sessions (id, patient_id, professional_id, session_date, notes, duration_minutes)

-- Pathologies diagnostiquées
pathologies (id, patient_id, pathology_name, diagnosis_date, primary_zone, 
             severity, status, resolution_date)

-- Statistiques (cache)
pathology_stats (id, pathology_name, total_cases, active_cases, resolved_cases,
                average_healing_days, average_improvement_rate)

-- Logs d'audit RGPD
audit_logs (id, user_id, action_type, target_type, target_id, 
            old_values, new_values, ip_address, timestamp)
```

### Vues SQL Automatiques

```sql
-- Temps de guérison par pathologie
v_pathology_healing_times
  → Calcule automatiquement avg/min/max healing days

-- Évolution des douleurs
v_pain_evolution
  → Suivi temporel avec calcul de tendances
```

---

## 🔧 API REST Locale (Flask)

### Endpoints Disponibles

**Authentification**
```
POST   /api/auth/login
POST   /api/auth/register
GET    /api/auth/verify
```

**Gestion des douleurs**
```
GET    /api/pain/points/<patient_id>
POST   /api/pain/points
GET    /api/pain/history/<patient_id>
GET    /api/pain/evolution/<patient_id>
```

**Statistiques**
```
GET    /api/stats/pathologies
GET    /api/stats/cabinet
GET    /api/stats/improvement/<patient_id>
```

**Monitoring**
```
GET    /api/health
GET    /api/info
```

---

## 📈 Statistiques Temps de Guérison

### Calculs Automatiques

**1. Temps moyen de guérison par pathologie**
```sql
AVG(resolution_date - diagnosis_date) WHERE status = 'resolved'
```

**2. Taux d'amélioration patient**
```python
improvement_rate = ((initial_intensity - final_intensity) / initial_intensity) * 100
```

**3. Points par semaine**
```python
points_per_week = (final_intensity - initial_intensity) / weeks_elapsed
```

**4. Statistiques agrégées cabinet**
- Nombre total de patients
- Nombre total de séances
- Intensité moyenne actuelle
- Top 5 zones de douleur
- Pathologies actives

### Exemple de Statistiques Générées

| Pathologie | Cas | Temps guérison moyen | Min | Max |
|------------|-----|---------------------|-----|-----|
| Lombalgie chronique | 12 | 45.2 jours (6.5 semaines) | 30j | 90j |
| Cervicalgie | 8 | 38.7 jours (5.5 semaines) | 20j | 60j |
| Tendinite épaule | 7 | 82.1 jours (11.7 semaines) | 40j | 120j |
| Gonalgie | 9 | 52.3 jours (7.5 semaines) | 30j | 90j |
| Sciatique | 6 | 76.5 jours (10.9 semaines) | 45j | 120j |

---

## 🔐 Sécurité et Conformité

### Mesures de Sécurité Locales

| Mesure | Description | Statut |
|--------|-------------|--------|
| **Authentification JWT** | Tokens sécurisés avec expiration 24h | ✅ Actif |
| **Bcrypt passwords** | Hash sécurisé des mots de passe | ✅ Actif |
| **SQLite local** | Données jamais exposées sur Internet | ✅ Actif |
| **Audit logs** | Traçabilité complète (qui/quoi/quand) | ✅ Actif |
| **Réseau interne** | Accessible uniquement Wi-Fi cabinet | ✅ Configuration |
| **Sauvegardes** | Backup quotidien fichier SQLite | 📝 À configurer |

### Conformité RGPD

**Traitements de données (Art. 30 RGPD) :**

1. **Suivi des douleurs** (Données santé - Art. 9 RGPD)
   - Base légale : Consentement explicite
   - Stockage : Local SQLite
   - Durée : Durée du suivi + 3 ans archives
   - Sécurité : Chiffrement au repos (filesystem)

2. **Traçabilité des modifications** (Audit logs)
   - Base légale : Obligation légale
   - Stockage : Local SQLite
   - Durée : 3 ans
   - Finalité : Preuve juridique

3. **Statistiques anonymisées** (Si partage inter-cabinets)
   - Base légale : Intérêt légitime
   - K-anonymat : ≥ 5 cas minimum
   - Stockage : Firebase (données agrégées uniquement)
   - Durée : 1 an

**Pas besoin HDS** : Données santé jamais hébergées sur serveur externe

---

## 🚀 Installation Cabinet

### Configuration Minimale

**Matériel requis :**
- 1 PC Windows/Linux/macOS (serveur principal)
- Wi-Fi sécurisé interne
- Optionnel : Plusieurs PC + smartphones

**Logiciels requis :**
- Python 3.8+ (gratuit)
- Navigateur web moderne
- 50 Mo d'espace disque

**Installation (5 minutes) :**

```bash
# 1. Télécharger le projet
git clone https://github.com/RBSoftwareAI/kine.git
cd kine/backend

# 2. Installer les dépendances
pip install -r requirements.txt

# 3. Générer les données demo (optionnel)
python DEMO_DATA.py

# 4. Démarrer le serveur
python api/app.py

# ✅ Serveur accessible sur http://localhost:8080
```

**Accès depuis autres appareils :**
1. Trouver l'IP du serveur : `ipconfig` (Windows) ou `ifconfig` (Linux/Mac)
2. Accéder depuis navigateur : `http://192.168.1.10:8080`
3. Installer raccourci bureau pour application web

---

## 📊 Cas d'Usage : Statistiques Inter-Cabinets (Optionnel)

### Scénario

> **Patient appelle** : "J'ai des douleurs lombaires chroniques, quel cabinet peut m'aider ?"
>
> **Système suggère** : "Cabinet B spécialisé lombalgie : 82% amélioration moyenne, 6.2 semaines guérison moyenne"

### Architecture Stats Partagées

```
Cabinet A (Tourcoing)          Cabinet B (Lille)
    │                               │
    │ Stats anonymisées             │ Stats anonymisées
    │ (k-anonymat ≥ 5)             │ (k-anonymat ≥ 5)
    │                               │
    └───────────┬───────────────────┘
                │
                ▼
        ┌──────────────┐
        │   Firebase    │
        │   Firestore   │
        │               │
        │ Agrégation    │
        │ Statistiques  │
        └──────────────┘
                │
                ▼
        Dashboard Public
        (Orientation patients)
```

### Exemple Données Partagées

```json
{
  "cabinet_id": "cabinet_tourcoing",
  "specializations": [
    {
      "pathology": "Lombalgie chronique",
      "case_range": "10-20",
      "avg_healing_weeks": 6.5,
      "improvement_rate": 82,
      "last_updated": "2024-01-15"
    }
  ],
  "total_patients_range": "50-100",
  "k_anonymity": 5
}
```

**Garanties k-anonymat :**
- Minimum 5 cas par pathologie
- Comptes exacts remplacés par intervalles
- Aucune donnée patient identifiable
- Agrégation uniquement

---

## 🔄 Migration Future (Phase 2)

Si commercialisation nécessaire :

**Option 1 : Conserver architecture locale (recommandé)**
- Chaque cabinet son propre serveur local
- Pas de coût HDS
- Données toujours locales
- Statistiques partagées via Firebase (anonymisées)

**Option 2 : Migration HDS (si hébergement centralisé requis)**
- OVHcloud Health Data (100-200€/mois)
- Certification HDS obtenue
- Migration via plan migration (voir `docs/migration/PLAN_MIGRATION_HDS.md`)
- Durée estimée : 13 semaines

**Recommandation : Conserver architecture locale**
- Coût : Gratuit (pas d'abonnement mensuel)
- Conformité : RGPD respecté sans HDS
- Performance : Meilleure (réseau local)
- Simplicité : Pas de migration complexe

---

## ✅ Checklist Déploiement Cabinet

**Prérequis**
- [ ] PC serveur identifié (Windows/Linux/macOS)
- [ ] Wi-Fi interne sécurisé disponible
- [ ] Python 3.8+ installé
- [ ] IP serveur notée et communiquée

**Installation Backend**
- [ ] Backend téléchargé
- [ ] Dépendances installées
- [ ] Données demo générées (test)
- [ ] Serveur démarre sans erreur
- [ ] Health check accessible

**Configuration Réseau**
- [ ] Pare-feu configuré (port 8080)
- [ ] Serveur accessible depuis autres PC
- [ ] Smartphones connectent au Wi-Fi
- [ ] Application web accessible depuis mobiles

**Configuration Flutter**
- [ ] URL API configurée (IP serveur)
- [ ] Test connexion réussi
- [ ] Login démo fonctionne
- [ ] Statistiques accessibles

**Production**
- [ ] Comptes réels créés
- [ ] Comptes demo supprimés
- [ ] Sauvegardes configurées
- [ ] Documentation fournie à l'équipe
- [ ] Formation utilisateurs effectuée

**Déploiement complet ! 🎉**

---

## 📞 Support Technique

**Documentation disponible :**
- `backend/INSTALLATION.md` - Guide installation détaillé
- `backend/INTEGRATION_FLUTTER.md` - Intégration Flutter
- `docs/test_pilot/PROTOCOLE_TEST_PILOTE.md` - Protocole test cabinet

**Fichiers de configuration :**
- `backend/requirements.txt` - Dépendances Python
- `backend/database/schema.sql` - Structure base de données
- `backend/api/app.py` - API REST principale

**En cas de problème :**
1. Vérifier les logs serveur (terminal)
2. Tester `/api/health` endpoint
3. Consulter `backend/INSTALLATION.md` section Dépannage
