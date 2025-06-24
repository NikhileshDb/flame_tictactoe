part of 'match_making_bloc.dart';

sealed class MatchMakingState extends Equatable {
  const MatchMakingState();

  @override
  List<Object> get props => [];
}

final class MatchMakingInitial extends MatchMakingState {}

class MatchMakingSuccess extends MatchMakingState {
  final String matchId;
  final String opponentId;

  const MatchMakingSuccess(this.matchId, this.opponentId);

  @override
  List<Object> get props => [matchId];
}

class ChipSelectedState extends MatchMakingState {
  final double chip;

  const ChipSelectedState(this.chip);

  @override
  List<Object> get props => [chip];
}

class MatchJoinedState extends MatchMakingState {
  final String matchId;

  const MatchJoinedState(this.matchId);

  @override
  List<Object> get props => [matchId];
}

class MatchMakingLoading extends MatchMakingState {}

class MatchMakingError extends MatchMakingState {
  final String message;

  const MatchMakingError(this.message);

  @override
  List<Object> get props => [message];
}
