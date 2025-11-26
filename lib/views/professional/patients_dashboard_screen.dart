import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/patient.dart';
import '../../utils/app_theme.dart';
import '../../screens/patients/patient_detail_screen.dart';

/// Tableau de bord professionnel pour kinésithérapeutes et coachs
class PatientsDashboardScreen extends StatefulWidget {
  const PatientsDashboardScreen({super.key});

  @override
  State<PatientsDashboardScreen> createState() => _PatientsDashboardScreenState();
}

class _PatientsDashboardScreenState extends State<PatientsDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Patient> _filteredPatients = [];
  bool _showOnlyActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    final authProvider = context.read<AuthProvider>();
    final patientProvider = context.read<PatientProvider>();
    final user = authProvider.currentUser;
    
    if (user != null) {
      await patientProvider.loadPatients(user.centreId);
      _applyFilters();
    }
  }

  void _applyFilters() {
    final patientProvider = context.read<PatientProvider>();
    var filtered = List<Patient>.from(patientProvider.allPatients);

    // Filtre de recherche
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.nomComplet.toLowerCase().contains(query) ||
              (p.email?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    // Filtre actif/inactif
    if (_showOnlyActive) {
      filtered = filtered.where((p) => p.actif).toList();
    }

    setState(() {
      _filteredPatients = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Liste des patients'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadPatients,
              ),
            ],
          ),
          body: patientProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : patientProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            patientProvider.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadPatients,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  : _buildContent(),
        );
      },
    );
  }

  Widget _buildContent() {
    final patientProvider = context.watch<PatientProvider>();
    
    return Column(
      children: [
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => _applyFilters(),
          ),
        ),

        // Statistiques simplifiées
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Total',
                    patientProvider.patientsCount.toString(),
                    Icons.people,
                    AppTheme.info,
                  ),
                  _buildStatItem(
                    'Actifs',
                    patientProvider.allPatients.where((p) => p.actif).length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
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
                    return _buildPatientCard(_filteredPatients[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToPatientDetail(patient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.info.withValues(alpha: 0.1),
                child: Text(
                  patient.initiales,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.info,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.nomComplet,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${patient.age} ans',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppTheme.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun patient trouvé',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun patient ne correspond à vos critères de recherche.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToPatientDetail(Patient patient) async {
    // Navigation vers PatientDetailScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patient.id),
      ),
    );
    
    // Rafraîchir la liste si des changements ont été effectués
    if (result == true && mounted) {
      _loadPatients();
    }
  }
}
