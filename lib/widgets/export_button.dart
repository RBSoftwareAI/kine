import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:convert';
import '../services/export_service.dart';
import '../models/patient_summary.dart';

/// Bouton d'export universel pour données patients
/// 
/// Télécharge automatiquement le fichier en mode Web
/// Affiche le contenu en mode mobile (à implémenter)
class ExportButton extends StatelessWidget {
  final List<PatientSummary> patients;
  final VoidCallback? onExportComplete;
  
  const ExportButton({
    super.key,
    required this.patients,
    this.onExportComplete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.download),
      tooltip: 'Exporter les données',
      onSelected: (value) => _handleExport(context, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'csv',
          child: Row(
            children: [
              Icon(Icons.table_chart, size: 20),
              SizedBox(width: 8),
              Text('Export CSV'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'json',
          child: Row(
            children: [
              Icon(Icons.code, size: 20),
              SizedBox(width: 8),
              Text('Export JSON (backup complet)'),
            ],
          ),
        ),
      ],
    );
  }
  
  Future<void> _handleExport(BuildContext context, String format) async {
    try {
      if (patients.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucun patient à exporter'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      
      String content;
      String filename;
      String mimeType;
      
      if (format == 'csv') {
        // Export CSV
        content = ExportService.exportPatients(patients);
        filename = ExportService.getExportFilename(
          type: 'patients',
          extension: 'csv',
        );
        mimeType = 'text/csv;charset=utf-8';
      } else {
        // Export JSON (pour le moment, liste simple)
        // TODO: Export complet avec points douleur et séances
        final jsonData = patients.map((p) => {
          'id': p.patientId,
          'name': p.patientName,
          'email': p.patientEmail,
          'totalPainPoints': p.totalPainPoints,
          'averagePainIntensity': p.averagePainIntensity,
          'sessionsCount': p.sessionsCount,
          'lastSessionDate': p.lastSessionDate?.toIso8601String(),
        }).toList();
        
        content = const JsonEncoder.withIndent('  ').convert({
          'patients': jsonData,
          'exportDate': DateTime.now().toIso8601String(),
          'count': patients.length,
        });
        
        filename = ExportService.getExportFilename(
          type: 'patients_backup',
          extension: 'json',
        );
        mimeType = 'application/json;charset=utf-8';
      }
      
      // Télécharger le fichier (Web uniquement pour le moment)
      if (kIsWeb) {
        _downloadFile(content, filename, mimeType);
      }
      
      // Afficher confirmation
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${patients.length} patient(s) exporté(s) avec succès',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      
      // Callback optionnel
      onExportComplete?.call();
      
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
  
  /// Télécharger un fichier côté Web
  void _downloadFile(String content, String filename, String mimeType) {
    // Créer un Blob avec le contenu
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    
    // Créer un lien de téléchargement
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    
    // Nettoyer
    html.Url.revokeObjectUrl(url);
  }
}
