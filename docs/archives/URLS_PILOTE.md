# 🌐 URLs MEDIDESK - Pilote Tourcoing

**Version** : 1.0  
**Date de mise à jour** : 18 novembre 2025

---

## 📱 APPLICATION WEB (FRONTEND)

### **URL de Test Actuelle (Sandbox)**
```
https://5060-iwvw0ubiemorjzzgug549-2b54fc91.sandbox.novita.ai
```

**Statut** : ✅ Actif  
**Type** : Serveur de développement (temporaire)  
**Utilisation** : Tests internes et validation

---

### **URL de Production (À venir)**
```
https://app.medidesk.fr
```

**Statut** : ⏳ En attente de déploiement  
**Type** : Production (Netlify)  
**Utilisation** : Pilote Tourcoing et utilisateurs finaux

**Étapes pour activer** :
1. Déployer sur Netlify (15 minutes)
2. Configurer DNS : `CNAME app → [netlify-url].netlify.app`
3. Attendre propagation DNS (5-30 minutes)

---

## 🔌 BACKEND API

### **URL Locale (Développement)**
```
http://localhost:8080/api/
```

**Statut** : ✅ Actif (Backend Flask)  
**Type** : Serveur local  
**Utilisation** : Développement et tests backend

---

### **URL de Production (À venir)**
```
https://api.medidesk.fr
```

**Statut** : ⏳ En attente de déploiement  
**Type** : Production (Render ou VPS)  
**Utilisation** : API pour l'application production

**Endpoints disponibles** :
- `POST /api/auth/login` - Authentification
- `GET /api/patients` - Liste des patients
- `POST /api/patients` - Créer un patient
- `GET /api/pain-points/:patientId` - Points de douleur
- `POST /api/sessions` - Créer une séance
- `GET /health` - Health check (monitoring)

---

## 🔐 COMPTES DE TEST

### **Compte Kinésithérapeute** (Usage principal)
```
📧 Email    : kine@demo.com
🔑 Password : kine123
```

### **Compte Manager** (Gestion cabinet)
```
📧 Email    : patron@medidesk.local
🔑 Password : manager123
```

### **Compte Super Admin** (Configuration système)
```
📧 Email    : sadmin@medidesk.local
🔑 Password : sadmin123
```

---

## 🗂️ REPOSITORY GITHUB

### **Code Source**
```
https://github.com/RBSoftwareAI/kine
```

**Branche** : `base`  
**Visibilité** : Privé (ou Public selon configuration)  
**Derniers commits** : 3 commits (18 novembre 2025)

---

## 📚 DOCUMENTATION

### **Guide Utilisateur**
```
https://github.com/RBSoftwareAI/kine/blob/base/GUIDE_UTILISATEUR_TOURCOING.md
```

### **Guide de Déploiement Express**
```
https://github.com/RBSoftwareAI/kine/blob/base/DEPLOIEMENT_QUICKSTART.md
```

### **Architecture Hybride**
```
https://github.com/RBSoftwareAI/kine/blob/base/ARCHITECTURE_HYBRIDE_LOCALE.md
```

### **Intégration Doctolib**
```
https://github.com/RBSoftwareAI/kine/blob/base/INTEGRATION_DOCTOLIB_MAIIA.md
```

### **Justification SaaS**
```
https://github.com/RBSoftwareAI/kine/blob/base/VALEUR_SAAS_VS_OPEN_SOURCE.md
```

---

## 📧 CONTACT & SUPPORT

### **Email Support**
```
contact@medidesk.fr
```

**Réponse** : < 24 heures pendant le pilote

---

### **Issues GitHub**
```
https://github.com/RBSoftwareAI/kine/issues
```

**Pour** : Bugs techniques, demandes de fonctionnalités

---

## 🔧 OUTILS DE DÉVELOPPEMENT

### **Netlify Dashboard** (Frontend)
```
https://app.netlify.com
```

**Connexion** : Avec compte GitHub  
**Projet** : MediDesk Frontend

---

### **Render Dashboard** (Backend)
```
https://render.com
```

**Connexion** : Avec compte GitHub  
**Projet** : medidesk-backend

---

## 📊 MONITORING & ANALYTICS

### **Health Check Endpoint**
```
https://api.medidesk.fr/health
```

**Réponse attendue** :
```json
{
  "status": "healthy",
  "timestamp": "2025-11-18T10:00:00Z",
  "database": {
    "connected": true,
    "total_records": 6
  }
}
```

---

### **Logs Backend** (Production)
```bash
# Render.com : Dashboard → Logs
# VPS : sudo journalctl -u medidesk-backend -f
```

---

## 🌍 DOMAINE PRINCIPAL

### **Domaine Actuel**
```
medidesk.fr
```

**Registrar** : [À compléter - OVH, Gandi, etc.]  
**Expiration** : [À compléter]

**Sous-domaines configurés** :
- `app.medidesk.fr` → Frontend Flutter
- `api.medidesk.fr` → Backend Flask
- `www.medidesk.fr` → Redirection vers app.medidesk.fr

---

## 🚀 CHECKLIST DE DÉPLOIEMENT

### **Frontend (Netlify)**
- [ ] Build Flutter : `flutter build web --release`
- [ ] Upload sur Netlify (drag & drop `build/web`)
- [ ] Configurer domaine personnalisé : `app.medidesk.fr`
- [ ] Vérifier DNS : `dig app.medidesk.fr`
- [ ] Tester URL : https://app.medidesk.fr

### **Backend (Render)**
- [ ] Créer Web Service depuis GitHub
- [ ] Configurer variables d'environnement (SECRET_KEY, JWT_SECRET_KEY)
- [ ] Vérifier déploiement : https://[app-name].onrender.com
- [ ] Configurer domaine personnalisé : `api.medidesk.fr`
- [ ] Tester health check : https://api.medidesk.fr/health

### **DNS (Registrar)**
- [ ] CNAME `app` → Netlify
- [ ] CNAME `api` → Render
- [ ] Vérifier propagation (5-30 minutes)
- [ ] Tester résolution DNS

---

## 📅 TIMELINE DU PILOTE

### **Phase 1 : Déploiement** (Semaine 1)
- **Jour 1** : Déploiement backend (Render)
- **Jour 2** : Déploiement frontend (Netlify)
- **Jour 3** : Configuration DNS
- **Jour 4** : Tests de validation
- **Jour 5** : Onboarding testeurs

### **Phase 2 : Pilote Actif** (Semaines 2-4)
- Utilisation quotidienne par testeurs Tourcoing
- Collecte feedback hebdomadaire
- Corrections mineures si nécessaires

### **Phase 3 : Bilan** (Semaine 5)
- Analyse des retours (satisfaction attendue 9/10)
- Planification v1.1 ou v2.0
- Décision déploiement multi-cabinets

---

## 🔄 MISES À JOUR

**Dernière mise à jour** : 18 novembre 2025

**Prochaine mise à jour prévue** :
- Après déploiement production (URLs finales)
- Après retours pilote (nouvelles fonctionnalités)

---

## 📝 NOTES IMPORTANTES

⚠️ **URL Sandbox** : Temporaire, peut expirer après quelques jours d'inactivité

✅ **URLs Production** : Permanentes, disponibles 24/7 après déploiement

🔒 **Sécurité** : HTTPS obligatoire pour toutes les URLs de production

📊 **Performance** : Temps de réponse < 300ms attendu pour le backend

---

**Pour toute question ou problème, contactez : contact@medidesk.fr**
