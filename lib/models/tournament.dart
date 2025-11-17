import 'package:mon_app/models/round.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String id;
  final String name;
  final String playerDeckId;
  final List<Round> rounds;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;

  Tournament({
    required this.id,
    required this.name,
    required this.playerDeckId,
    required this.rounds,
    required this.createdAt,
    this.completedAt,
    required this.isCompleted,
  });

  int get totalWins => rounds.fold(0, (sum, round) => sum + round.playerWins);
  int get totalLosses => rounds.fold(0, (sum, round) => sum + round.opponentWins);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'playerDeckId': playerDeckId,
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      playerDeckId: json['playerDeckId'],
      rounds: (json['rounds'] as List)
          .map((r) => Round.fromJson(r))
          .toList(),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] is Timestamp
              ? (json['completedAt'] as Timestamp).toDate()
              : DateTime.parse(json['completedAt']))
          : null,
      isCompleted: json['isCompleted'],
    );
  }

  Tournament copyWith({
    String? id,
    String? name,
    String? playerDeckId,
    List<Round>? rounds,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      playerDeckId: playerDeckId ?? this.playerDeckId,
      rounds: rounds ?? this.rounds,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
