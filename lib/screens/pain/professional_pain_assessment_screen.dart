import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/pain_point.dart';
import '../../models/patient.dart';
import '../../utils/app_theme.dart';
import '../../views/pain/widgets/body_silhouette.dart';
import '../../views/pain/widgets/pain_intensity_selector.dart';
import '../../views/pain/widgets/pain_frequency_selector.dart';

/// Écran pour le professionnel de santé pour évaluer les douleurs du patient
/// Permet au praticien d'enregistrer son propre jugement clinique
class ProfessionalPainAssessmentScreen extends StatefulWidget {
  final String patientId;

  const ProfessionalPainAssessmentScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<ProfessionalPainAssessmentScreen> createState() =>
      _ProfessionalPainAssessmentScreenState();
}

class _ProfessionalPainAssessmentScreenState
    extends State<ProfessionalPainAssessmentScreen> {
  BodyView _currentView = BodyView.front;
  List<PainPoint> _professionalAssessment = [];
  List<PainPoint> _patientDeclaration = [];

  PainPoint? _selectedPoint;
  PainIntensity _selectedIntensity = PainIntensity.moderate;
  PainFrequency _selectedFrequency = PainFrequency.daily;
  Patient? _patient;
  bool _isLoading = true;
  bool _showComparison = false;

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

    // Charger les données factices pour démonstration
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      // Points déclarés par le patient (simulation)
      _patientDeclaration = _getMockPatientPainPoints();
      // Points évalués par le professionnel (vide au début)
      _professionalAssessment = [];
      _isLoading = false;
    });
  }

  List<PainPoint> _getMockPatientPainPoints() {
    final now = DateTime.now();
    return [
      PainPoint(
        id: 'patient_1',
        patientId: widget.patientId,
        zone: BodyZone.lowerBack,
        view: BodyView.back,
        x: 0.5,
        y: 0.45,
        intensity: PainIntensity.severe, // Patient déclare 8/10
        frequency: PainFrequency.constant,
        recordedAt: now.subtract(const Duration(hours: 2)),
        recordedBy: widget.patientId, // Enregistré par le patient
      ),
      PainPoint(
        id: 'patient_2',
        patientId: widget.patientId,
        zone: BodyZone.shoulder,
        view: BodyView.front,
        x: 0.2,
        y: 0.35,
        intensity: PainIntensity.severe, // Patient déclare 7/10
        frequency: PainFrequency.daily,
        recordedAt: now.subtract(const Duration(hours: 2)),
        recordedBy: widget.patientId,
      ),
    ];
  }

  void _addProfessionalAssessment(Offset position, Size size) {
    final authProvider = context.read<AuthProvider>();
    final professional = authProvider.currentUser;

    if (professional == null) return;

    // Convertir la position en coordonnées relatives (0-1)
    final relativeX = position.dx / size.width;
    final relativeY = position.dy / size.height;

    // Déterminer la zone anatomique
    final zone = _determineBodyZone(relativeX, relativeY, _currentView);

    final newPoint = PainPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: widget.patientId,
      zone: zone,
      view: _currentView,
      x: relativeX,
      y: relativeY,
      intensity: _selectedIntensity,
      frequency: _selectedFrequency,
      recordedAt: DateTime.now(),
      recordedBy: professional.id, // Enregistré par le professionnel
    );

    setState(() {
      _professionalAssessment.add(newPoint);
      _selectedPoint = newPoint;
    });
  }

  void _removeProfessionalAssessment(PainPoint point) {
    setState(() {
      _professionalAssessment.remove(point);
      if (_selectedPoint?.id == point.id) {
        _selectedPoint = null;
      }
    });
  }

  void _updateSelectedPoint() {
    if (_selectedPoint == null) return;

    setState(() {
      final index = _professionalAssessment
          .indexWhere((p) => p.id == _selectedPoint!.id);
      if (index != -1) {
        _professionalAssessment[index] = _selectedPoint!.copyWith(
          intensity: _selectedIntensity,
          frequency: _selectedFrequency,
        );
        _selectedPoint = _professionalAssessment[index];
      }
    });
  }

  BodyZone _determineBodyZone(double x, double y, BodyView view) {
    if (view == BodyView.front) {
      if (y < 0.15) return BodyZone.head;
      if (y < 0.25) return BodyZone.neck;
      if (y < 0.45) {
        if (x < 0.3 || x > 0.7) return BodyZone.shoulder;
        return BodyZone.chest;
      }
      if (y < 0.55) return BodyZone.abdomen;
      if (y < 0.75) return BodyZone.thigh;
      if (y < 0.9) return BodyZone.knee;
      return BodyZone.foot;
    } else {
      if (y < 0.15) return BodyZone.head;
      if (y < 0.25) return BodyZone.neck;
      if (y < 0.45) {
        if (x < 0.3 || x > 0.7) return BodyZone.shoulder;
        if (y < 0.35) return BodyZone.upperBack;
        return BodyZone.lowerBack;
      }
      if (y < 0.55) return BodyZone.hip;
      if (y < 0.75) return BodyZone.thigh;
      if (y < 0.9) return BodyZone.calf;
      return BodyZone.foot;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Évaluation professionnelle'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cartographie des douleurs'),
            if (_patient != null)
              Text(
                '${_patient!.nomComplet} - Évaluation professionnelle',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showComparison ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showComparison = !_showComparison;
              });
            },
            tooltip: _showComparison
                ? 'Masquer déclaration patient'
                : 'Afficher déclaration patient',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _professionalAssessment.isEmpty
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Évaluation professionnelle enregistrée'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Instructions pour le professionnel
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medical_services, color: AppTheme.primaryOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode professionnel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enregistrez votre propre évaluation clinique des douleurs du patient. '
                                'Votre jugement professionnel peut différer de la déclaration du patient.',
                                style: TextStyle(fontSize: 13, color: AppTheme.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Légende comparative
              if (_showComparison && _patientDeclaration.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.3),
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Déclaration patient',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                                border: Border.all(color: AppTheme.primaryOrange, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Évaluation pro',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Sélecteur de vue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<BodyView>(
                        segments: const [
                          ButtonSegment(
                            value: BodyView.front,
                            label: Text('Face'),
                            icon: Icon(Icons.person),
                          ),
                          ButtonSegment(
                            value: BodyView.back,
                            label: Text('Dos'),
                            icon: Icon(Icons.accessibility_new),
                          ),
                        ],
                        selected: {_currentView},
                        onSelectionChanged: (Set<BodyView> selected) {
                          setState(() {
                            _currentView = selected.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Silhouette avec double affichage (patient + professionnel)
              Stack(
                children: [
                  // Points du patient (si affichés)
                  if (_showComparison)
                    Opacity(
                      opacity: 0.4,
                      child: BodySilhouette(
                        view: _currentView,
                        painPoints: _patientDeclaration
                            .where((p) => p.view == _currentView)
                            .toList(),
                        selectedPoint: null,
                        onTap: (_, __) {}, // Pas d'interaction
                        onPointTap: (_) {},
                        onPointRemove: (_) {},
                        displayOnly: true,
                      ),
                    ),

                  // Points du professionnel (interactifs)
                  BodySilhouette(
                    view: _currentView,
                    painPoints: _professionalAssessment
                        .where((p) => p.view == _currentView)
                        .toList(),
                    selectedPoint: _selectedPoint,
                    onTap: _addProfessionalAssessment,
                    onPointTap: (point) {
                      setState(() {
                        _selectedPoint = point;
                        _selectedIntensity = point.intensity;
                        _selectedFrequency = point.frequency;
                      });
                    },
                    onPointRemove: _removeProfessionalAssessment,
                    professionalMode: true,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sélecteurs (si un point est sélectionné)
              if (_selectedPoint != null) ...[
                const Divider(),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: AppTheme.primaryOrange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Évaluation professionnelle',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _selectedPoint!.zone.displayName,
                                  style: const TextStyle(
                                    color: AppTheme.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppTheme.error),
                            onPressed: () =>
                                _removeProfessionalAssessment(_selectedPoint!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Intensité
                      PainIntensitySelector(
                        selectedIntensity: _selectedIntensity,
                        onChanged: (intensity) {
                          setState(() {
                            _selectedIntensity = intensity;
                            _updateSelectedPoint();
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Fréquence
                      PainFrequencySelector(
                        selectedFrequency: _selectedFrequency,
                        onChanged: (frequency) {
                          setState(() {
                            _selectedFrequency = frequency;
                            _updateSelectedPoint();
                          });
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],

              // Tableau comparatif
              if (_patientDeclaration.isNotEmpty ||
                  _professionalAssessment.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildComparisonTable(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparatif Patient vs Professionnel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),

        // Déclaration patient
        if (_patientDeclaration.isNotEmpty) ...[
          _buildComparisonSection(
            'Déclaration du patient',
            _patientDeclaration,
            Colors.blue,
            Icons.person,
          ),
          const SizedBox(height: 16),
        ],

        // Évaluation professionnelle
        if (_professionalAssessment.isNotEmpty) ...[
          _buildComparisonSection(
            'Évaluation professionnelle',
            _professionalAssessment,
            AppTheme.primaryOrange,
            Icons.medical_services,
          ),
          const SizedBox(height: 16),
        ],

        // Analyse comparative
        if (_patientDeclaration.isNotEmpty &&
            _professionalAssessment.isNotEmpty)
          _buildComparisonAnalysis(),
      ],
    );
  }

  Widget _buildComparisonSection(
    String title,
    List<PainPoint> points,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.getPainColor(point.intensity.numericValue)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          point.intensity.numericValue.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getPainColor(
                                point.intensity.numericValue),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point.zone.displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${point.frequency.displayName} • ${point.view == BodyView.front ? "Face" : "Dos"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildComparisonAnalysis() {
    // Calculer la différence moyenne d'intensité
    double totalDiff = 0;
    int comparisons = 0;

    for (var patientPoint in _patientDeclaration) {
      for (var proPoint in _professionalAssessment) {
        if (patientPoint.zone == proPoint.zone) {
          totalDiff += (patientPoint.intensity.numericValue -
                  proPoint.intensity.numericValue)
              .abs();
          comparisons++;
        }
      }
    }

    if (comparisons == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey[600]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Aucune zone commune entre la déclaration patient et l\'évaluation professionnelle.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final avgDiff = totalDiff / comparisons;
    String interpretation;
    Color interpretationColor;

    if (avgDiff <= 1) {
      interpretation = 'Évaluation cohérente avec la déclaration patient';
      interpretationColor = AppTheme.success;
    } else if (avgDiff <= 2) {
      interpretation = 'Légère différence d\'appréciation (normale)';
      interpretationColor = Colors.orange;
    } else {
      interpretation =
          'Différence significative : patient peut surestimer ou sous-estimer la douleur';
      interpretationColor = AppTheme.warning;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: interpretationColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: interpretationColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: interpretationColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Analyse comparative',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            interpretation,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Écart moyen d\'intensité : ${avgDiff.toStringAsFixed(1)}/10',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
