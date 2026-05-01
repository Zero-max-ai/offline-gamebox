import 'package:flutter/material.dart';

class GameMeta {
  final String id;
  final String title;
  final String image;
  // final Widget Function() builder;

  const GameMeta({
    required this.id,
    required this.title,
    required this.image,
    // required this.builder,
  });
}

const List<GameMeta> gameRegistry = [
  GameMeta(
    id: 'snake',
    title: 'Snake',
    image: '2048-game.jpg',
    // builder: SnakeGame.new,
  ),
  GameMeta(
    id: '2048',
    title: '2048',
    image: '2048-game.jpg',
    // builder: NumberGame.new,
  ),
];
