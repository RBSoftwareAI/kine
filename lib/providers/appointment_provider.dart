import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../services/data_service.dart';
import '../services/firebase_data_service.dart';

/// Provider pour gérer l'état des rendez-vous
/// Utilise Firebase directement (mode DEMO simplifié)
class AppointmentProvider extends ChangeNotifier {
  final DataService _dataService = FirebaseDataService();

  // État
  List<Appointment> _appointments = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Appointment> get appointments => _appointments;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Rendez-vous de la date sélectionnée
  List<Appointment> get selectedDateAppointments {
    return _appointments.where((apt) => apt.estAujourdhui).toList()
      ..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
  }

  /// Rendez-vous du jour
  List<Appointment> get todayAppointments {
    final now = DateTime.now();
    return _appointments.where((apt) {
      return apt.dateHeure.year == now.year &&
          apt.dateHeure.month == now.month &&
          apt.dateHeure.day == now.day;
    }).toList()
      ..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
  }

  /// Nombre total de rendez-vous
  int get appointmentsCount => _appointments.length;

  /// Changer la date sélectionnée
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Charger tous les rendez-vous d'un centre
  Future<void> loadAppointments(String centreId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _appointments = await _dataService.getAppointments(centreId);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des rendez-vous : $e';
      if (kDebugMode) {
        print('❌ Erreur loadAppointments: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Récupérer les rendez-vous d'une date spécifique
  Future<List<Appointment>> getAppointmentsByDate(
    String centreId,
    DateTime date,
  ) async {
    try {
      return await _dataService.getAppointmentsByDate(centreId, date);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur getAppointmentsByDate: $e');
      }
      return [];
    }
  }

  /// Récupérer les rendez-vous d'un patient
  Future<List<Appointment>> getPatientAppointments(
    String centreId,
    String patientId,
  ) async {
    try {
      return await _dataService.getPatientAppointments(
        centreId,
        patientId,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur getPatientAppointments: $e');
      }
      return [];
    }
  }

  /// Récupérer les rendez-vous d'un praticien
  Future<List<Appointment>> getPraticienAppointments(
    String centreId,
    String praticienId,
  ) async {
    try {
      return await _dataService.getPraticienAppointments(
        centreId,
        praticienId,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur getPraticienAppointments: $e');
      }
      return [];
    }
  }

  /// Ajouter un nouveau rendez-vous
  Future<String?> addAppointment(Appointment appointment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final id = await _dataService.addAppointment(appointment);
      
      // Recharger la liste
      await loadAppointments(appointment.centreId);
      
      return id;
    } catch (e) {
      _error = 'Erreur lors de la création du rendez-vous : $e';
      if (kDebugMode) {
        print('❌ Erreur addAppointment: $e');
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mettre à jour un rendez-vous
  Future<bool> updateAppointment(
    String appointmentId,
    Appointment appointment,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dataService.updateAppointment(appointmentId, appointment);
      
      // Recharger la liste
      await loadAppointments(appointment.centreId);
      
      return true;
    } catch (e) {
      _error = 'Erreur lors de la modification du rendez-vous : $e';
      if (kDebugMode) {
        print('❌ Erreur updateAppointment: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Changer le statut d'un rendez-vous
  Future<bool> updateAppointmentStatus(
    String centreId,
    String appointmentId,
    String statut,
  ) async {
    try {
      await _dataService.updateAppointmentStatus(appointmentId, statut);
      
      // Recharger la liste
      await loadAppointments(centreId);
      
      return true;
    } catch (e) {
      _error = 'Erreur lors du changement de statut : $e';
      if (kDebugMode) {
        print('❌ Erreur updateAppointmentStatus: $e');
      }
      return false;
    }
  }

  /// Annuler un rendez-vous
  Future<bool> cancelAppointment(String centreId, String appointmentId) async {
    return updateAppointmentStatus(centreId, appointmentId, 'annulé');
  }

  /// Confirmer un rendez-vous
  Future<bool> confirmAppointment(String centreId, String appointmentId) async {
    return updateAppointmentStatus(centreId, appointmentId, 'confirmé');
  }

  /// Marquer un rendez-vous comme terminé
  Future<bool> completeAppointment(String centreId, String appointmentId) async {
    return updateAppointmentStatus(centreId, appointmentId, 'terminé');
  }

  /// Supprimer un rendez-vous
  Future<bool> deleteAppointment(String centreId, String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dataService.deleteAppointment(appointmentId);
      
      // Recharger la liste
      await loadAppointments(centreId);
      
      return true;
    } catch (e) {
      _error = 'Erreur lors de la suppression du rendez-vous : $e';
      if (kDebugMode) {
        print('❌ Erreur deleteAppointment: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Vérifier la disponibilité d'un créneau
  Future<bool> isSlotAvailable(
    String centreId,
    String praticienId,
    DateTime dateHeure,
    int duree, {
    String? excludeAppointmentId,
  }) async {
    try {
      return await _dataService.isSlotAvailable(
        centreId,
        praticienId,
        dateHeure,
        duree,
        excludeAppointmentId: excludeAppointmentId,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur isSlotAvailable: $e');
      }
      return false;
    }
  }

  /// Récupérer les rendez-vous d'une plage de dates
  Future<List<Appointment>> getAppointmentsByDateRange(
    String centreId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _dataService.getAppointmentsByDateRange(
        centreId,
        startDate,
        endDate,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur getAppointmentsByDateRange: $e');
      }
      return [];
    }
  }

  /// Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
