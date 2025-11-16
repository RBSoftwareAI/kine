import 'package:flutter/material.dart';
import '../../../models/pain_point.dart';
import '../../../utils/app_theme.dart';

/// Widget de silhouette corporelle interactive
class BodySilhouette extends StatelessWidget {
  final BodyView view;
  final List<PainPoint> painPoints;
  final PainPoint? selectedPoint;
  final Function(Offset position, Size size) onTap;
  final Function(PainPoint point) onPointTap;
  final Function(PainPoint point) onPointRemove;

  const BodySilhouette({
    super.key,
    required this.view,
    required this.painPoints,
    this.selectedPoint,
    required this.onTap,
    required this.onPointTap,
    required this.onPointRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapDown: (details) {
                final renderBox = context.findRenderObject() as RenderBox;
                final localPosition = renderBox.globalToLocal(details.globalPosition);
                onTap(localPosition, renderBox.size);
              },
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _BodySilhouettePainter(
                  view: view,
                  painPoints: painPoints,
                  selectedPoint: selectedPoint,
                  onPointTap: onPointTap,
                ),
                child: Container(), // Zone cliquable
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Painter personnalisé pour dessiner la silhouette
class _BodySilhouettePainter extends CustomPainter {
  final BodyView view;
  final List<PainPoint> painPoints;
  final PainPoint? selectedPoint;
  final Function(PainPoint point) onPointTap;

  _BodySilhouettePainter({
    required this.view,
    required this.painPoints,
    this.selectedPoint,
    required this.onPointTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner la silhouette
    _drawSilhouette(canvas, size);
    
    // Dessiner les points de douleur
    for (final point in painPoints) {
      _drawPainPoint(canvas, size, point, point == selectedPoint);
    }
  }

  void _drawSilhouette(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = AppTheme.lightGrey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final headRadius = size.width * 0.12;

    if (view == BodyView.front) {
      // FACE - Silhouette simplifiée

      // Tête (cercle)
      canvas.drawCircle(
        Offset(centerX, size.height * 0.1),
        headRadius,
        fillPaint,
      );
      canvas.drawCircle(
        Offset(centerX, size.height * 0.1),
        headRadius,
        paint,
      );

      // Cou
      final neckPath = Path()
        ..moveTo(centerX - headRadius * 0.4, size.height * 0.1 + headRadius)
        ..lineTo(centerX - headRadius * 0.3, size.height * 0.2)
        ..lineTo(centerX + headRadius * 0.3, size.height * 0.2)
        ..lineTo(centerX + headRadius * 0.4, size.height * 0.1 + headRadius);
      canvas.drawPath(neckPath, fillPaint);
      canvas.drawPath(neckPath, paint);

      // Torse (trapèze + rectangle)
      final torsoPath = Path()
        ..moveTo(centerX - size.width * 0.15, size.height * 0.2) // Épaule gauche
        ..lineTo(centerX + size.width * 0.15, size.height * 0.2) // Épaule droite
        ..lineTo(centerX + size.width * 0.18, size.height * 0.35) // Taille droite
        ..lineTo(centerX + size.width * 0.16, size.height * 0.5) // Hanche droite
        ..lineTo(centerX - size.width * 0.16, size.height * 0.5) // Hanche gauche
        ..lineTo(centerX - size.width * 0.18, size.height * 0.35) // Taille gauche
        ..close();
      canvas.drawPath(torsoPath, fillPaint);
      canvas.drawPath(torsoPath, paint);

      // Bras gauche
      final leftArmPath = Path()
        ..moveTo(centerX - size.width * 0.15, size.height * 0.2)
        ..lineTo(centerX - size.width * 0.25, size.height * 0.25)
        ..lineTo(centerX - size.width * 0.28, size.height * 0.45)
        ..lineTo(centerX - size.width * 0.22, size.height * 0.48)
        ..lineTo(centerX - size.width * 0.18, size.height * 0.35);
      canvas.drawPath(leftArmPath, fillPaint);
      canvas.drawPath(leftArmPath, paint);

      // Bras droit
      final rightArmPath = Path()
        ..moveTo(centerX + size.width * 0.15, size.height * 0.2)
        ..lineTo(centerX + size.width * 0.25, size.height * 0.25)
        ..lineTo(centerX + size.width * 0.28, size.height * 0.45)
        ..lineTo(centerX + size.width * 0.22, size.height * 0.48)
        ..lineTo(centerX + size.width * 0.18, size.height * 0.35);
      canvas.drawPath(rightArmPath, fillPaint);
      canvas.drawPath(rightArmPath, paint);

      // Jambe gauche
      final leftLegPath = Path()
        ..moveTo(centerX - size.width * 0.12, size.height * 0.5)
        ..lineTo(centerX - size.width * 0.1, size.height * 0.75)
        ..lineTo(centerX - size.width * 0.08, size.height * 0.95)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.95)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.75)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.5);
      canvas.drawPath(leftLegPath, fillPaint);
      canvas.drawPath(leftLegPath, paint);

      // Jambe droite
      final rightLegPath = Path()
        ..moveTo(centerX + size.width * 0.12, size.height * 0.5)
        ..lineTo(centerX + size.width * 0.1, size.height * 0.75)
        ..lineTo(centerX + size.width * 0.08, size.height * 0.95)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.95)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.75)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.5);
      canvas.drawPath(rightLegPath, fillPaint);
      canvas.drawPath(rightLegPath, paint);

    } else {
      // DOS - Vue arrière AMÉLIORÉE avec colonne vertébrale visible

      // Tête
      canvas.drawCircle(
        Offset(centerX, size.height * 0.1),
        headRadius,
        fillPaint,
      );
      canvas.drawCircle(
        Offset(centerX, size.height * 0.1),
        headRadius,
        paint,
      );

      // Cou
      final neckPath = Path()
        ..moveTo(centerX - headRadius * 0.4, size.height * 0.1 + headRadius)
        ..lineTo(centerX - headRadius * 0.3, size.height * 0.2)
        ..lineTo(centerX + headRadius * 0.3, size.height * 0.2)
        ..lineTo(centerX + headRadius * 0.4, size.height * 0.1 + headRadius);
      canvas.drawPath(neckPath, fillPaint);
      canvas.drawPath(neckPath, paint);

      // Dos avec courbure naturelle
      final backPath = Path()
        ..moveTo(centerX - size.width * 0.15, size.height * 0.2) // Épaule gauche
        ..lineTo(centerX + size.width * 0.15, size.height * 0.2) // Épaule droite
        // Courbure thoracique (légère convexité)
        ..quadraticBezierTo(
          centerX + size.width * 0.17, size.height * 0.3,
          centerX + size.width * 0.16, size.height * 0.4,
        )
        // Courbure lombaire (légère concavité)
        ..quadraticBezierTo(
          centerX + size.width * 0.14, size.height * 0.45,
          centerX + size.width * 0.16, size.height * 0.5,
        )
        ..lineTo(centerX - size.width * 0.16, size.height * 0.5)
        ..quadraticBezierTo(
          centerX - size.width * 0.14, size.height * 0.45,
          centerX - size.width * 0.16, size.height * 0.4,
        )
        ..quadraticBezierTo(
          centerX - size.width * 0.17, size.height * 0.3,
          centerX - size.width * 0.15, size.height * 0.2,
        )
        ..close();
      canvas.drawPath(backPath, fillPaint);
      canvas.drawPath(backPath, paint);

      // LIGNE VERTÉBRALE CENTRALE (caractéristique dos)
      final spinePaint = Paint()
        ..color = AppTheme.grey.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      
      final spinePath = Path()
        ..moveTo(centerX, size.height * 0.2) // C7
        // Courbure thoracique
        ..quadraticBezierTo(
          centerX + size.width * 0.02, size.height * 0.3,
          centerX, size.height * 0.4,
        )
        // Courbure lombaire
        ..quadraticBezierTo(
          centerX - size.width * 0.015, size.height * 0.45,
          centerX, size.height * 0.5, // L5
        );
      canvas.drawPath(spinePath, spinePaint);

      // MARQUEURS VERTÉBRAUX (C7, T12, L5)
      final vertebraePaint = Paint()
        ..color = AppTheme.grey
        ..style = PaintingStyle.fill;
      
      // C7 (Cervicale 7) - Base du cou
      canvas.drawCircle(
        Offset(centerX, size.height * 0.21),
        4,
        vertebraePaint,
      );
      
      // T12 (Thoracique 12) - Milieu du dos
      canvas.drawCircle(
        Offset(centerX, size.height * 0.35),
        4,
        vertebraePaint,
      );
      
      // L5 (Lombaire 5) - Bas du dos
      canvas.drawCircle(
        Offset(centerX, size.height * 0.47),
        4,
        vertebraePaint,
      );

      // Bras (identiques à la vue face)
      final leftArmPath = Path()
        ..moveTo(centerX - size.width * 0.15, size.height * 0.2)
        ..lineTo(centerX - size.width * 0.25, size.height * 0.25)
        ..lineTo(centerX - size.width * 0.28, size.height * 0.45)
        ..lineTo(centerX - size.width * 0.22, size.height * 0.48)
        ..lineTo(centerX - size.width * 0.18, size.height * 0.35);
      canvas.drawPath(leftArmPath, fillPaint);
      canvas.drawPath(leftArmPath, paint);

      final rightArmPath = Path()
        ..moveTo(centerX + size.width * 0.15, size.height * 0.2)
        ..lineTo(centerX + size.width * 0.25, size.height * 0.25)
        ..lineTo(centerX + size.width * 0.28, size.height * 0.45)
        ..lineTo(centerX + size.width * 0.22, size.height * 0.48)
        ..lineTo(centerX + size.width * 0.18, size.height * 0.35);
      canvas.drawPath(rightArmPath, fillPaint);
      canvas.drawPath(rightArmPath, paint);

      // Jambes (identiques)
      final leftLegPath = Path()
        ..moveTo(centerX - size.width * 0.12, size.height * 0.5)
        ..lineTo(centerX - size.width * 0.1, size.height * 0.75)
        ..lineTo(centerX - size.width * 0.08, size.height * 0.95)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.95)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.75)
        ..lineTo(centerX - size.width * 0.05, size.height * 0.5);
      canvas.drawPath(leftLegPath, fillPaint);
      canvas.drawPath(leftLegPath, paint);

      final rightLegPath = Path()
        ..moveTo(centerX + size.width * 0.12, size.height * 0.5)
        ..lineTo(centerX + size.width * 0.1, size.height * 0.75)
        ..lineTo(centerX + size.width * 0.08, size.height * 0.95)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.95)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.75)
        ..lineTo(centerX + size.width * 0.05, size.height * 0.5);
      canvas.drawPath(rightLegPath, fillPaint);
      canvas.drawPath(rightLegPath, paint);
    }
  }

  void _drawPainPoint(Canvas canvas, Size size, PainPoint point, bool isSelected) {
    final x = point.x * size.width;
    final y = point.y * size.height;
    final position = Offset(x, y);

    final color = AppTheme.getPainColor(point.intensity.numericValue);
    
    // Cercle extérieur (sélection)
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = AppTheme.primaryOrange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(position, 20, selectionPaint);
    }

    // Cercle principal
    final circlePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 15, circlePaint);

    // Bordure
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(position, 15, borderPaint);

    // Numéro d'intensité
    final textPainter = TextPainter(
      text: TextSpan(
        text: point.intensity.numericValue.toString(),
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_BodySilhouettePainter oldDelegate) {
    return oldDelegate.view != view ||
        oldDelegate.painPoints != painPoints ||
        oldDelegate.selectedPoint != selectedPoint;
  }
}
