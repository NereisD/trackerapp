import 'package:flutter/material.dart';
import 'package:mon_app/models/deck.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/screens/start_screen.dart';

class DeckSelectionScreen extends StatefulWidget {
  final Tournament tournament;

  const DeckSelectionScreen({super.key, required this.tournament});

  @override
  State<DeckSelectionScreen> createState() => _DeckSelectionScreenState();
}

class _DeckSelectionScreenState extends State<DeckSelectionScreen> {
  String? _selectedOpponentDeckId;
  final Set<DeckColor> _selectedColors = {};

  List<Deck> get filteredDecks {
    // Aucun filtre = aucun deck affiché
    if (_selectedColors.isEmpty) {
      return [];
    }

    // Si 1 couleur : decks avec cette couleur
    if (_selectedColors.length == 1) {
      return Deck.allDecks
          .where((deck) => deck.colors.contains(_selectedColors.first))
          .toList();
    }

    // Si 2 couleurs : decks avec exactement ces 2 couleurs
    if (_selectedColors.length == 2) {
      return Deck.allDecks
          .where(
            (deck) =>
                deck.colors.length == 2 &&
                deck.colors.toSet().containsAll(_selectedColors),
          )
          .toList();
    }

    // Si 3+ couleurs : aucun deck (un deck n'a que 2 couleurs max)
    return [];
  }

  void _confirmSelection() {
    if (_selectedOpponentDeckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un deck adverse'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigation vers l'écran Start
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StartScreen(
              tournament: widget.tournament,
              opponentDeckId: _selectedOpponentDeckId!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerDeck = Deck.getDeckById(widget.tournament.playerDeckId);

    return Scaffold(
      appBar: AppBar(title: const Text('Deck adverse')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Affichage du deck du joueur
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.style, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Votre deck',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        playerDeck.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Filtres de couleur
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

            // Liste des decks
            const Text(
              'Sélectionnez le deck adverse',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    filteredDecks.map((deck) {
                      final isSelected = _selectedOpponentDeckId == deck.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOpponentDeckId = deck.id;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected ? Colors.red : Colors.transparent,
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
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirmer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
