import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/patient_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/common/loading_screen.dart';

void main() async {
  // Assurez-vous que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Firebase avec configuration multi-plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MediDeskApp());
}

class MediDeskApp extends StatelessWidget {
  const MediDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: MaterialApp(
        title: 'MediDesk Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3), // Bleu MediDesk
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Widget qui gère le routing basé sur l'état d'authentification
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Afficher l'écran de chargement pendant l'initialisation
        if (authProvider.isLoading) {
          return const LoadingScreen();
        }
        
        // Si une erreur s'est produite et que Firebase User existe, réessayer
        if (authProvider.error != null && authProvider.firebaseUser != null) {
          // Afficher l'erreur et proposer de réessayer
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authProvider.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        authProvider.loadUserData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        authProvider.logout();
                      },
                      child: const Text('Se déconnecter'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        // Si l'utilisateur est authentifié, afficher le dashboard
        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        }
        
        // Sinon, afficher l'écran de connexion
        return const LoginScreen();
      },
    );
  }
}
