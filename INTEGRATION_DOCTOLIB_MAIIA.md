# 🔗 INTÉGRATION DOCTOLIB / MAIIA - MediDesk

**Date** : 16 novembre 2025  
**Version** : 1.0  
**Stratégie** : Coexistence et complémentarité

---

## 🎯 PHILOSOPHIE : "BEST OF BOTH WORLDS"

**MediDesk ne combat PAS Doctolib/Maiia, il les complète !**

```
┌─────────────────────────────────────────────────────────────┐
│               PATIENT PREND RDV (Plusieurs canaux)          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🌐 Doctolib        📱 Maiia        🖥️ MediDesk.fr        │
│  (Grand public)     (Parcours soins) (Site cabinet)        │
│                                                             │
│  ✅ Notoriété       ✅ Intégré CPAM  ✅ Personnalisé       │
│  ✅ SEO puissant    ✅ Téléconsult   ✅ 0 commission       │
│  ❌ Commission 15%  ❌ Commission 10% ✅ Contrôle total     │
│                                                             │
└──────────────┬──────────────────┬──────────────┬───────────┘
               │                  │              │
               └──────────────────┴──────────────┘
                         ▼
            ┌────────────────────────────┐
            │  SYNCHRONISATION CENTRALE  │
            │     MediDesk Backend       │
            │  (Agenda unifié cabinet)   │
            └────────────────────────────┘
                         ▼
            ┌────────────────────────────┐
            │   APPLICATION LOCALE       │
            │   MediDesk Desktop         │
            │   (Gestion dossiers)       │
            └────────────────────────────┘
```

---

## 🤝 SCÉNARIOS D'INTÉGRATION

### **Scénario 1 : Synchronisation Unidirectionnelle** (Le Plus Simple)

**Principe** : Doctolib/Maiia → MediDesk (lecture seule)

**Flux** :
```
1. Patient prend RDV sur Doctolib
   ↓
2. Webhook Doctolib notifie MediDesk
   ↓
3. MediDesk crée RDV automatiquement dans agenda local
   ↓
4. Praticien voit RDV dans MediDesk Desktop
   ↓
5. Jour J : Praticien consulte dossier patient MediDesk
   ↓
6. Après séance : Notes médicales stockées localement
```

**Avantages** :
- ✅ Pas de double-saisie
- ✅ Agenda unifié dans MediDesk
- ✅ Patients utilisent Doctolib (habitudes)
- ✅ Praticien utilise MediDesk (dossiers complets)

**Mise en œuvre** :
```python
# Backend MediDesk - Webhook Doctolib
@app.route('/api/webhooks/doctolib', methods=['POST'])
def doctolib_webhook():
    data = request.json
    
    # RDV Doctolib
    rdv = {
        'source': 'doctolib',
        'patient_nom': data['patient']['last_name'],
        'patient_prenom': data['patient']['first_name'],
        'patient_email': data['patient']['email'],
        'patient_tel': data['patient']['phone'],
        'date_rdv': data['appointment']['start_time'],
        'duree': data['appointment']['duration'],
        'praticien_id': data['practitioner']['id'],
        'statut': 'confirmé'
    }
    
    # Créer RDV dans MediDesk
    create_appointment(rdv)
    
    # Synchroniser avec app locale
    sync_to_local_app(rdv)
    
    return {'status': 'ok'}
```

---

### **Scénario 2 : Synchronisation Bidirectionnelle** (Plus Avancé)

**Principe** : MediDesk ↔ Doctolib/Maiia (lecture/écriture)

**Flux** :
```
📱 Patient prend RDV sur Doctolib
   ↓ Webhook
🖥️ MediDesk importe RDV
   ↓
👨‍⚕️ Praticien modifie heure dans MediDesk
   ↓ API Doctolib
📱 Doctolib mis à jour automatiquement
   ↓
📧 Patient reçoit notification changement
```

**Avantages** :
- ✅ Source de vérité unique (MediDesk)
- ✅ Praticien contrôle agenda dans MediDesk
- ✅ Patients voient changements temps réel
- ✅ Pas de désynchronisation

**Mise en œuvre** :
```python
# Backend MediDesk - Sync bidirectionnelle
def sync_appointment_to_doctolib(rdv_id):
    rdv = get_appointment(rdv_id)
    
    # Appeler API Doctolib
    doctolib_api = DoctolibAPI(api_key=os.getenv('DOCTOLIB_API_KEY'))
    
    if rdv['source'] == 'doctolib':
        # Mettre à jour RDV existant
        doctolib_api.update_appointment(
            appointment_id=rdv['doctolib_id'],
            start_time=rdv['date_rdv'],
            duration=rdv['duree']
        )
    else:
        # Créer nouveau RDV sur Doctolib
        doctolib_id = doctolib_api.create_appointment(
            practitioner_id=rdv['praticien_id'],
            patient_email=rdv['patient_email'],
            start_time=rdv['date_rdv'],
            duration=rdv['duree']
        )
        
        # Sauvegarder lien
        update_appointment(rdv_id, doctolib_id=doctolib_id)
```

---

### **Scénario 3 : Agrégation Multi-Sources** (Recommandé)

**Principe** : MediDesk centralise TOUS les canaux de RDV

**Sources possibles** :
1. 🌐 Doctolib (patients grand public)
2. 📱 Maiia (parcours soins CPAM)
3. 🖥️ MediDesk.fr (site cabinet direct)
4. 📞 Téléphone secrétariat (saisie manuelle)
5. 🚶 Walk-in cabinet (ajout spontané)

**Architecture** :
```
┌─────────────────────────────────────────────────────────────┐
│                    SOURCES RDV MULTIPLES                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Doctolib  │  Maiia  │  MediDesk.fr  │  Téléphone  │  Sur place │
│    (40%)   │  (20%)  │     (30%)     │    (5%)     │    (5%)    │
│                                                              │
└─────────┬──────────┬──────────┬──────────┬─────────┬────────┘
          │          │          │          │         │
          └──────────┴──────────┴──────────┴─────────┘
                            ▼
          ┌─────────────────────────────────────┐
          │   MEDIDESK AGENDA UNIFIÉ (SaaS)     │
          │   • Dédoublonnage automatique       │
          │   • Gestion conflits créneaux       │
          │   • Notifications unifiées          │
          │   • Synchronisation temps réel      │
          └─────────────────────────────────────┘
                            ▼
          ┌─────────────────────────────────────┐
          │   MEDIDESK DESKTOP (Local)          │
          │   • Dossiers patients complets      │
          │   • Notes séances                   │
          │   • Cartographie douleur            │
          └─────────────────────────────────────┘
```

**Avantages** :
- ✅ Praticien voit TOUT dans un seul agenda
- ✅ Patients utilisent leur plateforme préférée
- ✅ Pas de perte de RDV
- ✅ Statistiques globales précises

---

## 📊 COMPARAISON STRATÉGIES

| Critère | Doctolib Seul | MediDesk Seul | **MediDesk + Doctolib** ✅ |
|---------|---------------|---------------|--------------------------|
| **Visibilité patients** | 🟢 Excellente | 🟡 Moyenne | 🟢 **Excellente** |
| **Coût commission RDV** | 🔴 15% | 🟢 0% | 🟡 **15% (Doctolib uniquement)** |
| **Dossiers médicaux** | 🔴 Cloud HDS | 🟢 Local sécurisé | 🟢 **Local sécurisé** |
| **Contrôle données** | 🔴 Limité | 🟢 Total | 🟢 **Total** |
| **Flexibilité** | 🔴 Dépendance | 🟢 Indépendant | 🟢 **Indépendant** |
| **Expérience patient** | 🟢 Fluide | 🟡 Nouveau | 🟢 **Fluide** |
| **Coût total/mois** | 🔴 129€ | 🟢 19-49€ | 🟡 **148-178€** |

**🎯 Verdict : MediDesk + Doctolib = Meilleur compromis**

---

## 💡 STRATÉGIE COMMERCIALE RECOMMANDÉE

### **Phase 1 : Installation (Mois 1-3)**

**Objectif** : Adoption MediDesk Desktop (local)

**Actions** :
- ✅ Installer MediDesk Desktop sur PC praticiens
- ✅ Former équipe à l'interface
- ✅ Importer dossiers patients existants
- ✅ Utiliser sans synchronisation cloud

**Coût** : 0€ (version locale gratuite)

---

### **Phase 2 : Activation Agenda SaaS (Mois 3-6)**

**Objectif** : Tester valeur ajoutée agenda unifié

**Actions** :
- ✅ Activer forfait MediDesk Essentiel (19€/mois)
- ✅ Configurer intégration Doctolib (webhook)
- ✅ Synchroniser RDV Doctolib → MediDesk
- ✅ Praticiens voient tout dans MediDesk

**Coût** : 19€/mois MediDesk + 129€/mois Doctolib = **148€/mois**

---

### **Phase 3 : Mixage Canaux (Mois 6-12)**

**Objectif** : Diversifier sources RDV, réduire dépendance Doctolib

**Actions** :
- ✅ Activer prise RDV directe MediDesk.fr (0% commission)
- ✅ Promouvoir site cabinet auprès patients fidèles
- ✅ Garder Doctolib pour nouveaux patients (SEO)
- ✅ Mesurer répartition sources RDV

**Répartition cible** :
- 40% Doctolib (nouveaux patients, SEO)
- 50% MediDesk.fr (patients fidèles, 0% commission)
- 10% Téléphone (personnes âgées)

**Économie** : -50% commissions Doctolib

---

### **Phase 4 : Autonomie Progressive (Mois 12+)**

**Objectif** : Réduire coûts Doctolib si souhaité

**Actions** :
- ✅ Évaluer ROI Doctolib (nouveaux patients / coût)
- ✅ Si SEO cabinet fort → Réduire dépendance Doctolib
- ✅ Si SEO faible → Garder Doctolib (acquisition)
- ✅ Décision praticien selon contexte

**Scénario A : Cabinet établi (10+ ans)**
- 70% MediDesk.fr (réputation locale forte)
- 20% Bouche-à-oreille
- 10% Doctolib
- **Économie** : -70% coûts Doctolib

**Scénario B : Nouveau cabinet (< 3 ans)**
- 60% Doctolib (acquisition nécessaire)
- 30% MediDesk.fr
- 10% Autres
- **Investissement** : Garder Doctolib pour croissance

---

## 🔧 IMPLÉMENTATION TECHNIQUE

### **API Doctolib (Webhooks)**

**Documentation** : https://developers.doctolib.com

**Événements disponibles** :
```json
{
  "event": "appointment.created",
  "data": {
    "appointment": {
      "id": "apt_123456",
      "start_time": "2025-11-20T14:00:00Z",
      "duration": 45,
      "status": "confirmed"
    },
    "patient": {
      "id": "pat_789",
      "first_name": "Jean",
      "last_name": "Dupont",
      "email": "jean.dupont@example.com",
      "phone": "+33612345678"
    },
    "practitioner": {
      "id": "pra_001",
      "name": "Dr. Martin"
    }
  }
}
```

**Configuration MediDesk** :
```python
# backend/api/integrations/doctolib.py

class DoctolibIntegration:
    def __init__(self, api_key, practice_id):
        self.api_key = api_key
        self.practice_id = practice_id
        self.base_url = "https://api.doctolib.com/v1"
    
    def register_webhook(self, callback_url):
        """Enregistrer webhook Doctolib → MediDesk"""
        response = requests.post(
            f"{self.base_url}/webhooks",
            headers={"Authorization": f"Bearer {self.api_key}"},
            json={
                "url": callback_url,
                "events": [
                    "appointment.created",
                    "appointment.updated",
                    "appointment.cancelled"
                ]
            }
        )
        return response.json()
    
    def sync_appointment(self, appointment_data):
        """Synchroniser RDV Doctolib dans MediDesk"""
        rdv = {
            'source': 'doctolib',
            'external_id': appointment_data['appointment']['id'],
            'patient_prenom': appointment_data['patient']['first_name'],
            'patient_nom': appointment_data['patient']['last_name'],
            'patient_email': appointment_data['patient']['email'],
            'patient_tel': appointment_data['patient']['phone'],
            'date_rdv': appointment_data['appointment']['start_time'],
            'duree_minutes': appointment_data['appointment']['duration'],
            'praticien_id': appointment_data['practitioner']['id'],
            'statut': appointment_data['appointment']['status']
        }
        
        # Créer dans DB MediDesk
        db.appointments.insert_one(rdv)
        
        # Synchroniser avec app locale (WebSocket)
        notify_local_app(rdv)
```

---

### **API Maiia (Parcours Soins)**

**Documentation** : https://developers.maiia.com

**Principe similaire** :
```python
class MaiiaIntegration:
    def __init__(self, api_key):
        self.api_key = api_key
        self.base_url = "https://api.maiia.com/v2"
    
    def sync_appointment(self, appointment_data):
        """Synchroniser RDV Maiia dans MediDesk"""
        rdv = {
            'source': 'maiia',
            'external_id': appointment_data['id'],
            # ... mapping similaire Doctolib
        }
        
        db.appointments.insert_one(rdv)
        notify_local_app(rdv)
```

---

### **Interface Unifiée MediDesk**

**Vue praticien dans MediDesk Desktop** :

```
┌─────────────────────────────────────────────────────────────┐
│  AGENDA - Jeudi 20 Novembre 2025                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📅 09:00 - 09:45  Jean DUPONT                               │
│     📱 Source: Doctolib                                      │
│     📋 Premier RDV                                           │
│     [Ouvrir dossier]                                         │
│                                                              │
│  📅 10:00 - 10:45  Marie MARTIN                              │
│     🖥️ Source: MediDesk.fr                                  │
│     📋 Suivi lombalgies                                      │
│     [Ouvrir dossier]                                         │
│                                                              │
│  📅 11:00 - 11:30  Pierre LEFEBVRE                           │
│     📞 Source: Téléphone (secrétariat)                       │
│     📋 Urgence                                               │
│     [Ouvrir dossier]                                         │
│                                                              │
│  📅 14:00 - 14:45  Sophie DUBOIS                             │
│     📱 Source: Maiia (Parcours soins)                        │
│     📋 Rééducation post-opératoire                           │
│     [Ouvrir dossier]                                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Légende visuelle** :
- 📱 = Doctolib (bleu)
- 🖥️ = MediDesk.fr (vert)
- 📞 = Téléphone (orange)
- 📋 = Maiia (violet)

---

## 💰 ANALYSE COÛTS COMPARÉE

### **Scénario 1 : Doctolib Seul**

**Coûts mensuels** :
- Abonnement Doctolib : 129€
- Commission 15% sur RDV en ligne (ex: 50 RDV × 45€ × 15%) : 337.50€
- **Total** : **466.50€/mois** = **5,598€/an**

---

### **Scénario 2 : MediDesk Seul**

**Coûts mensuels** :
- MediDesk Professionnel : 49€
- Commission RDV : 0€
- **Total** : **49€/mois** = **588€/an**

**Économie** : **5,010€/an** (vs Doctolib seul)

**⚠️ Inconvénient** : Perte visibilité SEO Doctolib (acquisition nouveaux patients)

---

### **Scénario 3 : MediDesk + Doctolib (Mix 50/50)**

**Coûts mensuels** :
- Abonnement Doctolib : 129€
- Commission 15% sur RDV Doctolib (25 RDV × 45€ × 15%) : 168.75€
- MediDesk Essentiel : 19€
- **Total** : **316.75€/mois** = **3,801€/an**

**Économie** : **1,797€/an** (vs Doctolib seul)  
**Coût** : **+3,213€/an** (vs MediDesk seul)

**✅ Avantages** :
- Garde visibilité Doctolib (SEO)
- Réduit dépendance (50% RDV directs)
- Dossiers sécurisés localement
- Flexibilité maximale

---

## 🎯 RECOMMANDATION STRATÉGIQUE

### **Pour le Pilote Tourcoing**

**Phase 1 (Mois 1-3) : MediDesk Local Uniquement**
```
Objectif : Validation usage quotidien
Coût : 0€
Risque : Faible (pas d'engagement)
```

**Phase 2 (Mois 3-6) : + Intégration Doctolib**
```
Objectif : Tester agenda unifié
Coût : +19€/mois (MediDesk Essentiel)
Risque : Faible (peut arrêter)
Gain : Vision complète RDV
```

**Phase 3 (Mois 6-12) : + Prise RDV MediDesk.fr**
```
Objectif : Diversifier canaux
Coût : Stable (19€/mois)
Risque : Très faible
Gain : -50% commissions Doctolib
```

---

## ✅ CONCLUSION

### **OUI, MediDesk peut totalement s'intégrer avec Doctolib/Maiia !**

**3 approches possibles** :

1. **🔵 Synchronisation unidirectionnelle** (Simple)
   - Doctolib → MediDesk (lecture seule)
   - Praticien voit tout dans MediDesk
   - Patients gardent habitudes Doctolib

2. **🔷 Synchronisation bidirectionnelle** (Avancé)
   - MediDesk ↔ Doctolib (lecture/écriture)
   - Source de vérité unique (MediDesk)
   - Modifications synchronisées temps réel

3. **🟢 Agrégation multi-sources** (Recommandé)
   - Tous canaux → MediDesk (unifié)
   - Doctolib + Maiia + MediDesk.fr + Téléphone
   - Flexibilité maximale praticien

---

**🎯 Avantages Mix MediDesk + Doctolib** :

✅ **Visibilité patients** : Garde SEO Doctolib  
✅ **Coûts réduits** : -30 à -70% selon répartition  
✅ **Données sécurisées** : Dossiers 100% locaux  
✅ **Flexibilité** : Pas de dépendance unique  
✅ **Expérience** : Patients utilisent plateforme préférée  

**💡 C'est une stratégie gagnant-gagnant !**

---

**📧 Questions ou besoin de précisions ?**  
Contact : commercial@medidesk.fr

**📅 Document créé le 16 novembre 2025**
