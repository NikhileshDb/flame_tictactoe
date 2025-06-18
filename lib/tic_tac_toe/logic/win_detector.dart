import '../core/enums/cell_state.dart';
import '../core/constants/game_constants.dart';
import '../models/board_model.dart';

class WinDetector {
  bool checkForWin(BoardModel board, CellState playerCell) {
    for (final pattern in GameConstants.winPatterns) {
      if (board.cells[pattern[0]] == playerCell &&
          board.cells[pattern[1]] == playerCell &&
          board.cells[pattern[2]] == playerCell) {
        return true;
      }
    }
    return false;
  }

  bool checkForDraw(BoardModel board) {
    return !board.cells.contains(CellState.empty) &&
        !checkForWin(board, CellState.x) &&
        !checkForWin(board, CellState.o);
  }

  List<int>? getWinningLine(BoardModel board) {
    for (final pattern in GameConstants.winPatterns) {
      if ((board.cells[pattern[0]] != CellState.empty) &&
          board.cells[pattern[0]] == board.cells[pattern[1]] &&
          board.cells[pattern[1]] == board.cells[pattern[2]]) {
        return pattern;
      }
    }
    return null;
  }
}
