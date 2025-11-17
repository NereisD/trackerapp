import 'package:flutter/material.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/models/deck.dart';
import 'package:intl/intl.dart';

class TournamentHistoryDetailScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentHistoryDetailScreen({super.key, required this.tournament});

  @override
  State<TournamentHistoryDetailScreen> createState() =>
      _TournamentHistoryDetailScreenState();
}

class _TournamentHistoryDetailScreenState
    extends State<TournamentHistoryDetailScreen> {
  final Set<int> _expandedRounds = {};

  int get playerTotalWins {
    return widget.tournament.rounds.fold(
      0,
      (sum, round) => sum + round.playerWins,
    );
  }

  int get opponentTotalWins {
    return widget.tournament.rounds.fold(
      0,
      (sum, round) => sum + round.opponentWins,
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerDeck = Deck.getDeckById(widget.tournament.playerDeckId);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.tournament.name),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Score global - Bandeau simplifié
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Image du deck
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
                // Score global (W L D)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$playerTotalWins',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$opponentTotalWins',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date et statut
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(widget.tournament.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (widget.tournament.isCompleted) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Terminé',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Historique des rounds
          Expanded(
            child:
                widget.tournament.rounds.isEmpty
                    ? const Center(
                      child: Text(
                        'Aucun round joué',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.tournament.rounds.length,
                      itemBuilder: (context, index) {
                        final round = widget.tournament.rounds[index];
                        final isExpanded = _expandedRounds.contains(index);
                        final opponentDeck = Deck.getDeckById(
                          round.opponentDeckId,
                        );
                        final playerWon = round.playerWins > round.opponentWins;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Qui a commencé (dés)
                                    Column(
                                      children: [
                                        const Text(
                                          '🎲',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          round.matches.isNotEmpty &&
                                                  round
                                                      .matches
                                                      .first
                                                      .playerStarted
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.asset(
                                              opponentDeck.imagePath,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                  '${round.playerWins}-${round.opponentWins}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Icône victoire/défaite
                                    Icon(
                                      playerWon
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          playerWon ? Colors.green : Colors.red,
                                      size: 32,
                                    ),
                                  ],
                                ),
                                // Bouton pour afficher/masquer les détails
                                if (round.matches.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedRounds.remove(index);
                                        } else {
                                          _expandedRounds.add(index);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      size: 20,
                                    ),
                                    label: Text(
                                      isExpanded
                                          ? 'Masquer les détails'
                                          : 'Afficher les détails (${round.matches.length} matchs)',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                                // Détails des matchs (dépliables)
                                if (round.matches.isNotEmpty && isExpanded) ...[
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Détail des matchs',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...round.matches.asMap().entries.map((
                                    matchEntry,
                                  ) {
                                    final matchIndex = matchEntry.key;
                                    final match = matchEntry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Match ${matchIndex + 1}:',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${match.playerScore} - ${match.opponentScore}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                match.winnerId == 'player'
                                                    ? Icons.check_circle
                                                    : match.winnerId ==
                                                        'opponent'
                                                    ? Icons.cancel
                                                    : Icons.remove_circle,
                                                size: 16,
                                                color:
                                                    match.winnerId == 'player'
                                                        ? Colors.green
                                                        : match.winnerId ==
                                                            'opponent'
                                                        ? Colors.red
                                                        : Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                match.playerStarted
                                                    ? '(Vous)'
                                                    : '(Adv)',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
