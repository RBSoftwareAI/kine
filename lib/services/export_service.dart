import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/patient_summary.dart';
import '../models/pain_point.dart';
import '../models/session_note.dart';

/// Service pour exporter les données patients
/// Utile pour le pilote Tourcoing (backup et partage données)
class ExportService {
  /// Format de date pour les exports
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  
  /// Exporter la liste des patients en CSV
  /// 
  /// Retourne une chaîne CSV prête à être téléchargée
  /// Format: ID, Nom, Email, Dernière séance, Points douleur, Intensité moyenne
  static String exportPatients(List<PatientSummary> patients) {
    try {
      // En-têtes CSV
      final List<List<dynamic>> rows = [
        [
          'ID Patient',
          'Nom',
          'Email',
          'Dernière séance',
          'Nombre de séances',
          'Points de douleur',
          'Intensité moyenne',
          'Statut',
        ]
      ];
      
      // Ajouter les données patients
      for (var patient in patients) {
        rows.add([
          patient.patientId,
          patient.patientName,
          patient.patientEmail,
          patient.lastSessionDate != null
              ? _dateFormat.format(patient.lastSessionDate!)
              : 'Aucune',
          patient.sessionsCount.toString(),
          patient.totalPainPoints.toString(),
          patient.averagePainIntensity.toStringAsFixed(1),
          patient.latestStatus?.displayName ?? 'N/A',
        ]);
      }
      
      // Convertir en CSV
      final csv = const ListToCsvConverter().convert(rows);
      
      if (kDebugMode) {
        debugPrint('✅ Export CSV: ${patients.length} patients exportés');
      }
      
      return csv;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erreur export patients CSV: $e');
      }
      rethrow;
    }
  }
  
  /// Exporter les points de douleur d'un patient en CSV
  /// 
  /// Utile pour suivi évolution douleur
  static String exportPainPoints(
    String patientName,
    List<PainPoint> painPoints,
  ) {
    try {
      // En-têtes CSV
      final List<List<dynamic>> rows = [
        [
          'Patient',
          'Date',
          'Zone corporelle',
          'Intensité (0-10)',
          'Type',
          'Fréquence',
          'Description',
          'Position X',
          'Position Y'
        ]
      ];
      
      // Ajouter les points de douleur
      for (var point in painPoints) {
        rows.add([
          patientName,
          _dateFormat.format(point.recordedAt),
          point.zone.displayName,
          point.intensity.displayName,
          point.view.toString().split('.').last,
          point.frequency.displayName,
          point.description ?? '',
          point.x.toStringAsFixed(2),
          point.y.toStringAsFixed(2),
        ]);
      }
      
      // Convertir en CSV
      final csv = const ListToCsvConverter().convert(rows);
      
      if (kDebugMode) {
        debugPrint('✅ Export CSV: ${painPoints.length} points de douleur exportés');
      }
      
      return csv;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erreur export points de douleur CSV: $e');
      }
      rethrow;
    }
  }
  
  /// Exporter les notes de séances d'un patient en CSV
  static String exportSessionNotes(
    String patientName,
    List<SessionNote> sessions,
  ) {
    try {
      // En-têtes CSV
      final List<List<dynamic>> rows = [
        [
          'Patient',
          'Date séance',
          'Professionnel',
          'Statut progression',
          'Observations',
          'Recommandations',
          'Date création'
        ]
      ];
      
      // Ajouter les séances
      for (var session in sessions) {
        rows.add([
          patientName,
          _dateFormat.format(session.sessionDate),
          session.professionalName,
          session.progressStatus.displayName,
          _cleanTextForCSV(session.observations),
          _cleanTextForCSV(session.recommendations ?? ''),
          _dateFormat.format(session.createdAt),
        ]);
      }
      
      // Convertir en CSV
      final csv = const ListToCsvConverter().convert(rows);
      
      if (kDebugMode) {
        debugPrint('✅ Export CSV: ${sessions.length} séances exportées');
      }
      
      return csv;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erreur export séances CSV: $e');
      }
      rethrow;
    }
  }
  
  /// Export complet d'un patient (JSON structuré)
  /// 
  /// Utile pour backup complet ou transfert données
  static String exportPatientComplete({
    required PatientSummary patient,
    required List<PainPoint> painPoints,
    required List<SessionNote> sessions,
  }) {
    try {
      final data = {
        'patient': {
          'id': patient.patientId,
          'name': patient.patientName,
          'email': patient.patientEmail,
          'totalPainPoints': patient.totalPainPoints,
          'averagePainIntensity': patient.averagePainIntensity,
          'sessionsCount': patient.sessionsCount,
          'lastSessionDate': patient.lastSessionDate?.toIso8601String(),
        },
        'painPoints': painPoints.map((p) => {
          'date': p.recordedAt.toIso8601String(),
          'zone': p.zone.toString().split('.').last,
          'intensity': p.intensity.toString().split('.').last,
          'view': p.view.toString().split('.').last,
          'frequency': p.frequency.toString().split('.').last,
          'description': p.description,
          'x': p.x,
          'y': p.y,
        }).toList(),
        'sessions': sessions.map((s) => {
          'date': s.sessionDate.toIso8601String(),
          'professional': s.professionalName,
          'observations': s.observations,
          'progressStatus': s.progressStatus.toString().split('.').last,
          'recommendations': s.recommendations,
          'createdAt': s.createdAt.toIso8601String(),
        }).toList(),
        'exportDate': DateTime.now().toIso8601String(),
        'exportVersion': '1.0',
      };
      
      final json = const JsonEncoder.withIndent('  ').convert(data);
      
      if (kDebugMode) {
        debugPrint('✅ Export JSON complet: Patient ${patient.patientId}');
      }
      
      return json;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erreur export complet JSON: $e');
      }
      rethrow;
    }
  }
  
  /// Nettoyer le texte pour CSV (retirer sauts de ligne, guillemets)
  static String _cleanTextForCSV(String text) {
    return text
        .replaceAll('\n', ' ')
        .replaceAll('\r', '')
        .replaceAll('"', '""')
        .trim();
  }
  
  /// Obtenir le nom de fichier formaté pour export
  /// 
  /// Exemples:
  /// - patients_2025-11-16_14h30.csv
  /// - patient_dupont_jean_2025-11-16.json
  static String getExportFilename({
    required String type,
    String? patientName,
    String extension = 'csv',
  }) {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd_HHhmm').format(now);
    
    if (patientName != null) {
      final cleanName = patientName
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '');
      return '${type}_${cleanName}_$dateStr.$extension';
    }
    
    return '${type}_$dateStr.$extension';
  }
}
