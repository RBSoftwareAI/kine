# 🔗 Intégration Backend Local avec Flutter

## 📋 Vue d'ensemble

Ce guide explique comment connecter l'application Flutter KinéCare au backend local SQLite.

**Architecture :**
```
Flutter App (Frontend)
     ↓ HTTP
API REST Local (Flask - Port 8080)
     ↓
SQLite Database (Fichier local)
```

---

## 🔧 Configuration Flutter

### 1. Créer le service de connexion local

**Créer `lib/services/local_api_service.dart` :**

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalApiService {
  // URL du backend local
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Pour réseau local : remplacer par l'IP du serveur
  // static const String baseUrl = 'http://192.168.1.10:8080/api';
  
  String? _authToken;
  
  // ============================================
  // Authentification
  // ============================================
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _authToken = data['token'];
      return {'success': true, 'user': data['user']};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'error': error['error']};
    }
  }
  
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return {'success': true, 'user_id': data['user_id']};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'error': error['error']};
    }
  }
  
  // ============================================
  // Gestion des douleurs
  // ============================================
  
  Future<List<dynamic>> getPainPoints(String patientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pain/points/$patientId'),
      headers: _getAuthHeaders(),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['pain_points'];
    } else {
      throw Exception('Erreur lors de la récupération des douleurs');
    }
  }
  
  Future<Map<String, dynamic>> createPainPoint(Map<String, dynamic> painData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pain/points'),
      headers: _getAuthHeaders(),
      body: json.encode(painData),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return {'success': true, 'pain_id': data['pain_id']};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'error': error['error']};
    }
  }
  
  Future<List<dynamic>> getPainHistory(
    String patientId, {
    String? startDate,
    String? endDate,
  }) async {
    var uri = Uri.parse('$baseUrl/pain/history/$patientId');
    
    if (startDate != null || endDate != null) {
      final params = <String, String>{};
      if (startDate != null) params['start_date'] = startDate;
      if (endDate != null) params['end_date'] = endDate;
      uri = uri.replace(queryParameters: params);
    }
    
    final response = await http.get(uri, headers: _getAuthHeaders());
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['history'];
    } else {
      throw Exception('Erreur lors de la récupération de l\'historique');
    }
  }
  
  // ============================================
  // Statistiques
  // ============================================
  
  Future<List<dynamic>> getPathologyStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/pathologies'),
      headers: _getAuthHeaders(),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['stats'];
    } else {
      throw Exception('Erreur lors de la récupération des statistiques');
    }
  }
  
  Future<Map<String, dynamic>> getCabinetStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/cabinet'),
      headers: _getAuthHeaders(),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['stats'];
    } else {
      throw Exception('Erreur lors de la récupération des statistiques cabinet');
    }
  }
  
  Future<Map<String, dynamic>> getPatientImprovement(String patientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/improvement/$patientId'),
      headers: _getAuthHeaders(),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['improvement'];
    } else {
      throw Exception('Erreur lors du calcul d\'amélioration');
    }
  }
  
  // ============================================
  // Health check
  // ============================================
  
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // ============================================
  // Helpers privés
  // ============================================
  
  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }
}
```

### 2. Adapter AuthProvider pour le backend local

**Modifier `lib/providers/auth_provider.dart` :**

```dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_api_service.dart';

class AuthProvider with ChangeNotifier {
  final LocalApiService _localApi = LocalApiService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  // Connexion avec backend local
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _localApi.login(email, password);
      
      if (result['success']) {
        _currentUser = UserModel.fromMap(result['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion au serveur local: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Inscription avec backend local
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final userData = {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role.toString().split('.').last,
      };
      
      final result = await _localApi.register(userData);
      
      if (result['success']) {
        // Connexion automatique après inscription
        return await signIn(email, password);
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'inscription: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Déconnexion
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
  
  // Vérification connexion serveur
  Future<bool> checkServerConnection() async {
    return await _localApi.checkHealth();
  }
}
```

### 3. Créer un écran de vérification serveur

**Créer `lib/views/auth/server_check_screen.dart` :**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ServerCheckScreen extends StatefulWidget {
  const ServerCheckScreen({Key? key}) : super(key: key);

  @override
  State<ServerCheckScreen> createState() => _ServerCheckScreenState();
}

class _ServerCheckScreenState extends State<ServerCheckScreen> {
  bool _isChecking = true;
  bool _serverAvailable = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkServer();
  }

  Future<void> _checkServer() async {
    setState(() {
      _isChecking = true;
      _errorMessage = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final available = await authProvider.checkServerConnection();

      setState(() {
        _serverAvailable = available;
        _isChecking = false;
        
        if (!available) {
          _errorMessage = 'Serveur local non accessible.\n'
              'Vérifiez que le backend est démarré sur http://localhost:8080';
        }
      });

      // Si serveur disponible, rediriger vers login
      if (available) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    } catch (e) {
      setState(() {
        _isChecking = false;
        _serverAvailable = false;
        _errorMessage = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou icône
              Icon(
                _isChecking
                    ? Icons.wifi_find
                    : _serverAvailable
                        ? Icons.check_circle
                        : Icons.error,
                size: 80,
                color: _isChecking
                    ? Colors.orange
                    : _serverAvailable
                        ? Colors.green
                        : Colors.red,
              ),
              const SizedBox(height: 24),
              
              // Message
              Text(
                _isChecking
                    ? 'Connexion au serveur local...'
                    : _serverAvailable
                        ? 'Serveur disponible !'
                        : 'Serveur non disponible',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              
              if (!_isChecking && !_serverAvailable) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Bouton réessayer
                ElevatedButton(
                  onPressed: _checkServer,
                  child: const Text('Réessayer'),
                ),
                
                const SizedBox(height: 16),
                
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pour démarrer le serveur local:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('1. Ouvrir un terminal'),
                        Text('2. cd backend'),
                        Text('3. python api/app.py'),
                      ],
                    ),
                  ),
                ),
              ],
              
              if (_isChecking)
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🚀 Démarrage

### Étape 1 : Démarrer le backend

```bash
cd backend
python api/app.py
```

**Vérifier que le serveur répond :**
```bash
# Dans un autre terminal
curl http://localhost:8080/api/health
```

### Étape 2 : Générer les données demo (optionnel)

```bash
cd backend
python DEMO_DATA.py
```

### Étape 3 : Démarrer l'application Flutter

```bash
cd ..
flutter run -d chrome
# ou
flutter run -d windows
# ou
flutter run -d linux
```

---

## 🌐 Configuration Réseau Local

Pour utiliser l'application sur le réseau local (plusieurs PC + smartphones) :

### 1. Trouver l'IP du serveur

**Windows :**
```bash
ipconfig
# Rechercher "Adresse IPv4" (ex: 192.168.1.10)
```

**Linux/macOS :**
```bash
ip addr show
# ou
ifconfig
```

### 2. Modifier l'URL dans Flutter

**Dans `lib/services/local_api_service.dart` :**
```dart
// Remplacer localhost par l'IP du serveur
static const String baseUrl = 'http://192.168.1.10:8080/api';
```

### 3. Tester depuis un autre appareil

**Sur smartphone ou autre PC :**
- Connecter au même Wi-Fi que le serveur
- Ouvrir l'application Flutter
- Connexion automatique à `http://192.168.1.10:8080`

---

## 🔒 Sécurité Réseau Local

**Recommandations :**

1. **Wi-Fi sécurisé** : Utiliser un réseau Wi-Fi avec mot de passe WPA2/WPA3
2. **Réseau séparé** : Idéalement, réseau dédié au personnel médical
3. **Pare-feu** : Configurer le pare-feu pour autoriser le port 8080
4. **HTTPS optionnel** : Pour connexions très sensibles (voir backend/INSTALLATION.md)

---

## 📊 Test des Statistiques

**Exemple de récupération des statistiques :**

```dart
// Dans un StatefulWidget
Future<void> _loadStats() async {
  final localApi = LocalApiService();
  
  // Statistiques pathologies
  final pathologyStats = await localApi.getPathologyStats();
  print('Pathologies: $pathologyStats');
  
  // Statistiques cabinet
  final cabinetStats = await localApi.getCabinetStats();
  print('Cabinet: $cabinetStats');
  
  // Amélioration patient
  final improvement = await localApi.getPatientImprovement('patient_id');
  print('Amélioration: $improvement');
}
```

---

## ✅ Checklist Intégration

- [ ] Backend installé et démarré (`python api/app.py`)
- [ ] Health check répond sur `/api/health`
- [ ] Données demo générées (optionnel)
- [ ] `LocalApiService` créé dans Flutter
- [ ] `AuthProvider` adapté pour backend local
- [ ] `ServerCheckScreen` créé
- [ ] URL configurée (localhost ou IP réseau)
- [ ] Test connexion depuis Flutter réussi
- [ ] Test login avec compte demo réussi
- [ ] Statistiques accessibles depuis l'app

**Intégration complète ! 🎉**
