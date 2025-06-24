part of 'match_timer_cubit.dart';

sealed class MatchTimerState extends Equatable {
  const MatchTimerState();

  @override
  List<Object> get props => [];
}

final class MatchTimerInitial extends MatchTimerState {}

class MatchTimerTicking extends MatchTimerState {
  final int secondsLeft;
  final String message;

  const MatchTimerTicking(this.secondsLeft, this.message);
}

class MatchTimerTimeout extends MatchTimerState {
  final String message;
  const MatchTimerTimeout({this.message = '⏰ Matchmaking timed out.'});
}

class MatchTimerStopped extends MatchTimerState {
  final int secondsLeft;
  final String message;
  const MatchTimerStopped(this.secondsLeft, this.message);
}
