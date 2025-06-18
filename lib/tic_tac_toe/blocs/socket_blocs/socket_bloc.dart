import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nakama/nakama.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  late NakamaWebsocketClient? socket;
  late final StreamSubscription _matchmakerSubscription;

  SocketBloc({this.socket}) : super(SocketInitial()) {
    _matchmakerSubscription = socket!.onMatchmakerMatched.listen((
      MatchmakerMatched matchData,
    ) {
      add(MatchMakerMatchEvent(matchData));
    });
    on<MatchMakerMatchEvent>(_onMatchFound);
  }

  FutureOr<void> _onMatchFound(
    MatchMakerMatchEvent event,
    Emitter<SocketState> emit,
  ) {
    emit(SocketMatchFoundState(event.matchData));
  }

  @override
  Future<void> close() {
    _matchmakerSubscription.cancel();
    return super.close();
  }
}
