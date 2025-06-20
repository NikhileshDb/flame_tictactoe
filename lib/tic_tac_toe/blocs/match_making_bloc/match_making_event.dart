part of 'match_making_bloc.dart';

sealed class MatchMakingEvent extends Equatable {
  const MatchMakingEvent();

  @override
  List<Object> get props => [];
}

class MatchMakingStartEvent extends MatchMakingEvent {
  final Session session;

  const MatchMakingStartEvent({required this.session});

  @override
  List<Object> get props => [session];
}

class ChipSelectEvent extends MatchMakingEvent {
  final int chip;

  const ChipSelectEvent(this.chip);

  @override
  List<Object> get props => [chip];
}
