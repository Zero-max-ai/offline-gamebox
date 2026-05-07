import 'package:flutter/material.dart';
import 'package:offline_gamebox/games/game_model.dart';

class Snake extends StatefulWidget {
  final GameConfig config;
  const Snake({super.key, required this.config});

  @override
  State<Snake> createState() => _Snake();
}

class _Snake extends State<Snake> {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}