import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/appointment.dart';
import '../../models/patient.dart';

/// Écran de création/modification d'un rendez-vous
class AppointmentFormScreen extends StatefulWidget {
  final Appointment? appointment; // null = création, non-null = modification
  final DateTime? selectedDate;

  const AppointmentFormScreen({
    super.key,
    this.appointment,
    this.selectedDate,
  });

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Champs du formulaire
  Patient? _selectedPatient;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _duration = 30;
  String _type = 'consultation';
  final _motifController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.appointment != null) {
      // Mode modification
      _selectedDate = widget.appointment!.dateHeure;
      _selectedTime = TimeOfDay.fromDateTime(widget.appointment!.dateHeure);
      _duration = widget.appointment!.duree;
      _type = widget.appointment!.type;
      _motifController.text = widget.appointment!.motif ?? '';
      _notesController.text = widget.appointment!.notes ?? '';
    } else {
      // Mode création
      _selectedDate = widget.selectedDate ?? DateTime.now();
      _selectedTime = TimeOfDay.now();
    }

    // Charger le patient si en mode modification
    if (widget.appointment?.patientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPatient();
      });
    }
  }

  void _loadPatient() {
    final patientProvider = context.read<PatientProvider>();
    final patient = patientProvider.patients.firstWhere(
      (p) => p.id == widget.appointment!.patientId,
      orElse: () => patientProvider.patients.first,
    );
    setState(() {
      _selectedPatient = patient;
    });
  }

  @override
  void dispose() {
    _motifController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un patient'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date et une heure'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    // Combiner date et heure
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Vérifier la disponibilité
    final isAvailable = await appointmentProvider.isSlotAvailable(
      authProvider.centre!.id,
      authProvider.appUser!.id,
      dateTime,
      _duration,
      excludeAppointmentId: widget.appointment?.id,
    );

    if (!isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ce créneau horaire n\'est pas disponible'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appointment = Appointment(
        id: widget.appointment?.id ?? '',
        centreId: authProvider.centre!.id,
        praticienId: authProvider.appUser!.id,
        patientId: _selectedPatient!.id,
        dateHeure: dateTime,
        duree: _duration,
        type: _type,
        motif: _motifController.text.trim().isEmpty
            ? null
            : _motifController.text.trim(),
        statut: widget.appointment?.statut ?? 'planifié',
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        dateCreation: widget.appointment?.dateCreation ?? DateTime.now(),
        dateModification: widget.appointment != null ? DateTime.now() : null,
      );

      bool success;
      if (widget.appointment == null) {
        // Création
        final id = await appointmentProvider.addAppointment(appointment);
        success = id != null;
      } else {
        // Modification
        success = await appointmentProvider.updateAppointment(
          widget.appointment!.id,
          appointment,
        );
      }

      if (mounted) {
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.appointment == null
                    ? 'Rendez-vous créé avec succès'
                    : 'Rendez-vous modifié avec succès',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appointmentProvider.error ?? 'Erreur inconnue'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointment == null
              ? 'Nouveau rendez-vous'
              : 'Modifier le rendez-vous',
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sélection patient
              DropdownButtonFormField<Patient>(
                value: _selectedPatient,
                decoration: InputDecoration(
                  labelText: 'Patient *',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: patientProvider.patients.map((patient) {
                  return DropdownMenuItem(
                    value: patient,
                    child: Text(patient.nomComplet),
                  );
                }).toList(),
                onChanged: (patient) {
                  setState(() {
                    _selectedPatient = patient;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un patient';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Sélectionner une date',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Heure
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Heure *',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Sélectionner une heure',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Durée
              DropdownButtonFormField<int>(
                value: _duration,
                decoration: InputDecoration(
                  labelText: 'Durée',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [15, 30, 45, 60, 90, 120].map((minutes) {
                  return DropdownMenuItem(
                    value: minutes,
                    child: Text('$minutes minutes'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _duration = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Type
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(
                  labelText: 'Type de consultation',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'consultation', child: Text('Consultation')),
                  DropdownMenuItem(value: 'suivi', child: Text('Suivi')),
                  DropdownMenuItem(value: 'urgence', child: Text('Urgence')),
                  DropdownMenuItem(value: 'bilan', child: Text('Bilan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Motif
              TextFormField(
                controller: _motifController,
                decoration: InputDecoration(
                  labelText: 'Motif de consultation',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (optionnel)',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Bouton enregistrer
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAppointment,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          widget.appointment == null ? 'Créer' : 'Modifier',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
