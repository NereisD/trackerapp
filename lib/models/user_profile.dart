class UserProfile {
  final String uid;
  String displayName;
  String? photoUrl;
  final Map<String, GameStats> gameStats; // TCG -> Stats
  final DateTime createdAt;
  DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    Map<String, GameStats>? gameStats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : gameStats = gameStats ?? {'Riftbound': GameStats()},
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'gameStats': gameStats.map((key, value) => MapEntry(key, value.toJson())),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      gameStats:
          (json['gameStats'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, GameStats.fromJson(value)),
          ) ??
          {'Riftbound': GameStats()},
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    Map<String, GameStats>? gameStats,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      gameStats: gameStats ?? this.gameStats,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class GameStats {
  int totalGames;
  int wins;
  int losses;
  Map<String, ChampionStats> championStats; // ChampionName -> Stats

  GameStats({
    this.totalGames = 0,
    this.wins = 0,
    this.losses = 0,
    Map<String, ChampionStats>? championStats,
  }) : championStats = championStats ?? {};

  double get winRate {
    if (totalGames == 0) return 0.0;
    return (wins / totalGames) * 100;
  }

  List<MapEntry<String, ChampionStats>> get topChampions {
    final entries = championStats.entries.toList();
    entries.sort((a, b) => b.value.gamesPlayed.compareTo(a.value.gamesPlayed));
    return entries.take(5).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGames': totalGames,
      'wins': wins,
      'losses': losses,
      'championStats': championStats.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalGames: json['totalGames'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      championStats:
          (json['championStats'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, ChampionStats.fromJson(value)),
          ) ??
          {},
    );
  }
}

class ChampionStats {
  int gamesPlayed;
  int wins;
  int losses;

  ChampionStats({this.gamesPlayed = 0, this.wins = 0, this.losses = 0});

  double get winRate {
    if (gamesPlayed == 0) return 0.0;
    return (wins / gamesPlayed) * 100;
  }

  Map<String, dynamic> toJson() {
    return {'gamesPlayed': gamesPlayed, 'wins': wins, 'losses': losses};
  }

  factory ChampionStats.fromJson(Map<String, dynamic> json) {
    return ChampionStats(
      gamesPlayed: json['gamesPlayed'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
    );
  }
}
