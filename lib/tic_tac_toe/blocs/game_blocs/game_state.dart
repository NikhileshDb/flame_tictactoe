part of 'game_bloc.dart';

class TicTacToeGameState extends Equatable {
  final GameState gameState;
  final BoardModel board;
  final PlayerType currentPlayer;
  final PlayerModel playerX;
  final PlayerModel playerO;
  final List<int>? winningLine;

  const TicTacToeGameState({
    required this.gameState,
    required this.board,
    required this.currentPlayer,
    required this.playerX,
    required this.playerO,
    this.winningLine,
  });

  factory TicTacToeGameState.initial() {
    return TicTacToeGameState(
      gameState: GameState.initial,
      board: BoardModel(),
      currentPlayer: PlayerType.x,
      playerX: PlayerModel(type: PlayerType.x, name: 'Player X'),
      playerO: PlayerModel(type: PlayerType.o, name: 'Player O'),
    );
  }

  TicTacToeGameState copyWith({
    GameState? gameState,
    BoardModel? board,
    PlayerType? currentPlayer,
    PlayerModel? playerX,
    PlayerModel? playerO,
    List<int>? winningLine,
    bool clearWinningLine = false,
  }) {
    return TicTacToeGameState(
      gameState: gameState ?? this.gameState,
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      playerX: playerX ?? this.playerX,
      playerO: playerO ?? this.playerO,
      winningLine: clearWinningLine ? null : winningLine ?? this.winningLine,
    );
  }

  @override
  List<Object?> get props => [
    gameState,
    board,
    currentPlayer,
    playerX,
    playerO,
    winningLine,
  ];
}
