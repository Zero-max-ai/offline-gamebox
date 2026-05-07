import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_gamebox/games/game_model.dart';
import 'package:offline_gamebox/providers/score_provider.dart';

class Twenty48 extends ConsumerStatefulWidget {
  final GameConfig config;
  const Twenty48({super.key, required this.config});

  @override
  ConsumerState<Twenty48> createState() => _Twenty48State();
}

class _Twenty48State extends ConsumerState<Twenty48> {
  late int size;
  late double _fourSpawnChance;
  late int _targetTile;
  late List<List<int>> grid;

  int _score = 0;
  bool _hasStarted = false;
  bool _hasWonAlready = false;
  Offset _dragDelta = Offset.zero;

  String get _difficultyKey => widget.config.difficulty.name;

  @override
  void initState() {
    super.initState();
    _applyDifficulty();
    resetGame();
  }

  void _applyDifficulty() {
    switch (widget.config.difficulty) {
      case Difficulty.easy:
        size = 4;
        _fourSpawnChance = 0.05;
        _targetTile = 1024;
        break;
      case Difficulty.medium:
        size = 4;
        _fourSpawnChance = 0.10;
        _targetTile = 2048;
        break;
      case Difficulty.hard:
        size = 5;
        _fourSpawnChance = 0.20;
        _targetTile = 2048;
        break;
    }
  }

  void resetGame() {
    _hasWonAlready = false;
    _hasStarted = false;
    grid = List.generate(size, (_) => List.generate(size, (_) => 0));
    _score = 0;
    addRandomTile();
    addRandomTile();
    setState(() {});
  }

  void addRandomTile() {
    List<List<int>> empty = [];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j] == 0) empty.add([i, j]);
      }
    }
    if (empty.isEmpty) return;
    final rand = empty[Random().nextInt(empty.length)];
    grid[rand[0]][rand[1]] = Random().nextDouble() < _fourSpawnChance ? 4 : 2;
  }

  (List<int>, int) mergeLine(List<int> line) {
    List<int> result = line.where((e) => e != 0).toList();
    int earned = 0;

    for (int i = 0; i < result.length - 1; i++) {
      if (result[i] == result[i + 1]) {
        result[i] *= 2;
        earned += result[i];
        result[i + 1] = 0;
        i++;
      }
    }

    result.removeWhere((e) => e == 0);
    while (result.length < size) {
      result.add(0);
    }

    return (result, earned);
  }

  bool moveLeft() {
    bool changed = false;
    for (int i = 0; i < size; i++) {
      final (merged, earned) = mergeLine(grid[i]);
      if (!listEquals(merged, grid[i])) changed = true;
      grid[i] = merged;
      _score += earned;
    }
    return changed;
  }

  bool moveRight() {
    bool changed = false;
    for (int i = 0; i < size; i++) {
      final (merged, earned) = mergeLine(grid[i].reversed.toList());
      final result = merged.reversed.toList();
      if (!listEquals(result, grid[i])) changed = true;
      grid[i] = result;
      _score += earned;
    }
    return changed;
  }

  bool moveUp() {
    bool changed = false;
    for (int col = 0; col < size; col++) {
      List<int> column = List.generate(size, (row) => grid[row][col]);
      final (merged, earned) = mergeLine(column);
      if (!listEquals(merged, column)) changed = true;
      for (int row = 0; row < size; row++) {
        grid[row][col] = merged[row];
      }
      _score += earned;
    }
    return changed;
  }

  bool moveDown() {
    bool changed = false;
    for (int col = 0; col < size; col++) {
      List<int> column = List.generate(size, (row) => grid[row][col]);
      final (merged, earned) = mergeLine(column.reversed.toList());
      final result = merged.reversed.toList();
      if (!listEquals(result, column)) changed = true;
      for (int row = 0; row < size; row++) {
        grid[row][col] = result[row];
      }
      _score += earned;
    }
    return changed;
  }

  bool _canMove() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j] == 0) return true;
        if (j + 1 < size && grid[i][j] == grid[i][j + 1]) return true;
        if (i + 1 < size && grid[i][j] == grid[i + 1][j]) return true;
      }
    }
    return false;
  }

  bool _hasWon() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j] >= _targetTile) return true;
      }
    }
    return false;
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  void _showYouWon() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: Text('You reached $_targetTile!\nScore: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Going'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  String get _difficultyLabel {
    switch (widget.config.difficulty) {
      case Difficulty.easy:
        return 'EASY';
      case Difficulty.medium:
        return 'MEDIUM';
      case Difficulty.hard:
        return 'HARD';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestScore = ref
        .watch(twentyFortyEightScoreProvider)
        .bestFor(_difficultyKey);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) => _dragDelta = Offset.zero,
      onPanUpdate: (d) => _dragDelta += d.delta,
      onPanEnd: (_) {
        const minSwipe = 20.0;
        bool changed = false;

        if (_dragDelta.dx.abs() > _dragDelta.dy.abs()) {
          if (_dragDelta.dx > minSwipe) {
            changed = moveRight();
          } else if (_dragDelta.dx < -minSwipe) {
            changed = moveLeft();
          }
        } else {
          if (_dragDelta.dy > minSwipe) {
            changed = moveDown();
          } else if (_dragDelta.dy < -minSwipe) {
            changed = moveUp();
          }
        }

        if (changed) {
          _hasStarted = true;
          ref
              .read(twentyFortyEightScoreProvider.notifier)
              .updateBest(_difficultyKey, _score);
          addRandomTile();
          setState(() {});
          if (_hasWon() && !_hasWonAlready) {
            _hasWonAlready = true;
            _showYouWon();
          } else if (!_canMove()) {
            _showGameOver();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 5),
            child: Column(
              children: [
                CustomAppBar(onRestart: resetGame, hasStarted: _hasStarted),
                const SizedBox(height: 10),
                Scores(
                  score: _score,
                  bestScore: bestScore,
                  difficultyLabel: _difficultyLabel,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1C1C1E)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: List.generate(size, (i) {
                            return Expanded(
                              child: Row(
                                children: List.generate(size, (j) {
                                  return Expanded(
                                    child: buildTile(grid[i][j], size, context),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final VoidCallback onRestart;
  final bool hasStarted;
  const CustomAppBar({
    super.key,
    required this.onRestart,
    required this.hasStarted,
  });

  void _handleRestart(BuildContext context) {
    if (!hasStarted) {
      onRestart();
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Restart Game"),
          content: const Text("Do you want to start a new game or continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRestart();
              },
              child: const Text('New'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          icon: const Icon(Icons.arrow_back),
        ),
        IconButton(
          onPressed: () => _handleRestart(context),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

class Scores extends StatelessWidget {
  final int score;
  final int bestScore;
  final String difficultyLabel;

  const Scores({
    super.key,
    required this.score,
    required this.bestScore,
    required this.difficultyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ScoreBox(label: '$difficultyLabel MODE', value: score),
        const SizedBox(width: 12),
        _ScoreBox(label: 'BEST', value: bestScore),
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int value;

  const _ScoreBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTile(int value, int size, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final double fontSize = size == 5 ? 16 : 22;

  Color getColor() {
    if (isDark) {
      switch (value) {
        case 0:
          return const Color(0xFF2C2C2E);
        case 2:
          return const Color(0xFF4A3728);
        case 4:
          return const Color(0xFF5C3D1E);
        case 8:
          return const Color(0xFF7C4A1E);
        case 16:
          return const Color(0xFF9C5A1E);
        case 32:
          return const Color(0xFFB06020);
        case 64:
          return const Color(0xFFC47020);
        case 128:
          return const Color(0xFFD4522A);
        case 256:
          return const Color(0xFFE04030);
        case 512:
          return const Color(0xFFE83030);
        case 1024:
          return const Color(0xFFF02020);
        case 2048:
          return const Color(0xFFFF1010);
        default:
          return const Color(0xFFFF0000);
      }
    } else {
      switch (value) {
        case 0:
          return Colors.grey.shade300;
        case 2:
          return Colors.orange.shade100;
        case 4:
          return Colors.orange.shade200;
        case 8:
          return Colors.orange.shade300;
        case 16:
          return Colors.orange.shade400;
        case 32:
          return Colors.orange.shade500;
        case 64:
          return Colors.orange.shade600;
        case 128:
          return Colors.deepOrange.shade300;
        case 256:
          return Colors.deepOrange.shade400;
        case 512:
          return Colors.deepOrange.shade500;
        case 1024:
          return Colors.deepOrange.shade600;
        case 2048:
          return Colors.deepOrange.shade700;
        default:
          return Colors.orange.shade700;
      }
    }
  }

  return Container(
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: getColor(),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: value == 0
          ? const SizedBox()
          : Text(
              '$value',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
    ),
  );
}
