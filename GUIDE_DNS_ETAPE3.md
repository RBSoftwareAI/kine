# 🌐 Guide Configuration DNS - Étape 3

**Domaine Cible :** `demo.medidesk.fr`  
**Status :** ⏳ **EN ATTENTE CONFIGURATION UTILISATEUR**

---

## 🎯 Objectif

Connecter votre domaine personnalisé `demo.medidesk.fr` à l'application MediDesk déployée sur Firebase Hosting.

**Résultat Final :**
- ✅ `https://demo.medidesk.fr` accessible
- ✅ Certificat HTTPS automatique (Let's Encrypt)
- ✅ Redirection automatique http → https

---

## 📋 Étapes de Configuration

### Étape 3.1 : Ajouter Domaine dans Firebase

**1. Aller sur Firebase Hosting Console :**
```
https://console.firebase.google.com/project/kinecare-81f52/hosting/domains
```

**2. Cliquer sur "Ajouter un domaine personnalisé"**

**3. Entrer le domaine :**
```
demo.medidesk.fr
```

**4. Firebase affichera les enregistrements DNS à configurer**

---

### Étape 3.2 : Configurer Votre Panneau DNS

Firebase fournira probablement des enregistrements de type **A** :

```
Type : A
Nom : demo
Valeur : 151.101.1.195 (ou IP fournie par Firebase)
TTL : 3600
```

**Avec vos accès DNS, ajoutez ces enregistrements dans votre panneau de configuration DNS.**

---

### Étape 3.3 : Vérification Propagation DNS

**Attendre 15-60 minutes après configuration, puis vérifier :**

```bash
nslookup demo.medidesk.fr
# Doit retourner l'IP Firebase

# Alternative
dig demo.medidesk.fr
```

**Outil en ligne :**
```
https://dnschecker.org/#A/demo.medidesk.fr
```

---

### Étape 3.4 : Certificat SSL Automatique

Firebase émettra automatiquement un certificat SSL Let's Encrypt après vérification DNS.

**Délai :** 1-24 heures après propagation DNS

**Vérification :**
- Ouvrir : `https://demo.medidesk.fr`
- Cadenas vert dans la barre d'adresse ✅
- Certificat valide "Let's Encrypt" ✅

---

## 📊 Estimation Temporelle

| Étape | Durée |
|-------|-------|
| Ajout domaine Firebase | 2 min |
| Configuration DNS | 5-10 min |
| Propagation DNS | 15-60 min |
| Certificat SSL | 1-24h |
| **Total** | **1-25h** |

**Note :** Dans la plupart des cas, accessible en **30-60 minutes**.

---

## 🎯 Résultat Final

**Avant Configuration DNS :**
```
https://kinecare-81f52.web.app
```

**Après Configuration DNS :**
```
https://demo.medidesk.fr
```

Les deux URLs resteront fonctionnelles après configuration.

---

*Guide généré le 24 novembre 2024 - MediDesk v4*
