import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/audit_log.dart';
import '../../services/audit_service.dart';
import '../../utils/app_theme.dart';
import 'widgets/audit_timeline_item.dart';

/// Écran d'historique de traçabilité
class AuditHistoryScreen extends StatefulWidget {
  final String? patientId; // Si null, utilise l'ID de l'utilisateur connecté

  const AuditHistoryScreen({
    super.key,
    this.patientId,
  });

  @override
  State<AuditHistoryScreen> createState() => _AuditHistoryScreenState();
}

class _AuditHistoryScreenState extends State<AuditHistoryScreen> {
  final AuditService _auditService = AuditService();
  
  List<AuditLog> _allLogs = [];
  List<AuditLog> _filteredLogs = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  ActionType? _selectedActionFilter;
  bool _showOnlyProfessionalChanges = false;

  @override
  void initState() {
    super.initState();
    _loadAuditLogs();
  }

  Future<void> _loadAuditLogs() async {
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

      final patientId = widget.patientId ?? user.id;
      final logs = await _auditService.getAuditLogsForPatient(patientId);
      
      setState(() {
        _allLogs = logs;
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
    var filtered = List<AuditLog>.from(_allLogs);

    // Filtre par type d'action
    if (_selectedActionFilter != null) {
      filtered = filtered
          .where((log) => log.actionType == _selectedActionFilter)
          .toList();
    }

    // Filtre modifications professionnelles
    if (_showOnlyProfessionalChanges) {
      filtered = filtered.where((log) => log.isModifiedByProfessional).toList();
    }

    setState(() {
      _filteredLogs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Modifications'),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyProfessionalChanges
                  ? Icons.medical_services
                  : Icons.medical_services_outlined,
              color: _showOnlyProfessionalChanges ? AppTheme.primaryOrange : null,
            ),
            tooltip: 'Modifications professionnelles uniquement',
            onPressed: () {
              setState(() {
                _showOnlyProfessionalChanges = !_showOnlyProfessionalChanges;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAuditLogs,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAuditLogs,
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
            const Text(
              'Erreur de chargement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAuditLogs,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Bannière d'information
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.info.withValues(alpha: 0.1),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.info),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Toutes les actions effectuées sur votre dossier sont enregistrées '
                  'pour assurer une transparence totale.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // Statistiques rapides
        _buildQuickStats(),

        const SizedBox(height: 8),

        // Filtres d'action
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Toutes'),
                selected: _selectedActionFilter == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedActionFilter = null;
                    _applyFilters();
                  });
                },
              ),
              const SizedBox(width: 8),
              for (final actionType in ActionType.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(actionType.emoji),
                        const SizedBox(width: 4),
                        Text(actionType.displayName),
                      ],
                    ),
                    selected: _selectedActionFilter == actionType,
                    onSelected: (selected) {
                      setState(() {
                        _selectedActionFilter = selected ? actionType : null;
                        _applyFilters();
                      });
                    },
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Timeline des logs
        Expanded(
          child: _filteredLogs.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredLogs.length,
                  itemBuilder: (context, index) {
                    final isFirst = index == 0;
                    final isLast = index == _filteredLogs.length - 1;
                    
                    return AuditTimelineItem(
                      log: _filteredLogs[index],
                      isFirst: isFirst,
                      isLast: isLast,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final totalLogs = _allLogs.length;
    final professionalChanges = _allLogs
        .where((log) => log.isModifiedByProfessional)
        .length;
    final patientChanges = totalLogs - professionalChanges;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.timeline,
              value: totalLogs.toString(),
              label: 'Actions totales',
              color: AppTheme.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.medical_services,
              value: professionalChanges.toString(),
              label: 'Par professionnels',
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.person,
              value: patientChanges.toString(),
              label: 'Par le patient',
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showOnlyProfessionalChanges
                ? Icons.medical_services_outlined
                : Icons.history,
            size: 64,
            color: AppTheme.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _showOnlyProfessionalChanges
                ? 'Aucune modification professionnelle'
                : 'Aucun historique',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _showOnlyProfessionalChanges
                ? 'Aucun professionnel n\'a modifié votre dossier'
                : 'Aucune action enregistrée pour l\'instant',
            style: TextStyle(color: AppTheme.grey),
          ),
        ],
      ),
    );
  }
}
