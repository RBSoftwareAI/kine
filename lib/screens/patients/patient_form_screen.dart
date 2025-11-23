import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/patient_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/patient.dart';

/// Écran de formulaire pour ajouter ou modifier un patient
class PatientFormScreen extends StatefulWidget {
  final Patient? patient;

  const PatientFormScreen({
    super.key,
    this.patient,
  });

  bool get isEditing => patient != null;

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _dateNaissanceController;
  late final TextEditingController _telephoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _adresseController;
  late final TextEditingController _codePostalController;
  late final TextEditingController _villeController;
  late final TextEditingController _professionController;
  late final TextEditingController _numeroSSController;
  late final TextEditingController _medecinTraitantController;
  late final TextEditingController _notesController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Initialiser les controllers avec les valeurs existantes si modification
    _nomController = TextEditingController(text: widget.patient?.nom ?? '');
    _prenomController =
        TextEditingController(text: widget.patient?.prenom ?? '');
    _dateNaissanceController = TextEditingController(
      text: widget.patient != null
          ? DateFormat('dd/MM/yyyy').format(widget.patient!.dateNaissance)
          : '',
    );
    _telephoneController =
        TextEditingController(text: widget.patient?.telephone ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _adresseController =
        TextEditingController(text: widget.patient?.adresse ?? '');
    _codePostalController =
        TextEditingController(text: widget.patient?.codePostal ?? '');
    _villeController = TextEditingController(text: widget.patient?.ville ?? '');
    _professionController =
        TextEditingController(text: widget.patient?.profession ?? '');
    _numeroSSController =
        TextEditingController(text: widget.patient?.numeroSecuriteSociale ?? '');
    _medecinTraitantController =
        TextEditingController(text: widget.patient?.medecinTraitant ?? '');
    _notesController = TextEditingController(text: widget.patient?.notes ?? '');

    _selectedDate = widget.patient?.dateNaissance;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _codePostalController.dispose();
    _villeController.dispose();
    _professionController.dispose();
    _numeroSSController.dispose();
    _medecinTraitantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? DateTime(now.year - 30, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la date de naissance',
      cancelText: 'Annuler',
      confirmText: 'OK',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateNaissanceController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date de naissance'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final patientProvider = context.read<PatientProvider>();
    final centreId = authProvider.centre?.id;

    if (centreId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur: Centre non trouvé'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final patient = Patient(
      id: widget.patient?.id ?? '',
      centreId: centreId,
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      dateNaissance: _selectedDate!,
      telephone: _telephoneController.text.trim().isEmpty
          ? null
          : _telephoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      adresse: _adresseController.text.trim().isEmpty
          ? null
          : _adresseController.text.trim(),
      codePostal: _codePostalController.text.trim().isEmpty
          ? null
          : _codePostalController.text.trim(),
      ville: _villeController.text.trim().isEmpty
          ? null
          : _villeController.text.trim(),
      profession: _professionController.text.trim().isEmpty
          ? null
          : _professionController.text.trim(),
      numeroSecuriteSociale: _numeroSSController.text.trim().isEmpty
          ? null
          : _numeroSSController.text.trim(),
      medecinTraitant: _medecinTraitantController.text.trim().isEmpty
          ? null
          : _medecinTraitantController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      dateCreation: widget.patient?.dateCreation ?? DateTime.now(),
      dateModification: widget.isEditing ? DateTime.now() : null,
    );

    bool success;
    if (widget.isEditing) {
      success = await patientProvider.updatePatient(
        widget.patient!.id,
        patient,
      );
    } else {
      final patientId = await patientProvider.addPatient(patient);
      success = patientId != null;
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Patient modifié avec succès'
                  : 'Patient ajouté avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              patientProvider.error ?? 'Erreur lors de la sauvegarde',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier patient' : 'Nouveau patient'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Informations principales
            _buildSection(
              'Informations principales',
              [
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nom requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Prénom requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateNaissanceController,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance *',
                    prefixIcon: Icon(Icons.cake_outlined),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'Date de naissance requise';
                    }
                    return null;
                  },
                ),
              ],
            ),

            // Contact
            _buildSection(
              'Contact',
              [
                TextFormField(
                  controller: _telephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '01 23 45 67 89',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'patient@email.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
              ],
            ),

            // Adresse
            _buildSection(
              'Adresse',
              [
                TextFormField(
                  controller: _adresseController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _codePostalController,
                        decoration: const InputDecoration(
                          labelText: 'Code postal',
                          prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _villeController,
                        decoration: const InputDecoration(
                          labelText: 'Ville',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Informations complémentaires
            _buildSection(
              'Informations complémentaires',
              [
                TextFormField(
                  controller: _professionController,
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numeroSSController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de sécurité sociale',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medecinTraitantController,
                  decoration: const InputDecoration(
                    labelText: 'Médecin traitant',
                    prefixIcon: Icon(Icons.medical_services_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ],
            ),

            // Notes
            _buildSection(
              'Notes',
              [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    prefixIcon: Icon(Icons.note_outlined),
                    hintText: 'Notes sur le patient...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: patientProvider.isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: patientProvider.isLoading ? null : _savePatient,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: patientProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            widget.isEditing
                                ? 'Enregistrer les modifications'
                                : 'Créer le patient',
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
