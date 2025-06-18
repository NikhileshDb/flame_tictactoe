part of 'socket_bloc.dart';

sealed class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class MatchMakerMatchEvent extends SocketEvent {
  final MatchmakerMatched matchData;

  const MatchMakerMatchEvent(this.matchData);

  @override
  List<Object> get props => [matchData];
}
