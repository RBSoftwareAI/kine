import '../models/user.dart';
import '../models/centre.dart';
import '../models/patient.dart';
import '../models/appointment.dart';

/// Interface abstraite pour les services de données
/// Permet de basculer entre Firebase (mode DEMO) et Flask (mode LOCAL)
abstract class DataService {
  // ==================== AUTHENTIFICATION ====================
  
  /// Stream de l'état d'authentification
  Stream<AuthState> get authStateChanges;
  
  /// Utilisateur actuellement connecté (ID)
  String? get currentUserId;
  
  /// Inscription avec création automatique du centre
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
  });
  
  /// Connexion
  Future<AuthResult> login(String email, String password);
  
  /// Déconnexion
  Future<void> logout();
  
  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email);
  
  /// Récupérer les données utilisateur
  Future<User> getUserData(String uid);
  
  /// Récupérer le centre de l'utilisateur
  Future<Centre> getUserCentre(String centreId);
  
  // ==================== PATIENTS ====================
  
  /// Récupérer tous les patients d'un centre (Stream)
  Stream<List<Patient>> getPatientsStream(String centreId);
  
  /// Récupérer tous les patients d'un centre (Future)
  Future<List<Patient>> getPatients(String centreId);
  
  /// Récupérer un patient par son ID
  Future<Patient?> getPatient(String patientId);
  
  /// Rechercher des patients par nom/prénom
  Future<List<Patient>> searchPatients(String centreId, String query);
  
  /// Ajouter un nouveau patient
  Future<String> addPatient(Patient patient);
  
  /// Mettre à jour un patient
  Future<void> updatePatient(String patientId, Patient patient);
  
  /// Désactiver un patient (soft delete)
  Future<void> deactivatePatient(String patientId);
  
  /// Réactiver un patient
  Future<void> reactivatePatient(String patientId);
  
  /// Supprimer définitivement un patient
  Future<void> deletePatient(String patientId);
  
  /// Récupérer les patients inactifs
  Future<List<Patient>> getInactivePatients(String centreId);
  
  /// Compter les patients actifs d'un centre
  Future<int> countActivePatients(String centreId);
  
  /// Récupérer les patients récents (créés dans les X derniers jours)
  Future<List<Patient>> getRecentPatients(String centreId, {int days = 30});
  
  /// Vérifier si un patient existe avec cet email dans le centre
  Future<bool> patientExistsByEmail(String centreId, String email);
  
  // ==================== RENDEZ-VOUS ====================
  
  /// Récupérer tous les rendez-vous d'un centre (Stream)
  Stream<List<Appointment>> getAppointmentsStream(String centreId);
  
  /// Récupérer tous les rendez-vous d'un centre (Future)
  Future<List<Appointment>> getAppointments(String centreId);
  
  /// Récupérer les rendez-vous d'une date spécifique
  Future<List<Appointment>> getAppointmentsByDate(String centreId, DateTime date);
  
  /// Récupérer les rendez-vous d'un patient
  Future<List<Appointment>> getPatientAppointments(String centreId, String patientId);
  
  /// Récupérer les rendez-vous d'un praticien
  Future<List<Appointment>> getPraticienAppointments(String centreId, String praticienId);
  
  /// Récupérer un rendez-vous par son ID
  Future<Appointment?> getAppointment(String appointmentId);
  
  /// Ajouter un nouveau rendez-vous
  Future<String> addAppointment(Appointment appointment);
  
  /// Mettre à jour un rendez-vous
  Future<void> updateAppointment(String appointmentId, Appointment appointment);
  
  /// Changer le statut d'un rendez-vous
  Future<void> updateAppointmentStatus(String appointmentId, String statut);
  
  /// Annuler un rendez-vous
  Future<void> cancelAppointment(String appointmentId);
  
  /// Confirmer un rendez-vous
  Future<void> confirmAppointment(String appointmentId);
  
  /// Marquer un rendez-vous comme terminé
  Future<void> completeAppointment(String appointmentId);
  
  /// Supprimer définitivement un rendez-vous
  Future<void> deleteAppointment(String appointmentId);
  
  /// Récupérer les rendez-vous d'une plage de dates
  Future<List<Appointment>> getAppointmentsByDateRange(
    String centreId,
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Vérifier la disponibilité d'un créneau
  Future<bool> isSlotAvailable(
    String centreId,
    String praticienId,
    DateTime dateHeure,
    int duree, {
    String? excludeAppointmentId,
  });
  
  /// Compter les rendez-vous par statut
  Future<Map<String, int>> countByStatus(String centreId);
  
  /// Récupérer les rendez-vous du jour
  Future<List<Appointment>> getTodayAppointments(String centreId);
  
  /// Récupérer les prochains rendez-vous (X jours)
  Future<List<Appointment>> getUpcomingAppointments(String centreId, {int days = 7});
  
  /// Libérer les ressources du service
  void dispose();
}

/// État d'authentification
class AuthState {
  final String? userId;
  final bool isAuthenticated;
  
  AuthState({this.userId, required this.isAuthenticated});
}

/// Résultat d'authentification
class AuthResult {
  final bool success;
  final String? userId;
  final String? error;
  
  AuthResult({required this.success, this.userId, this.error});
  
  factory AuthResult.success(String userId) {
    return AuthResult(success: true, userId: userId);
  }
  
  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}
