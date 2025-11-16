import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

/// Service pour gestion administrative (permissions, délégation)
class AdminService {
  final String baseUrl;
  String? _accessToken;
  
  AdminService({this.baseUrl = 'http://localhost:8080'});
  
  void setAccessToken(String token) {
    _accessToken = token;
  }
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };
  
  /// Récupérer tous les professionnels (pour gestion permissions)
  Future<List<UserModel>> getProfessionals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/users'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromFirestore(json, json['id'])).toList();
    } else if (response.statusCode == 403) {
      throw Exception('Accès refusé : Vous devez être manager ou super admin');
    } else {
      throw Exception('Erreur chargement professionnels: ${response.statusCode}');
    }
  }
  
  /// Créer un nouveau professionnel
  Future<UserModel> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role.toString().split('.').last,
        'phoneNumber': phoneNumber,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return UserModel.fromFirestore(data, data['id']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Erreur création utilisateur');
    }
  }
  
  /// Activer/désactiver un utilisateur
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/users/$userId/status'),
      headers: _headers,
      body: json.encode({'isActive': isActive}),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Erreur changement statut utilisateur');
    }
  }
  
  /// Déléguer permissions à un utilisateur
  Future<void> delegatePermissions({
    required String userId,
    DateTime? expiresAt,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/users/$userId/delegate'),
      headers: _headers,
      body: json.encode({
        'canManagePermissions': true,
        'expiresAt': expiresAt?.toIso8601String(),
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Erreur délégation permissions');
    }
  }
  
  /// Révoquer délégation permissions
  Future<void> revokeDelegation(String userId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/users/$userId/revoke-delegation'),
      headers: _headers,
      body: json.encode({'canManagePermissions': false}),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Erreur révocation délégation');
    }
  }
}
