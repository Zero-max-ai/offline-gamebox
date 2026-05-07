import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

class GameConfig {
  final Difficulty difficulty;
  const GameConfig({this.difficulty = Difficulty.medium});
}

class GameMeta {
  final String id;
  final String title;
  final String description;
  final String assetImage;
  final Widget Function(GameConfig config) builder;

  const GameMeta({
    required this.id,
    required this.title,
    required this.description,
    required this.assetImage,
    required this.builder,
  });
}
