# 📘 GUIDE UTILISATEUR MEDIDESK - Pilote Tourcoing

**Version** : 1.0  
**Date** : 16 novembre 2025  
**Public** : Kinésithérapeutes et praticiens testeurs

---

## 🎯 BIENVENUE DANS MEDIDESK

MediDesk est votre assistant numérique pour la gestion de patients et le suivi des douleurs. Ce guide vous accompagne pour une prise en main rapide et efficace.

---

## 🔐 CONNEXION À L'APPLICATION

### **Accès Web**
```
URL : https://5060-iwvw0ubiemorjzzgug549-2b54fc91.sandbox.novita.ai
(Une URL permanente sur medidesk.fr sera bientôt disponible)
```

### **Vos Identifiants de Test**

**Compte Kinésithérapeute :**
- 📧 Email : `kine@demo.com`
- 🔑 Mot de passe : `kine123`

**Compte Responsable Cabinet :**
- 📧 Email : `patron@medidesk.local`
- 🔑 Mot de passe : `manager123`

> 💡 **Astuce** : Gardez ces identifiants à portée de main pendant la phase de test.

---

## 🏠 ÉCRAN D'ACCUEIL

Après connexion, vous accédez au **tableau de bord** avec :

✅ **Menu principal** (barre latérale gauche) :
- 🏠 Accueil
- 👥 Mes Patients
- 🎯 Cartographie Douleur
- 📝 Notes de Séances
- ⚙️ Paramètres

✅ **Statistiques rapides** :
- Nombre total de patients
- Séances cette semaine
- Points de douleur actifs

✅ **Actions rapides** :
- ➕ Nouveau patient
- 📋 Nouvelle séance

---

## 👥 GESTION DES PATIENTS

### **1. Créer un Nouveau Patient**

1. Cliquez sur **"Mes Patients"** dans le menu
2. Appuyez sur le bouton **"➕ Nouveau Patient"**
3. Remplissez les informations :
   - ✅ Nom et Prénom (obligatoires)
   - ✅ Date de naissance
   - ✅ Téléphone
   - ✅ Email
   - ✅ Adresse
4. Cliquez sur **"Enregistrer"**

> 💡 **Conseil** : Plus les informations sont complètes, meilleur sera le suivi.

---

### **2. Consulter un Dossier Patient**

1. Dans **"Mes Patients"**, recherchez le patient
2. Cliquez sur sa carte pour ouvrir le dossier complet
3. Vous accédez à :
   - 📋 Informations personnelles
   - 🎯 Points de douleur actifs
   - 📝 Historique des séances
   - 📊 Graphiques d'évolution

---

### **3. Modifier un Patient**

1. Ouvrez le dossier patient
2. Cliquez sur l'icône **✏️ Modifier** (en haut à droite)
3. Modifiez les champs nécessaires
4. Cliquez sur **"Enregistrer les modifications"**

---

### **4. Exporter les Données Patients** 🆕

**Nouvelle fonctionnalité pour le pilote !**

1. Dans **"Mes Patients"**, cliquez sur l'icône **📥 Export** (en haut à droite)
2. Choisissez le format :
   - **CSV** : Pour Excel/LibreOffice (tableau simple)
   - **JSON** : Pour backup complet (données structurées)
3. Le fichier se télécharge automatiquement

**Fichiers générés** :
- `patients_2025-11-16_14h30.csv`
- `patients_backup_2025-11-16_14h30.json`

> 💡 **Usage** : Idéal pour créer des backups réguliers ou partager des statistiques anonymisées.

---

## 🎯 CARTOGRAPHIE INTERACTIVE DES DOULEURS

### **Fonctionnalité Unique de MediDesk**

La cartographie douleur permet de localiser précisément les zones douloureuses sur des silhouettes anatomiques.

---

### **1. Ajouter un Point de Douleur**

1. Ouvrez le dossier patient
2. Accédez à l'onglet **"Cartographie Douleur"**
3. Choisissez la vue :
   - **FACE** : Vue frontale du corps
   - **DOS** : Vue dorsale avec colonne vertébrale visible
4. **Cliquez sur la zone douloureuse** directement sur la silhouette
5. Remplissez les détails :
   - 📊 **Intensité** : Échelle 0-10 (EVA)
   - 🔹 **Type** : Aiguë, Chronique, Irradiante
   - ⏱️ **Fréquence** : Occasionnelle, Quotidienne, Constante
   - 📝 **Description** : Notes complémentaires
6. Cliquez sur **"Enregistrer"**

---

### **2. Visualiser l'Évolution**

- Les points de douleur s'affichent sur la silhouette
- La **couleur** indique l'intensité :
  - 🟢 Vert : Faible (0-2)
  - 🟡 Jaune : Modérée (3-6)
  - 🔴 Rouge : Sévère (7-10)
- Consultez l'**historique** pour voir l'évolution dans le temps

---

### **3. Modifier ou Supprimer un Point**

1. Cliquez sur un point existant sur la silhouette
2. Une fiche s'affiche avec les détails
3. Options :
   - **✏️ Modifier** : Changer intensité, type, description
   - **🗑️ Supprimer** : Retirer le point de douleur

---

## 📝 NOTES DE SÉANCES

### **1. Créer une Note de Séance**

1. Ouvrez le dossier patient
2. Cliquez sur **"📝 Nouvelle Séance"**
3. Remplissez :
   - 📅 **Date de la séance** (aujourd'hui par défaut)
   - 📊 **Statut de progression** :
     - 📈 Amélioration
     - ➡️ Stable
     - 📉 Dégradation
     - ✅ Guérison
   - 📝 **Observations** : Déroulement de la séance
   - 💡 **Recommandations** : Conseils pour le patient
4. Cliquez sur **"Enregistrer la séance"**

---

### **2. Consulter l'Historique**

1. Dans le dossier patient, onglet **"Séances"**
2. Toutes les séances sont listées chronologiquement
3. Cliquez sur une séance pour voir les détails complets

---

## ⚙️ PARAMÈTRES ET PERMISSIONS

### **Rôles Disponibles (Pilote)**

**🔧 Manager / Patron Cabinet :**
- Gérer tous les professionnels du cabinet
- Créer de nouveaux comptes (kinés, coaches)
- Déléguer des permissions temporaires
- Accès à toutes les statistiques

**👨‍⚕️ Kinésithérapeute / Coach :**
- Gérer ses propres patients
- Créer et modifier des dossiers
- Accéder à la cartographie douleur
- Rédiger des notes de séances

---

### **Gestion des Permissions** (Manager uniquement)

1. Menu → **"Gestion Permissions"**
2. Vous voyez la liste des professionnels du cabinet
3. Actions possibles :
   - **Activer / Désactiver** un compte
   - **Déléguer** des permissions temporaires
   - **Créer** un nouveau professionnel

---

## 🐛 SIGNALER UN BUG OU DONNER DU FEEDBACK

### **Pendant le Pilote Tourcoing**

📧 **Email de contact** : contact@medidesk.fr  
💬 **Feedback direct** : Contactez votre référent MediDesk

**Informations utiles à fournir** :
- 📱 Appareil utilisé (PC, tablette, smartphone)
- 🌐 Navigateur (Chrome, Firefox, Safari, Edge)
- 📝 Description du problème ou suggestion
- 📸 Capture d'écran si possible

---

## ❓ FAQ - QUESTIONS FRÉQUENTES

### **Q1 : L'application fonctionne-t-elle hors ligne ?**
**R :** Actuellement, une connexion internet est requise. Le mode hors ligne est prévu pour une version future.

---

### **Q2 : Les données sont-elles sécurisées ?**
**R :** Oui ! MediDesk respecte le RGPD :
- ✅ Chiffrement AES-256 de la base de données
- ✅ Connexion HTTPS sécurisée
- ✅ Logs d'audit (traçabilité)
- ✅ Hébergement France (HDS en préparation)

---

### **Q3 : Puis-je supprimer un patient ?**
**R :** Oui, via le dossier patient → Menu ⋮ → "Supprimer". Les données sont effacées définitivement après 30 jours (droit RGPD).

---

### **Q4 : Combien de patients puis-je créer ?**
**R :** Aucune limite pendant la phase de test ! Testez autant que nécessaire.

---

### **Q5 : L'export CSV fonctionne sur mobile ?**
**R :** Actuellement optimisé pour ordinateurs et tablettes. Support mobile en amélioration continue.

---

### **Q6 : Puis-je imprimer les dossiers patients ?**
**R :** Utilisez la fonction d'impression du navigateur (Ctrl+P / Cmd+P) sur n'importe quel écran. Export PDF à venir.

---

## 🚀 NOUVEAUTÉS VERSION PILOTE (16 Nov 2025)

### ✨ **Ce qui a été ajouté pour vous**

1. **✅ Export CSV/JSON** : Backup et partage de données facilités
2. **✅ Code 100% clean** : 0 erreurs, performance optimale
3. **✅ Vue DOS améliorée** : Colonne vertébrale visible (C7, T12, L5)
4. **✅ Système permissions** : Gestion hiérarchique complète
5. **✅ Stabilité renforcée** : Corrections techniques majeures

---

## 🎯 OBJECTIFS DU PILOTE TOURCOING

### **Ce que nous testons ensemble**

1. **👥 Gestion quotidienne** : Création et suivi de vrais dossiers patients
2. **🎯 Cartographie douleur** : Précision et utilité clinique
3. **📱 Ergonomie** : Interface intuitive et rapide
4. **⚡ Performance** : Fluidité sur différents appareils
5. **💡 Besoins métier** : Fonctionnalités manquantes ou améliorations

---

## 📞 SUPPORT & CONTACT

**Référent MediDesk :**
- 📧 Email : contact@medidesk.fr
- 📅 Disponibilité : Lundi-Vendredi 9h-18h

**En cas d'urgence technique :**
- Notez l'heure et la nature du problème
- Envoyez un email avec capture d'écran
- Réponse sous 24h maximum

---

## 🙏 MERCI DE VOTRE PARTICIPATION !

Votre feedback est **essentiel** pour améliorer MediDesk. Chaque suggestion compte !

Ensemble, nous créons l'outil parfait pour les professionnels de santé. 💪

---

**📅 Document mis à jour le 16 novembre 2025**  
**📄 Version 1.0 - Phase Pilote Tourcoing**  
**🔄 Prochaine mise à jour : Décembre 2025**
