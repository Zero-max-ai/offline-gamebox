// lib/widgets/game_card.dart
import 'package:flutter/material.dart';
import 'package:offline_gamebox/games/game_registery.dart';
import 'package:offline_gamebox/pages/settings.dart';

class GameCard extends StatelessWidget {
  final GameMeta game;
  const GameCard({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Settings()),
        // MaterialPageRoute(builder: (_) => game.builder()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 0.5, color: Colors.white24),
          image: DecorationImage(
            image: AssetImage('assets/images/${game.image}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              game.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
