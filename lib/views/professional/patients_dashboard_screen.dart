import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/patient_summary.dart';
import '../../models/session_note.dart';
import '../../services/patient_service.dart';
import '../../utils/app_theme.dart';
import 'widgets/patient_card.dart';
import 'widgets/dashboard_stats.dart';

/// Tableau de bord professionnel pour kinésithérapeutes et coachs
class PatientsDashboardScreen extends StatefulWidget {
  const PatientsDashboardScreen({super.key});

  @override
  State<PatientsDashboardScreen> createState() => _PatientsDashboardScreenState();
}

class _PatientsDashboardScreenState extends State<PatientsDashboardScreen> {
  final PatientService _patientService = PatientService();
  final TextEditingController _searchController = TextEditingController();
  
  List<PatientSummary> _allPatients = [];
  List<PatientSummary> _filteredPatients = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  ProgressStatus? _selectedStatusFilter;
  bool _showOnlyNeedingAttention = false;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;
      
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final patients = await _patientService.getPatientsForProfessional(user.id);
      
      setState(() {
        _allPatients = patients;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    var filtered = List<PatientSummary>.from(_allPatients);

    // Filtre de recherche
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.patientName.toLowerCase().contains(query) ||
              p.patientEmail.toLowerCase().contains(query))
          .toList();
    }

    // Filtre par statut
    if (_selectedStatusFilter != null) {
      filtered = filtered
          .where((p) => p.latestStatus == _selectedStatusFilter)
          .toList();
    }

    // Filtre attention nécessaire
    if (_showOnlyNeedingAttention) {
      filtered = filtered.where((p) => p.needsAttention).toList();
    }

    setState(() {
      _filteredPatients = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Patients'),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyNeedingAttention ? Icons.notifications_active : Icons.notifications_outlined,
              color: _showOnlyNeedingAttention ? AppTheme.warning : null,
            ),
            tooltip: 'Patients nécessitant attention',
            onPressed: () {
              setState(() {
                _showOnlyNeedingAttention = !_showOnlyNeedingAttention;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatients,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPatients,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.error),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPatients,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Statistiques globales
        DashboardStats(patients: _allPatients),

        const SizedBox(height: 8),

        // Barre de recherche
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un patient...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
            ),
            onChanged: (value) => _applyFilters(),
          ),
        ),

        // Filtres de statut
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Tous'),
                selected: _selectedStatusFilter == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedStatusFilter = null;
                    _applyFilters();
                  });
                },
              ),
              const SizedBox(width: 8),
              ...ProgressStatus.values.map((status) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(status.emoji),
                          const SizedBox(width: 4),
                          Text(status.displayName),
                        ],
                      ),
                      selected: _selectedStatusFilter == status,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter = selected ? status : null;
                          _applyFilters();
                        });
                      },
                    ),
                  )),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Liste des patients
        Expanded(
          child: _filteredPatients.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredPatients.length,
                  itemBuilder: (context, index) {
                    return PatientCard(
                      patient: _filteredPatients[index],
                      onTap: () => _navigateToPatientDetail(_filteredPatients[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showOnlyNeedingAttention
                ? Icons.check_circle_outline
                : Icons.people_outline,
            size: 64,
            color: AppTheme.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _showOnlyNeedingAttention
                ? 'Aucun patient nécessitant attention'
                : 'Aucun patient trouvé',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _showOnlyNeedingAttention
                ? 'Tous vos patients vont bien !'
                : 'Ajustez vos filtres de recherche',
            style: TextStyle(color: AppTheme.grey),
          ),
        ],
      ),
    );
  }

  void _navigateToPatientDetail(PatientSummary patient) {
    // TODO: Navigation vers détail patient
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détail patient : ${patient.patientName}'),
        backgroundColor: AppTheme.info,
      ),
    );
  }
}
