import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/session_note.dart';
import '../../models/patient.dart';
import '../../providers/patient_provider.dart';
import '../../utils/app_theme.dart';

/// Écran d'historique des consultations pour un patient spécifique
class PatientConsultationHistoryScreen extends StatefulWidget {
  final String patientId;

  const PatientConsultationHistoryScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientConsultationHistoryScreen> createState() =>
      _PatientConsultationHistoryScreenState();
}

class _PatientConsultationHistoryScreenState
    extends State<PatientConsultationHistoryScreen> {
  List<SessionNote> _sessionNotes = [];
  bool _isLoading = true;
  Patient? _patient;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Charger le patient
    final patientProvider = context.read<PatientProvider>();
    await patientProvider.selectPatient(widget.patientId);
    _patient = patientProvider.selectedPatient;

    // Charger les notes de séances pour ce patient
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _sessionNotes = _getMockSessionNotesForPatient(widget.patientId);
      _isLoading = false;
    });
  }

  /// Génère des notes factices pour le patient sélectionné
  List<SessionNote> _getMockSessionNotesForPatient(String patientId) {
    final now = DateTime.now();
    return [
      SessionNote(
        id: 'note_${patientId}_1',
        patientId: patientId,
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 2)),
        observations:
            'Première consultation pour douleur lombaire chronique. Le patient décrit une douleur de niveau 8/10, aggravée en position assise prolongée. Mobilité limitée en flexion antérieure (environ 60% de l\'amplitude normale). À l\'examen clinique : tensions musculaires paravertébrales L3-L5, test de Lasègue négatif. Aucun signe neurologique.',
        progressStatus: ProgressStatus.stable,
        painPointIds: ['pain_1', 'pain_2'],
        recommendations:
            'Séances de kinésithérapie 2x/semaine pendant 6 semaines. Exercices de renforcement du core à domicile. Éviter port de charges lourdes. Application de chaleur avant les exercices.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      SessionNote(
        id: 'note_${patientId}_2',
        patientId: patientId,
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 9)),
        observations:
            'Séance de suivi n°2. Le patient rapporte une amélioration subjective de 30% depuis la dernière séance. Douleur actuelle : 6/10 au repos, 7/10 lors des mouvements. Meilleure tolérance à la position assise (2h vs 45min précédemment). Mobilité en flexion : 75% (amélioration de 15%). Tensions musculaires réduites. Technique de mobilisation appliquée : flexion-distraction L3-L4.',
        progressStatus: ProgressStatus.improving,
        painPointIds: ['pain_1', 'pain_2'],
        recommendations:
            'Poursuivre exercices quotidiens (30min/jour). Introduire exercices de stabilisation dynamique. Augmenter progressivement durée position assise.',
        createdAt: now.subtract(const Duration(days: 9)),
      ),
      SessionNote(
        id: 'note_${patientId}_3',
        patientId: patientId,
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 16)),
        observations:
            'Séance n°3. Excellente progression. Douleur réduite à 3/10, uniquement lors d\'efforts intenses. Le patient peut maintenant rester assis 4h sans inconfort majeur. Mobilité en flexion : 90% (quasi normale). Tous les tests fonctionnels négatifs. Patient très motivé et observant du protocole.',
        progressStatus: ProgressStatus.improving,
        painPointIds: ['pain_1'],
        recommendations:
            'Dernière phase de rééducation : renforcement intensif + retour progressif aux activités sportives. Séance de contrôle dans 2 semaines.',
        createdAt: now.subtract(const Duration(days: 16)),
      ),
      SessionNote(
        id: 'note_${patientId}_4',
        patientId: patientId,
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 30)),
        observations:
            'Séance d\'évaluation initiale avant début de traitement. Bilan complet effectué : lombalgie chronique évoluant depuis 6 mois, sans antécédent de traumatisme. IRM récente : discopathie L4-L5 sans hernie. Le patient souhaite éviter solution chirurgicale. Objectifs thérapeutiques définis : réduction douleur, amélioration mobilité, reprise activités professionnelles normales.',
        progressStatus: ProgressStatus.stable,
        painPointIds: ['pain_1', 'pain_2', 'pain_3'],
        recommendations:
            'Plan de traitement sur 8 semaines : Phase 1 (2 semaines) décontraction musculaire + mobilisation douce. Phase 2 (4 semaines) renforcement progressif. Phase 3 (2 semaines) réathlétisation.',
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Historique des consultations'),
            if (_patient != null)
              Text(
                _patient!.nomComplet,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddNoteDialog,
            tooltip: 'Nouvelle consultation',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessionNotes.isEmpty
              ? _buildEmptyState()
              : _buildConsultationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune consultation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez une note de consultation',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddNoteDialog,
            icon: const Icon(Icons.add),
            label: const Text('Première consultation'),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationsList() {
    return Column(
      children: [
        // Statistiques rapides
        _buildQuickStats(),
        
        // Liste des consultations
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessionNotes.length,
              itemBuilder: (context, index) {
                final note = _sessionNotes[index];
                final isFirst = index == 0;
                final isLast = index == _sessionNotes.length - 1;
                
                return _buildConsultationCard(note, isFirst, isLast);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final totalSessions = _sessionNotes.length;
    final improvingCount = _sessionNotes
        .where((n) => n.progressStatus == ProgressStatus.improving)
        .length;
    final stableCount = _sessionNotes
        .where((n) => n.progressStatus == ProgressStatus.stable)
        .length;
    final worseningCount = _sessionNotes
        .where((n) => n.progressStatus == ProgressStatus.worsening)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            'Total',
            totalSessions.toString(),
            Icons.event_note,
            Colors.blue,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            'Amélioration',
            improvingCount.toString(),
            Icons.trending_up,
            AppTheme.success,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            'Stable',
            stableCount.toString(),
            Icons.linear_scale,
            Colors.orange,
          ),
          if (worseningCount > 0) ...[
            const SizedBox(width: 16),
            _buildStatItem(
              'Dégradation',
              worseningCount.toString(),
              Icons.trending_down,
              AppTheme.error,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
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
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(SessionNote note, bool isFirst, bool isLast) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showConsultationDetail(note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec date et statut
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getStatusColor(note.progressStatus)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getStatusIcon(note.progressStatus),
                      color: _getStatusColor(note.progressStatus),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _formatDate(note.sessionDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isFirst) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.info.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Récente',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.info,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              note.professionalName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(note.progressStatus),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Observations (aperçu)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Observations',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.observations,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Recommandations (si présentes)
              if (note.recommendations != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.info,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note.recommendations!,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ProgressStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(status),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.improving:
        return Icons.trending_up;
      case ProgressStatus.stable:
        return Icons.linear_scale;
      case ProgressStatus.worsening:
        return Icons.trending_down;
      case ProgressStatus.recovered:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.improving:
        return AppTheme.success;
      case ProgressStatus.stable:
        return Colors.blue;
      case ProgressStatus.worsening:
        return AppTheme.warning;
      case ProgressStatus.recovered:
        return Colors.teal;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }

  void _showConsultationDetail(SessionNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // En-tête
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(note.sessionDate),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              note.professionalName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(note.progressStatus),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              
              // Observations détaillées
              const Text(
                'Observations cliniques',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  note.observations,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ),
              
              // Recommandations
              if (note.recommendations != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Recommandations thérapeutiques',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: AppTheme.info,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          note.recommendations!,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditNoteDialog(note);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✏️ Fonctionnalité d\'ajout de consultation en développement'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditNoteDialog(SessionNote note) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✏️ Fonctionnalité de modification en développement'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
