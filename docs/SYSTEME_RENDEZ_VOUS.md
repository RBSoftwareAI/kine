# 📅 Système de Rendez-vous Optionnel - MediDesk

## 🎯 Philosophie

Le système de rendez-vous intégré est **100% optionnel** car la réalité des cabinets est :

✅ **Doctolib** : Largement adopté  
✅ **Téléphone** : Toujours utilisé  
✅ **iCal/Google Calendar** : Synchronisation existante  

**→ MediDesk s'adapte à VOTRE workflow existant**

---

## 🔄 Modes d'Utilisation

### Mode 1 : Import Doctolib/iCal (Recommandé)

**Principe :** MediDesk importe les rendez-vous depuis Doctolib ou Google Calendar

**Avantages :**
- ✅ Pas besoin changer vos habitudes
- ✅ Patients continuent d'utiliser Doctolib
- ✅ Synchronisation automatique
- ✅ Lien rendez-vous → dossier patient

**Configuration :**
```yaml
# backend/config/calendar_sync.yaml
calendar_sync:
  enabled: true
  provider: doctolib  # ou google_calendar, ical
  
  doctolib:
    api_key: "votre_cle_api"
    sync_frequency_minutes: 15
    
  google_calendar:
    calendar_id: "votre_calendrier@gmail.com"
    credentials_path: "google_calendar_credentials.json"
    
  ical:
    url: "https://votre-calendrier.ics"
```

**Fonctionnalités :**
- Import automatique toutes les 15 minutes
- Création automatique dossier patient si nouveau
- Lien rendez-vous → historique douleurs
- Rappel automatique saisie douleurs après RDV

### Mode 2 : Saisie Manuelle Téléphone

**Principe :** Patient appelle, vous notez le RDV dans MediDesk

**Avantages :**
- ✅ Simple et rapide
- ✅ Contrôle total
- ✅ Pas de dépendance externe

**Interface :**
```
┌─────────────────────────────────────┐
│  📞 Nouveau Rendez-vous             │
├─────────────────────────────────────┤
│  Patient: [Jean Dupont ▼]          │
│  Date:    [15/01/2025]              │
│  Heure:   [14:00]                   │
│  Durée:   [30 min ▼]                │
│  Type:    [Suivi ▼]                 │
│  Notes:   [                    ]    │
│                                      │
│  [Annuler]  [Enregistrer]           │
└─────────────────────────────────────┘
```

### Mode 3 : Prise de Rendez-vous En Ligne (Optionnel)

**Principe :** Module optionnel pour prise RDV par patients

**⚠️ Activation uniquement si besoin spécifique**

**Avantages par rapport à Doctolib :**
- ✅ Lien direct avec dossier patient
- ✅ Rappel automatique saisie douleurs avant RDV
- ✅ Suggestion créneaux adaptés à la pathologie
- ✅ Pas de commission Doctolib

**Fonctionnalités différenciantes :**

**1. Préparation Rendez-vous Intelligente**
```
📱 Patient reçoit SMS 24h avant:
"Votre RDV demain 14h. Pour optimiser votre séance,
indiquez vos douleurs actuelles : 
https://medidesk.app/pain-check/abc123"

→ Le kiné arrive avec données à jour
→ Gain de temps consultation
→ Meilleur suivi évolution
```

**2. Suggestion Créneaux Optimale**
```python
# Système analyse:
- Pathologie patient
- Durée séances précédentes
- Amélioration typique pour cette pathologie
- Disponibilité kiné spécialisé

→ Propose créneaux optimaux
```

**3. Statistiques Utilisation**
```
Cabinet Dashboard:
- Taux présence (vs Doctolib)
- Délai moyen prise RDV
- Patients actifs auto-saisie douleurs
- Qualité préparation séances
```

---

## 🎁 Valeur Ajoutée vs Doctolib

| Fonctionnalité | Doctolib | MediDesk RDV | Avantage |
|----------------|----------|--------------|----------|
| **Prise RDV en ligne** | ✅ | ✅ | Égalité |
| **Rappels SMS/Email** | ✅ | ✅ | Égalité |
| **Gestion agenda** | ✅ | ✅ | Égalité |
| **Saisie douleurs pré-RDV** | ❌ | ✅ | **MediDesk** |
| **Lien dossier patient** | ❌ | ✅ | **MediDesk** |
| **Suggestions créneaux intelligentes** | ❌ | ✅ | **MediDesk** |
| **Statistiques temps guérison** | ❌ | ✅ | **MediDesk** |
| **Données 100% locales** | ❌ | ✅ | **MediDesk** |
| **Coût mensuel** | 129€ | 0€ | **MediDesk** |

---

## 💡 Cas d'Usage Recommandés

### Scénario A : Cabinet Satisfait Doctolib

**Recommandation :** Mode 1 (Import Doctolib)

**Configuration :**
```yaml
appointments:
  mode: import_only
  source: doctolib
  enable_online_booking: false
  
# MediDesk importe les RDV mais ne les gère pas
# Patients continuent de prendre RDV via Doctolib
```

**Bénéfice :**
- Zéro changement pour les patients
- Lien automatique RDV → dossier MediDesk
- Rappel saisie douleurs pré-RDV

### Scénario B : Cabinet Sans Doctolib

**Recommandation :** Mode 2 (Saisie manuelle) + Mode 3 (Optionnel)

**Configuration :**
```yaml
appointments:
  mode: manual_entry
  enable_online_booking: true  # Si souhaité
  
  online_booking:
    require_account: true
    send_preparation_reminder: true
    allow_reschedule: true
    cancellation_deadline_hours: 24
```

**Bénéfice :**
- Alternative gratuite à Doctolib
- Contrôle total données
- Fonctionnalités métier spécifiques

### Scénario C : Cabinet Multi-Canaux

**Recommandation :** Tous modes activés

**Configuration :**
```yaml
appointments:
  mode: hybrid
  sources:
    - doctolib
    - phone_manual
    - online_booking
  
  # Consolidation intelligente
  prevent_double_booking: true
  sync_bidirectional: false  # Éviter conflits
```

---

## 🔧 Implémentation Technique

### API Endpoints (Optionnels)

```
# Consultation uniquement (toujours actif)
GET /api/appointments?patient_id=<id>

# Création manuelle (toujours actif)
POST /api/appointments
  Body: { patient_id, date, time, type, ... }

# Prise RDV en ligne (optionnel, nécessite activation)
POST /api/appointments/book
  Body: { patient_id, slot_id, preparation_consent }

# Import externe (optionnel, nécessite configuration)
POST /api/appointments/import/doctolib
POST /api/appointments/import/ical
```

### Base de Données

```sql
-- Table appointments (déjà créée)
CREATE TABLE IF NOT EXISTS appointments (
    id TEXT PRIMARY KEY,
    patient_pseudonym TEXT NOT NULL,
    patient_id TEXT,
    professional_id TEXT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    status TEXT DEFAULT 'scheduled',
    appointment_type TEXT,
    notes TEXT,
    
    -- Source du rendez-vous
    source TEXT DEFAULT 'manual', -- manual, doctolib, online, ical
    external_id TEXT,  -- ID Doctolib, Google Calendar, etc.
    
    -- Préparation patient
    pain_check_completed BOOLEAN DEFAULT 0,
    pain_check_reminder_sent TIMESTAMP,
    
    -- Synchronisation
    firebase_synced INTEGER DEFAULT 0,
    firebase_id TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES users(id)
);
```

---

## 📊 Mesure Adoption (si Module Activé)

```python
# Tracking utilisation optionnelle
def track_appointment_source():
    stats = {
        'doctolib_imports': 45,      # 60%
        'phone_manual': 20,           # 27%
        'online_bookings': 10,        # 13%
        
        'pain_check_completion_rate': 0.75,  # 75% patients préparent RDV
        'avg_preparation_time_hours': 18,    # Saisie 18h avant en moyenne
        'no_show_rate': 0.05                 # 5% absences (vs 8% Doctolib)
    }
    return stats
```

---

## 🚀 Activation Progressive

### Phase 1 : Import Seul (Semaine 1)

```bash
# Configuration minimale
python3 backend/utils/configure_calendar_sync.py
# Choisir: Doctolib ou iCal
# Fréquence: 15 minutes
```

**Résultat :**
- RDV apparaissent dans MediDesk
- Lien automatique avec dossiers patients
- Aucun changement côté patient

### Phase 2 : Rappels Préparation (Semaine 2-4)

```yaml
appointments:
  preparation_reminders:
    enabled: true
    send_before_hours: 24
    method: sms  # ou email
```

**Résultat :**
- Patients reçoivent lien saisie douleurs
- Kinés arrivent avec données à jour
- Gain temps consultation

### Phase 3 : Prise RDV En Ligne (Optionnel, Mois 2+)

```yaml
appointments:
  online_booking:
    enabled: true
    public_url: https://medidesk.app/book/cabinet-tourcoing
```

**Résultat :**
- Alternative Doctolib disponible
- Fonctionnalités métier intégrées
- Économie 129€/mois si remplacement complet

---

## 💰 Analyse Coût/Bénéfice

### Scénario "Import Doctolib"

**Coût :**
- Doctolib : 129€/mois (inchangé)
- MediDesk : 0€

**Bénéfice :**
- ✅ Lien RDV → dossier patient
- ✅ Rappels préparation séance
- ✅ Statistiques prise en charge

### Scénario "Remplacement Doctolib"

**Coût :**
- Doctolib : 0€ (résiliation)
- MediDesk : 0€

**Économie :** 1 548€/an

**Bénéfice :**
- ✅ Toutes fonctionnalités MediDesk
- ✅ Données 100% locales
- ✅ Pas de dépendance externe

**Risque :**
- ⚠️ Patients habitués Doctolib
- ⚠️ Visibilité moindre (SEO Doctolib)

**Mitigation :**
- Widget prise RDV sur site web cabinet
- Communication transition (email, affichage)
- Période test 3 mois avec double système

---

## 📋 Checklist Décision

**Garder Doctolib si :**
- [ ] Patients très satisfaits Doctolib
- [ ] Forte acquisition nouveaux patients via Doctolib
- [ ] Pas de problème budget 129€/mois
- [ ] Équipe habituée interface Doctolib

**Activer Module MediDesk si :**
- [ ] Besoin lien fort RDV ↔ dossier patient
- [ ] Volonté améliorer préparation séances
- [ ] Budget contraint
- [ ] Données 100% locales prioritaire
- [ ] Fonctionnalités métier spécifiques

**Solution Hybride (Recommandée) :**
- [ ] Import Doctolib dans MediDesk
- [ ] Activation rappels préparation
- [ ] Module prise RDV MediDesk désactivé (pas de concurrence)
- [ ] Réévaluation dans 6 mois

---

## 🎯 Recommandation Finale

### Pour Cabinet Tourcoing

**Phase Test (Mois 1-6) :**

```yaml
appointments:
  mode: import_only
  source: doctolib  # Si existe, sinon manual_entry
  enable_online_booking: false
  
  preparation_reminders:
    enabled: true
    send_before_hours: 24
```

**Résultat attendu :**
- Amélioration 20-30% taux préparation séances
- Gain 5-10 min par consultation
- Meilleur suivi évolution douleurs
- **Sans changer habitudes patients**

**Décision Mois 6 :**
- Si satisfaction haute + économies souhaitées → Activer module complet
- Si Doctolib toujours préféré → Garder mode import

---

**Philosophie MediDesk :**  
> "S'adapter à votre workflow, pas l'inverse"

**Version :** 1.0.0  
**Date :** 2025-01-15
