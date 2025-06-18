class GameConstants {
  static const int boardSize = 3;
  static const int winScore = 1;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Win patterns (rows, columns, diagonals)
  static final List<List<int>> winPatterns = [
    // Rows
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    // Columns
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    // Diagonals
    [0, 4, 8],
    [2, 4, 6],
  ];
}
