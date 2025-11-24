# 🤝 Contributing to MediDesk

Merci de votre intérêt pour contribuer à MediDesk ! Ce document explique comment participer au projet.

---

## 📋 Code de Conduite

En participant à ce projet, vous vous engagez à :
- ✅ Être respectueux et professionnel
- ✅ Accepter les critiques constructives
- ✅ Collaborer dans l'intérêt du projet
- ✅ Respecter la confidentialité des données de santé

---

## 🚀 Comment Contribuer

### 1. Types de Contributions Bienvenues

**Code :**
- 🐛 Corrections de bugs
- ✨ Nouvelles fonctionnalités
- ⚡ Améliorations performances
- 🎨 Améliorations UI/UX
- 🌐 Traductions (internationalization)

**Documentation :**
- 📝 Corrections typos/grammaire
- 📚 Ajout exemples/tutoriels
- 🔧 Améliorations guides installation
- 💡 Cas d'usage réels

**Tests :**
- 🧪 Tests unitaires
- 🔍 Tests d'intégration
- 📱 Tests sur différents appareils

**Reporting :**
- 🐞 Signalement bugs
- 💬 Suggestions améliorations
- 📊 Retours d'expérience utilisateurs

---

## 🔧 Workflow de Contribution

### Étape 1 : Fork le Projet

```bash
# Via GitHub : Cliquer "Fork" en haut à droite
# Puis cloner votre fork
git clone https://github.com/VOTRE-USERNAME/kine.git
cd kine
```

### Étape 2 : Créer une Branche

```bash
# Créer une branche descriptive
git checkout -b feature/nom-fonctionnalite
# ou
git checkout -b fix/correction-bug
# ou
git checkout -b docs/amelioration-doc
```

**Nommage branches :**
- `feature/` : Nouvelle fonctionnalité
- `fix/` : Correction bug
- `docs/` : Documentation
- `refactor/` : Refactoring code
- `test/` : Ajout tests

### Étape 3 : Faire vos Modifications

**Bonnes pratiques :**
- ✅ Commits atomiques (une modification logique = un commit)
- ✅ Messages clairs (voir section Commits ci-dessous)
- ✅ Code formaté (`dart format .` pour Dart, `black` pour Python)
- ✅ Tests ajoutés pour nouvelles features

### Étape 4 : Tester Localement

**Flutter :**
```bash
cd /path/to/flutter_app
flutter analyze  # Vérifier erreurs
flutter test     # Lancer tests
flutter build web --release  # Test build
```

**Backend Python :**
```bash
cd backend
python3 -m pytest  # Si tests configurés
python3 start_server.py  # Tester serveur
```

### Étape 5 : Commit & Push

```bash
git add .
git commit -m "feat: description concise de la feature"
git push origin feature/nom-fonctionnalite
```

### Étape 6 : Créer Pull Request

1. **Aller sur GitHub** → Votre fork
2. **Cliquer "New Pull Request"**
3. **Remplir template PR :**
   - Description claire des changements
   - Motivation (pourquoi cette modification ?)
   - Tests effectués
   - Screenshots si UI/UX

---

## 📝 Standards de Code

### Dart/Flutter

**Style :**
- Suivre [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Utiliser `dart format .` avant commit
- Analyse : `flutter analyze` doit passer sans erreurs critiques

**Conventions :**
```dart
// ✅ BON : Noms explicites
class PatientPainTracker {
  Future<List<PainPoint>> loadPainHistory() async { ... }
}

// ❌ MAUVAIS : Noms vagues
class PPT {
  Future<List<PP>> loadHist() async { ... }
}
```

**Documentation :**
```dart
/// Charge l'historique des points de douleur pour un patient
/// 
/// [patientId] : Identifiant unique du patient
/// Returns : Liste des points de douleur triés par date décroissante
/// Throws : [DatabaseException] si erreur de connexion
Future<List<PainPoint>> loadPainHistory(String patientId) async {
  // ...
}
```

### Python

**Style :**
- Suivre [PEP 8](https://pep8.org/)
- Utiliser `black` pour formatage automatique
- Type hints recommandés

**Conventions :**
```python
# ✅ BON : Type hints, docstrings
def calculate_improvement_rate(
    initial_pain: int, 
    current_pain: int
) -> float:
    """
    Calcule le taux d'amélioration de la douleur.
    
    Args:
        initial_pain: Douleur initiale (0-10)
        current_pain: Douleur actuelle (0-10)
        
    Returns:
        Taux d'amélioration en pourcentage (0-100)
    """
    return ((initial_pain - current_pain) / initial_pain) * 100
```

---

## 💬 Messages de Commit

**Format Conventional Commits :**

```
<type>(<scope>): <description>

[corps optionnel]

[footer optionnel]
```

**Types :**
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction bug
- `docs`: Documentation seule
- `style`: Formatage (pas de changement logique)
- `refactor`: Refactoring code
- `test`: Ajout/modification tests
- `chore`: Maintenance (dépendances, config)

**Exemples :**
```bash
feat(pain-tracking): Ajout silhouette vue de dos
fix(auth): Correction timeout connexion Firebase
docs(readme): Mise à jour instructions installation
refactor(database): Optimisation requêtes SQL
test(pain-sessions): Ajout tests unitaires création séance
```

---

## 🐛 Signaler un Bug

**Avant de créer une Issue :**
1. ✅ Vérifier que le bug n'est pas déjà signalé
2. ✅ Tester avec dernière version (`git pull origin main`)
3. ✅ Reproduire le bug de manière fiable

**Template Issue Bug :**

```markdown
**Description**
Description claire et concise du bug

**Reproduction**
Étapes pour reproduire :
1. Aller à '...'
2. Cliquer sur '...'
3. Voir erreur

**Comportement attendu**
Ce qui devrait se passer

**Comportement actuel**
Ce qui se passe réellement

**Screenshots**
Si applicable, ajouter captures d'écran

**Environnement**
- OS : [ex: Windows 10, Ubuntu 22.04]
- Flutter version : [ex: 3.35.4]
- Navigateur : [ex: Chrome 120]

**Logs/Erreurs**
Copier les messages d'erreur console
```

---

## 💡 Proposer une Fonctionnalité

**Template Issue Feature Request :**

```markdown
**Problème à Résoudre**
Quel problème cette fonctionnalité résout-elle ?

**Solution Proposée**
Description claire de la fonctionnalité souhaitée

**Alternatives Considérées**
Autres solutions envisagées

**Contexte Additionnel**
Cas d'usage, mockups, exemples
```

---

## 🧪 Tests

**Tests requis pour nouvelles features :**

**Flutter (Tests widgets) :**
```dart
testWidgets('PainTracker affiche 18 zones corporelles', (tester) async {
  await tester.pumpWidget(PainTrackerWidget());
  
  // Vérifier que les 18 zones sont présentes
  expect(find.text('Cou'), findsOneWidget);
  expect(find.text('Dos'), findsOneWidget);
  // ... etc
});
```

**Python (Tests unitaires) :**
```python
def test_calculate_improvement_rate():
    """Test calcul taux amélioration"""
    rate = calculate_improvement_rate(initial_pain=8, current_pain=4)
    assert rate == 50.0
```

---

## 🌐 Traductions

**Ajouter une langue :**

1. Créer fichier `lib/l10n/app_[CODE_LANGUE].arb`
2. Traduire toutes les clés du fichier `app_fr.arb`
3. Ajouter langue dans `pubspec.yaml`

**Exemple traduction anglais :**
```json
{
  "@@locale": "en",
  "appTitle": "MediDesk",
  "painTracking": "Pain Tracking",
  "statistics": "Statistics"
}
```

---

## 📄 Documentation

**Fichiers à mettre à jour si modification fonctionnalité majeure :**

- `README.md` : Vue d'ensemble
- `DEPLOIEMENT.md` : Si changements déploiement
- `docs/` : Documentation spécifique
- Code : Commentaires inline pour logique complexe

---

## ✅ Checklist Pull Request

**Avant de soumettre PR, vérifiez :**

- [ ] Code formaté (`dart format .` / `black`)
- [ ] `flutter analyze` passe sans erreurs critiques
- [ ] Tests existants passent (`flutter test`)
- [ ] Nouveaux tests ajoutés si feature
- [ ] Documentation mise à jour
- [ ] Commits suivent convention
- [ ] Branche à jour avec `main`
- [ ] Description PR complète

---

## 🏅 Reconnaissance Contributeurs

**Contributeurs seront ajoutés dans :**
- Section "Contributors" du README
- `CONTRIBUTORS.md` avec rôle/contributions
- Mentions dans releases notes

**Contributeurs réguliers :**
- Badge "Core Contributor" GitHub
- Possibilité devenir mainteneur
- Mention dans communications projet

---

## 💬 Communication

**Canaux :**
- 🐛 **Issues GitHub** : Bugs, features
- 💬 **Discussions GitHub** : Questions, idées
- 📧 **Email** : [VOTRE EMAIL] (questions privées)

**Temps de réponse :**
- Issues critiques : <24h
- Issues normales : <72h
- Pull Requests : <1 semaine

---

## 🚫 Ce qui N'est PAS Accepté

❌ **Code malveillant** (détection = ban permanent)  
❌ **Violation RGPD** (exposition données patients)  
❌ **Code non testé** (features majeures sans tests)  
❌ **Spam** (issues/PRs non constructives)  
❌ **Plagiat** (code copié sans attribution)  

---

## 📜 Licence

En contribuant, vous acceptez que vos contributions soient sous **licence MIT** (voir [LICENSE](LICENSE)).

---

## 🙏 Remerciements

Merci de contribuer à améliorer les soins de santé via l'open source !

**Chaque contribution, petite ou grande, compte.** 🎉

---

**🏥 MediDesk - Open Source Healthcare Software**

**Questions ? Ouvrir une Discussion sur GitHub !**
