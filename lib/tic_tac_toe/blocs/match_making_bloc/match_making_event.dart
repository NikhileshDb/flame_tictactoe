part of 'match_making_bloc.dart';

sealed class MatchMakingEvent extends Equatable {
  const MatchMakingEvent();

  @override
  List<Object> get props => [];
}

class ChipSelectEvent extends MatchMakingEvent {
  final double chip;

  const ChipSelectEvent(this.chip);

  @override
  List<Object> get props => [chip];
}

class MatchMakingStartEvent extends MatchMakingEvent {
  final Session session;
  final double amount;
  const MatchMakingStartEvent({required this.session, required this.amount});

  @override
  List<Object> get props => [session];
}

class MatchFoundEvent extends MatchMakingEvent {
  final MatchmakerMatched data;

  const MatchFoundEvent({required this.data});

  @override
  List<Object> get props => [data];
}

class JoinMatchEvent extends MatchMakingEvent {
  final String matchId;

  const JoinMatchEvent(this.matchId);

  @override
  List<Object> get props => [matchId];
}
