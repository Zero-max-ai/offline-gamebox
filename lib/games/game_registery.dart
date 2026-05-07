import 'package:offline_gamebox/games/game_model.dart';
import 'package:offline_gamebox/games/snake/snake.dart';
import 'package:offline_gamebox/games/twenty48/twenty48.dart';

final List<GameMeta> gameRegistry = [
  GameMeta(
    id: '2048',
    title: '2048',
    assetImage: '2048-game.jpg',
    description:
        'Slide and merge matching numbers to reach 2048 before the grid fills up.',
    builder: (config) => Twenty48(config: config),
  ),
  // GameMeta(
  //   id: 'sliding_puzzle',
  //   title: 'Sliding Puzzle',
  //   description: '',
  //   assetImage: '2048-game.jpg',
  //   // builder: SlidingPuzzle.new,
  // ),
  // GameMeta(
  //   id: 'snake',
  //   title: 'Snake',
  //   assetImage: '2048-game.jpg',
  //   description: '',
  //   builder: (config) => Snake(config: config),
  // ),
  // GameMeta(
  //   id: 'sudoku',
  //   title: 'Sudoku',
  //   assetImage: '2048-game.jpg',
  //   description: '',
  //   // builder: Sudoku.new,
  // ),
];
