import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/pain_point.dart';
import '../../utils/app_theme.dart';
import 'widgets/body_silhouette.dart';
import 'widgets/pain_intensity_selector.dart';
import 'widgets/pain_frequency_selector.dart';

/// Écran de suivi des douleurs avec silhouettes anatomiques
class PainTrackingScreen extends StatefulWidget {
  const PainTrackingScreen({super.key});

  @override
  State<PainTrackingScreen> createState() => _PainTrackingScreenState();
}

class _PainTrackingScreenState extends State<PainTrackingScreen> {
  BodyView _currentView = BodyView.front;
  List<PainPoint> _painPoints = [];
  
  PainPoint? _selectedPoint;
  PainIntensity _selectedIntensity = PainIntensity.moderate;
  PainFrequency _selectedFrequency = PainFrequency.daily;

  @override
  void initState() {
    super.initState();
    _loadPainPoints();
  }

  Future<void> _loadPainPoints() async {
    // TODO: Charger depuis Firebase
    // Pour l'instant, liste vide
    setState(() {
      _painPoints = [];
    });
  }

  void _addPainPoint(Offset position, Size size) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user == null) return;

    // Convertir la position en coordonnées relatives (0-1)
    final relativeX = position.dx / size.width;
    final relativeY = position.dy / size.height;

    // Déterminer la zone anatomique basée sur la position
    final zone = _determineBodyZone(relativeX, relativeY, _currentView);

    final newPoint = PainPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: user.id,
      zone: zone,
      view: _currentView,
      x: relativeX,
      y: relativeY,
      intensity: _selectedIntensity,
      frequency: _selectedFrequency,
      recordedAt: DateTime.now(),
      recordedBy: user.id,
    );

    setState(() {
      _painPoints.add(newPoint);
      _selectedPoint = newPoint;
    });

    // TODO: Sauvegarder dans Firebase
  }

  void _removePainPoint(PainPoint point) {
    setState(() {
      _painPoints.remove(point);
      if (_selectedPoint?.id == point.id) {
        _selectedPoint = null;
      }
    });
    // TODO: Supprimer de Firebase
  }

  void _updateSelectedPoint() {
    if (_selectedPoint == null) return;

    setState(() {
      final index = _painPoints.indexWhere((p) => p.id == _selectedPoint!.id);
      if (index != -1) {
        _painPoints[index] = _selectedPoint!.copyWith(
          intensity: _selectedIntensity,
          frequency: _selectedFrequency,
        );
        _selectedPoint = _painPoints[index];
      }
    });

    // TODO: Mettre à jour dans Firebase
  }

  BodyZone _determineBodyZone(double x, double y, BodyView view) {
    // Logique simplifiée de détection de zone
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
      // Vue dos
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie des Douleurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _painPoints.isEmpty ? null : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Douleurs enregistrées'),
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
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.info.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cliquez sur la silhouette pour indiquer vos zones de douleur. '
                        'Ajustez l\'intensité et la fréquence pour chaque point.',
                        style: TextStyle(fontSize: 14, color: AppTheme.grey),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sélecteur de vue (Face/Dos)
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

              // Silhouette interactive
              BodySilhouette(
                view: _currentView,
                painPoints: _painPoints
                    .where((p) => p.view == _currentView)
                    .toList(),
                selectedPoint: _selectedPoint,
                onTap: _addPainPoint,
                onPointTap: (point) {
                  setState(() {
                    _selectedPoint = point;
                    _selectedIntensity = point.intensity;
                    _selectedFrequency = point.frequency;
                  });
                },
                onPointRemove: _removePainPoint,
              ),

              const SizedBox(height: 24),

              // Sélecteurs Intensité et Fréquence
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
                            child: Icon(
                              Icons.location_on,
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
                                  'Point de douleur sélectionné',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _selectedPoint!.zone.displayName,
                                  style: TextStyle(
                                    color: AppTheme.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppTheme.error),
                            onPressed: () => _removePainPoint(_selectedPoint!),
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

              // Résumé des points de douleur
              if (_painPoints.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Points de douleur enregistrés (${_painPoints.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._painPoints.map((point) => _buildPainSummaryCard(point)),
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

  Widget _buildPainSummaryCard(PainPoint point) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
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
                color: AppTheme.getPainColor(point.intensity.numericValue),
              ),
            ),
          ),
        ),
        title: Text(point.zone.displayName),
        subtitle: Text(
          '${point.frequency.displayName} • ${point.view == BodyView.front ? "Face" : "Dos"}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () {
            setState(() {
              _selectedPoint = point;
              _selectedIntensity = point.intensity;
              _selectedFrequency = point.frequency;
            });
          },
        ),
      ),
    );
  }
}
