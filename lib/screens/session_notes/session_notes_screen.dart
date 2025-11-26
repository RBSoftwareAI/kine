import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/session_note.dart';
import '../../utils/app_theme.dart';

/// Écran de gestion des notes de séances
class SessionNotesScreen extends StatefulWidget {
  const SessionNotesScreen({super.key});

  @override
  State<SessionNotesScreen> createState() => _SessionNotesScreenState();
}

class _SessionNotesScreenState extends State<SessionNotesScreen> {
  List<SessionNote> _sessionNotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionNotes();
  }

  Future<void> _loadSessionNotes() async {
    // Pour la démonstration, créer des notes factices
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _sessionNotes = _getMockSessionNotes();
      _isLoading = false;
    });
  }

  List<SessionNote> _getMockSessionNotes() {
    final now = DateTime.now();
    return [
      SessionNote(
        id: 'note_1',
        patientId: 'patient_1',
        patientName: 'Jean Dupont',
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 1)),
        observations: 'Séance de traitement du dos. Patient signale une amélioration significative de la douleur lombaire. Mobilité accrue de 30%. Recommandation de continuer les exercices à domicile.',
        progressStatus: ProgressStatus.improving,
        painPointIds: ['pain_1', 'pain_2'],
        recommendations: 'Exercices de renforcement lombaire 2x par jour, application de glace après effort.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      SessionNote(
        id: 'note_2',
        patientId: 'patient_2',
        patientName: 'Marie Martin',
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 2)),
        observations: 'Première séance pour douleur à l\'épaule droite. Patient rapporte douleur depuis 3 semaines suite à un mouvement brusque. Amplitude de mouvement limitée à 70°.',
        progressStatus: ProgressStatus.stable,
        painPointIds: ['pain_3'],
        recommendations: 'Repos relatif, éviter mouvements brusques, séance de suivi dans 1 semaine.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      SessionNote(
        id: 'note_3',
        patientId: 'patient_3',
        patientName: 'Sophie Bernard',
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 3)),
        observations: 'Séance de suivi pour genou gauche. Patient rapporte légère augmentation de la douleur après activité sportive intense. Inflammation visible.',
        progressStatus: ProgressStatus.worsening,
        painPointIds: ['pain_4'],
        recommendations: 'Réduction activité physique, application de froid, anti-inflammatoires selon prescription médecin.',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      SessionNote(
        id: 'note_4',
        patientId: 'patient_4',
        patientName: 'Thomas Petit',
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 5)),
        observations: 'Dernière séance pour douleur cervicale. Patient ne signale plus de douleur, mobilité complète retrouvée. Objectifs thérapeutiques atteints.',
        progressStatus: ProgressStatus.recovered,
        painPointIds: ['pain_5'],
        recommendations: 'Maintenir exercices posturaux, séance de contrôle dans 1 mois si besoin.',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      SessionNote(
        id: 'note_5',
        patientId: 'patient_5',
        patientName: 'Claire Dubois',
        professionalId: 'prof_1',
        professionalName: 'Dr. Pierre Durand',
        sessionDate: now.subtract(const Duration(days: 7)),
        observations: 'Séance de traitement pour douleur lombaire chronique. Patient rapporte amélioration progressive. Techniques de mobilisation appliquées avec succès.',
        progressStatus: ProgressStatus.improving,
        painPointIds: ['pain_6', 'pain_7'],
        recommendations: 'Poursuivre exercices quotidiens, éviter port de charges lourdes.',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes de séances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddNoteDialog,
            tooltip: 'Ajouter une note',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessionNotes.isEmpty
              ? _buildEmptyState()
              : _buildNotesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune note de séance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des notes pour suivre vos séances',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddNoteDialog,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une note'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return RefreshIndicator(
      onRefresh: _loadSessionNotes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sessionNotes.length,
        itemBuilder: (context, index) {
          final note = _sessionNotes[index];
          return _buildNoteCard(note);
        },
      ),
    );
  }

  Widget _buildNoteCard(SessionNote note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showNoteDetail(note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(note.progressStatus).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_note,
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
                            Icon(
                              Icons.person,
                              size: 16,
                              color: AppTheme.primaryOrange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              note.patientName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatDate(note.sessionDate),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          note.professionalName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(note.progressStatus),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                note.observations,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              if (note.recommendations != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withValues(alpha: 0.1),
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
                        size: 20,
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
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
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

  void _showNoteDetail(SessionNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(note.sessionDate),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note.professionalName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(note.progressStatus),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Observations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                note.observations,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              if (note.recommendations != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Recommandations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
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
        content: Text('Fonctionnalité d\'ajout de notes en développement'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
