import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'match_timer_state.dart';

class MatchTimerCubit extends Cubit<MatchTimerState> {
  Timer? _timer;
  MatchTimerCubit() : super(MatchTimerInitial());

  void startCountdown({int duration = 10}) {
    emit(MatchTimerTicking(duration, 'Searching for players...'));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is MatchTimerTicking) {
        final current = currentState.secondsLeft;

        if (current <= 1) {
          timer.cancel();
          emit(MatchTimerTimeout());
        } else {
          emit(MatchTimerTicking(current - 1, '⏳ Time left: ${current - 1}s'));
        }
      }
    });
  }

  void stopTimer({String message = '🎯 Match found!'}) {
    _timer?.cancel();

    final currentState = state;
    if (currentState is MatchTimerTicking) {
      emit(MatchTimerStopped(currentState.secondsLeft, message));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
