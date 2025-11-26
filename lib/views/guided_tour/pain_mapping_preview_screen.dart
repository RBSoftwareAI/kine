import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Écran de prévisualisation de la cartographie des douleurs pour la visite guidée
/// Affiche une silhouette anatomique avec points de douleur factices
class PainMappingPreviewScreen extends StatelessWidget {
  const PainMappingPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartographie des douleurs'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Sélecteur de vue
          _buildViewSelector(),
          
          // Silhouette avec points de douleur
          Expanded(
            child: _buildBodySilhouette(),
          ),
          
          // Panneau des contrôles
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildViewButton('Face avant', Icons.accessibility, true),
          const SizedBox(width: 16),
          _buildViewButton('Face arrière', Icons.accessibility, false),
        ],
      ),
    );
  }

  Widget _buildViewButton(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppTheme.primaryOrange 
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected 
              ? AppTheme.primaryOrange 
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodySilhouette() {
    return Stack(
      children: [
        // Fond avec grid
        Container(
          color: Colors.grey[50],
          child: CustomPaint(
            painter: GridPainter(),
            child: Container(),
          ),
        ),
        
        // Silhouette anatomique simplifiée
        Center(
          child: CustomPaint(
            size: const Size(300, 500),
            painter: BodySilhouettePainter(),
          ),
        ),
        
        // Points de douleur factices
        ..._buildPainPoints(),
        
        // Légende
        Positioned(
          top: 16,
          right: 16,
          child: _buildLegend(),
        ),
      ],
    );
  }

  List<Widget> _buildPainPoints() {
    return [
      _buildPainPoint(0.48, 0.25, 7, 'Épaule droite'),  // Épaule
      _buildPainPoint(0.50, 0.48, 8, 'Bas du dos'),     // Bas du dos
      _buildPainPoint(0.46, 0.75, 5, 'Genou gauche'),   // Genou
    ];
  }

  Widget _buildPainPoint(double x, double y, int intensity, String zone) {
    final color = AppTheme.getIntensityColor(intensity);
    final size = 20.0 + (intensity / 10 * 20); // Taille proportionnelle à l'intensité
    
    return Positioned(
      left: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width * x - size / 2,
      top: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height * y - size / 2,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              intensity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Intensité',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, '0-2: Légère'),
          _buildLegendItem(Colors.yellow, '3-4: Modérée'),
          _buildLegendItem(Colors.orange, '5-6: Forte'),
          _buildLegendItem(Colors.red, '7-10: Sévère'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zone sélectionnée
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.place, color: AppTheme.primaryOrange),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bas du dos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Intensité: 8/10 • Fréquence: Quotidienne',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Curseur d'intensité
          Row(
            children: [
              const Icon(Icons.whatshot, color: AppTheme.primaryOrange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Intensité de la douleur',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppTheme.primaryOrange,
                        thumbColor: AppTheme.primaryOrange,
                        overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: 8.0,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: '8',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '8/10',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getIntensityColor(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Sélecteur de fréquence
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppTheme.primaryOrange),
              const SizedBox(width: 12),
              const Text(
                'Fréquence:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildFrequencyChip('Quotidienne', true),
                    _buildFrequencyChip('Hebdomadaire', false),
                    _buildFrequencyChip('Occasionnelle', false),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyChip(String label, bool isSelected) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 12,
        ),
      ),
      backgroundColor: isSelected 
          ? AppTheme.primaryOrange 
          : Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

/// Painter pour la grille de fond
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Lignes verticales
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Lignes horizontales
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter pour la silhouette corporelle simplifiée
class BodySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Tête
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.1),
      size.width * 0.12,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.1),
      size.width * 0.12,
      fillPaint,
    );

    // Corps
    path.moveTo(size.width / 2, size.height * 0.22);
    
    // Épaules
    path.lineTo(size.width * 0.35, size.height * 0.28);
    path.lineTo(size.width * 0.35, size.height * 0.35);
    
    // Bras gauche
    path.lineTo(size.width * 0.30, size.height * 0.50);
    
    // Retour vers le corps
    path.moveTo(size.width * 0.35, size.height * 0.35);
    path.lineTo(size.width * 0.40, size.height * 0.35);
    
    // Torse
    path.lineTo(size.width * 0.38, size.height * 0.55);
    
    // Jambe gauche
    path.lineTo(size.width * 0.42, size.height * 0.90);
    
    // Retour vers le centre
    path.moveTo(size.width * 0.38, size.height * 0.55);
    path.lineTo(size.width / 2, size.height * 0.55);
    
    // Côté droit (miroir)
    path.lineTo(size.width * 0.62, size.height * 0.55);
    path.lineTo(size.width * 0.58, size.height * 0.90);
    
    // Retour vers le haut côté droit
    path.moveTo(size.width * 0.62, size.height * 0.55);
    path.lineTo(size.width * 0.60, size.height * 0.35);
    
    // Bras droit
    path.lineTo(size.width * 0.65, size.height * 0.35);
    path.lineTo(size.width * 0.70, size.height * 0.50);
    
    // Retour à l'épaule droite
    path.moveTo(size.width * 0.65, size.height * 0.35);
    path.lineTo(size.width * 0.65, size.height * 0.28);
    path.lineTo(size.width / 2, size.height * 0.22);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
