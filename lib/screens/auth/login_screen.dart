import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/guided_tour_v2.dart';

/// Écran de connexion pour les utilisateurs existants
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Erreur de connexion'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _fillAndLogin(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
    // Connexion automatique
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      body: SafeArea(
        child: isWideScreen ? _buildWideLayout() : _buildNarrowLayout(),
      ),
    );
  }

  // Layout pour écrans larges (desktop/tablette)
  Widget _buildWideLayout() {
    return Row(
      children: [
        // Panneau de gauche : Comptes test
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue.shade50,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: _buildTestAccountsPanel(),
            ),
          ),
        ),
        
        // Panneau de droite : Formulaire de connexion
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout pour écrans étroits (smartphone)
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          _buildLoginForm(),
          const SizedBox(height: 32),
          _buildTestAccountsPanel(),
        ],
      ),
    );
  }

  // Formulaire de connexion
  Widget _buildLoginForm() {
    final authProvider = context.watch<AuthProvider>();
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo et titre
          Icon(
            Icons.medical_services_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          
          Text(
            'MediDesk',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Gestion de cabinet médical',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 48),
          
          // Email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'exemple@cabinet.fr',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email requis';
              }
              if (!value.contains('@')) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Mot de passe
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mot de passe requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Bouton de connexion
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Bouton visite guidée
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: authProvider.isLoading 
                  ? null 
                  : () => GuidedTourV2.startTour(context),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text(
                '🎯 Essayer la visite guidée (5-7 min)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Panneau des comptes test
  Widget _buildTestAccountsPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user,
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Comptes de test disponibles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Cliquez sur un compte pour vous connecter automatiquement',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          
          // Comptes test
          _buildTestAccountCard(
            icon: Icons.person,
            role: 'Patient',
            name: 'Patient Test',
            email: 'test.patient@medidesk.fr',
            password: 'password123',
            description: 'Accès limité : suivi des douleurs personnelles',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          
          _buildTestAccountCard(
            icon: Icons.medical_services,
            role: 'Praticien (Kiné)',
            name: 'Marie Lefebvre',
            email: 'marie.lefebvre@kine-paris.fr',
            password: 'password123',
            description: 'Suivi patients, notes de séance, courbes',
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          
          _buildTestAccountCard(
            icon: Icons.healing,
            role: 'Praticien (Ostéo)',
            name: 'Pierre Durand',
            email: 'pierre.durand@osteo-lyon.fr',
            password: 'password123',
            description: 'Suivi patients, notes de séance, courbes',
            color: Colors.teal,
          ),
          const SizedBox(height: 12),
          
          _buildTestAccountCard(
            icon: Icons.supervisor_account,
            role: 'Manager',
            name: 'Jean Martin',
            email: 'manager@medidesk.fr',
            password: 'password123',
            description: 'Gestion des permissions + accès professionnel',
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          
          _buildTestAccountCard(
            icon: Icons.settings,
            role: 'Administrateur',
            name: 'Admin Système',
            email: 'admin@medidesk.fr',
            password: 'password123',
            description: 'Accès complet au système',
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          
          _buildTestAccountCard(
            icon: Icons.admin_panel_settings,
            role: 'Secrétaire',
            name: 'Sophie Dupont',
            email: 'secretariat@medidesk.fr',
            password: 'password123',
            description: 'Gestion patients et rendez-vous',
            color: Colors.purple,
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // Info - Connexion automatique
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app, color: Colors.blue.shade900),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '✨ Cliquez sur une carte pour connexion automatique en 1 clic',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Info sur le mot de passe commun
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.key, color: Colors.amber.shade900),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '🔑 Tous les comptes : password123',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Carte de compte test
  Widget _buildTestAccountCard({
    required IconData icon,
    required String role,
    required String name,
    required String email,
    required String password,
    required String description,
    required MaterialColor color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _fillAndLogin(email, password),
        borderRadius: BorderRadius.circular(12),
        splashColor: color[200]!.withOpacity(0.3),
        highlightColor: color[100]!.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: color[200]!, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: color[50]!,
          ),
          child: Row(
            children: [
              // Icône du rôle
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color[100]!,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color[700]!, size: 24),
              ),
              const SizedBox(width: 12),
              
              // Informations du compte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rôle + Nom
                    Text(
                      '$role - $name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color[900]!,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Email (police réduite, gris)
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Indicateur visuel de clic
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color[400]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
