import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/enums/cell_state.dart';
import '../../core/enums/game_state.dart';
import '../../core/enums/player_type.dart';
import '../../logic/win_detector.dart';
import '../../models/board_model.dart';
import '../../models/player_model.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, TicTacToeGameState> {
  final WinDetector _winDetector = WinDetector();

  GameBloc()
    : super(
        TicTacToeGameState.initial().copyWith(gameState: GameState.playing),
      ) {
    on<GameStarted>(_onGameStarted);
    on<CellTapped>(_onCellTapped);
    on<GameRestarted>(_onGameRestarted);
    on<ScoreReset>(_onScoreReset);
  }

  void _onGameStarted(GameStarted event, Emitter<TicTacToeGameState> emit) {
    emit(TicTacToeGameState.initial().copyWith(gameState: GameState.playing));
  }

  void _onCellTapped(CellTapped event, Emitter<TicTacToeGameState> emit) {
    // Ignore taps if game is not in playing state or cell already filled

    if (state.gameState != GameState.playing ||
        state.board.cells[event.index] != CellState.empty) {
      return;
    }

    // Update board with player's move
    final updatedBoard = BoardModel()..cells = List.from(state.board.cells);
    updatedBoard.cells[event.index] = state.currentPlayer == PlayerType.x
        ? CellState.x
        : CellState.o;

    // Check for win or draw
    final currentCellState = state.currentPlayer == PlayerType.x
        ? CellState.x
        : CellState.o;

    if (_winDetector.checkForWin(updatedBoard, currentCellState)) {
      // Handle win
      final winningLine = _winDetector.getWinningLine(updatedBoard);
      final updatedPlayerX = state.currentPlayer == PlayerType.x
          ? state.playerX.copyWith(score: state.playerX.score + 1)
          : state.playerX;
      final updatedPlayerO = state.currentPlayer == PlayerType.o
          ? state.playerO.copyWith(score: state.playerO.score + 1)
          : state.playerO;

      emit(
        state.copyWith(
          gameState: GameState.win,
          board: updatedBoard,
          playerX: updatedPlayerX,
          playerO: updatedPlayerO,
          winningLine: winningLine,
        ),
      );
    } else if (_winDetector.checkForDraw(updatedBoard)) {
      // Handle draw
      emit(state.copyWith(gameState: GameState.draw, board: updatedBoard));
    } else {
      // Continue game - switch player
      final nextPlayer = state.currentPlayer == PlayerType.x
          ? PlayerType.o
          : PlayerType.x;

      emit(state.copyWith(board: updatedBoard, currentPlayer: nextPlayer));
    }
  }

  void _onGameRestarted(GameRestarted event, Emitter<TicTacToeGameState> emit) {
    emit(
      state.copyWith(
        gameState: GameState.playing,
        board: BoardModel(),
        currentPlayer: PlayerType.x,
        clearWinningLine: true,
      ),
    );
  }

  void _onScoreReset(ScoreReset event, Emitter<TicTacToeGameState> emit) {
    emit(
      state.copyWith(
        playerX: state.playerX.copyWith(score: 0),
        playerO: state.playerO.copyWith(score: 0),
      ),
    );
  }
}
