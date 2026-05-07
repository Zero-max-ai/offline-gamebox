import 'package:flutter/material.dart';
import 'package:offline_gamebox/games/game_model.dart';

class GameLaunchPanel extends StatefulWidget {
  final GameMeta game;
  const GameLaunchPanel({required this.game, super.key});

  @override
  State<GameLaunchPanel> createState() => _GameLaunchPanelState();
}

class _GameLaunchPanelState extends State<GameLaunchPanel> {
  Difficulty _difficulty = Difficulty.medium;

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('How to Play'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleItem(
              icon: Icons.swipe_rounded,
              text: 'Swipe in any direction to move all tiles',
            ),
            SizedBox(height: 12),
            _RuleItem(
              icon: Icons.merge_rounded,
              text: 'Tiles with the same number merge into one',
            ),
            SizedBox(height: 12),
            _RuleItem(
              icon: Icons.emoji_events_rounded,
              text: 'Reach the target tile to win',
            ),
            SizedBox(height: 12),
            _RuleItem(
              icon: Icons.block_rounded,
              text: 'Game ends when no moves are left',
            ),
            SizedBox(height: 12),
            _RuleItem(
              icon: Icons.star_rounded,
              text: 'Higher difficulty = bigger grid & harder tiles',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onHowToPlay: () => _showHowToPlay(context)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Game title
                    Text(
                      widget.game.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      widget.game.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Difficulty label
                    Text(
                      'Difficulty',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Difficulty selector
                    _DifficultySelector(
                      selected: _difficulty,
                      onChanged: (d) => setState(() => _difficulty = d),
                    ),
                    const SizedBox(height: 16),
                    // Difficulty description
                    _DifficultyDescription(difficulty: _difficulty),
                    const SizedBox(height: 48),
                    // Play button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => widget.game.builder(
                              GameConfig(difficulty: _difficulty),
                            ),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App Bar ─────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onHowToPlay;
  const _AppBar({required this.onHowToPlay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          IconButton(
            onPressed: onHowToPlay,
            icon: const Icon(Icons.question_mark_rounded),
          ),
        ],
      ),
    );
  }
}

// ─── Difficulty Selector (replaces the slider) ────────────────────────────────
class _DifficultySelector extends StatelessWidget {
  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;

  const _DifficultySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Difficulty.values.map((d) {
        final isSelected = d == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onChanged(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _difficultyColor(d)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    d.name[0].toUpperCase() + d.name.substring(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _difficultyColor(Difficulty d) => switch (d) {
        Difficulty.easy => Colors.green.shade500,
        Difficulty.medium => Colors.orange.shade500,
        Difficulty.hard => Colors.red.shade500,
      };
}

// ─── Difficulty Description ───────────────────────────────────────────────────
class _DifficultyDescription extends StatelessWidget {
  final Difficulty difficulty;
  const _DifficultyDescription({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (label, desc) = switch (difficulty) {
      Difficulty.easy => ('Easy', '4×4 grid · Target 1024 · Fewer 4-tiles'),
      Difficulty.medium => ('Medium', '4×4 grid · Target 2048 · Standard'),
      Difficulty.hard => ('Hard', '5×5 grid · Target 2048 · More 4-tiles'),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(desc,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ─── Rule Item ────────────────────────────────────────────────────────────────
class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20,
            color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}