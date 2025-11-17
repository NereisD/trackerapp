import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id;
  final int playerScore;
  final int opponentScore;
  final String? winnerId; // 'player' ou 'opponent'
  final bool playerStarted; // Qui a commencé
  final DateTime timestamp;

  Match({
    required this.id,
    required this.playerScore,
    required this.opponentScore,
    this.winnerId,
    required this.playerStarted,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerScore': playerScore,
      'opponentScore': opponentScore,
      'winnerId': winnerId,
      'playerStarted': playerStarted,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      playerScore: json['playerScore'],
      opponentScore: json['opponentScore'],
      winnerId: json['winnerId'],
      playerStarted: json['playerStarted'],
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.parse(json['timestamp']),
    );
  }

  Match copyWith({
    String? id,
    int? playerScore,
    int? opponentScore,
    String? winnerId,
    bool? playerStarted,
    DateTime? timestamp,
  }) {
    return Match(
      id: id ?? this.id,
      playerScore: playerScore ?? this.playerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      winnerId: winnerId ?? this.winnerId,
      playerStarted: playerStarted ?? this.playerStarted,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
