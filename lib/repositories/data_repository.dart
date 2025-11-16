/// Abstract Data Repository Interface
/// Permet de basculer entre stockage local (API Flask) et cloud (Firebase)
library;

import '../models/user_model.dart';
import '../models/pain_point.dart';
import '../models/session_note.dart';
import '../models/audit_log.dart';

/// Interface abstraite pour tous les repositories
abstract class DataRepository {
  // ============================================
  // AUTHENTICATION
  // ============================================
  
  /// Login avec email/password
  Future<UserModel?> signIn(String email, String password);
  
  /// Récupérer utilisateur actuel
  Future<UserModel?> getCurrentUser();
  
  /// Logout
  Future<void> signOut();
  
  // ============================================
  // USERS
  // ============================================
  
  /// Récupérer tous les utilisateurs d'un rôle spécifique
  Future<List<UserModel>> getUsers({UserRole? role});
  
  /// Récupérer un utilisateur par ID
  Future<UserModel?> getUserById(String userId);
  
  /// Créer un utilisateur
  Future<UserModel> createUser(UserModel user, String password);
  
  /// Mettre à jour un utilisateur
  Future<void> updateUser(UserModel user);
  
  // ============================================
  // PAIN POINTS
  // ============================================
  
  /// Récupérer les points de douleur d'un patient
  Future<List<PainPoint>> getPainPoints(String patientId);
  
  /// Créer un point de douleur
  Future<PainPoint> createPainPoint(PainPoint point);
  
  /// Mettre à jour un point de douleur
  Future<void> updatePainPoint(PainPoint point);
  
  /// Supprimer un point de douleur
  Future<void> deletePainPoint(String pointId);
  
  // ============================================
  // SESSIONS
  // ============================================
  
  /// Récupérer les séances d'un patient
  Future<List<SessionNote>> getSessions(String patientId);
  
  /// Créer une séance
  Future<SessionNote> createSession(SessionNote session);
  
  /// Mettre à jour une séance
  Future<void> updateSession(SessionNote session);
  
  // ============================================
  // AUDIT LOGS
  // ============================================
  
  /// Récupérer les logs d'audit
  Future<List<AuditLog>> getAuditLogs({
    String? userId,
    String? entityId,
    int limit = 100,
  });
  
  /// Créer un log d'audit
  Future<void> createAuditLog(AuditLog log);
  
  // ============================================
  // STATISTICS
  // ============================================
  
  /// Récupérer statistiques temps réel
  Future<Map<String, dynamic>> getRealtimeStats();
  
  /// Récupérer statistiques par pathologie
  Future<List<Map<String, dynamic>>> getPathologyStats({String? pathologyCode});
  
  /// Calculer les statistiques (déclenche le calcul backend)
  Future<void> calculatePathologyStats();
}
