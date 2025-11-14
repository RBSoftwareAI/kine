# PLAN DE MIGRATION FIREBASE → HDS
## KinéCare - Passage en Production Certifiée

**Version:** 1.0  
**Date:** 14 Novembre 2025  
**Responsable:** RBSoftware AI + Cabinet Kinésithérapie Tourcoing

---

## 📋 SYNTHÈSE EXÉCUTIVE

### Objectif

Migrer l'application KinéCare depuis **Firebase (test pilote)** vers un **hébergeur certifié HDS** pour un déploiement commercial conforme à la réglementation française sur les données de santé.

### Timeline Globale

```
Mois 0-3  : Test Pilote Firebase (R&D)
Mois 3-6  : Itérations + Feedbacks utilisateurs
Mois 6-7  : Préparation technique migration
Mois 7-8  : Migration données + Tests
Mois 8-9  : Déploiement production HDS
Mois 9+   : Commercialisation conforme
```

### Budget Estimé

| Poste | Coût Développement | Coût Hébergement (mensuel) |
|-------|--------------------|-----------------------------|
| **Développement migration** | 2,000 - 5,000 € | - |
| **OVHcloud Health Data** | - | 100 - 200 €/mois |
| **Tests et validation** | 500 - 1,000 € | - |
| **Formation équipe** | 300 - 500 € | - |
| **TOTAL** | **2,800 - 6,500 € (one-time)** | **100 - 200 €/mois** |

---

## 1. POURQUOI MIGRER VERS HDS ?

### 1.1 Obligations Légales

**Article L1111-8 du Code de la Santé Publique :**

> *"L'hébergement des données de santé à caractère personnel recueillies à l'occasion d'activités de prévention, de diagnostic, de soins ou de suivi social et médico-social est réalisé dans des conditions garantissant leur confidentialité."*

**HDS obligatoire pour :**
- ✅ Données de santé **identifiantes** (nom + douleur)
- ✅ Usage **professionnel médical** en production
- ✅ **Commercialisation** de l'application
- ✅ Plus de 50 patients en base active

### 1.2 Limitations de Firebase

| Critère | Firebase | HDS Requis |
|---------|----------|------------|
| **Certification HDS** | ❌ NON | ✅ OUI |
| **Conformité française** | Partielle | ✅ Totale |
| **Assurance responsabilité** | Limitée | ✅ Complète |
| **Commercialisation France** | ❌ Risque légal | ✅ Conforme |
| **Données identifiantes** | ⚠️ Test uniquement | ✅ Production OK |

### 1.3 Bénéfices de la Migration

- ✅ **Conformité légale** totale (HDS, RGPD, CNIL)
- ✅ **Commercialisation** sans risque
- ✅ **Confiance patients** accrue (label HDS)
- ✅ **Assurance** responsabilité civile facilitée
- ✅ **Évolutivité** vers d'autres services santé

---

## 2. CHOIX DE L'HÉBERGEUR HDS

### 2.1 Comparatif des Solutions

| Critère | OVHcloud Health Data ⭐ | Azure Health | AWS HealthLake | Hébergeurs FR spé |
|---------|-------------------------|--------------|----------------|-------------------|
| **Certification HDS** | ✅ Oui (valide) | ✅ Oui | ⚠️ Partielle | ✅ Oui |
| **Localisation** | 🇫🇷 France | 🇪🇺 Europe | 🌍 Mondial | 🇫🇷 France |
| **Prix/mois** | 100-200 € | 200-500 € | 500-1000 € | 300-800 € |
| **Support FR** | ✅ Excellent | ⚠️ Moyen | ⚠️ Faible | ✅ Excellent |
| **Documentation** | ✅ Française | Anglais | Anglais | ✅ Française |
| **Migration Firebase** | ✅ Facilitée | ⚠️ Complexe | ⚠️ Complexe | ⚠️ Variable |
| **API REST** | ✅ Oui | ✅ Oui | ✅ Oui | ⚠️ Variable |

### 2.2 Solution Recommandée : OVHcloud Health Data

**Pourquoi OVHcloud ?**

1. **Certifié HDS** (certificat ASIP Santé valide)
2. **Datacenter France** (Gravelines, Roubaix - proche Tourcoing)
3. **Prix compétitif** (100-200€/mois pour démarrage)
4. **Support français** (7j/7)
5. **Compatible Firebase** (API REST, PostgreSQL)
6. **Documentation complète** en français
7. **Paiement SEPA** (pas de carte US obligatoire)

**Services OVH Health Data utilisés :**

```yaml
Infrastructure HDS:
  - Public Cloud Instances (VM certifiées HDS)
  - Databases as a Service (PostgreSQL HDS)
  - Object Storage S3 (stockage fichiers HDS)
  - Load Balancer HDS (haute disponibilité)
  - Logs Data Platform (audit logs)

Prix estimé:
  - Compute (2 vCPU, 4GB RAM): ~40 €/mois
  - Database PostgreSQL (Shared): ~50 €/mois
  - Object Storage (100GB): ~5 €/mois
  - Load Balancer: ~20 €/mois
  - TOTAL: ~115 €/mois (petite échelle)
```

**Lien documentation :**  
https://www.ovhcloud.com/fr/public-cloud/healthcare-data-hosting/

---

## 3. ARCHITECTURE TECHNIQUE DE MIGRATION

### 3.1 Architecture Actuelle (Firebase)

```
┌─────────────────────────────────────────────┐
│          FIREBASE (Google Cloud)            │
│                                             │
│  ┌──────────────┐  ┌──────────────┐       │
│  │ Firebase     │  │ Cloud        │       │
│  │ Auth         │  │ Firestore    │       │
│  │ (comptes)    │  │ (données)    │       │
│  └──────────────┘  └──────────────┘       │
│                                             │
│  Localisation: europe-west1 (Belgique)     │
│  Certification: ❌ Non-HDS                 │
└─────────────────────────────────────────────┘
         ▲
         │ HTTPS / API REST
         │
    ┌────┴────┐
    │ Flutter │ (Web + Android)
    │   App   │
    └─────────┘
```

### 3.2 Architecture Cible (OVH HDS)

```
┌──────────────────────────────────────────────────┐
│     OVHcloud HEALTH DATA (HDS Certifié)          │
│                                                   │
│  ┌──────────────┐  ┌───────────────┐            │
│  │ PostgreSQL   │  │ Object        │            │
│  │ Database     │  │ Storage S3    │            │
│  │ (données)    │  │ (fichiers)    │            │
│  └──────────────┘  └───────────────┘            │
│                                                   │
│  ┌──────────────┐  ┌───────────────┐            │
│  │ Compute VM   │  │ Load Balancer │            │
│  │ (API REST)   │  │ (HA)          │            │
│  └──────────────┘  └───────────────┘            │
│                                                   │
│  Localisation: FR-GRA (Gravelines, France 🇫🇷)  │
│  Certification: ✅ HDS Valide                    │
└──────────────────────────────────────────────────┘
         ▲
         │ HTTPS / API REST
         │
    ┌────┴────┐
    │ Flutter │ (Web + Android)
    │   App   │
    └─────────┘
```

### 3.3 Stack Technique Cible

| Composant | Technologie | Rôle |
|-----------|-------------|------|
| **Frontend** | Flutter 3.35.4 (inchangé) | Interface utilisateur |
| **Backend API** | FastAPI (Python 3.12) ou Node.js | API REST |
| **Database** | PostgreSQL 15 (OVH DBaaS HDS) | Données structurées |
| **Storage** | OVH Object Storage S3 | Fichiers/exports |
| **Auth** | JWT + bcrypt | Authentification |
| **Logs** | OVH Logs Data Platform | Audit trails |

---

## 4. PLAN DE MIGRATION DÉTAILLÉ

### PHASE 1 : PRÉPARATION (Semaines 1-4)

#### Semaine 1-2 : Infrastructure OVH

**Tâches:**
1. ✅ Créer compte OVH Cloud
2. ✅ Activer option Health Data (HDS)
3. ✅ Créer projet "kinecare-production"
4. ✅ Provisionner ressources:
   - VM Compute (2 vCPU, 4GB RAM)
   - PostgreSQL Database (Shared Plan)
   - Object Storage bucket (HDS)
   - Load Balancer
5. ✅ Configurer réseau privé (vRack)
6. ✅ Activer Logs Data Platform

**Coût estimé:** Configuration gratuite, paiement au prorata

#### Semaine 3-4 : Développement Backend API

**Tâches:**
1. ✅ Créer projet FastAPI (ou Node.js)
2. ✅ Implémenter endpoints API:
   - `/auth` - Authentification (POST login/register)
   - `/users` - Gestion utilisateurs (GET, PUT, DELETE)
   - `/pain-points` - Points de douleur (CRUD)
   - `/audit-logs` - Logs de traçabilité (GET)
   - `/evolution` - Données d'évolution (GET)
3. ✅ Configurer connexion PostgreSQL
4. ✅ Implémenter système JWT
5. ✅ Ajouter validation données (Pydantic ou Joi)
6. ✅ Tests unitaires (pytest ou Jest)

**Livrables:**
- API REST fonctionnelle (localhost)
- Documentation OpenAPI (Swagger)
- Tests coverage > 80%

---

### PHASE 2 : MIGRATION SCHÉMA DONNÉES (Semaines 5-6)

#### Semaine 5 : Conception Base PostgreSQL

**Mapping Firestore → PostgreSQL:**

**Table: users**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) CHECK (role IN ('patient', 'kine', 'coach')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);
```

**Table: pain_points**
```sql
CREATE TABLE pain_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    body_view VARCHAR(20) CHECK (body_view IN ('front', 'back', 'side')),
    body_zone VARCHAR(50) NOT NULL,
    x_coordinate DECIMAL(5,4) CHECK (x_coordinate >= 0 AND x_coordinate <= 1),
    y_coordinate DECIMAL(5,4) CHECK (y_coordinate >= 0 AND y_coordinate <= 1),
    intensity INT CHECK (intensity >= 0 AND intensity <= 10),
    frequency VARCHAR(20) CHECK (frequency IN ('occasional', 'daily', 'frequent', 'constant')),
    recorded_by UUID REFERENCES users(id),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

CREATE INDEX idx_pain_patient ON pain_points(patient_id);
CREATE INDEX idx_pain_date ON pain_points(recorded_at);
```

**Table: audit_logs**
```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    action_type VARCHAR(20) NOT NULL,
    user_id UUID REFERENCES users(id),
    user_role VARCHAR(20),
    old_values JSONB,
    new_values JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_modified_by_professional BOOLEAN DEFAULT false
);

CREATE INDEX idx_audit_patient ON audit_logs(patient_id);
CREATE INDEX idx_audit_timestamp ON audit_logs(timestamp);
```

#### Semaine 6 : Script de Migration

**Création script Python:**

```python
# scripts/migrate_firebase_to_postgresql.py

import firebase_admin
from firebase_admin import credentials, firestore
import psycopg2
from psycopg2.extras import execute_values
import json
from datetime import datetime

def migrate_users():
    """Migrer collection users Firebase → Table users PostgreSQL"""
    # Code de migration (voir fichier complet dans scripts/)
    pass

def migrate_pain_points():
    """Migrer collection pain_points"""
    pass

def migrate_audit_logs():
    """Migrer collection audit_logs"""
    pass

if __name__ == "__main__":
    # Connexions
    cred = credentials.Certificate("firebase-admin-sdk.json")
    firebase_admin.initialize_app(cred)
    
    pg_conn = psycopg2.connect(
        host="postgresql.hds.ovh.net",
        database="kinecare",
        user="kinecare_user",
        password="SECURE_PASSWORD"
    )
    
    # Exécution migrations
    print("Migrating users...")
    migrate_users()
    
    print("Migrating pain points...")
    migrate_pain_points()
    
    print("Migrating audit logs...")
    migrate_audit_logs()
    
    print("Migration completed!")
```

**Tests:**
1. ✅ Migration sur environnement de test
2. ✅ Vérification intégrité données
3. ✅ Validation contraintes SQL
4. ✅ Performance (< 1s pour 1000 records)

---

### PHASE 3 : REFACTORING APPLICATION (Semaines 7-8)

#### Semaine 7 : Abstraction Layer

**Créer interface générique:**

```dart
// lib/repositories/data_repository.dart
abstract class DataRepository {
  // Users
  Future<UserModel?> signIn(String email, String password);
  Future<UserModel?> signUp(/* params */);
  Future<UserModel?> getCurrentUser();
  
  // Pain Points
  Future<List<PainPoint>> getPainPoints(String patientId);
  Future<void> savePainPoint(PainPoint point);
  
  // Audit Logs
  Future<List<AuditLog>> getAuditLogs(String patientId);
  
  // Evolution
  Future<EvolutionData> getEvolution(/* params */);
}
```

**Implémentation Firebase (existante):**

```dart
// lib/repositories/firebase_repository.dart
class FirebaseRepository implements DataRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Code actuel (déjà écrit)
}
```

**Nouvelle implémentation HDS:**

```dart
// lib/repositories/hds_repository.dart
class HdsRepository implements DataRepository {
  final String _apiBaseUrl = 'https://api-kinecare.hds.ovh.net';
  final http.Client _client = http.Client();
  String? _authToken;
  
  @override
  Future<UserModel?> signIn(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$_apiBaseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _authToken = data['token'];
      return UserModel.fromJson(data['user']);
    }
    return null;
  }
  
  // Autres méthodes similaires avec API calls...
}
```

#### Semaine 8 : Feature Flag

**Configuration switch:**

```dart
// lib/config/app_config.dart
class AppConfig {
  static const bool USE_HDS = true; // Switch Firebase <-> HDS
  
  static DataRepository getRepository() {
    if (USE_HDS) {
      return HdsRepository(apiUrl: _getHdsApiUrl());
    } else {
      return FirebaseRepository();
    }
  }
  
  static String _getHdsApiUrl() {
    return const String.fromEnvironment(
      'HDS_API_URL',
      defaultValue: 'https://api-kinecare.hds.ovh.net',
    );
  }
}
```

**Utilisation dans providers:**

```dart
// lib/providers/auth_provider.dart
class AuthProvider with ChangeNotifier {
  final DataRepository _repository = AppConfig.getRepository();
  
  Future<bool> signIn(String email, String password) async {
    // Le reste du code ne change pas
    _currentUser = await _repository.signIn(email, password);
    // ...
  }
}
```

---

### PHASE 4 : TESTS ET VALIDATION (Semaines 9-10)

#### Semaine 9 : Tests Fonctionnels

**Tests unitaires Backend API:**
```bash
# API Tests
pytest tests/test_auth.py -v
pytest tests/test_pain_points.py -v
pytest tests/test_audit_logs.py -v

# Couverture attendue: > 80%
```

**Tests intégration Flutter:**
```dart
// test/integration/hds_repository_test.dart
void main() {
  group('HDS Repository Integration Tests', () {
    test('Sign in with valid credentials', () async {
      final repo = HdsRepository();
      final user = await repo.signIn('test@example.com', 'password123');
      expect(user, isNotNull);
      expect(user!.email, 'test@example.com');
    });
    
    // Autres tests...
  });
}
```

**Tests end-to-end:**
```bash
flutter drive --target=test_driver/app.dart
```

#### Semaine 10 : Tests Performance et Sécurité

**Tests de charge:**
- ✅ 100 utilisateurs simultanés
- ✅ Temps réponse API < 500ms (95e percentile)
- ✅ Base données < 1000 req/sec

**Audit sécurité:**
- ✅ Scan vulnérabilités (OWASP Top 10)
- ✅ Test injection SQL (sqlmap)
- ✅ Test authentification (JWT validation)
- ✅ Test HTTPS/TLS (sslyze)

**Tools utilisés:**
```bash
# Scan sécurité
owasp-zap -quickurl https://api-kinecare.hds.ovh.net

# Test charge
artillery run load-test-config.yml
```

---

### PHASE 5 : DÉPLOIEMENT PRODUCTION (Semaines 11-12)

#### Semaine 11 : Déploiement Infrastructure

**Déploiement VM OVH:**
```bash
# Connexion VM
ssh ubuntu@vm-kinecare-prod.ovh.net

# Installation stack
sudo apt update && sudo apt upgrade -y
sudo apt install python3.12 python3-pip nginx -y

# Déploiement API
cd /opt/kinecare-api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Service systemd
sudo systemctl start kinecare-api
sudo systemctl enable kinecare-api

# Configuration Nginx (reverse proxy)
sudo cp nginx.conf /etc/nginx/sites-available/kinecare
sudo ln -s /etc/nginx/sites-available/kinecare /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Certificat SSL (Let's Encrypt)
sudo certbot --nginx -d api-kinecare.hds.ovh.net
```

**Configuration PostgreSQL:**
```sql
-- Création utilisateur production
CREATE USER kinecare_prod WITH PASSWORD 'STRONG_RANDOM_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE kinecare TO kinecare_prod;

-- Optimisations
ALTER SYSTEM SET shared_buffers = '1GB';
ALTER SYSTEM SET effective_cache_size = '3GB';
```

#### Semaine 12 : Migration Données Réelles

**1. Backup Firebase (avant migration):**
```bash
firebase firestore:export gs://kinecare-backup/$(date +%Y%m%d)
```

**2. Migration données test:**
```bash
python3 scripts/migrate_firebase_to_postgresql.py --env production
```

**3. Vérification intégrité:**
```sql
-- Compter records
SELECT 'users' as table, COUNT(*) FROM users
UNION ALL
SELECT 'pain_points', COUNT(*) FROM pain_points
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs;

-- Vérifier contraintes
SELECT * FROM users WHERE email IS NULL;
SELECT * FROM pain_points WHERE intensity > 10;
```

**4. Tests post-migration:**
- ✅ Connexion 3 comptes démo
- ✅ Création nouveau point douleur
- ✅ Visualisation courbes évolution
- ✅ Consultation audit logs

**5. Switch DNS (si applicable):**
```bash
# Pointer domaine vers OVH
api.kinecare.app → vm-kinecare-prod.ovh.net
```

---

### PHASE 6 : FORMATION ET DOCUMENTATION (Semaine 13)

**Formation équipe:**
- ✅ Nouvelle architecture HDS (2h)
- ✅ Procédures incidents (1h)
- ✅ Backup et restauration (1h)
- ✅ Monitoring logs OVH (1h)

**Documentation mise à jour:**
- ✅ README technique (API endpoints)
- ✅ Guide déploiement
- ✅ Procédures d'exploitation
- ✅ Runbook incidents

---

## 5. COÛTS DÉTAILLÉS

### 5.1 Coûts de Migration (One-Time)

| Poste | Heures | Tarif/h | Total |
|-------|--------|---------|-------|
| **Architecture & Setup** | 16h | 80€ | 1,280 € |
| **Développement Backend API** | 24h | 80€ | 1,920 € |
| **Migration données** | 8h | 80€ | 640 € |
| **Refactoring Flutter** | 16h | 80€ | 1,280 € |
| **Tests** | 12h | 60€ | 720 € |
| **Déploiement** | 8h | 80€ | 640 € |
| **Documentation** | 6h | 60€ | 360 € |
| **Formation** | 6h | 60€ | 360 € |
| **TOTAL** | **96h** | - | **7,200 €** |

**Réduction possible (DIY) :** 2,800 - 5,000 € si développement interne partiel

### 5.2 Coûts Récurrents (Mensuel)

**OVHcloud Health Data:**

| Ressource | Capacité | Prix |
|-----------|----------|------|
| **Compute VM** | 2 vCPU, 4GB RAM, 40GB SSD | 40 €/mois |
| **PostgreSQL DBaaS** | Shared, 10GB | 50 €/mois |
| **Object Storage** | 100GB | 5 €/mois |
| **Load Balancer** | Basic | 20 €/mois |
| **Logs Platform** | 5GB/jour | 10 €/mois |
| **Bande passante** | 1TB/mois | Inclus |
| **Backup automatique** | 7 jours retention | 15 €/mois |
| **TOTAL** | - | **140 €/mois** |

**Évolution selon trafic:**
- 100 patients : 140 €/mois
- 500 patients : 200 €/mois (upgrade VM + DB)
- 1000 patients : 350 €/mois (multi-VM + DB larger)

### 5.3 ROI (Return on Investment)

**Comparaison Firebase vs HDS:**

| Critère | Firebase | OVH HDS |
|---------|----------|---------|
| **Coût mensuel (100 users)** | 25 €/mois (gratuit R&D) | 140 €/mois |
| **Conformité HDS** | ❌ Non | ✅ Oui |
| **Risque légal** | ⚠️ Élevé (production) | ✅ Nul |
| **Commercialisation** | ❌ Impossible | ✅ Possible |
| **Assurance RC Pro** | ⚠️ Difficile | ✅ Facilitée |

**Conclusion:** Le surcoût HDS (115€/mois) est **OBLIGATOIRE** pour commercialisation légale.

---

## 6. RISQUES ET MITIGATION

### 6.1 Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| **Perte données migration** | Faible | Critique | Backup complet avant migration + tests |
| **Downtime prolongé** | Moyenne | Élevé | Migration le week-end + rollback plan |
| **Incompatibilité API** | Faible | Élevé | Tests intensifs + feature flag |
| **Dépassement budget** | Moyenne | Moyen | Buffer 20% + devis détaillé |
| **Bugs production** | Moyenne | Élevé | Tests end-to-end + monitoring |

### 6.2 Plan de Rollback

**En cas d'échec migration:**

1. ⏱️ **0-30 min:** Détection problème (monitoring alerts)
2. ⏱️ **30-60 min:** Décision rollback ou fix
3. ⏱️ **60-90 min:** Switch back to Firebase (feature flag)
4. ⏱️ **90-120 min:** Restauration backup si data loss
5. ⏱️ **120+ min:** Post-mortem + plan correction

**Critères de rollback:**
- Impossibilité connexion > 30% utilisateurs
- Perte de données détectée
- Performance < 50% baseline
- Bug bloquant critique

---

## 7. CHECKLIST DE VALIDATION

### ✅ Avant Migration

- [ ] Backup complet Firebase réalisé
- [ ] Infrastructure OVH provisionnée et testée
- [ ] Backend API développé et testé (coverage > 80%)
- [ ] Flutter app refactorisé (abstraction layer)
- [ ] Tests end-to-end passés avec succès
- [ ] Documentation technique complète
- [ ] Équipe formée aux nouvelles procédures
- [ ] Plan de rollback documenté et testé
- [ ] Validation certificat HDS OVH à jour

### ✅ Après Migration

- [ ] Tous les utilisateurs peuvent se connecter
- [ ] Données migrées intègres (vérification échantillon)
- [ ] API répond en < 500ms (95e percentile)
- [ ] Logs audit fonctionnels
- [ ] Backup automatique configuré
- [ ] Monitoring alertes actives
- [ ] SSL/TLS certificat valide
- [ ] Tests sécurité OWASP passés
- [ ] Conformité HDS vérifiée

---

## 8. CONTACTS ET SUPPORT

### 8.1 Support OVHcloud

**Support technique HDS:**
- 📞 Téléphone: +33 9 72 10 10 07
- 📧 Email: support@ovhcloud.com
- 🌐 Portail: https://help.ovhcloud.com/csm
- 💬 Discord: https://discord.gg/ovhcloud

**Account Manager:**
- Demander attribution d'un AM pour suivi projet HDS

### 8.2 Équipe Projet

| Rôle | Nom | Contact |
|------|-----|---------|
| **Responsable projet** | [Nom] | [Email] |
| **Développeur lead** | RBSoftware AI | support@kinecare.fr |
| **Référent OVH** | [À assigner] | - |
| **Responsable RGPD** | [Nom] | rgpd@cabinet-tourcoing.fr |

---

## 9. TIMELINE VISUELLE

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1 : PRÉPARATION (4 semaines)                         │
│ ├─ S1-2: Infrastructure OVH                                 │
│ └─ S3-4: Développement Backend API                          │
├─────────────────────────────────────────────────────────────┤
│ PHASE 2 : MIGRATION SCHÉMA (2 semaines)                    │
│ ├─ S5: Conception base PostgreSQL                           │
│ └─ S6: Script migration + tests                             │
├─────────────────────────────────────────────────────────────┤
│ PHASE 3 : REFACTORING APP (2 semaines)                     │
│ ├─ S7: Abstraction layer                                    │
│ └─ S8: Feature flag + intégration                           │
├─────────────────────────────────────────────────────────────┤
│ PHASE 4 : TESTS (2 semaines)                               │
│ ├─ S9: Tests fonctionnels                                   │
│ └─ S10: Tests performance + sécurité                        │
├─────────────────────────────────────────────────────────────┤
│ PHASE 5 : DÉPLOIEMENT (2 semaines)                         │
│ ├─ S11: Déploiement infrastructure                          │
│ └─ S12: Migration données + Go Live                         │
├─────────────────────────────────────────────────────────────┤
│ PHASE 6 : FORMATION (1 semaine)                            │
│ └─ S13: Formation équipe + documentation                    │
└─────────────────────────────────────────────────────────────┘

TOTAL: 13 semaines (~3 mois)
```

---

## 10. PROCHAINES ÉTAPES

### Immédiat (Mois 0-3)

1. ✅ Compléter test pilote Firebase (collecter feedbacks)
2. ✅ Valider architecture cible avec OVH (pré-vente)
3. ✅ Obtenir devis détaillé OVH Health Data
4. ✅ Planifier ressources développement

### Court Terme (Mois 3-6)

1. ⏱️ Finaliser spécifications API REST
2. ⏱️ Créer compte OVH et provisionner infra test
3. ⏱️ Démarrer développement backend
4. ⏱️ Refactoring progressif Flutter app

### Moyen Terme (Mois 6-9)

1. 🚀 Exécuter migration complète
2. 🚀 Tests intensifs production
3. 🚀 Formation équipe cabinet Tourcoing
4. 🚀 Go Live production HDS

---

**Version:** 1.0  
**Date de création:** 14 Novembre 2025  
**Prochaine révision:** 14 Février 2026 (Mois 3 - fin test pilote)

---

*Ce plan de migration est conforme aux exigences HDS et RGPD pour le déploiement d'applications de santé numérique en France.*

**Contact:** support@kinecare.fr
