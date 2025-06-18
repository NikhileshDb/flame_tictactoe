part of 'socket_bloc.dart';

sealed class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object> get props => [];
}

final class SocketInitial extends SocketState {}

class SocketMatchFoundState extends SocketState {
  final MatchmakerMatched matchData;

  const SocketMatchFoundState(this.matchData);

  @override
  List<Object> get props => [matchData];
}
