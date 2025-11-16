/// Local Repository Implementation
/// Se connecte au serveur Flask local via HTTP API
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_repository.dart';
import '../models/user_model.dart';
import '../models/pain_point.dart';
import '../models/session_note.dart';
import '../models/audit_log.dart';

/// Implémentation du repository pour le serveur local (Flask)
class LocalRepository implements DataRepository {
  /// URL de base du serveur local
  /// Par défaut: http://localhost:8080
  /// Sur réseau local: http://192.168.x.x:8080
  String baseUrl;
  
  /// Token JWT pour authentification
  String? _accessToken;
  
  LocalRepository({this.baseUrl = 'http://localhost:8080'});
  
  /// Headers HTTP avec authentification
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    
    return headers;
  }
  
  /// Sauvegarder le token dans le stockage local
  Future<void> _saveToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
  
  /// Charger le token depuis le stockage local
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
  }
  
  /// Supprimer le token
  Future<void> _clearToken() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
  
  // ============================================
  // AUTHENTICATION
  // ============================================
  
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Sauvegarder le token
        await _saveToken(data['access_token']);
        
        // Retourner l'utilisateur
        return UserModel.fromFirestore(data['user'], data['user']['id']);
      } else {
        print('❌ Login failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Charger le token si nécessaire
      if (_accessToken == null) {
        await _loadToken();
      }
      
      if (_accessToken == null) {
        return null;
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromFirestore(data, data['id']);
      } else {
        print('❌ Get current user failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }
  
  @override
  Future<void> signOut() async {
    await _clearToken();
  }
  
  // ============================================
  // USERS
  // ============================================
  
  @override
  Future<List<UserModel>> getUsers({UserRole? role}) async {
    try {
      await _loadToken();
      
      final uri = role != null
          ? Uri.parse('$baseUrl/api/users?role=${role.toString().split('.').last}')
          : Uri.parse('$baseUrl/api/users');
      
      final response = await http.get(uri, headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromFirestore(json, json['id'])).toList();
      } else {
        print('❌ Get users failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Get users error: $e');
      return [];
    }
  }
  
  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      await _loadToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromFirestore(data, data['id']);
      } else {
        print('❌ Get user by ID failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Get user by ID error: $e');
      return null;
    }
  }
  
  @override
  Future<UserModel> createUser(UserModel user, String password) async {
    try {
      await _loadToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: _headers,
        body: json.encode({
          'email': user.email,
          'password': password,
          'first_name': user.firstName,
          'last_name': user.lastName,
          'role': user.role.toString().split('.').last,
          'phone': user.phoneNumber,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return UserModel.fromFirestore(data, data['id']);
      } else {
        throw Exception('Create user failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Create user error: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateUser(UserModel user) async {
    // TODO: Implement update endpoint in Flask API
    throw UnimplementedError('Update user not yet implemented');
  }
  
  // ============================================
  // PAIN POINTS
  // ============================================
  
  @override
  Future<List<PainPoint>> getPainPoints(String patientId) async {
    try {
      await _loadToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/pain-points?patient_id=$patientId'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PainPoint.fromFirestore(json, json['id'])).toList();
      } else {
        print('❌ Get pain points failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Get pain points error: $e');
      return [];
    }
  }
  
  @override
  Future<PainPoint> createPainPoint(PainPoint point) async {
    try {
      await _loadToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/pain-points'),
        headers: _headers,
        body: json.encode(point.toFirestore()),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return PainPoint.fromFirestore(data, data['id']);
      } else {
        throw Exception('Create pain point failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Create pain point error: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updatePainPoint(PainPoint point) async {
    throw UnimplementedError('Update pain point not yet implemented');
  }
  
  @override
  Future<void> deletePainPoint(String pointId) async {
    throw UnimplementedError('Delete pain point not yet implemented');
  }
  
  // ============================================
  // SESSIONS
  // ============================================
  
  @override
  Future<List<SessionNote>> getSessions(String patientId) async {
    try {
      await _loadToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/sessions?patient_id=$patientId'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SessionNote.fromFirestore(json, json['id'])).toList();
      } else {
        print('❌ Get sessions failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Get sessions error: $e');
      return [];
    }
  }
  
  @override
  Future<SessionNote> createSession(SessionNote session) async {
    try {
      await _loadToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/sessions'),
        headers: _headers,
        body: json.encode(session.toFirestore()),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return SessionNote.fromFirestore(data, data['id']);
      } else {
        throw Exception('Create session failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Create session error: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateSession(SessionNote session) async {
    throw UnimplementedError('Update session not yet implemented');
  }
  
  // ============================================
  // AUDIT LOGS
  // ============================================
  
  @override
  Future<List<AuditLog>> getAuditLogs({
    String? userId,
    String? entityId,
    int limit = 100,
  }) async {
    try {
      await _loadToken();
      
      final queryParams = <String, String>{'limit': limit.toString()};
      if (userId != null) queryParams['user_id'] = userId;
      if (entityId != null) queryParams['entity_id'] = entityId;
      
      final uri = Uri.parse('$baseUrl/api/audit-logs').replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AuditLog.fromFirestore(json, json['id'])).toList();
      } else {
        print('❌ Get audit logs failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Get audit logs error: $e');
      return [];
    }
  }
  
  @override
  Future<void> createAuditLog(AuditLog log) async {
    // Audit logs are created automatically by the backend
    // This method is here for interface completeness
  }
  
  // ============================================
  // STATISTICS
  // ============================================
  
  @override
  Future<Map<String, dynamic>> getRealtimeStats() async {
    try {
      await _loadToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats/realtime'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('❌ Get realtime stats failed: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('❌ Get realtime stats error: $e');
      return {};
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getPathologyStats({String? pathologyCode}) async {
    try {
      await _loadToken();
      
      final uri = pathologyCode != null
          ? Uri.parse('$baseUrl/api/stats/pathologies?code=$pathologyCode')
          : Uri.parse('$baseUrl/api/stats/pathologies');
      
      final response = await http.get(uri, headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('❌ Get pathology stats failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Get pathology stats error: $e');
      return [];
    }
  }
  
  @override
  Future<void> calculatePathologyStats() async {
    try {
      await _loadToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/stats/pathologies/calculate'),
        headers: _headers,
      );
      
      if (response.statusCode != 200) {
        print('❌ Calculate pathology stats failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Calculate pathology stats error: $e');
    }
  }
}
