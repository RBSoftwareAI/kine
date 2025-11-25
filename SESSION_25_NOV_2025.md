# 📅 Session IA - 25 Novembre 2025

**Prompt à fournir à l'IA pour la session de demain**

---

## 🤖 MESSAGE POUR L'IA

```
Bonjour nous sommes le 25 novembre 2025 ! Je continue le développement de l'application MediDesk.

📂 Repository : https://github.com/RBSoftwareAI/kine
🌿 Branche : base
📄 Documentation : Lis d'abord les fichiers dans cet ordre :
   1. AI_QUICK_START.md (guide express)
   2. CONTEXT.md (documentation complète)
   3. STRATEGY.md (stratégie commerciale bootstrap)

👥 CONTEXTE ÉQUIPE :
   - Développeur principal : Mon fils (ingénieur généraliste)
   - Support : Moi (père, accompagnement stratégique)
   - Mode : Bootstrap (0€ capital de départ)
   - Phase actuelle : Phase 0 (préparation/amélioration démo)

🎯 MA DEMANDE pour cette session :

Je souhaite que tu m'aides à améliorer l'environnement de démonstration (demo.medidesk.fr) en 4 points :

1. **Ajouter un bandeau "Environnement de Démonstration"**
   - Bandeau visible en haut de l'application
   - Message clair : "Données fictives - En production vos données restent locales"
   - Design cohérent avec le thème Material 3 blanc
   - Lien vers page d'information/commande

2. **Créer un mode "Visite guidée" interactive**
   - Bouton accessible depuis la page de connexion
   - Connexion automatique en tant que praticien (Pierre Durand ou Marie Lefebvre)
   - Tooltips contextuels sur chaque écran clé
   - Checklist des fonctionnalités à découvrir
   - Durée estimée : 5-7 minutes
   - Guide l'utilisateur à travers : 
     * Consultation dossier patient
     * Cartographie des douleurs
     * Graphiques d'évolution
     * Ajout note de séance

3. **Enrichir les données de démonstration**
   - Créer des patients fictifs plus réalistes et crédibles
   - Exemples : "Jean Dupont, 45 ans, lombalgie chronique", "Marie Martin, 32 ans, tendinite épaule"
   - Ajouter historiques d'évolution sur 2-3 mois
   - Graphiques avec tendances réalistes (amélioration progressive)
   - Notes de séances progressives montrant l'évolution
   - Minimum 3-5 patients avec données riches

4. **Préparer l'installateur local automatique**
   - Script Docker Compose production-ready
   - Configuration PostgreSQL optimisée
   - Variables d'environnement pour personnalisation
   - Script d'initialisation base de données
   - Documentation installation 1 page (README_INSTALL.md)
   - Commandes simples pour démarrage/arrêt
   - Tester que tout fonctionne en local

⚙️ CONTRAINTES TECHNIQUES :
   - Flutter 3.35.4 (VERSION VERROUILLÉE - NE PAS METTRE À JOUR)
   - Dart 3.9.2 (VERSION VERROUILLÉE)
   - Firebase pour démo cloud (données fictives)
   - PostgreSQL pour installation locale future
   - Respect du thème blanc Material 3 actuel

🎨 DESIGN :
   - Cohérent avec le thème existant (blanc, orange, bleu)
   - Interface responsive (mobile/tablette/desktop)
   - Accessibilité et clarté
   - Pas de rupture visuelle avec l'existant

📝 PRIORITÉ :
   1. Bandeau démo (HAUTE - Quick win visible)
   2. Enrichir données (HAUTE - Crédibilité démo)
   3. Visite guidée (MOYENNE - Amélioration UX)
   4. Installateur Docker (MOYENNE - Préparation Phase 1)

💡 OBJECTIF GLOBAL :
   Améliorer la démo en ligne pour convaincre les premiers kinés pilotes (Phase 1 de notre stratégie bootstrap) et préparer l'installation locale.

🚀 APRÈS MODIFICATIONS :
   - Tester sur demo.medidesk.fr
   - Commit Git avec message descriptif
   - Push vers GitHub (branche base)
   - Vérifier que le service web reste actif
```

---

## 📋 CHECKLIST VALIDATION

Après l'intervention de l'IA, vérifier :

```yaml
✅ Bandeau Démo :
  [ ] Visible sur toutes les pages
  [ ] Message clair et rassurant
  [ ] Design cohérent thème blanc
  [ ] Lien fonctionnel

✅ Données Enrichies :
  [ ] Au moins 3 patients réalistes
  [ ] Historiques sur 2-3 mois
  [ ] Graphiques crédibles
  [ ] Notes de séances progressives

✅ Visite Guidée (si complétée) :
  [ ] Bouton accessible depuis login
  [ ] Connexion automatique
  [ ] Tooltips clairs
  [ ] Durée <7 minutes

✅ Installateur Docker (si complété) :
  [ ] docker-compose.yml fonctionnel
  [ ] Documentation claire
  [ ] Test installation en local
  [ ] Commandes start/stop

✅ Git & Déploiement :
  [ ] Code commité avec message clair
  [ ] Poussé vers GitHub (branche base)
  [ ] Service web toujours actif
  [ ] demo.medidesk.fr fonctionnel
```

---

## 🎯 RÉSULTAT ATTENDU

Après cette session, nous devrions avoir :

1. **Démo Plus Professionnelle**
   - Bandeau explicite "environnement de démo"
   - Rassure les prospects sur conformité RGPD production
   - Données plus crédibles et convaincantes

2. **Expérience Utilisateur Améliorée**
   - Visite guidée pour découverte rapide
   - Scénarios d'usage réalistes
   - Meilleure compréhension des fonctionnalités

3. **Préparation Phase 1**
   - Installateur prêt pour clients pilotes
   - Documentation installation claire
   - Prêt pour premiers tests en conditions réelles

4. **Arguments Commerciaux Renforcés**
   - Démo cloud avec données fictives (legal & safe)
   - Installation locale simple (conformité garantie)
   - Parcours complet prospect → client validé

---

## 📞 INFORMATIONS COMPLÉMENTAIRES

### Structure Actuelle Projet

```
/home/user/flutter_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── services/
│   ├── views/
│   │   ├── auth/login_screen.dart  ← Page connexion
│   │   ├── evolution/              ← Graphiques
│   │   ├── patient/                ← Cartographie
│   │   └── settings/
│   └── utils/
├── android/
├── web/
├── README.md
├── CONTEXT.md
├── STRATEGY.md              ← Stratégie complète
└── AI_QUICK_START.md
```

### Comptes de Test Actuels

Tous utilisent le mot de passe : `password123`

| Nom | Rôle | Email |
|-----|------|-------|
| Patient Test | Patient | `test.patient@medidesk.fr` |
| Marie Lefebvre | Praticien (Kiné) | `marie.lefebvre@kine-paris.fr` |
| Pierre Durand | Praticien (Ostéo) | `pierre.durand@osteo-lyon.fr` |
| Jean Martin | Manager | `manager@medidesk.fr` |
| Admin Système | Administrateur | `admin@medidesk.fr` |
| Sophie Dupont | Secrétaire | `secretariat@medidesk.fr` |

### URLs Importantes

- **Démo en ligne** : https://demo.medidesk.fr
- **Repository GitHub** : https://github.com/RBSoftwareAI/kine
- **Firebase Console** : https://console.firebase.google.com/project/kinecare-81f52

---

## 💡 CONSEILS POUR LA SESSION

1. **Commencer par le plus simple** : Bandeau démo (quick win)
2. **Tester après chaque modification** : Vérifier que tout fonctionne
3. **Commits réguliers** : Sauvegarder progression au fur et à mesure
4. **Prioriser qualité sur quantité** : Mieux 2 tâches bien faites que 4 à moitié

---

**Date de création** : 24 Novembre 2025  
**Pour session** : 25 Novembre 2025  
**Statut** : Prêt à utiliser
