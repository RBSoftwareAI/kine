import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/pain_history.dart';
import '../../../utils/app_theme.dart';

class IntensityChart extends StatelessWidget {
  final List<PainHistoryPoint> historyPoints;

  const IntensityChart({
    super.key,
    required this.historyPoints,
  });

  @override
  Widget build(BuildContext context) {
    if (historyPoints.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text(
            'Aucune donnée disponible',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        _buildChartData(),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData _buildChartData() {
    // Convertir les points en spots pour le graphique
    final spots = historyPoints.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.averageIntensity,
      );
    }).toList();

    // Repérer les points de session
    final sessionSpots = <int, bool>{};
    for (int i = 0; i < historyPoints.length; i++) {
      if (historyPoints[i].sessionId != null) {
        sessionSpots[i] = historyPoints[i].isBeforeSession;
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateBottomInterval(),
            getTitlesWidget: (value, meta) => _buildBottomTitle(value.toInt()),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
          left: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
      minX: 0,
      maxX: (historyPoints.length - 1).toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppTheme.primaryOrange,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Marquer les points de session différemment
              if (sessionSpots.containsKey(index)) {
                final isBeforeSession = sessionSpots[index]!;
                return FlDotCirclePainter(
                  radius: 6,
                  color: isBeforeSession ? Colors.red : Colors.green,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              }
              
              // Points normaux
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.getIntensityColor(spot.y.round()),
                strokeWidth: 1.5,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryOrange.withValues(alpha: 0.3),
                AppTheme.primaryOrange.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.grey[800]!,
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              if (index < 0 || index >= historyPoints.length) {
                return null;
              }
              
              final point = historyPoints[index];
              final dateStr = _formatDate(point.timestamp);
              final intensityStr = point.averageIntensity.toStringAsFixed(1);
              
              String label = '$dateStr\n$intensityStr/10';
              
              if (point.sessionId != null) {
                label += '\n${point.isBeforeSession ? "Avant séance" : "Après séance"}';
              }
              
              return LineTooltipItem(
                label,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  double _calculateBottomInterval() {
    // Adapter l'intervalle selon le nombre de points
    if (historyPoints.length <= 7) return 1;
    if (historyPoints.length <= 14) return 2;
    if (historyPoints.length <= 30) return 5;
    return 10;
  }

  Widget _buildBottomTitle(int index) {
    if (index < 0 || index >= historyPoints.length) {
      return const SizedBox.shrink();
    }

    final point = historyPoints[index];
    final dateStr = _formatShortDate(point.timestamp);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        dateStr,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM à HH:mm').format(date);
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }
}
