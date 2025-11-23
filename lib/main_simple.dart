import 'package:flutter/material.dart';

/// Version simplifiée de main.dart pour tester si l'app se lance sur iOS
/// Sans Firebase, sans authentification
///
/// Pour tester:
/// 1. Renommez main.dart en main_backup.dart
/// 2. Renommez main_simple.dart en main.dart
/// 3. Rebuild et installez sur iPhone
///
/// Si ça marche → le problème vient de Firebase/Auth
/// Si ça crash → problème de configuration iOS de base

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('iOS Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              '✅ L\'app fonctionne sur iOS !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Si vous voyez ceci, le problème\nvient de Firebase ou de l\'authentification',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
