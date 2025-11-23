import 'package:flutter/material.dart';
import 'package:mon_app/models/deck.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/screens/deck_selection_screen.dart';
import 'package:mon_app/screens/simple_counter_screen.dart';
import 'package:mon_app/screens/four_player_counter_screen.dart';
import 'package:mon_app/screens/tracker_setup_screen.dart';
import 'package:mon_app/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riftbound Tracker'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sélectionnez une option',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMenuCard(
                        context: context,
                        title: 'Tracker',
                        subtitle: 'Lancer un tracker',
                        icon: Icons.play_circle_filled,
                        color: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrackerSetupScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Counter',
                        subtitle: 'Counter vide',
                        icon: Icons.calculate_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SimpleCounterScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Multi-joueurs',
                        subtitle: 'Counter à 4',
                        icon: Icons.people,
                        color: Theme.of(context).colorScheme.tertiary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const FourPlayerCounterScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Autre TCG',
                        subtitle: 'Bientôt disponible',
                        icon: Icons.style,
                        color: Colors.grey,
                        onTap: null, // Désactivé
                        isDisabled: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: null,
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return Card(
      elevation: isDisabled ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDisabled
                      ? [Colors.grey[300]!, Colors.grey[400]!]
                      : [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isDisabled ? Colors.grey[600] : Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDisabled ? Colors.grey[700] : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDisabled
                          ? Colors.grey[600]
                          : Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
