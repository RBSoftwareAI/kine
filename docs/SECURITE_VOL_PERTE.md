# 🔐 Protection Contre Vol et Perte de Matériel

## ⚠️ Risques Identifiés

### Scénario 1 : Vol du PC Serveur

**❌ Conséquences sans protection :**
- Base de données lisible en clair
- Accès à toutes les données patients
- Vol d'identité possible
- Non-conformité RGPD

### Scénario 2 : Destruction PC (incendie, inondation)

**❌ Conséquences sans sauvegarde :**
- Perte définitive de toutes les données
- Impossibilité continuer activité
- Reconstruction historique impossible

---

## 🛡️ Solution Complète Anti-Vol

### Niveau 1 : Chiffrement Base de Données (OBLIGATOIRE)

**🔒 SQLCipher AES-256**

**Installation :**
```bash
pip install pysqlcipher3
```

**Configuration initiale :**
```bash
python3 backend/database/encryption_manager.py
```

**Processus :**
```
🔐 KinéCare Database Encryption Setup
===============================================================

Enter master passphrase: ************
Confirm passphrase: ************

🔄 Encrypting database...
✅ ENCRYPTION SUCCESSFUL

📋 Next steps:
   1. Test database access with new passphrase
   2. Verify application still works
   3. Delete backup file: data/kinecare.db.backup

🔑 Master Passphrase Recovery:
   - Store passphrase in password manager
   - Write on paper and store in safe
   - Share with trusted colleague (sealed envelope)
```

**Résultat :**
```bash
# Avant chiffrement
file data/kinecare.db
→ SQLite 3.x database

# Après chiffrement
file data/kinecare.db
→ data (impossible à lire sans mot de passe)
```

**✅ Si PC volé :**
- Base de données illisible
- Tentative lecture = fichier corrompu
- Données patients protégées

---

### Niveau 2 : Protection Physique Serveur

**Recommandations :**

**💻 PC Serveur :**
- [ ] Verrouillage session Windows/macOS automatique (5 min inactivité)
- [ ] Mot de passe BIOS/UEFI
- [ ] Chiffrement disque dur complet (BitLocker/FileVault)
- [ ] Câble antivol (Kensington lock)
- [ ] Placard/bureau fermé à clé

**🔐 Accès Physique :**
- [ ] Salle de soin fermée à clé hors présence
- [ ] Alarme cabinet si possible
- [ ] Caméra surveillance (optionnel)

**📱 Appareils Mobiles :**
- [ ] Code PIN/FaceID obligatoire
- [ ] Chiffrement activé (iOS par défaut, Android settings)
- [ ] Effacement à distance activé (Find My Device)
- [ ] Applications verrouillées (App Lock)

---

### Niveau 3 : Authentification Renforcée

**🔑 Stratégies Mots de Passe**

**Pour la base de données (master passphrase) :**
```
Exigences:
✅ Minimum 16 caractères
✅ Majuscules + minuscules + chiffres + symboles
✅ Pas de mots du dictionnaire
✅ Unique (pas réutilisé ailleurs)

Exemple FORT:
K1n3-C@r3_T0urc01ng!2025

Exemple FAIBLE:
kinecare123  ❌
```

**Pour les comptes utilisateurs :**
```yaml
password_policy:
  min_length: 12
  require_uppercase: true
  require_lowercase: true
  require_digit: true
  require_special: true
  expiration_days: 90
  history_count: 5  # Pas de réutilisation 5 derniers
```

**Double authentification (2FA) - Optionnel :**
```yaml
two_factor_auth:
  enabled: true
  methods:
    - totp  # Google Authenticator
    - sms   # SMS code
  required_for_roles:
    - admin
    - kine
```

---

## ☁️ Solution Sauvegarde Cloud Chiffrée

### Stratégie Sauvegarde 3-2-1

**Règle d'or :**
- **3** copies des données
- **2** supports différents
- **1** copie hors site

**Application KinéCare :**

**Copy 1 : Base principale**
```
📂 data/kinecare.db (chiffrée)
└─ PC serveur cabinet
```

**Copy 2 : Sauvegarde locale**
```
📂 data/backups/ (chiffrée)
└─ Même PC, dossier différent
```

**Copy 3 : Sauvegarde hors site (CRITIQUE)**
```
☁️  Cloud chiffré
└─ Google Drive / Dropbox / OVH S3
   OU
💾 Clé USB
└─ Domicile responsable cabinet
```

---

### Configuration Sauvegarde Cloud

**Option A : Google Drive (Recommandé - Simple)**

```bash
python3 backend/utils/cloud_backup.py
```

**Assistant :**
```
☁️  KinéCare Cloud Backup Setup
===============================================================

📋 Available providers:
   1. local_sync    - Local folder (USB key, NAS, synced folder)
   2. google_drive  - Google Drive (requires API setup)
   3. dropbox       - Dropbox (requires API setup)
   4. ovh_s3        - OVH S3 Storage (requires credentials)

Select provider [1]: 1

Backup folder [/home/user/KinéCare_Backups_Cloud]: /media/usb_backup

Backup frequency in hours [24]: 12
Retention period in days [30]: 90

🧪 Testing backup...
✅ Backup created: 87 KB (compressed + encrypted)
✅ Backup uploaded to: /media/usb_backup/kinecare_backup_20250115_143000.db.gz.enc

✅ BACKUP CONFIGURATION SUCCESSFUL

📋 Configuration:
   Provider: local_sync
   Frequency: Every 12 hours
   Retention: 90 days

🔄 Automatic backups enabled
```

---

### Chiffrement Double Couche

**Principe :**
1. Base de données chiffrée (SQLCipher)
2. Sauvegarde chiffrée à nouveau (AES-256)

**Résultat :**
```
PC volé → Base illisible ✅
Sauvegarde volée → Illisible ✅
Cloud piraté → Illisible ✅
```

**Configuration :**
```python
# backend/utils/cloud_backup.py
backup_config = {
    'encryption_enabled': True,    # ← TOUJOURS True
    'compression_enabled': True,   # Réduit taille 70-90%
    'double_encryption': True      # Base + sauvegarde chiffrées
}
```

---

## 📱 Procédure Vol/Perte Matériel

### Étape 1 : Réaction Immédiate (< 1 heure)

**Si vol constaté :**

1. **Déclarer aux autorités**
   - [ ] Dépôt plainte police/gendarmerie
   - [ ] Numéro plainte à conserver

2. **Sécuriser les accès**
   - [ ] Changer tous mots de passe administrateurs
   - [ ] Révoquer sessions actives
   - [ ] Désactiver comptes compromis

3. **Notifier l'assurance**
   - [ ] Déclaration sinistre
   - [ ] Fournir numéro plainte

4. **Évaluer l'exposition**
   - [ ] Base chiffrée ? → Risque faible
   - [ ] Base en clair ? → Risque ÉLEVÉ → Notification CNIL

---

### Étape 2 : Restauration (< 24 heures)

**Prérequis :**
- ✅ Sauvegarde cloud/USB récente
- ✅ Passphrase master disponible
- ✅ Nouveau PC ou PC de secours

**Procédure :**

```bash
# 1. Installer KinéCare sur nouveau PC
git clone https://github.com/RBSoftwareAI/kine.git
cd kine
pip install -r backend/requirements.txt

# 2. Récupérer dernière sauvegarde
# Depuis Google Drive / USB / Dropbox
cp /media/usb_backup/kinecare_backup_20250115_143000.db.gz.enc data/

# 3. Déchiffrer la sauvegarde
python3 backend/utils/restore_backup.py data/kinecare_backup_20250115_143000.db.gz.enc

Enter master passphrase: ************
🔄 Decrypting backup...
🔄 Decompressing...
✅ Database restored: data/kinecare.db

# 4. Vérifier intégrité
python3 backend/database/db_manager.py

📊 Database Info:
   total_records: 785
   last_backup: 2025-01-15 14:30:00
✅ Database integrity OK

# 5. Démarrer serveur
python3 backend/start_server.py
```

**⏱️ Temps total : 15-30 minutes**

---

### Étape 3 : Communication (< 48 heures)

**Si données compromises (base NON chiffrée) :**

**Obligation RGPD Article 33 :**
- Notification CNIL sous 72 heures
- Notification patients concernés si risque élevé

**Template email patients :**
```
Objet : Information de sécurité - Cabinet [NOM]

Madame, Monsieur,

Nous vous informons qu'un incident de sécurité a affecté 
notre cabinet le [DATE]. Un ordinateur contenant des données 
patients a été dérobé.

Données potentiellement concernées :
- Nom, prénom, date de naissance
- Historique consultations
- Notes cliniques

Mesures prises :
- Plainte déposée (n° [NUMERO])
- Changement tous mots de passe
- Renforcement sécurité
- Notification CNIL

Vos droits RGPD :
- Accès, rectification, suppression de vos données
- Contact : [EMAIL/TELEPHONE]

Cordialement,
[SIGNATURE]
```

**Si données protégées (base chiffrée) :**
- Pas d'obligation notification (risque minimal)
- Communication interne équipe recommandée
- Renforcement procédures sécurité

---

## 🔑 Gestion Clés de Chiffrement

### Problème : Perte Passphrase = Perte Données

**Solutions :**

**1. Dépôt Notaire (Recommandé pour cabinets)**
```
📄 Enveloppe scellée chez notaire contenant:
   - Passphrase master
   - Instructions récupération
   - Contact responsable cabinet

Coût: ~50€
Sécurité: Maximale
Accessibilité: 24-72h
```

**2. Coffre-fort Banque**
```
🏦 Dépôt enveloppe scellée

Coût: 50-150€/an
Sécurité: Élevée
Accessibilité: Horaires banque
```

**3. Partage Secret Shamir (Technique)**
```python
# Diviser passphrase en 5 parts
# Nécessite 3/5 parts pour reconstituer

from secretsharing import PlaintextToHexSecretSharer

passphrase = "K1n3-C@r3_T0urc01ng!2025"
shares = PlaintextToHexSecretSharer.split_secret(passphrase, 3, 5)

# Distribuer:
shares[0] → Responsable cabinet
shares[1] → Kinésithérapeute senior
shares[2] → Comptable cabinet
shares[3] → Notaire (enveloppe)
shares[4] → Conjoint responsable

# Pour reconstituer (besoin 3 parts):
recovered = PlaintextToHexSecretSharer.recover_secret([shares[0], shares[2], shares[4]])
```

**4. Gestionnaire Mots de Passe Partagé**
```
Exemples:
- 1Password Teams (coffre partagé)
- Bitwarden Organization
- LastPass Enterprise

Avantages:
✅ Accès contrôlé
✅ Audit logs
✅ Révocation rapide
✅ Backup automatique

Coût: 5-10€/utilisateur/mois
```

---

## 📋 Checklist Sécurité Complète

### Configuration Initiale

- [ ] **Chiffrement base activé** (SQLCipher)
- [ ] **Mot de passe master FORT** (16+ caractères)
- [ ] **Passphrase sauvegardée** (3 emplacements)
- [ ] **Sauvegarde cloud configurée** (quotidienne)
- [ ] **Sauvegarde USB hebdomadaire** (domicile)
- [ ] **Test restauration effectué** (1x)

### Protection Physique

- [ ] **PC session verrouillée** (auto 5 min)
- [ ] **Chiffrement disque** (BitLocker/FileVault)
- [ ] **Câble antivol** (si PC portable)
- [ ] **Salle fermée** (hors présence)
- [ ] **Alarme** (si possible)

### Authentification

- [ ] **Politique mots de passe** (12+ caractères)
- [ ] **Expiration 90 jours** (comptes professionnels)
- [ ] **2FA activée** (admins)
- [ ] **Sessions limitées** (24h expiration)

### Sauvegardes

- [ ] **3 copies données** (principal + 2 backups)
- [ ] **2 supports différents** (PC + cloud/USB)
- [ ] **1 hors site** (cloud ou domicile)
- [ ] **Test restauration** (trimestriel)
- [ ] **Rétention 90 jours** (minimum)

### Procédures

- [ ] **Plan vol/perte documenté**
- [ ] **Contacts d'urgence listés**
- [ ] **Template notification CNIL**
- [ ] **Template communication patients**
- [ ] **Exercice simulation** (annuel)

---

## 💰 Budget Sécurité

| Poste | Coût | Fréquence | Priorité |
|-------|------|-----------|----------|
| **Chiffrement SQLite** | 0€ | Unique | 🔴 CRITIQUE |
| **Sauvegarde cloud** | 0-10€ | /mois | 🔴 CRITIQUE |
| **Clé USB sauvegarde** | 20€ | Unique | 🟡 Important |
| **Câble antivol** | 30€ | Unique | 🟢 Optionnel |
| **Dépôt notaire passphrase** | 50€ | Unique | 🟡 Important |
| **Gestionnaire mots de passe** | 5€ | /mois | 🟢 Optionnel |
| **TOTAL An 1** | ~100€ | - | - |
| **TOTAL Années suivantes** | ~60€ | /an | - |

**💡 Comparaison :**
- Solution complète : ~100€
- Perte données (amende CNIL) : 10 000 à 20 000€
- Reconstruction manuelle : Impossible

---

## 🎯 Recommandation Cabinet Tourcoing

### Configuration Minimale Viable (Semaine 1)

```bash
# 1. Activer chiffrement
python3 backend/database/encryption_manager.py
# → Passphrase notée 3 endroits (coffre + domicile + notaire)

# 2. Sauvegarde USB hebdomadaire
# → Clé USB dédiée, rapportée domicile chaque vendredi

# 3. Verrouillage auto session
# → Windows: Settings → Lock screen → 5 minutes
# → macOS: System Preferences → Security → 5 minutes
```

### Configuration Optimale (Semaine 2-4)

```bash
# 4. Sauvegarde cloud automatique
python3 backend/utils/cloud_backup.py
# → Google Drive quotidien + compression + chiffrement

# 5. Test restauration
# → Simuler vol, restaurer sur PC test

# 6. Dépôt passphrase notaire
# → Enveloppe scellée avec instructions
```

---

**🔐 Sécurité = Tranquillité d'esprit**

**Version :** 1.0.0  
**Date :** 2025-01-15
