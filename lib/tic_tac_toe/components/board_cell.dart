import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import '../core/enums/cell_state.dart';
import '../blocs/bloc_exports.dart';
import '../tic_tac_toe_game.dart';

class BoardCell extends PositionComponent
    with
        TapCallbacks,
        HasGameReference<TicTacToeGame>,
        FlameBlocReader<GameBloc, TicTacToeGameState> {
  final int index;
  CellState cellState;
  bool isWinningCell;

  BoardCell({
    required this.index,
    required this.cellState,
    required Vector2 position,
    required Vector2 size,
    this.isWinningCell = false,
  }) : super(position: position, size: size);

  @override
  bool onTapDown(TapDownEvent event) {
    // Only handle tap if cell is empty
    if (cellState == CellState.empty) {
      bloc.add(CellTapped(index));

      return true; // Consume the event
    }
    return false; // Don't consume if cell is occupied
  }

  void updateState(CellState newState, bool newIsWinningCell) {
    cellState = newState;
    isWinningCell = newIsWinningCell;
  }

  @override
  void render(Canvas canvas) {
    // Draw cell background
    final bgPaint = Paint()
      ..color = isWinningCell
          ? Colors.green.withValues(alpha: 0.3)
          : Colors.blue.withValues(alpha: 0.1);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(20),
      ),
      bgPaint,
    );

    // Draw X or O
    final padding = size.x * 0.24;

    switch (cellState) {
      case CellState.x:
        final paint = Paint()
          ..color = isWinningCell ? Colors.green : Colors.white
          ..strokeWidth = 20
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(padding, padding),
          Offset(size.x - padding, size.y - padding),
          paint,
        );

        canvas.drawLine(
          Offset(size.x - padding, padding),
          Offset(padding, size.y - padding),
          paint,
        );
        break;

      case CellState.o:
        final paint = Paint()
          ..color = isWinningCell ? Colors.green : Colors.white
          ..strokeWidth = 20
          ..style = PaintingStyle.stroke;

        canvas.drawCircle(
          Offset(size.x / 2, size.y / 2),
          size.x / 2 - padding,
          paint,
        );
        break;

      case CellState.empty:
        // Draw nothing for empty cells
        break;
    }
  }
}
