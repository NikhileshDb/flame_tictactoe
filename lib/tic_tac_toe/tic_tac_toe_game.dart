import 'package:bakku/tic_tac_toe/blocs/bloc_exports.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

import 'models/board_model.dart';
import 'core/constants/game_constants.dart';
import 'components/board_cell.dart';

class TicTacToeGame extends FlameGame {
  BoardModel board;
  List<int>? winningLine;
  final GameBloc gameBloc;

  TicTacToeGame({
    required this.board,
    required this.gameBloc,
    this.winningLine,
  });

  // Add this method to update the board without recreating
  void updateBoard(BoardModel newBoard, List<int>? newWinningLine) {
    board = newBoard;
    winningLine = newWinningLine;

    // Update existing cells instead of recreating them
    final cells = children.whereType<BoardCell>().toList();
    for (final cell in cells) {
      cell.updateState(
        board.cells[cell.index],
        winningLine?.contains(cell.index) ?? false,
      );
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Calculate cell size with padding considerations
    final edgePadding = 8.0; // Padding for edge cells
    final cellSpacing = 16.0; // Space between cells
    final availableWidth = size.x - (edgePadding * 2);
    final availableHeight = size.y - (edgePadding * 2);
    final boardSize = availableWidth < availableHeight
        ? availableWidth
        : availableHeight;

    // Calculate cell size accounting for spacing between cells
    final totalSpacing = cellSpacing * (GameConstants.boardSize - 1);
    final cellSize = (boardSize - totalSpacing) / GameConstants.boardSize;

    // Calculate the offset to center the board
    final offsetX = (size.x - boardSize) / 2;
    final offsetY = (size.y - boardSize) / 2;

    // Create board cells list
    final List<BoardCell> boardCells = [];

    // Create board cells with adjusted positioning
    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        final index = row * GameConstants.boardSize + col;
        final isWinningCell = winningLine?.contains(index) ?? false;

        // Adjust cell position based on column and row (for equal edge padding)
        double cellX = offsetX + col * (cellSize + cellSpacing);
        double cellY = offsetY + row * (cellSize + cellSpacing);

        // Add extra padding for edge cells to ensure equal spacing
        if (col == 0) {
          // Left column (cells 1, 4, 7)
          cellX += edgePadding / 2;
        } else if (col == 2) {
          // Right column (cells 3, 6, 9)
          cellX -= edgePadding / 2;
        }

        // Add extra padding for edge rows to ensure equal spacing
        if (row == 0) {
          // Top row (cells 1, 2, 3)
          cellY += edgePadding / 2;
        } else if (row == 2) {
          // Bottom row (cells 7, 8, 9)
          cellY -= edgePadding / 2;
        }

        final cell = BoardCell(
          index: index,
          cellState: board.cells[index],
          position: Vector2(cellX, cellY),
          size: Vector2(cellSize, cellSize),
          isWinningCell: isWinningCell,
        );

        boardCells.add(cell);
      }
    }

    // Add FlameMultiBlocProvider with all board cells as children
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, TicTacToeGameState>.value(
            value: gameBloc,
          ),
        ],
        children: boardCells,
      ),
    );
  }
}
