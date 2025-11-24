import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_service.dart';
import '../models/user.dart';
import '../models/centre.dart';
import '../models/patient.dart';
import '../models/appointment.dart';

/// Implémentation Flask du DataService (MODE LOCAL)
/// Communique avec l'API REST Flask via HTTP
class FlaskDataService implements DataService {
  final String baseUrl;
  String? _accessToken;
  String? _refreshToken;
  String? _currentUserId;

  // StreamController pour l'état d'authentification
  final _authStateController = StreamController<AuthState>.broadcast();

  FlaskDataService({this.baseUrl = 'http://localhost:5000'}) {
    _loadTokensFromStorage();
  }

  @override
  void dispose() {
    _authStateController.close();
  }

  // ==================== GESTION DES TOKENS ====================

  /// Charger les tokens depuis le stockage local
  Future<void> _loadTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _currentUserId = prefs.getString('user_id');

    // Émettre l'état d'authentification initial
    _authStateController.add(AuthState(
      userId: _currentUserId,
      isAuthenticated: _accessToken != null,
    ));
  }

  /// Sauvegarder les tokens dans le stockage local
  Future<void> _saveTokensToStorage(String accessToken, String refreshToken, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('user_id', userId);
    
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _currentUserId = userId;
  }

  /// Supprimer les tokens du stockage local
  Future<void> _clearTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    
    _accessToken = null;
    _refreshToken = null;
    _currentUserId = null;
  }

  /// Rafraîchir le token d'accès
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      throw Exception('Aucun refresh token disponible');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_refreshToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
    } else {
      // Token invalide, déconnexion
      await logout();
      throw Exception('Session expirée, veuillez vous reconnecter');
    }
  }

  /// Effectuer une requête HTTP avec gestion automatique du token
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Méthode HTTP non supportée: $method');
    }

    // Si 401 Unauthorized, tenter de rafraîchir le token
    if (response.statusCode == 401 && requiresAuth) {
      await _refreshAccessToken();
      // Réessayer la requête avec le nouveau token
      return _makeRequest(method, endpoint, body: body, requiresAuth: requiresAuth);
    }

    return response;
  }

  // ==================== AUTHENTIFICATION ====================

  @override
  Stream<AuthState> get authStateChanges => _authStateController.stream;

  @override
  String? get currentUserId => _currentUserId;

  @override
  Future<AuthResult> signup({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String specialite,
    required String centreName,
    required String centreAdresse,
    String? centreTelephone,
    String? centreEmail,
  }) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/api/auth/register',
        requiresAuth: false,
        body: {
          'email': email,
          'password': password,
          'nom': nom,
          'prenom': prenom,
          'specialite': specialite,
          'centre_name': centreName,
          'centre_adresse': centreAdresse,
          'centre_telephone': centreTelephone,
          'centre_email': centreEmail ?? email,
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveTokensToStorage(
          data['access_token'],
          data['refresh_token'],
          data['user']['id'],
        );

        _authStateController.add(AuthState(
          userId: data['user']['id'],
          isAuthenticated: true,
        ));

        return AuthResult.success(data['user']['id']);
      } else {
        final error = json.decode(response.body);
        return AuthResult.failure(error['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      return AuthResult.failure('Erreur de connexion au serveur : $e');
    }
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/api/auth/login',
        requiresAuth: false,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokensToStorage(
          data['access_token'],
          data['refresh_token'],
          data['user']['id'],
        );

        _authStateController.add(AuthState(
          userId: data['user']['id'],
          isAuthenticated: true,
        ));

        return AuthResult.success(data['user']['id']);
      } else {
        final error = json.decode(response.body);
        return AuthResult.failure(error['message'] ?? 'Erreur lors de la connexion');
      }
    } catch (e) {
      return AuthResult.failure('Erreur de connexion au serveur : $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Notifier le serveur (optionnel)
      await _makeRequest('POST', '/api/auth/logout');
    } catch (e) {
      // Ignorer les erreurs, on déconnecte quand même localement
    } finally {
      await _clearTokensFromStorage();
      _authStateController.add(AuthState(
        userId: null,
        isAuthenticated: false,
      ));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    // À implémenter selon l'API Flask
    throw UnimplementedError('Réinitialisation de mot de passe non implémentée');
  }

  @override
  Future<User> getUserData(String uid) async {
    final response = await _makeRequest('GET', '/api/auth/user');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Erreur lors de la récupération des données utilisateur');
    }
  }

  @override
  Future<Centre> getUserCentre(String centreId) async {
    final response = await _makeRequest('GET', '/api/centres/$centreId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Centre.fromJson(data['centre']);
    } else {
      throw Exception('Erreur lors de la récupération du centre');
    }
  }

  // ==================== PATIENTS ====================

  @override
  Stream<List<Patient>> getPatientsStream(String centreId) {
    // Les streams ne sont pas supportés en HTTP REST
    // On simule avec un Stream qui émet une seule fois
    return Stream.fromFuture(getPatients(centreId));
  }

  @override
  Future<List<Patient>> getPatients(String centreId) async {
    final response = await _makeRequest('GET', '/api/patients');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final patients = (data['patients'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();
      
      patients.sort((a, b) => a.nom.compareTo(b.nom));
      return patients;
    } else {
      throw Exception('Erreur lors de la récupération des patients');
    }
  }

  @override
  Future<Patient?> getPatient(String patientId) async {
    final response = await _makeRequest('GET', '/api/patients/$patientId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Patient.fromJson(data['patient']);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erreur lors de la récupération du patient');
    }
  }

  @override
  Future<List<Patient>> searchPatients(String centreId, String query) async {
    final response = await _makeRequest(
      'GET',
      '/api/patients?search=$query',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['patients'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();
    } else {
      throw Exception('Erreur lors de la recherche de patients');
    }
  }

  @override
  Future<String> addPatient(Patient patient) async {
    final response = await _makeRequest(
      'POST',
      '/api/patients',
      body: patient.toJson(),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['patient']['id'];
    } else {
      throw Exception('Erreur lors de l\'ajout du patient');
    }
  }

  @override
  Future<void> updatePatient(String patientId, Patient patient) async {
    final response = await _makeRequest(
      'PUT',
      '/api/patients/$patientId',
      body: patient.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du patient');
    }
  }

  @override
  Future<void> deactivatePatient(String patientId) async {
    final response = await _makeRequest(
      'PUT',
      '/api/patients/$patientId',
      body: {'actif': false},
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la désactivation du patient');
    }
  }

  @override
  Future<void> reactivatePatient(String patientId) async {
    final response = await _makeRequest(
      'PUT',
      '/api/patients/$patientId',
      body: {'actif': true},
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la réactivation du patient');
    }
  }

  @override
  Future<void> deletePatient(String patientId) async {
    final response = await _makeRequest('DELETE', '/api/patients/$patientId');

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du patient');
    }
  }

  @override
  Future<List<Patient>> getInactivePatients(String centreId) async {
    final patients = await getPatients(centreId);
    return patients.where((p) => !p.actif).toList();
  }

  @override
  Future<int> countActivePatients(String centreId) async {
    final patients = await getPatients(centreId);
    return patients.where((p) => p.actif).length;
  }

  @override
  Future<List<Patient>> getRecentPatients(String centreId, {int days = 30}) async {
    final patients = await getPatients(centreId);
    final date = DateTime.now().subtract(Duration(days: days));
    
    final recentPatients = patients
        .where((p) => p.actif && p.dateCreation.isAfter(date))
        .toList();
    
    recentPatients.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    return recentPatients;
  }

  @override
  Future<bool> patientExistsByEmail(String centreId, String email) async {
    final patients = await getPatients(centreId);
    return patients.any((p) => p.email == email);
  }

  // ==================== RENDEZ-VOUS ====================

  @override
  Stream<List<Appointment>> getAppointmentsStream(String centreId) {
    return Stream.fromFuture(getAppointments(centreId));
  }

  @override
  Future<List<Appointment>> getAppointments(String centreId) async {
    final response = await _makeRequest('GET', '/api/appointments');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['appointments'] as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des rendez-vous');
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByDate(String centreId, DateTime date) async {
    final appointments = await getAppointments(centreId);
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final filtered = appointments
        .where((apt) =>
            apt.dateHeure.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList();

    filtered.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    return filtered;
  }

  @override
  Future<List<Appointment>> getPatientAppointments(String centreId, String patientId) async {
    final response = await _makeRequest(
      'GET',
      '/api/appointments?patient_id=$patientId',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final appointments = (data['appointments'] as List)
          .map((json) => Appointment.fromJson(json))
          .toList();

      appointments.sort((a, b) => b.dateHeure.compareTo(a.dateHeure));
      return appointments;
    } else {
      throw Exception('Erreur lors de la récupération des rendez-vous du patient');
    }
  }

  @override
  Future<List<Appointment>> getPraticienAppointments(String centreId, String praticienId) async {
    final response = await _makeRequest(
      'GET',
      '/api/appointments?praticien_id=$praticienId',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final appointments = (data['appointments'] as List)
          .map((json) => Appointment.fromJson(json))
          .toList();

      appointments.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
      return appointments;
    } else {
      throw Exception('Erreur lors de la récupération des rendez-vous du praticien');
    }
  }

  @override
  Future<Appointment?> getAppointment(String appointmentId) async {
    final response = await _makeRequest('GET', '/api/appointments/$appointmentId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Appointment.fromJson(data['appointment']);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erreur lors de la récupération du rendez-vous');
    }
  }

  @override
  Future<String> addAppointment(Appointment appointment) async {
    final response = await _makeRequest(
      'POST',
      '/api/appointments',
      body: appointment.toJson(),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['appointment']['id'];
    } else {
      throw Exception('Erreur lors de l\'ajout du rendez-vous');
    }
  }

  @override
  Future<void> updateAppointment(String appointmentId, Appointment appointment) async {
    final response = await _makeRequest(
      'PUT',
      '/api/appointments/$appointmentId',
      body: appointment.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du rendez-vous');
    }
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, String statut) async {
    final response = await _makeRequest(
      'PUT',
      '/api/appointments/$appointmentId',
      body: {'statut': statut},
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du statut');
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'annulé');
  }

  @override
  Future<void> confirmAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'confirmé');
  }

  @override
  Future<void> completeAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'terminé');
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    final response = await _makeRequest('DELETE', '/api/appointments/$appointmentId');

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du rendez-vous');
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByDateRange(
    String centreId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final appointments = await getAppointments(centreId);
    
    final filtered = appointments
        .where((apt) =>
            apt.dateHeure.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            apt.dateHeure.isBefore(endDate.add(const Duration(seconds: 1))))
        .toList();

    filtered.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    return filtered;
  }

  @override
  Future<bool> isSlotAvailable(
    String centreId,
    String praticienId,
    DateTime dateHeure,
    int duree, {
    String? excludeAppointmentId,
  }) async {
    final heureDebut = dateHeure;
    final heureFin = dateHeure.add(Duration(minutes: duree));

    final appointments = await getPraticienAppointments(centreId, praticienId);

    final conflicts = appointments.where((apt) {
      if (excludeAppointmentId != null && apt.id == excludeAppointmentId) {
        return false;
      }
      if (apt.statut == 'annulé') {
        return false;
      }
      return apt.dateHeure.isBefore(heureFin) && apt.heureFin.isAfter(heureDebut);
    }).toList();

    return conflicts.isEmpty;
  }

  @override
  Future<Map<String, int>> countByStatus(String centreId) async {
    final appointments = await getAppointments(centreId);

    final counts = <String, int>{
      'planifié': 0,
      'confirmé': 0,
      'en_cours': 0,
      'terminé': 0,
      'annulé': 0,
    };

    for (final appointment in appointments) {
      counts[appointment.statut] = (counts[appointment.statut] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Future<List<Appointment>> getTodayAppointments(String centreId) async {
    final now = DateTime.now();
    return getAppointmentsByDate(centreId, now);
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments(String centreId, {int days = 7}) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    return getAppointmentsByDateRange(centreId, now, endDate);
  }
}
