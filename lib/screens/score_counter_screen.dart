import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/models/deck.dart';
import 'package:mon_app/models/round.dart';
import 'package:mon_app/models/match.dart';
import 'package:mon_app/services/firestore_service.dart';
import 'package:mon_app/screens/tournament_detail_screen.dart';
import 'package:uuid/uuid.dart';

class ScoreCounterScreen extends StatefulWidget {
  final Tournament tournament;
  final String opponentDeckId;
  final bool playerStarts;
  final Round? currentRound;

  const ScoreCounterScreen({
    super.key,
    required this.tournament,
    required this.opponentDeckId,
    required this.playerStarts,
    this.currentRound,
  });

  @override
  State<ScoreCounterScreen> createState() => _ScoreCounterScreenState();
}

class _ScoreCounterScreenState extends State<ScoreCounterScreen> {
  int _playerScore = 0;
  int _opponentScore = 0;
  late Round _round;
  final _uuid = const Uuid();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Initialiser ou récupérer le round
    _round =
        widget.currentRound ??
        Round(
          id: _uuid.v4(),
          opponentDeckId: widget.opponentDeckId,
          matches: [],
          timestamp: DateTime.now(),
          playerWins: 0,
          opponentWins: 0,
          isCompleted: false,
        );
  }

  void _incrementPlayerScore() {
    setState(() {
      _playerScore++;
    });
  }

  void _decrementPlayerScore() {
    setState(() {
      if (_playerScore > 0) _playerScore--;
    });
  }

  void _incrementOpponentScore() {
    setState(() {
      _opponentScore++;
    });
  }

  void _decrementOpponentScore() {
    setState(() {
      if (_opponentScore > 0) _opponentScore--;
    });
  }

  void _newMatch() async {
    print('🔥 _newMatch appelé - Score: $_playerScore vs $_opponentScore');

    if (_playerScore == 0 && _opponentScore == 0) {
      print('⚠️ Scores à 0-0, affichage du message');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jouez un match avant d\'enregistrer !'),
          backgroundColor: Colors.orange,
        ),
      );
      return; // Pas de match à enregistrer
    }

    print('✅ Scores valides, création du match');

    // Déterminer le gagnant
    String? winnerId;
    if (_playerScore > _opponentScore) {
      winnerId = 'player';
    } else if (_opponentScore > _playerScore) {
      winnerId = 'opponent';
    }

    print('🏆 Gagnant: $winnerId');

    // Créer le match
    final match = Match(
      id: _uuid.v4(),
      playerScore: _playerScore,
      opponentScore: _opponentScore,
      winnerId: winnerId,
      playerStarted: widget.playerStarts,
      timestamp: DateTime.now(),
    );

    // Ajouter le match au round
    final updatedMatches = [..._round.matches, match];
    print('📝 Match créé, total matches: ${updatedMatches.length}');

    // Calculer les victoires
    int playerWins = 0;
    int opponentWins = 0;
    for (var m in updatedMatches) {
      if (m.winnerId == 'player') playerWins++;
      if (m.winnerId == 'opponent') opponentWins++;
    }
    print('📊 Victoires - Player: $playerWins, Opponent: $opponentWins');

    // Mettre à jour le round
    final updatedRound = _round.copyWith(
      matches: updatedMatches,
      playerWins: playerWins,
      opponentWins: opponentWins,
      isCompleted: playerWins >= 2 || opponentWins >= 2,
    );
    print('🔄 Round mis à jour, completed: ${updatedRound.isCompleted}');

    // Mettre à jour le tournoi
    final List<Round> updatedRounds;
    final roundExists = widget.tournament.rounds.any((r) => r.id == _round.id);

    if (roundExists) {
      // Le round existe, on le met à jour
      updatedRounds =
          widget.tournament.rounds.map((r) {
            if (r.id == _round.id) return updatedRound;
            return r;
          }).toList();
    } else {
      // Le round n'existe pas encore, on l'ajoute
      updatedRounds = [...widget.tournament.rounds, updatedRound];
    }

    final updatedTournament = Tournament(
      id: widget.tournament.id,
      name: widget.tournament.name,
      playerDeckId: widget.tournament.playerDeckId,
      rounds: updatedRounds,
      createdAt: widget.tournament.createdAt,
      completedAt: widget.tournament.completedAt,
      isCompleted: false,
    );
    print('🏟️ Tournoi mis à jour');

    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('👤 User ID: $userId');
    if (userId != null) {
      print('💾 Sauvegarde dans Firestore...');
      try {
        await _firestoreService.updateTournament(userId, updatedTournament).timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            print('⏱️ Timeout Firebase, on continue quand même');
          },
        );
        print('✅ Sauvegarde réussie');
      } catch (e) {
        print('❌ Erreur sauvegarde (ignorée): $e');
        // On continue quand même, le tournoi est en mémoire
      }
    }
    print('🚀 Continuons après Firebase...');

    // Si le round est terminé, naviguer vers l'écran de tournoi
    if (updatedRound.isCompleted) {
      print('🏁 Round terminé, navigation vers TournamentDetailScreen');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    TournamentDetailScreen(tournament: updatedTournament),
          ),
        );
      }
    } else {
      print('🔄 Match enregistré, réinitialisation des scores');
      print('📊 Wins avant setState - Player: ${_round.playerWins}, Opponent: ${_round.opponentWins}');
      // Réinitialiser les scores pour le prochain match
      setState(() {
        _round = updatedRound;
        _playerScore = 0;
        _opponentScore = 0;
      });
      print('✅ Scores réinitialisés à 0-0');
      print('📊 Wins après setState - Player: ${_round.playerWins}, Opponent: ${_round.opponentWins}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerDeck = Deck.getDeckById(widget.tournament.playerDeckId);
    final opponentDeck = Deck.getDeckById(widget.opponentDeckId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        left: false,
        right: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // Zone de compteur split-screen
              Expanded(
                child: Column(
                  children: [
                    // Côté adversaire (haut)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              opponentDeck.colors[0].color,
                              opponentDeck.colors[1].color,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Image du deck en fond - à l'envers aussi
                            Positioned.fill(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationZ(3.14159), // 180 degrés
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    opponentDeck.imagePath,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Contenu par dessus - à l'envers pour l'adversaire
                            RotatedBox(
                              quarterTurns: 2,
                              child: Row(
                                children: [
                                  // Zone gauche cliquable (-)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _decrementOpponentScore,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            size: 48,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Score au centre
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        opponentDeck.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '$_opponentScore',
                                        style: const TextStyle(
                                          fontSize: 120,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Zone droite cliquable (+)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _incrementOpponentScore,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: const Center(
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            size: 48,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bandeau central avec fond blanc
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${opponentDeck.name} - ${_round.opponentWins}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _newMatch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Nouveau Match',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${playerDeck.name} - ${_round.playerWins}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Côté joueur (bas)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              playerDeck.colors[0].color,
                              playerDeck.colors[1].color,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Image du deck en fond
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.asset(
                                  playerDeck.imagePath,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                            // Contenu par dessus
                            Row(
                              children: [
                                // Zone gauche cliquable (-)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _decrementPlayerScore,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: const Center(
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Score au centre
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      playerDeck.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '$_playerScore',
                                      style: const TextStyle(
                                        fontSize: 120,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // Zone droite cliquable (+)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _incrementPlayerScore,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: const Center(
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
