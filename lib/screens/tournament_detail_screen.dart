import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/models/deck.dart';
import 'package:mon_app/screens/deck_selection_screen.dart';
import 'package:mon_app/services/firestore_service.dart';

class TournamentDetailScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailScreen({super.key, required this.tournament});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _endTournament() async {
    print('🔚 _endTournament appelé');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Marquer le tournoi comme terminé
    final updatedTournament = widget.tournament.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    if (userId != null) {
      print('💾 Mise à jour du tournoi terminé dans Firestore');
      try {
        await _firestoreService
            .updateTournament(userId, updatedTournament)
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () {
                print(
                  '⏱️ Timeout Firebase dans _endTournament, on continue quand même',
                );
              },
            );
        print('✅ Tournoi terminé sauvegardé (ou timeout ignoré)');
      } catch (e) {
        print('❌ Erreur Firebase (ignorée dans _endTournament): $e');
      }
    } else {
      print(
        '⚠️ User ID nul dans _endTournament, on saute la sauvegarde mais on continue la navigation',
      );
    }

    print('🚀 Fin de _endTournament, on gère la navigation');
    if (mounted) {
      print('🏠 Navigation retour à la racine (Home/MainScreen)');
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerDeck = Deck.getDeckById(widget.tournament.playerDeckId);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.tournament.name),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Score global
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Photo du deck
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(playerDeck.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Nom du deck
                Text(
                  playerDeck.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Score actuel (victoires - défaites - égalités)
                Text(
                  '${widget.tournament.totalWins} - ${widget.tournament.totalLosses} - ${widget.tournament.totalDraws}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Historique des rounds
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.tournament.rounds.length,
              itemBuilder: (context, index) {
                final round = widget.tournament.rounds[index];
                final opponentDeck = Deck.getDeckById(round.opponentDeckId);
                final playerWon = round.playerWins > round.opponentWins;
                final isTie =
                    round.playerWins == round.opponentWins && round.isCompleted;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Qui a commencé (dés)
                        Column(
                          children: [
                            const Text('🎲', style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(
                              round.matches.isNotEmpty &&
                                      round.matches.first.playerStarted
                                  ? '✅'
                                  : '❌',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Info du round avec image
                        Expanded(
                          child: Row(
                            children: [
                              // Image du deck adverse
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  opponentDeck.imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Nom et score
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      opponentDeck.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${round.playerWins} victoires - ${round.opponentWins} défaites',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icône victoire/défaite/égalité
                        Icon(
                          isTie
                              ? Icons.close
                              : (playerWon ? Icons.check_circle : Icons.cancel),
                          color:
                              isTie
                                  ? Colors.orange
                                  : (playerWon ? Colors.green : Colors.red),
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Section sélection adversaire
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Nouveau Round',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DeckSelectionScreen(
                              tournament: widget.tournament,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Sélectionner un adversaire',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _endTournament,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Fin du tournoi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
}
