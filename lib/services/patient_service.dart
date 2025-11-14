import '../models/patient_summary.dart';
import '../models/user_model.dart';
import '../models/pain_point.dart';
import '../models/session_note.dart';

/// Service pour gérer les données patients (version locale temporaire)
/// À remplacer par Firebase Firestore plus tard
class PatientService {
  /// Obtenir la liste des patients pour un professionnel
  Future<List<PatientSummary>> getPatientsForProfessional(String professionalId) async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Données de démonstration
    return [
      PatientSummary(
        patientId: 'patient_001',
        patientName: 'Jean Dupont',
        patientEmail: 'patient@demo.com',
        totalPainPoints: 5,
        averagePainIntensity: 6.5,
        latestStatus: ProgressStatus.improving,
        lastSessionDate: DateTime.now().subtract(const Duration(days: 2)),
        lastPainUpdate: DateTime.now().subtract(const Duration(hours: 5)),
        sessionsCount: 8,
        recentPainPoints: [
          PainPoint(
            id: '1',
            patientId: 'patient_001',
            zone: BodyZone.lowerBack,
            view: BodyView.back,
            x: 0.5,
            y: 0.4,
            intensity: PainIntensity.severe,
            frequency: PainFrequency.daily,
            recordedAt: DateTime.now().subtract(const Duration(hours: 5)),
            recordedBy: 'patient_001',
          ),
          PainPoint(
            id: '2',
            patientId: 'patient_001',
            zone: BodyZone.knee,
            view: BodyView.front,
            x: 0.4,
            y: 0.75,
            intensity: PainIntensity.moderate,
            frequency: PainFrequency.occasional,
            recordedAt: DateTime.now().subtract(const Duration(days: 1)),
            recordedBy: 'patient_001',
          ),
        ],
      ),
      PatientSummary(
        patientId: 'patient_002',
        patientName: 'Marie Martin',
        patientEmail: 'marie.martin@example.com',
        totalPainPoints: 3,
        averagePainIntensity: 4.2,
        latestStatus: ProgressStatus.stable,
        lastSessionDate: DateTime.now().subtract(const Duration(days: 5)),
        lastPainUpdate: DateTime.now().subtract(const Duration(days: 2)),
        sessionsCount: 12,
        recentPainPoints: [
          PainPoint(
            id: '3',
            patientId: 'patient_002',
            zone: BodyZone.shoulder,
            view: BodyView.front,
            x: 0.3,
            y: 0.25,
            intensity: PainIntensity.mild,
            frequency: PainFrequency.occasional,
            recordedAt: DateTime.now().subtract(const Duration(days: 2)),
            recordedBy: 'patient_002',
          ),
        ],
      ),
      PatientSummary(
        patientId: 'patient_003',
        patientName: 'Pierre Durand',
        patientEmail: 'pierre.durand@example.com',
        totalPainPoints: 8,
        averagePainIntensity: 8.5,
        latestStatus: ProgressStatus.worsening,
        lastSessionDate: DateTime.now().subtract(const Duration(days: 10)),
        lastPainUpdate: DateTime.now().subtract(const Duration(hours: 12)),
        sessionsCount: 4,
        recentPainPoints: [
          PainPoint(
            id: '4',
            patientId: 'patient_003',
            zone: BodyZone.neck,
            view: BodyView.back,
            x: 0.5,
            y: 0.2,
            intensity: PainIntensity.extreme,
            frequency: PainFrequency.constant,
            recordedAt: DateTime.now().subtract(const Duration(hours: 12)),
            recordedBy: 'patient_003',
          ),
          PainPoint(
            id: '5',
            patientId: 'patient_003',
            zone: BodyZone.upperBack,
            view: BodyView.back,
            x: 0.5,
            y: 0.35,
            intensity: PainIntensity.severe,
            frequency: PainFrequency.frequent,
            recordedAt: DateTime.now().subtract(const Duration(hours: 12)),
            recordedBy: 'patient_003',
          ),
        ],
      ),
      PatientSummary(
        patientId: 'patient_004',
        patientName: 'Sophie Leblanc',
        patientEmail: 'sophie.leblanc@example.com',
        totalPainPoints: 2,
        averagePainIntensity: 3.0,
        latestStatus: ProgressStatus.improving,
        lastSessionDate: DateTime.now().subtract(const Duration(days: 3)),
        lastPainUpdate: DateTime.now().subtract(const Duration(days: 1)),
        sessionsCount: 15,
        recentPainPoints: [
          PainPoint(
            id: '6',
            patientId: 'patient_004',
            zone: BodyZone.ankle,
            view: BodyView.front,
            x: 0.45,
            y: 0.9,
            intensity: PainIntensity.mild,
            frequency: PainFrequency.occasional,
            recordedAt: DateTime.now().subtract(const Duration(days: 1)),
            recordedBy: 'patient_004',
          ),
        ],
      ),
      PatientSummary(
        patientId: 'patient_005',
        patientName: 'Thomas Bernard',
        patientEmail: 'thomas.bernard@example.com',
        totalPainPoints: 0,
        averagePainIntensity: 0.0,
        latestStatus: ProgressStatus.recovered,
        lastSessionDate: DateTime.now().subtract(const Duration(days: 14)),
        lastPainUpdate: DateTime.now().subtract(const Duration(days: 20)),
        sessionsCount: 20,
        recentPainPoints: [],
      ),
    ];
  }

  /// Rechercher des patients par nom
  Future<List<PatientSummary>> searchPatients(
    String professionalId,
    String query,
  ) async {
    final allPatients = await getPatientsForProfessional(professionalId);
    
    if (query.isEmpty) return allPatients;
    
    final lowerQuery = query.toLowerCase();
    return allPatients
        .where((p) =>
            p.patientName.toLowerCase().contains(lowerQuery) ||
            p.patientEmail.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filtrer les patients par statut
  Future<List<PatientSummary>> filterPatientsByStatus(
    String professionalId,
    ProgressStatus? status,
  ) async {
    final allPatients = await getPatientsForProfessional(professionalId);
    
    if (status == null) return allPatients;
    
    return allPatients
        .where((p) => p.latestStatus == status)
        .toList();
  }

  /// Obtenir les patients nécessitant attention
  Future<List<PatientSummary>> getPatientsNeedingAttention(
    String professionalId,
  ) async {
    final allPatients = await getPatientsForProfessional(professionalId);
    return allPatients.where((p) => p.needsAttention).toList();
  }
}
