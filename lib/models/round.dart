import 'package:mon_app/models/match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Round {
  final String id;
  final String opponentDeckId;
  final List<Match> matches;
  final DateTime timestamp;
  final int playerWins;
  final int opponentWins;
  final bool isCompleted;

  Round({
    required this.id,
    required this.opponentDeckId,
    required this.matches,
    required this.timestamp,
    required this.playerWins,
    required this.opponentWins,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'opponentDeckId': opponentDeckId,
      'matches': matches.map((m) => m.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
      'playerWins': playerWins,
      'opponentWins': opponentWins,
      'isCompleted': isCompleted,
    };
  }

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      opponentDeckId: json['opponentDeckId'],
      matches: (json['matches'] as List)
          .map((m) => Match.fromJson(m))
          .toList(),
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.parse(json['timestamp']),
      playerWins: json['playerWins'],
      opponentWins: json['opponentWins'],
      isCompleted: json['isCompleted'],
    );
  }

  Round copyWith({
    String? id,
    String? opponentDeckId,
    List<Match>? matches,
    DateTime? timestamp,
    int? playerWins,
    int? opponentWins,
    bool? isCompleted,
  }) {
    return Round(
      id: id ?? this.id,
      opponentDeckId: opponentDeckId ?? this.opponentDeckId,
      matches: matches ?? this.matches,
      timestamp: timestamp ?? this.timestamp,
      playerWins: playerWins ?? this.playerWins,
      opponentWins: opponentWins ?? this.opponentWins,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
