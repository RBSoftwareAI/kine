import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/data_service.dart';
import '../services/firebase_data_service.dart';

/// Provider pour la gestion d'état des patients
/// Utilise Firebase directement (mode DEMO simplifié)
class PatientProvider extends ChangeNotifier {
  final DataService _dataService = FirebaseDataService();

  // État
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  Patient? _selectedPatient;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Patient> get patients => _filteredPatients;
  List<Patient> get allPatients => _patients;
  Patient? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool get hasPatients => _patients.isNotEmpty;
  int get patientsCount => _patients.length;

  /// Charger tous les patients d'un centre
  Future<void> loadPatients(String centreId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _patients = await _dataService.getPatients(centreId);
      _applySearchFilter();
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des patients : $e';
      if (kDebugMode) {
        print('Erreur loadPatients: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Écouter les changements en temps réel
  Stream<List<Patient>> streamPatients(String centreId) {
    return _dataService.getPatientsStream(centreId);
  }

  /// Rechercher des patients
  Future<void> searchPatients(String centreId, String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _applySearchFilter();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _dataService.searchPatients(centreId, query);
      _filteredPatients = results;
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de la recherche : $e';
      if (kDebugMode) {
        print('Erreur searchPatients: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Appliquer le filtre de recherche local
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredPatients = List.from(_patients);
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _filteredPatients = _patients.where((patient) {
        return patient.nomComplet.toLowerCase().contains(queryLower) ||
            patient.nom.toLowerCase().contains(queryLower) ||
            patient.prenom.toLowerCase().contains(queryLower);
      }).toList();
    }
  }

  /// Effacer la recherche
  void clearSearch() {
    _searchQuery = '';
    _applySearchFilter();
    notifyListeners();
  }

  /// Sélectionner un patient
  Future<void> selectPatient(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedPatient = await _dataService.getPatient(patientId);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement du patient : $e';
      if (kDebugMode) {
        print('Erreur selectPatient: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Désélectionner le patient actuel
  void clearSelectedPatient() {
    _selectedPatient = null;
    notifyListeners();
  }

  /// Ajouter un nouveau patient
  Future<String?> addPatient(Patient patient) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final patientId = await _dataService.addPatient(patient);
      
      // Recharger la liste des patients
      await loadPatients(patient.centreId);
      
      _error = null;
      return patientId;
    } catch (e) {
      _error = 'Erreur lors de l\'ajout du patient : $e';
      if (kDebugMode) {
        print('Erreur addPatient: $e');
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mettre à jour un patient
  Future<bool> updatePatient(String patientId, Patient patient) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dataService.updatePatient(patientId, patient);
      
      // Recharger la liste des patients
      await loadPatients(patient.centreId);
      
      // Mettre à jour le patient sélectionné si c'est le même
      if (_selectedPatient?.id == patientId) {
        _selectedPatient = patient;
      }
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Erreur lors de la mise à jour du patient : $e';
      if (kDebugMode) {
        print('Erreur updatePatient: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Désactiver un patient
  Future<bool> deactivatePatient(String patientId, String centreId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dataService.deactivatePatient(patientId);
      
      // Recharger la liste des patients
      await loadPatients(centreId);
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Erreur lors de la désactivation du patient : $e';
      if (kDebugMode) {
        print('Erreur deactivatePatient: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Compter les patients actifs
  Future<int> countActivePatients(String centreId) async {
    try {
      return await _dataService.countActivePatients(centreId);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur countActivePatients: $e');
      }
      return 0;
    }
  }

  /// Récupérer les patients récents
  Future<List<Patient>> getRecentPatients(String centreId, {int days = 30}) async {
    try {
      return await _dataService.getRecentPatients(centreId, days: days);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur getRecentPatients: $e');
      }
      return [];
    }
  }

  /// Trier les patients
  void sortPatients(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.nameAsc:
        _filteredPatients.sort((a, b) => a.nom.compareTo(b.nom));
        break;
      case SortOption.nameDesc:
        _filteredPatients.sort((a, b) => b.nom.compareTo(a.nom));
        break;
      case SortOption.dateCreatedAsc:
        _filteredPatients.sort((a, b) => a.dateCreation.compareTo(b.dateCreation));
        break;
      case SortOption.dateCreatedDesc:
        _filteredPatients.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
        break;
      case SortOption.ageAsc:
        _filteredPatients.sort((a, b) => a.age.compareTo(b.age));
        break;
      case SortOption.ageDesc:
        _filteredPatients.sort((a, b) => b.age.compareTo(a.age));
        break;
    }
    notifyListeners();
  }

  /// Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Options de tri pour les patients
enum SortOption {
  nameAsc,
  nameDesc,
  dateCreatedAsc,
  dateCreatedDesc,
  ageAsc,
  ageDesc,
}
