import 'package:flutter/foundation.dart';
import '../core/enums/cell_state.dart';
import '../core/constants/game_constants.dart';

class BoardModel {
  List<CellState> cells;

  BoardModel()
    : cells = List.filled(
        GameConstants.boardSize * GameConstants.boardSize,
        CellState.empty,
      );

  BoardModel copyWith({List<CellState>? cells}) {
    return BoardModel()..cells = cells ?? List.from(this.cells);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoardModel && listEquals(other.cells, cells);
  }

  @override
  int get hashCode => Object.hashAll(cells);
}
