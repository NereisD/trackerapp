import 'package:flutter/material.dart';
import 'package:mon_app/models/user_profile.dart';
import 'package:mon_app/models/tournament.dart';
import 'package:mon_app/services/auth_service.dart';
import 'package:mon_app/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  List<Tournament> _tournaments = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = _authService.currentUser;
    if (user != null) {
      // Charger les tournois pour calculer les stats
      _firestoreService.getTournaments(user.uid).listen((tournaments) {
        setState(() {
          _tournaments = tournaments;
        });
      });

      final profile = await _firestoreService.getUserProfile(user.uid);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile.displayName;
          _isLoading = false;
        });
      } else {
        // Créer un nouveau profil
        final newProfile = UserProfile(
          uid: user.uid,
          displayName: user.displayName ?? 'Joueur',
          photoUrl: user.photoURL,
        );
        await _firestoreService.updateUserProfile(newProfile);
        setState(() {
          _userProfile = newProfile;
          _nameController.text = newProfile.displayName;
          _isLoading = false;
        });
      }
    }
  }

  GameStats _calculateStatsFromTournaments() {
    final stats = GameStats();
    final championStats = <String, ChampionStats>{};

    for (final tournament in _tournaments) {
      final championName = tournament.playerDeckId;

      // Pour chaque round (BO3), compter qui a gagné
      for (final round in tournament.rounds) {
        final roundWon = round.playerWins > round.opponentWins;

        // Stats globales
        stats.totalGames += 1;
        if (roundWon) {
          stats.wins += 1;
        } else {
          stats.losses += 1;
        }

        // Stats par champion
        if (!championStats.containsKey(championName)) {
          championStats[championName] = ChampionStats();
        }
        championStats[championName]!.gamesPlayed += 1;
        if (roundWon) {
          championStats[championName]!.wins += 1;
        } else {
          championStats[championName]!.losses += 1;
        }
      }
    }

    stats.championStats.addAll(championStats);
    return stats;
  }

  Future<void> _saveProfile() async {
    if (_userProfile != null) {
      final updatedProfile = _userProfile!.copyWith(
        displayName: _nameController.text,
      );
      await _firestoreService.updateUserProfile(updatedProfile);
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profil mis à jour')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userProfile == null) {
      return const Scaffold(
        body: Center(child: Text('Erreur de chargement du profil')),
      );
    }

    return Scaffold(
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
          child: Column(
            children: [
              // Bouton de déconnexion
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => _authService.signOut(),
                      tooltip: 'Déconnexion',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Header avec image de profil
                      _buildProfileHeader(),
                      const SizedBox(height: 32),

                      // Stats des TCG avec Top Champions intégré
                      _buildTCGStats(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Photo de profil
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage:
                  _userProfile?.photoUrl != null
                      ? NetworkImage(_userProfile!.photoUrl!)
                      : null,
              child:
                  _userProfile?.photoUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    // TODO: Implémenter le changement de photo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fonction à venir')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Nom (éditable)
        if (_isEditing)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: _saveProfile,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _nameController.text = _userProfile!.displayName;
                  });
                },
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userProfile!.displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  setState(() => _isEditing = true);
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTCGStats() {
    // Calculer les stats depuis l'historique
    final riftboundStats = _calculateStatsFromTournaments();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_esports,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Riftbound',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTCGCard('Riftbound', riftboundStats),
          ],
        ),
      ),
    );
  }

  Widget _buildTCGCard(String tcgName, GameStats stats) {
    final topChampions = stats.topChampions;

    return Column(
      children: [
        // Carte principale avec les stats globales
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
                Theme.of(context).colorScheme.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistiques globales',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Parties', stats.totalGames.toString()),
                  _buildStatItem('Victoires', stats.wins.toString()),
                  _buildStatItem('Défaites', stats.losses.toString()),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Winrate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${stats.winRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stats.winRate / 100,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Top 3 Champions - Podium
        if (topChampions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.amber[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Top 3 Champions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPodium(topChampions),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildPodium(List<MapEntry<String, ChampionStats>> topChampions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2ème place (à gauche)
        if (topChampions.length > 1)
          Expanded(
            child: _buildPodiumItem(
              rank: 2,
              championName: topChampions[1].key,
              stats: topChampions[1].value,
              size: 90,
              color: Colors.grey[400]!,
            ),
          ),
        const SizedBox(width: 8),

        // 1ère place (au milieu, plus grand)
        if (topChampions.isNotEmpty)
          Expanded(
            child: _buildPodiumItem(
              rank: 1,
              championName: topChampions[0].key,
              stats: topChampions[0].value,
              size: 110,
              color: Colors.amber,
            ),
          ),
        const SizedBox(width: 8),

        // 3ème place (à droite)
        if (topChampions.length > 2)
          Expanded(
            child: _buildPodiumItem(
              rank: 3,
              championName: topChampions[2].key,
              stats: topChampions[2].value,
              size: 80,
              color: Colors.brown[300]!,
            ),
          ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required int rank,
    required String championName,
    required ChampionStats stats,
    required double size,
    required Color color,
  }) {
    return Column(
      children: [
        // Bulle avec le champion
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Numéro de rang
              Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size * 0.05),
              // Nom du champion
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size * 0.1),
                child: Text(
                  championName,
                  style: TextStyle(
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Stats en dessous
        Text(
          '${stats.gamesPlayed} parties',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${stats.winRate.toStringAsFixed(1)}% WR',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: stats.winRate >= 50 ? Colors.green[700] : Colors.red[700],
          ),
        ),
      ],
    );
  }
}
