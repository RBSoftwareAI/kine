import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/appointment.dart';
import 'appointment_form_screen.dart';
import 'appointment_detail_screen.dart';

/// Écran du calendrier des rendez-vous
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Appointment> _selectedDayAppointments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  Future<void> _loadAppointments() async {
    final authProvider = context.read<AuthProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();
    
    if (authProvider.centre?.id == null) return;

    setState(() {
      _isLoading = true;
    });

    await appointmentProvider.loadAppointments(authProvider.centre!.id);
    _loadSelectedDayAppointments();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadSelectedDayAppointments() {
    if (_selectedDay == null) return;

    final appointmentProvider = context.read<AppointmentProvider>();
    final authProvider = context.read<AuthProvider>();

    appointmentProvider
        .getAppointmentsByDate(authProvider.centre!.id, _selectedDay!)
        .then((appointments) {
      setState(() {
        _selectedDayAppointments = appointments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Calendrier
            Card(
              margin: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _loadSelectedDayAppointments();
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                eventLoader: (day) {
                  // Retourner les RDV du jour pour afficher les marqueurs
                  return appointmentProvider.appointments
                      .where((apt) =>
                          apt.dateHeure.year == day.year &&
                          apt.dateHeure.month == day.month &&
                          apt.dateHeure.day == day.day)
                      .toList();
                },
              ),
            ),

            // Séparateur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDay != null
                        ? _formatDate(_selectedDay!)
                        : 'Sélectionnez une date',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_selectedDayAppointments.length} RDV',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Liste des rendez-vous du jour sélectionné
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedDayAppointments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun rendez-vous',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Créez un nouveau rendez-vous',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _selectedDayAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = _selectedDayAppointments[index];
                            return _buildAppointmentCard(
                              appointment,
                              authProvider,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AppointmentFormScreen(
                selectedDate: _selectedDay ?? DateTime.now(),
              ),
            ),
          );

          if (result == true) {
            _loadAppointments();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau RDV'),
      ),
    );
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
    AuthProvider authProvider,
  ) {
    final patientProvider = context.watch<PatientProvider>();
    
    // Récupérer le patient si disponible
    final patient = appointment.patientId != null
        ? patientProvider.patients.firstWhere(
            (p) => p.id == appointment.patientId,
            orElse: () => patientProvider.patients.first,
          )
        : null;

    final statusColor = _getStatusColor(appointment.statut);
    final statusIcon = _getStatusIcon(appointment.statut);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AppointmentDetailScreen(
                appointment: appointment,
              ),
            ),
          );

          if (result == true) {
            _loadAppointments();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Heure
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(appointment.dateHeure),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      '${appointment.duree}min',
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Détails
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            patient?.nomComplet ??
                                (appointment.patientNom != null
                                    ? '${appointment.patientPrenom} ${appointment.patientNom}'
                                    : 'Patient inconnu'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (appointment.motif != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.motif!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusLabel(appointment.statut),
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'confirmé':
        return Colors.green;
      case 'en_cours':
        return Colors.blue;
      case 'terminé':
        return Colors.grey;
      case 'annulé':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String statut) {
    switch (statut) {
      case 'confirmé':
        return Icons.check_circle;
      case 'en_cours':
        return Icons.play_circle;
      case 'terminé':
        return Icons.check_circle_outline;
      case 'annulé':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  String _getStatusLabel(String statut) {
    switch (statut) {
      case 'planifié':
        return 'Planifié';
      case 'confirmé':
        return 'Confirmé';
      case 'en_cours':
        return 'En cours';
      case 'terminé':
        return 'Terminé';
      case 'annulé':
        return 'Annulé';
      default:
        return statut;
    }
  }
}
