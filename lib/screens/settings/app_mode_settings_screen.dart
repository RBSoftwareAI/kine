import 'package:flutter/material.dart';
import '../../services/service_locator.dart';

/// Écran de paramètres pour basculer entre les modes DEMO et LOCAL
class AppModeSettingsScreen extends StatefulWidget {
  const AppModeSettingsScreen({super.key});

  @override
  State<AppModeSettingsScreen> createState() => _AppModeSettingsScreenState();
}

class _AppModeSettingsScreenState extends State<AppModeSettingsScreen> {
  final ServiceLocator _serviceLocator = ServiceLocator();
  final TextEditingController _flaskUrlController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFlaskUrl();
  }

  Future<void> _loadFlaskUrl() async {
    final url = await _serviceLocator.getFlaskUrl();
    _flaskUrlController.text = url;
  }

  Future<void> _switchMode(AppMode mode) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (mode == AppMode.demo) {
        await _serviceLocator.switchToDemoMode();
      } else {
        await _serviceLocator.switchToLocalMode(
          flaskUrl: _flaskUrlController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mode changé vers ${mode == AppMode.demo ? 'DEMO' : 'LOCAL'}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Suggérer de redémarrer l'application
        _showRestartDialog();
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du changement de mode : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redémarrage recommandé'),
        content: const Text(
          'Pour que les changements prennent pleinement effet, '
          'il est recommandé de redémarrer l\'application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Plus tard'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retour à l'écran de connexion
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Redémarrer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flaskUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = _serviceLocator.currentMode;
    final isDemoMode = currentMode == AppMode.demo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode de l\'application'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mode actuel
                  Card(
                    child: ListTile(
                      leading: Icon(
                        isDemoMode ? Icons.cloud : Icons.storage,
                        color: isDemoMode ? Colors.blue : Colors.green,
                        size: 32,
                      ),
                      title: Text(
                        'Mode actuel : ${_serviceLocator.currentModeName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(_serviceLocator.currentModeDescription),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description des modes
                  const Text(
                    'Choisir un mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mode DEMO
                  _ModeCard(
                    title: 'Mode DEMO (Firebase)',
                    description:
                        'Idéal pour tester l\'application avec des données fictives.\n\n'
                        '✓ Données hébergées sur Firebase\n'
                        '✓ Accès depuis n\'importe où\n'
                        '✓ Parfait pour la formation\n'
                        '✗ Données partagées (non privées)',
                    icon: Icons.cloud,
                    color: Colors.blue,
                    isSelected: isDemoMode,
                    onTap: () => _switchMode(AppMode.demo),
                  ),

                  const SizedBox(height: 16),

                  // Mode LOCAL
                  _ModeCard(
                    title: 'Mode LOCAL (Flask)',
                    description:
                        'Pour une utilisation professionnelle avec vos données réelles.\n\n'
                        '✓ Données stockées localement\n'
                        '✓ Confidentialité totale\n'
                        '✓ Conforme RGPD\n'
                        '✓ Aucun frais d\'hébergement',
                    icon: Icons.storage,
                    color: Colors.green,
                    isSelected: !isDemoMode,
                    onTap: () => _switchMode(AppMode.local),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextField(
                        controller: _flaskUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL du serveur Flask',
                          hintText: 'http://localhost:5000',
                          border: OutlineInputBorder(),
                          helperText:
                              'Adresse du serveur Flask (ex: http://192.168.1.10:5000)',
                        ),
                      ),
                    ),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Informations supplémentaires
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Informations importantes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            '• Le changement de mode ne supprime pas vos données\n'
                            '• Vous pouvez basculer entre les modes à tout moment\n'
                            '• En mode LOCAL, assurez-vous que le serveur Flask est démarré\n'
                            '• Les données ne sont pas synchronisées entre les modes',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? child;

  const _ModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? color.withOpacity(0.1) : null,
      child: InkWell(
        onTap: isSelected ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: color, size: 28),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              if (child != null) child!,
              if (!isSelected) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Basculer vers ce mode'),
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
