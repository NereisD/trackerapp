import 'package:flutter/material.dart';

enum DeckColor {
  yellow(Colors.yellow, 'Order'),
  blue(Colors.blue, 'Mind'),
  red(Colors.red, 'Fury'),
  purple(Colors.purple, 'Chaos'),
  green(Colors.green, 'Calm'),
  orange(Colors.orange, 'Body');

  final Color color;
  final String label;

  const DeckColor(this.color, this.label);
}

extension DeckColorAssets on DeckColor {
  String get runeImagePath {
    switch (this) {
      case DeckColor.yellow:
        return 'assets/images/runes/Order.webp';
      case DeckColor.blue:
        return 'assets/images/runes/Mind.webp';
      case DeckColor.red:
        return 'assets/images/runes/Fury.webp';
      case DeckColor.purple:
        return 'assets/images/runes/Chaos.webp';
      case DeckColor.green:
        return 'assets/images/runes/Calm.webp';
      case DeckColor.orange:
        return 'assets/images/runes/Body.webp';
    }
  }
}

class Deck {
  final String id;
  final String name;
  final String imagePath;
  final List<DeckColor> colors;

  Deck({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.colors,
  });

  // Les 12 decks de Riftbound
  static final List<Deck> allDecks = [
    Deck(
      id: 'Ahri',
      name: 'Ahri',
      imagePath: 'assets/images/decks/Ahri.webp',
      colors: [DeckColor.green, DeckColor.blue],
    ),
    Deck(
      id: 'Annie',
      name: 'Annie',
      imagePath: 'assets/images/decks/Annie.webp',
      colors: [DeckColor.red, DeckColor.purple],
    ),
    // Azir - commentaire temporaire
    /*
    Deck(
      id: 'Azir',
      name: 'Azir',
      imagePath: 'assets/images/decks/Azir.webp',
      colors: [DeckColor.green, DeckColor.yellow],
    ),
    */
    Deck(
      id: 'Darius',
      name: 'Darius',
      imagePath: 'assets/images/decks/Darius.webp',
      colors: [DeckColor.red, DeckColor.yellow],
    ),

    /*
    Deck(
      id: 'Draven',
      name: 'Draven',
      imagePath: 'assets/images/decks/Draven.webp',
      colors: [DeckColor.red, DeckColor.purple],
    ),
    */
    Deck(
      id: 'Garen',
      name: 'Garen',
      imagePath: 'assets/images/decks/Garen.webp',
      colors: [DeckColor.orange, DeckColor.yellow],
    ),
    /*
    Deck(
      id: 'Irelia',
      name: 'Irelia',
      imagePath: 'assets/images/decks/Irelia.webp',
      colors: [DeckColor.green, DeckColor.purple],
    ),
    */
    Deck(
      id: 'Jinx',
      name: 'Jinx',
      imagePath: 'assets/images/decks/Jinx.webp',
      colors: [DeckColor.red, DeckColor.purple],
    ),
    Deck(
      id: 'KaiSa',
      name: 'KaiSa',
      imagePath: 'assets/images/decks/KaiSa.webp',
      colors: [DeckColor.red, DeckColor.blue],
    ),
    Deck(
      id: 'Lee Sin',
      name: 'Lee Sin',
      imagePath: 'assets/images/decks/Lee Sin.webp',
      colors: [DeckColor.green, DeckColor.orange],
    ),
    Deck(
      id: 'Leona',
      name: 'Leona',
      imagePath: 'assets/images/decks/Leona.webp',
      colors: [DeckColor.green, DeckColor.yellow],
    ),
    Deck(
      id: 'Lux',
      name: 'Lux',
      imagePath: 'assets/images/decks/Lux.webp',
      colors: [DeckColor.blue, DeckColor.yellow],
    ),
    Deck(
      id: 'MasterYi',
      name: 'MasterYi',
      imagePath: 'assets/images/decks/MasterYi.webp',
      colors: [DeckColor.green, DeckColor.orange],
    ),
    Deck(
      id: 'Sett',
      name: 'Sett',
      imagePath: 'assets/images/decks/Sett.webp',
      colors: [DeckColor.orange, DeckColor.yellow],
    ),
    /*
    Deck(
      id: 'Sivir',
      name: 'Sivir',
      imagePath: 'assets/images/decks/Sivir.webp',
      colors: [DeckColor.orange, DeckColor.purple],
    ),
    */
    Deck(
      id: 'Teemo',
      name: 'Teemo',
      imagePath: 'assets/images/decks/Teemo.webp',
      colors: [DeckColor.blue, DeckColor.purple],
    ),
    Deck(
      id: 'Viktor',
      name: 'Viktor',
      imagePath: 'assets/images/decks/Viktor.webp',
      colors: [DeckColor.blue, DeckColor.yellow],
    ),
    Deck(
      id: 'Volibear',
      name: 'Volibear',
      imagePath: 'assets/images/decks/Volibear.webp',
      colors: [DeckColor.red, DeckColor.orange],
    ),
    Deck(
      id: 'Yasuo',
      name: 'Yasuo',
      imagePath: 'assets/images/decks/Yasuo.webp',
      colors: [DeckColor.green, DeckColor.purple],
    ),
    /*
    Deck(
      id: 'Renata',
      name: 'Renata',
      imagePath: 'assets/images/decks/Renata.webp',
      colors: [DeckColor.blue, DeckColor.yellow],
    ),
    */
  ];

  static Deck getDeckById(String id) {
    return allDecks.firstWhere((deck) => deck.id == id);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'colors': colors.map((c) => c.name).toList(),
    };
  }

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      colors:
          (json['colors'] as List)
              .map(
                (colorName) =>
                    DeckColor.values.firstWhere((c) => c.name == colorName),
              )
              .toList(),
    );
  }
}
