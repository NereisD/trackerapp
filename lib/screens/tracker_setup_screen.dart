import 'package:flutter/material.dart';
import 'package:mon_app/models/deck.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/screens/deck_selection_screen.dart';
import 'package:mon_app/services/auth_service.dart';
import 'package:mon_app/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class TrackerSetupScreen extends StatefulWidget {
  const TrackerSetupScreen({super.key});

  @override
  State<TrackerSetupScreen> createState() => _TrackerSetupScreenState();
}

class _TrackerSetupScreenState extends State<TrackerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDeckId;
  final Set<DeckColor> _selectedColors = {};
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _uuid = const Uuid();

  List<Deck> get filteredDecks {
    if (_selectedColors.isEmpty) {
      return [];
    }

    if (_selectedColors.length == 1) {
      return Deck.allDecks
          .where((deck) => deck.colors.contains(_selectedColors.first))
          .toList();
    }

    if (_selectedColors.length == 2) {
      return Deck.allDecks
          .where(
            (deck) =>
                deck.colors.length == 2 &&
                deck.colors.toSet().containsAll(_selectedColors),
          )
          .toList();
    }

    return [];
  }

  void _createTournament() {
    if (_nameController.text.isEmpty || _selectedDeckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tournament = Tournament(
      id: _uuid.v4(),
      name: _nameController.text,
      playerDeckId: _selectedDeckId!,
      rounds: [],
      createdAt: DateTime.now(),
      isCompleted: false,
    );

    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _firestoreService.createTournament(userId, tournament);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckSelectionScreen(tournament: tournament),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un tournoi')),
      body: Column(
        children: [
          // Section fixe en haut (titre, nom, filtres)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Créer un nouveau tournoi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du tournoi',
                    hintText: 'Ex: Tournoi Local 2024',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Filtrer par couleur',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      DeckColor.values.map((color) {
                        final isSelected = _selectedColors.contains(color);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedColors.remove(color);
                              } else {
                                _selectedColors.add(color);
                              }
                            });
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: color.color.withOpacity(
                                isSelected ? 0.7 : 0.35,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.white : color.color,
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                color.runeImagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sélectionnez votre deck',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // Section scrollable (grille de decks uniquement)
          Expanded(
            child:
                filteredDecks.isEmpty
                    ? const Center(
                      child: Text(
                        'Sélectionnez une ou deux couleurs',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : GridView.count(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
                      children:
                          filteredDecks.map((deck) {
                            final isSelected = _selectedDeckId == deck.id;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDeckId = deck.id;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.deepPurple
                                            : Colors.transparent,
                                    width: isSelected ? 3 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    deck.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: ElevatedButton(
          onPressed: _createTournament,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Créer le tournoi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
