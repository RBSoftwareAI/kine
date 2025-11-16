# ⚡ AI Quick Start - MediDesk

**Date :** 16 novembre 2025  
**Durée de lecture :** 3 minutes  
**Objectif :** Démarrer rapidement sur le projet MediDesk

---

## 🎯 PROJET EN 30 SECONDES

**MediDesk** = Logiciel de gestion **open source** (MIT) pour kinésithérapeutes

**Stack Technique :**
- **Frontend :** Flutter 3.35.4 + Dart 3.9.2 (locked versions)
- **Backend :** Flask 3.0.0 + SQLite + SQLCipher (AES-256)
- **Paiements :** Stripe (SaaS hébergé)

**État Actuel :** 🟢 95% production-ready, pilote Tourcoing réussi

---

## 📂 STRUCTURE PROJET (Quick Map)

```
flutter_app/
├── lib/                        # Code Flutter (Dart)
│   ├── main.dart               # Point d'entrée
│   ├── models/                 # Modèles de données (User, Patient, PainPoint)
│   ├── providers/              # State management (Provider)
│   ├── services/               # API clients (backend calls)
│   ├── views/                  # Écrans UI
│   │   ├── auth/               # Connexion/Inscription
│   │   ├── home/               # Dashboard
│   │   ├── patients/           # Gestion patients
│   │   ├── pain/               # Cartographie douleur ⭐
│   │   └── admin/              # Gestion permissions (NEW)
│   └── theme/                  # Material Design 3
│
├── backend/                    # API Flask (Python)
│   ├── api/app.py              # API REST principale
│   ├── database/schema.sql     # Schéma SQLite + données démo
│   └── utils/                  # Scripts utilitaires
│
├── website/                    # Site web marketing ⭐ (NEW)
│   ├── index.html              # Landing page
│   ├── legal/                  # CGV/CGU/RGPD
│   └── backend_stripe.py       # API Stripe (abonnements)
│
└── docs/                       # Documentation complète
```

---

## 🔑 COMPTES DÉMO (Pour Tests)

```
Super Admin : sadmin@medidesk.local / sadmin123
Manager     : patron@medidesk.local / manager123
Kiné        : kine@demo.com / kine123
Coach       : coach@demo.com / coach123
Patient     : patient@demo.com / patient123
```

---

## 🚀 COMMANDES ESSENTIELLES

### Démarrer l'Application Flutter

```bash
cd /home/user/flutter_app

# Pre-flight check (RECOMMANDÉ)
flutter analyze && flutter pub get

# Démarrer serveur web (release mode)
flutter build web --release && \
cd build/web && \
python3 -c "
import http.server, socketserver
class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('X-Frame-Options', 'ALLOWALL')
        self.send_header('Content-Security-Policy', 'frame-ancestors *')
        super().end_headers()
with socketserver.TCPServer(('0.0.0.0', 5060), CORSRequestHandler) as httpd:
    httpd.serve_forever()
" &

# Obtenir URL publique
# (Utiliser GetServiceUrl tool avec port 5060)
```

### Backend API (Si nécessaire)

```bash
cd /home/user/flutter_app/backend/api
python3 app.py  # Démarre sur port 5000
```

### Restart Complet (Après Modifications)

```bash
cd /home/user/flutter_app
lsof -ti:5060 | xargs -r kill -9  # Kill serveur
rm -rf build/web .dart_tool/build_cache  # Clean cache
flutter pub get && flutter analyze  # Vérif
# Puis relancer build web (commande ci-dessus)
```

---

## 📋 VERSIONS LOCKÉES (⚠️ NE PAS METTRE À JOUR)

| Composant | Version | Raison |
|-----------|---------|--------|
| **Flutter** | 3.35.4 | Stabilité |
| **Dart** | 3.9.2 | Locked avec Flutter |
| **Provider** | 6.1.5+1 | State management |
| **Hive** | 2.2.3 | DB locale |
| **Flask** | 3.0.0 | Backend API |

**❌ NE JAMAIS FAIRE :**
- `flutter upgrade`
- `dart pub upgrade`
- Modifier versions dans `pubspec.yaml`

---

## 🎨 FEATURES PRINCIPALES

### 1. Cartographie Douleur Interactive ⭐

**Fichier :** `lib/views/pain/widgets/body_silhouette.dart`

- Silhouettes anatomiques face/dos
- Vue DOS améliorée avec colonne vertébrale (NEW)
- Zones cliquables pour ajouter points douleur
- Échelle visuelle analogique 0-10

### 2. Gestion Permissions Hiérarchique ⭐ (NEW)

**Fichier :** `lib/views/admin/permissions_management_screen.dart`

- Hiérarchie : sadmin → manager → délégué → kine/coach → patient
- Délégation permissions (permanente/temporaire)
- Écran complet avec statistiques et filtres

### 3. Système d'Authentification

**Fichier :** `lib/providers/auth_provider.dart`

- JWT tokens (si backend activé)
- Comptes démo pour tests (hors ligne)
- Rôles : sadmin, manager, kine, coach, patient

---

## 🐛 TROUBLESHOOTING RAPIDE

### Port 5060 déjà utilisé

```bash
lsof -ti:5060 | xargs -r kill -9
```

### Erreur "No Firebase App"

**Solution :** L'app utilise SQLite local (pas Firebase) en mode démo

### Erreur compilation Flutter

```bash
flutter clean
rm -rf .dart_tool
flutter pub get
```

---

## 📚 DOCUMENTATION COMPLÈTE

**Après avoir lu ce fichier, lire :** `CONTEXT.md` (documentation exhaustive)

**Autres docs importantes :**
- `CORRECTIONS_16_NOV_2025.md` - Dernières corrections P0
- `website/README.md` - Package marketing complet
- `website/GUIDE_TRANSFERT_NOUVELLE_SESSION.md` - Déploiement production

---

## 💡 CONSEILS POUR IA

### Avant de Modifier le Code

1. ✅ **Lire** `AI_QUICK_START.md` (ce fichier)
2. ✅ **Lire** `CONTEXT.md` (contexte complet)
3. ✅ **Analyser** la demande utilisateur
4. ✅ **Vérifier** versions lockées (pas de mise à jour)

### Pendant le Développement

- ✅ **Respecter** architecture Provider (state management)
- ✅ **Utiliser** Material Design 3 (theme existant)
- ✅ **Tester** avec comptes démo avant de livrer
- ✅ **Documenter** les changements (inline comments)

### Après les Modifications

- ✅ **Analyser** avec `flutter analyze`
- ✅ **Tester** preview web (port 5060)
- ✅ **Commit** avec message clair
- ✅ **Push** sur GitHub

---

## 🔗 LIENS UTILES

- **Repository :** github.com/RBSoftwareAI/kine
- **Branche principale :** `base` (stable) ou `main` (développement)
- **License :** MIT (open source)

---

## ✅ CHECKLIST DÉMARRAGE

Avant de commencer le développement :

- [ ] J'ai lu `AI_QUICK_START.md` (ce fichier)
- [ ] J'ai lu `CONTEXT.md` (documentation complète)
- [ ] J'ai compris l'architecture (Flutter + Flask)
- [ ] Je connais les comptes démo
- [ ] Je sais comment démarrer l'app (commandes ci-dessus)
- [ ] J'ai vérifié que les versions sont lockées (pas de mise à jour)
- [ ] Je comprends la demande de l'utilisateur

**→ Prêt à développer ! 🚀**

---

**📅 Document créé le 16 novembre 2025**  
**🔄 Mis à jour à chaque session**  
**⏱️ Lecture : 3 minutes**

---

**Pour documentation complète, lire maintenant : `CONTEXT.md`**
