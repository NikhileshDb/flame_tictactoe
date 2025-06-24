import 'package:bakku/tic_tac_toe/blocs/bloc_exports.dart';
import 'package:bakku/tic_tac_toe/ui/widgets/chance_left_indicator.dart';
import 'package:bakku/tic_tac_toe/ui/widgets/player_avatar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/game_blocs/game_bloc.dart';

import '../../core/enums/game_state.dart' as game_state_enum;
import '../../core/enums/player_type.dart';

import '../../tic_tac_toe_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TicTacToeGame _game;

  @override
  void initState() {
    super.initState();
    final gameBloc = context.read<GameBloc>();
    _game = TicTacToeGame(
      board: gameBloc.state.board,
      gameBloc: gameBloc,
      winningLine: gameBloc.state.winningLine,
    );

    // context.read<MatchMakingBloc>().socket?.onMatchData.listen((data) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1D27),

      body: BlocConsumer<GameBloc, TicTacToeGameState>(
        listenWhen: (previous, current) =>
            previous.gameState != current.gameState ||
            previous.board != current.board ||
            previous.winningLine != current.winningLine,
        listener: (context, state) {
          // Update the game board when state changes
          _game.updateBoard(state.board, state.winningLine);

          if (state.gameState == game_state_enum.GameState.win) {
            _showGameResultDialog(
              context,
              '${state.currentPlayer == PlayerType.x ? "X" : "O"} Wins!',
            );
          } else if (state.gameState == game_state_enum.GameState.draw) {
            _showGameResultDialog(context, 'Draw!');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
                // Header Section Row for Analytics and Time Left and Kebab Menu
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/analytic_icon.svg",
                      semanticsLabel: 'Analyic Icon',
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '02:43',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Time Left',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/svgs/kebab.svg",
                      semanticsLabel: 'Kebab Icon',
                    ),
                  ],
                ),
              ),
              // Players and Status Section
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChanceLeftIndicator(),
                        SizedBox(width: 24),
                        PlayerAvatar(
                          playerType: PlayerType.o,
                          isOppenent: false,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChanceLeftIndicator(),
                        SizedBox(width: 24),
                        PlayerAvatar(
                          playerType: PlayerType.x,
                          isOppenent: true,
                        ),
                      ].reversed.toList(),
                    ),
                  ],
                ),
              ),
              Center(child: Text("00:20", style: TextStyle(height: .1))),

              // Game board
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: GameWidget<TicTacToeGame>.controlled(
                      gameFactory: () => _game,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showGameResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(
          message,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<GameBloc>().add(GameRestarted());
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
