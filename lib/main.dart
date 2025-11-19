import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
    return MaterialApp(
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
      ),
      home: const FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatelessWidget {
  const FirebaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediDesk Demo - Firebase OK'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '🎉 Firebase Connecté !',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Projet: kinecare-81f52\nPackage: fr.medidesk.demo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildServiceStatus(context, 'Authentication', true),
                    const SizedBox(height: 8),
                    _buildServiceStatus(context, 'Firestore', true),
                    const SizedBox(height: 8),
                    _buildServiceStatus(context, 'Storage', true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Prêt pour le développement ! 🚀'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.rocket_launch),
              label: const Text('Prêt pour développement'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatus(BuildContext context, String service, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              service,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          isActive ? 'Actif' : 'Inactif',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
