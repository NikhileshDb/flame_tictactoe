part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {}

class CellTapped extends GameEvent {
  final int index;

  const CellTapped(this.index);

  @override
  List<Object?> get props => [index];
}

class GameRestarted extends GameEvent {}

class ScoreReset extends GameEvent {}
