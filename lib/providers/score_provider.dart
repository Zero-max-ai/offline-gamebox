import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_gamebox/providers/shared_preferences_provider.dart';

String _key(String gameId, String difficulty) => 'score_${gameId}_$difficulty';

class GameScores {
  final int easyBest;
  final int mediumBest;
  final int hardBest;

  const GameScores({
    this.easyBest = 0,
    this.mediumBest = 0,
    this.hardBest = 0,
  });

  int bestFor(String difficulty) => switch (difficulty) {
        'easy' => easyBest,
        'medium' => mediumBest,
        'hard' => hardBest,
        _ => 0,
      };

  GameScores copyWithBest(String difficulty, int score) => switch (difficulty) {
        'easy' => GameScores(
            easyBest: score,
            mediumBest: mediumBest,
            hardBest: hardBest,
          ),
        'medium' => GameScores(
            easyBest: easyBest,
            mediumBest: score,
            hardBest: hardBest,
          ),
        'hard' => GameScores(
            easyBest: easyBest,
            mediumBest: mediumBest,
            hardBest: score,
          ),
        _ => this,
      };
}

class ScoreNotifier extends Notifier<GameScores> {
  final String gameId;
  ScoreNotifier(this.gameId);

  @override
  GameScores build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return GameScores(
      easyBest: prefs.getInt(_key(gameId, 'easy')) ?? 0,
      mediumBest: prefs.getInt(_key(gameId, 'medium')) ?? 0,
      hardBest: prefs.getInt(_key(gameId, 'hard')) ?? 0,
    );
  }

  void updateBest(String difficulty, int score) {
    final current = state.bestFor(difficulty);
    if (score <= current) return;
    state = state.copyWithBest(difficulty, score);
    ref
        .read(sharedPreferencesProvider)
        .setInt(_key(gameId, difficulty), score);
  }
}

// ─── Game providers — add one line per game when you build new ones ───────────
final twentyFortyEightScoreProvider =
    NotifierProvider<ScoreNotifier, GameScores>(
  () => ScoreNotifier('2048'),
);

// final snakeScoreProvider = NotifierProvider<ScoreNotifier, GameScores>(
//   () => ScoreNotifier('snake'),
// );

// final sudokuScoreProvider = NotifierProvider<ScoreNotifier, GameScores>(
//   () => ScoreNotifier('sudoku'),
// );