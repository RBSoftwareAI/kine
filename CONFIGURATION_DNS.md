# 🌐 Configuration DNS pour demo.medidesk.fr

Ce guide détaille la configuration DNS nécessaire pour pointer **demo.medidesk.fr** vers Firebase Hosting.

---

## 📋 Informations du Projet Firebase

- **Projet ID** : `kinecare-81f52`
- **URL Firebase par défaut** : https://kinecare-81f52.web.app
- **URL alternative** : https://kinecare-81f52.firebaseapp.com
- **Domaine personnalisé cible** : demo.medidesk.fr

---

## 🔧 Configuration dans Firebase Console

### Étape 1 : Ajouter le domaine personnalisé

1. **Aller sur Firebase Console** : https://console.firebase.google.com/
2. Sélectionner le projet : **kinecare-81f52**
3. Menu latéral → **Hosting** (⚡ icône)
4. Onglet **"Domaines"** ou **"Domains"**
5. Cliquer **"Ajouter un domaine personnalisé"** ou **"Add custom domain"**
6. Entrer : `demo.medidesk.fr`
7. Cliquer **"Continuer"**

### Étape 2 : Récupérer les informations DNS

Firebase affichera les enregistrements DNS à configurer. Il existe **deux options** :

---

## 🎯 Option 1 : Configuration avec enregistrement A (Recommandé)

Cette option utilise des adresses IP directes.

### Enregistrements DNS à ajouter sur votre registrar (Gandi, OVH, etc.) :

```
Type: A
Nom: demo
Valeur: 151.101.1.195
TTL: 3600 (ou 1 heure)
```

```
Type: A
Nom: demo
Valeur: 151.101.65.195
TTL: 3600 (ou 1 heure)
```

**⚠️ Note** : Firebase peut fournir des IPs différentes. **Utilisez TOUJOURS les IPs affichées dans votre Firebase Console.**

**Avantages :**
- ✅ Pas de CNAME Flattening nécessaire
- ✅ Compatible avec tous les DNS providers
- ✅ Performance légèrement meilleure

---

## 🎯 Option 2 : Configuration avec CNAME

Cette option utilise un alias vers le domaine Firebase.

### Enregistrement DNS à ajouter :

```
Type: CNAME
Nom: demo
Valeur: kinecare-81f52.web.app.
TTL: 3600 (ou 1 heure)
```

**⚠️ Important** : Notez le **point final** (`.`) à la fin de la valeur !

**Avantages :**
- ✅ Plus simple (un seul enregistrement)
- ✅ Pas d'IP à mémoriser
- ✅ Mise à jour automatique si Firebase change d'IP

**Inconvénients :**
- ❌ Certains providers peuvent avoir des limitations avec CNAME

---

## 📝 Configuration sur Gandi (Exemple)

### 1. Connexion à Gandi

Aller sur : https://admin.gandi.net/

### 2. Accéder aux DNS du domaine

1. **Domaines** → Sélectionner `medidesk.fr`
2. **Enregistrements DNS** (DNS Records)

### 3. Supprimer les enregistrements existants (si nécessaire)

Si un enregistrement `demo` existe déjà, le supprimer avant d'ajouter les nouveaux.

### 4. Ajouter les enregistrements

**Option A (Recommandé) - Type A :**

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| A | demo | 151.101.1.195 | 3600 |
| A | demo | 151.101.65.195 | 3600 |

**Ou Option CNAME :**

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| CNAME | demo | kinecare-81f52.web.app. | 3600 |

### 5. Sauvegarder

Cliquer **"Créer"** ou **"Ajouter"** pour chaque enregistrement.

---

## 📝 Configuration sur OVH (Exemple)

### 1. Connexion à OVH

Aller sur : https://www.ovh.com/manager/

### 2. Accéder aux DNS du domaine

1. **Domaines** → Sélectionner `medidesk.fr`
2. **Zone DNS**
3. **Ajouter une entrée**

### 3. Ajouter les enregistrements

**Pour Type A :**
- Sélectionner **"A"**
- Sous-domaine : `demo`
- Cible : `151.101.1.195`
- TTL : `3600`
- Valider

Répéter pour la deuxième IP : `151.101.65.195`

**Pour Type CNAME :**
- Sélectionner **"CNAME"**
- Sous-domaine : `demo`
- Cible : `kinecare-81f52.web.app.`
- TTL : `3600`
- Valider

---

## 📝 Configuration sur Cloudflare (Exemple)

### 1. Connexion à Cloudflare

Aller sur : https://dash.cloudflare.com/

### 2. Sélectionner le domaine

Cliquer sur `medidesk.fr`

### 3. Ajouter les enregistrements DNS

1. Onglet **"DNS"**
2. **"Add record"**

**Pour Type A :**
- Type : `A`
- Name : `demo`
- IPv4 address : `151.101.1.195`
- Proxy status : **DNS only** (⚠️ Important !)
- TTL : `Auto`
- Save

Répéter pour : `151.101.65.195`

**Pour Type CNAME :**
- Type : `CNAME`
- Name : `demo`
- Target : `kinecare-81f52.web.app`
- Proxy status : **DNS only** (⚠️ Important !)
- TTL : `Auto`
- Save

**⚠️ IMPORTANT pour Cloudflare** :
- Désactiver le proxy orange (doit être gris : DNS only)
- Sinon Firebase ne pourra pas générer le certificat SSL

---

## ✅ Vérification de la Configuration

### 1. Retourner sur Firebase Console

1. Firebase Console → Hosting → Domaines
2. Firebase vérifiera automatiquement les enregistrements DNS
3. Attendre le message : **"Setup complete"** ✅

### 2. Vérifier avec les outils DNS

**Sur Linux/Mac :**
```bash
dig demo.medidesk.fr
```

**Sur Windows :**
```bash
nslookup demo.medidesk.fr
```

**Résultat attendu (Type A) :**
```
demo.medidesk.fr.    3600    IN    A    151.101.1.195
demo.medidesk.fr.    3600    IN    A    151.101.65.195
```

**Résultat attendu (Type CNAME) :**
```
demo.medidesk.fr.    3600    IN    CNAME    kinecare-81f52.web.app.
```

---

## ⏱️ Délais de Propagation

| Étape | Délai estimé |
|-------|--------------|
| Configuration DNS sur le registrar | Immédiate |
| Propagation DNS initiale | 10-30 minutes |
| Propagation DNS mondiale | 2-24 heures |
| Vérification par Firebase | 5-15 minutes |
| Génération certificat SSL | 10-30 minutes après vérification |
| Activation complète | 30 minutes - 24 heures |

**⚠️ Important** : La propagation DNS peut varier selon les providers et la localisation géographique.

---

## 🔐 Activation du Certificat SSL

Une fois les DNS vérifiés :

1. Firebase génère **automatiquement** un certificat SSL via **Let's Encrypt**
2. Le statut passera de **"Pending"** à **"Active"** ✅
3. HTTPS sera automatiquement activé
4. Redirection HTTP → HTTPS automatique

**Durée** : 10-30 minutes après vérification DNS

---

## 🧪 Tests Finaux

### 1. Test HTTP

```bash
curl -I http://demo.medidesk.fr
```

**Attendu** : Redirection 301 vers HTTPS

### 2. Test HTTPS

```bash
curl -I https://demo.medidesk.fr
```

**Attendu** : Statut 200 OK

### 3. Test dans le navigateur

Ouvrir : https://demo.medidesk.fr

**Vérifications :**
- ✅ Cadenas vert 🔒 (certificat SSL valide)
- ✅ Application MediDesk s'affiche
- ✅ Pas d'avertissement de sécurité

### 4. Vérifier le certificat SSL

**Sur le navigateur :**
- Cliquer sur le cadenas 🔒
- **"Certificat"** → Vérifier l'émetteur (Let's Encrypt)

**En ligne de commande :**
```bash
openssl s_client -connect demo.medidesk.fr:443 -servername demo.medidesk.fr
```

---

## 🆘 Dépannage

### Problème : "Domain not verified"

**Causes possibles :**
- DNS pas encore propagé
- Enregistrements DNS incorrects
- TTL trop élevé

**Solutions :**
1. Vérifier les enregistrements DNS sur le registrar
2. Attendre 30 minutes supplémentaires
3. Vérifier avec `dig demo.medidesk.fr`
4. Vider le cache DNS : `sudo systemd-resolve --flush-caches`

### Problème : "SSL certificate pending"

**Causes possibles :**
- Vérification DNS en cours
- Cloudflare proxy activé (doit être désactivé)

**Solutions :**
1. Attendre 30 minutes
2. Vérifier que le proxy Cloudflare est désactivé (gris, pas orange)
3. Firebase régénère automatiquement le certificat

### Problème : "DNS_PROBE_FINISHED_NXDOMAIN"

**Causes possibles :**
- Enregistrements DNS non propagés
- Erreur de configuration DNS

**Solutions :**
1. Vérifier les enregistrements DNS sur le registrar
2. Vérifier l'orthographe : `demo` (pas `démo`)
3. Attendre la propagation DNS (jusqu'à 24h)

### Problème : "ERR_SSL_VERSION_OR_CIPHER_MISMATCH"

**Causes possibles :**
- Certificat SSL pas encore généré

**Solutions :**
1. Attendre que Firebase génère le certificat (10-30 min)
2. Vérifier que la vérification DNS est complète

---

## 📞 Support

**Documentation Firebase Hosting :** https://firebase.google.com/docs/hosting/custom-domain  
**Vérificateur DNS en ligne :** https://dnschecker.org/  
**Test SSL en ligne :** https://www.ssllabs.com/ssltest/  

---

## ✅ Checklist Finale

Une fois la configuration terminée :

- [ ] Enregistrements DNS ajoutés sur le registrar
- [ ] Propagation DNS vérifiée avec `dig` ou `nslookup`
- [ ] Firebase a vérifié le domaine ✅
- [ ] Certificat SSL généré et actif 🔒
- [ ] https://demo.medidesk.fr accessible
- [ ] Redirection HTTP → HTTPS fonctionne
- [ ] Application MediDesk s'affiche correctement

**🎉 Votre domaine personnalisé est maintenant configuré !**

---

**Version 1.0.0 - Novembre 2025**
