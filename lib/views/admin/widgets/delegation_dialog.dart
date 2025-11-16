import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_theme.dart';

/// Dialog pour déléguer des permissions à un utilisateur
class DelegationDialog extends StatefulWidget {
  final UserModel user;

  const DelegationDialog({super.key, required this.user});

  @override
  State<DelegationDialog> createState() => _DelegationDialogState();
}

class _DelegationDialogState extends State<DelegationDialog> {
  DateTime? _expiresAt;
  bool _isPermanent = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Déléguer permissions à ${widget.user.firstName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.user.fullName} (${widget.user.role.displayName}) pourra gérer les permissions des autres utilisateurs.',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          SwitchListTile(
            title: const Text('Délégation permanente'),
            subtitle: const Text('Aucune date d\'expiration'),
            value: _isPermanent,
            onChanged: (value) {
              setState(() {
                _isPermanent = value;
                if (value) _expiresAt = null;
              });
            },
          ),
          
          if (!_isPermanent) ...[
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _expiresAt == null 
                    ? 'Sélectionner date expiration' 
                    : 'Expire le ${_expiresAt!.day}/${_expiresAt!.month}/${_expiresAt!.year}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _expiresAt = date;
                  });
                }
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: (!_isPermanent && _expiresAt == null) ? null : () {
            Navigator.pop(context, _expiresAt);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
          ),
          child: const Text('Déléguer'),
        ),
      ],
    );
  }
}
