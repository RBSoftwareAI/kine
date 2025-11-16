# 🏗️ MediDesk - Architecture Hybride Local + Cloud

## 📊 Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                    CABINET DE TOURCOING                      │
│                    Réseau Local (LAN)                        │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  🖥️  PC Principal Salle de Soin                      │  │
│  │                                                        │  │
│  │  ┌──────────────────────────────────────────────┐    │  │
│  │  │  MediDesk Server (Python Flask)             │    │  │
│  │  │  • Port 8080 (configurable)                 │    │  │
│  │  │  • API REST complète                        │    │  │
│  │  │  • SQLite database (données santé)          │    │  │
│  │  │  • Flutter Web interface                    │    │  │
│  │  └──────────────────────────────────────────────┘    │  │
│  │                                                        │  │
│  │  📊 Données Locales (JAMAIS sur Internet):           │  │
│  │  • Zones de douleur patients                         │  │
│  │  • Intensités (0-10)                                  │  │
│  │  • Historique séances                                 │  │
│  │  • Notes cliniques                                    │  │
│  │  • Informations personnelles                          │  │
│  │  • Audit logs (traçabilité RGPD)                      │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
│                    ↓ Wi-Fi Interne Cabinet                   │
│                                                               │
│  ┌──────────┬──────────┬──────────┬──────────┐             │
│  │ 🖥️ PC #2 │ 🖥️ PC #3 │ 📱 iPad  │ 📱 Phone │             │
│  │  Kiné    │  Coach   │  Kiné    │  Coach   │             │
│  └──────────┴──────────┴──────────┴──────────┘             │
│                                                               │
│  Accès: http://192.168.x.x:8080/                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Internet (optionnel)
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    ☁️  FIREBASE CLOUD                        │
│                    (Données NON-sensibles)                   │
│                                                               │
│  ✅ Authentification professionnels                          │
│  ✅ Calendrier rendez-vous (pseudonymes)                     │
│  ✅ Statistiques anonymisées inter-cabinets                  │
│  ✅ Notifications push                                        │
│  ❌ AUCUNE donnée santé identifiante                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Répartition des Données

### 🔒 Stockage Local (SQLite) - DONNÉES SENSIBLES

| Table | Contenu | Rétention |
|-------|---------|-----------|
| **users** | Comptes patients/kinés/coachs | Actif |
| **pain_points** | Zones douleur + intensités (0-10) | Illimitée |
| **pain_sessions** | Séances + amélioration | Illimitée |
| **audit_logs** | Traçabilité RGPD complète | 3 ans |
| **pathology_stats** | Stats anonymisées (k≥5) | 1 an |
| **cabinet_config** | Configuration cabinet | Permanente |

**📍 Emplacement:** `data/medidesk.db` (local uniquement)  
**💾 Sauvegardes:** `data/backups/` (hebdomadaire automatique)  
**🔐 Accès:** Réseau local uniquement (pas Internet)

---

### ☁️ Stockage Cloud (Firebase) - DONNÉES NON-SENSIBLES

| Collection | Contenu | Rétention |
|------------|---------|-----------|
| **appointments** | Rendez-vous (pseudonymes) | 6 mois |
| **cabinet_stats** | Stats anonymisées (k≥5) | 1 an |
| **professional_auth** | Authentification pros | Actif |
| **notifications** | Notifications métier | 30 jours |

**⚠️ RÈGLE CRITIQUE:** Aucune donnée permettant identification patient

---

## 🔧 Stack Technique

### Backend Local

```python
# Serveur Flask REST
- Flask 3.0.0 (API REST)
- Flask-CORS (accès multi-appareils)
- Flask-JWT-Extended (authentification)
- SQLAlchemy 2.0.23 (ORM)
- SQLite 3 (base de données)

# Statistiques
- NumPy 1.26.2 (calculs)
- Pandas 2.1.3 (analyses)

# Déploiement
- PyInstaller 6.3.0 (executable standalone)
```

### Frontend Flutter

```yaml
# Core
flutter: 3.35.4
dart: 3.9.2

# State Management
provider: 6.1.5+1

# Network
http: 1.5.0 (API REST locale)

# Storage
shared_preferences: 2.5.3 (tokens JWT)

# UI
fl_chart: 0.69.0 (graphiques)
```

### Repository Pattern

```dart
// Interface abstraite
abstract class DataRepository {
  Future<UserModel?> signIn(String email, String password);
  Future<List<PainPoint>> getPainPoints(String patientId);
  // ...
}

// Implémentation locale (Flask API)
class LocalRepository implements DataRepository { ... }

// Implémentation cloud (Firebase - optionnel)
class CloudRepository implements DataRepository { ... }
```

---

## 📡 Endpoints API REST

### Base URL: `http://localhost:8080/api/`

**🔑 Authentication**
```
POST /auth/login
  Body: { email, password }
  Response: { user, access_token }

GET /auth/me
  Headers: { Authorization: "Bearer <token>" }
  Response: { user }
```

**👥 Users**
```
GET /users?role=patient
  Response: [ { id, email, first_name, last_name, role, ... } ]

POST /users
  Body: { email, password, first_name, last_name, role, ... }
  Response: { user }
```

**💉 Pain Points**
```
GET /pain-points?patient_id=<id>
  Response: [ { id, zone, intensity, timestamp, ... } ]

POST /pain-points
  Body: { patient_id, zone, intensity, professional_id, ... }
  Response: { pain_point }
```

**🏥 Sessions**
```
GET /sessions?patient_id=<id>
  Response: [ { id, session_type, date, pain_before_avg, pain_after_avg, improvement, ... } ]

POST /sessions
  Body: { patient_id, session_type, professional_id, ... }
  Response: { session }
```

**📊 Statistics**
```
GET /stats/realtime
  Response: { total_patients, total_kines, avg_pain_7days, ... }

GET /stats/pathologies?code=lombalgie
  Response: [ { pathology_code, total_patients, avg_days_to_recovery, success_rate, ... } ]

POST /stats/pathologies/calculate
  Response: { calculated: 8, stats: [ ... ] }
```

**📋 Audit Logs**
```
GET /audit-logs?user_id=<id>&limit=100
  Response: [ { id, user_id, action_type, timestamp, old_values, new_values, ... } ]
```

---

## 📊 Statistiques Pathologies - Nouvelles Métriques

### Calcul Temps de Guérison

```python
# Pour chaque pathologie (si >= 5 patients)
stats = {
  'pathology_code': 'lombalgie',
  'pathology_name': 'Lombalgie chronique',
  'total_patients': 12,
  
  # Intensités
  'avg_initial_intensity': 7.5,  # Moyenne douleur initiale
  'avg_final_intensity': 2.1,    # Moyenne douleur finale
  'avg_total_improvement': 5.4,   # Amélioration moyenne
  
  # Sessions
  'avg_sessions_count': 8.3,      # Nombre moyen séances
  
  # Temps (NOUVEAU - comme demandé)
  'avg_days_to_30pct_improvement': 21.5,  # Jours pour 30% amélioration
  'avg_days_to_recovery': 45.2,           # Jours pour guérison (< 2/10)
  'patients_achieving_30pct': 11,         # Patients atteignant 30%
  'patients_achieving_recovery': 9,       # Patients guéris
  
  # Taux de succès
  'success_rate_30pct': 91.7,    # % patients avec 30%+ amélioration
  'success_rate_50pct': 75.0,    # % patients avec 50%+ amélioration
  'success_rate_recovery': 75.0, # % patients < 2/10
  
  # Zones affectées
  'affected_zones': {
    'lower_back': 85.2,  # % points douleur
    'pelvis': 14.8
  }
}
```

### k-Anonymat

**Règle:** Minimum 5 patients par pathologie pour garantir anonymat

```python
# Si < 5 patients → Stats NOT calculées
if total_patients < 5:
    return None  # Pas de stats publiées
```

---

## 🔐 Sécurité & RGPD

### Architecture Locale

| Aspect | Mesure | Statut |
|--------|--------|--------|
| **Données santé** | 100% locales (pas Internet) | ✅ |
| **Traçabilité** | Audit logs 3 ans | ✅ |
| **Authentification** | JWT tokens (24h expiration) | ✅ |
| **Réseau** | Wi-Fi interne sécurisé WPA2/WPA3 | ⚠️ Admin |
| **Accès physique** | Verrouillage PC principal | ⚠️ Admin |
| **Sauvegardes** | Hebdomadaires automatiques | ✅ |

### Conformité RGPD

**Article 30 - Registre des traitements:**
- ✅ Traitement #1: Gestion comptes utilisateurs
- ✅ Traitement #2: Suivi douleurs (données santé Art. 9)
- ✅ Traitement #3: Traçabilité modifications
- ✅ Traitement #4: Statistiques anonymisées
- ✅ Traitement #5: Sauvegardes locales

**Base légale:**
- Données santé: Consentement explicite (Art. 9.2.a)
- Audit logs: Obligation légale traçabilité
- Stats anonymisées: Intérêt légitime (k≥5)

---

## 💰 Coûts & Avantages

### Coûts

| Poste | Coût |
|-------|------|
| **Hébergement** | 0€ (local) |
| **Licences logicielles** | 0€ (open source) |
| **Certification HDS** | 0€ (pas nécessaire) |
| **Maintenance** | 0€ (auto-géré) |
| **TOTAL** | **0€/mois** |

### Comparaison Cloud HDS

| Solution | Coût mensuel | Certification |
|----------|--------------|---------------|
| **Local SQLite** | 0€ | Non (pas nécessaire) |
| OVHcloud Health Data | 100-200€ | HDS |
| AWS HIPAA | 150-300€ | HIPAA |
| Azure Healthcare | 200-400€ | HDS/HIPAA |

**💡 Économie:** ~1 500€/an par cabinet

---

## 🚀 Installation & Déploiement

### Installation Rapide (< 5 min)

```bash
# 1. Cloner le dépôt
git clone https://github.com/RBSoftwareAI/kine.git
cd kine

# 2. Installer dépendances
pip install -r backend/requirements.txt

# 3. Générer données demo (optionnel)
python3 backend/utils/generate_demo_data.py

# 4. Démarrer le serveur
python3 backend/start_server.py
```

**Accès:**
- PC principal: `http://localhost:8080/`
- Autres appareils: `http://192.168.x.x:8080/`

### Configuration Multi-Appareils

**Smartphones/Tablettes:**
1. Connecter au Wi-Fi interne
2. Ouvrir navigateur → `http://192.168.x.x:8080/`
3. **Ajouter à l'écran d'accueil** (iOS/Android)
4. Utiliser comme app native

---

## 📈 Performances

### Capacité

| Métrique | Capacité |
|----------|----------|
| **Patients** | 1 000+ |
| **Points douleur** | 10 000+ |
| **Séances** | 5 000+ |
| **Taille DB** | ~100 MB/an |
| **Utilisateurs simultanés** | 10+ |

### Temps de Réponse

| Endpoint | Temps |
|----------|-------|
| Login | < 50ms |
| Liste patients | < 100ms |
| Points douleur | < 200ms |
| Stats pathologies | < 500ms |
| Recherche | < 300ms |

---

## 🔄 Migration Future (si besoin)

### Vers OVHcloud HDS

**Quand migrer ?**
- Commercialisation application
- Partage données inter-cabinets
- Accès distant sécurisé

**Plan migration:**
1. Exporter SQLite → PostgreSQL
2. Adapter API Flask → API OVH
3. Repository pattern → Bascule automatique
4. Aucun changement UI Flutter

**Durée:** 13 semaines (voir [PLAN_MIGRATION_HDS.md](migration/PLAN_MIGRATION_HDS.md))

---

## 📚 Documentation Complète

- **Installation:** [INSTALLATION_LOCALE.md](INSTALLATION_LOCALE.md)
- **Test Pilote:** [test_pilot/PROTOCOLE_TEST_PILOTE.md](test_pilot/PROTOCOLE_TEST_PILOTE.md)
- **RGPD:** [rgpd/REGISTRE_TRAITEMENTS_RGPD.md](rgpd/REGISTRE_TRAITEMENTS_RGPD.md)
- **Migration HDS:** [migration/PLAN_MIGRATION_HDS.md](migration/PLAN_MIGRATION_HDS.md)

---

## 🆘 Support

### Logs Serveur

```bash
# Démarrer avec logs
python3 backend/start_server.py 2>&1 | tee server.log

# Voir logs en temps réel
tail -f server.log
```

### Dépannage

**Serveur ne démarre pas:**
```bash
# Vérifier port
netstat -tulpn | grep 8080

# Changer port
export PORT=3000 && python3 backend/start_server.py
```

**Backup manuel:**
```bash
python3 -c "from backend.database.db_manager import get_db; get_db().backup_database()"
```

---

**Version:** 1.0.0  
**Dernière mise à jour:** 2025-01-15
