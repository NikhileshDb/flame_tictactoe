import 'dart:async';

import 'package:bakku/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nakama/nakama.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  final Session? session;
  NakamaWebsocketClient? socket;
  late StreamSubscription _matchmakerSubscription;
  MatchMakingBloc({this.session, this.socket}) : super(MatchMakingInitial()) {
    on<ChipSelectEvent>(_handleChipSelection);

    on<MatchMakingStartEvent>(_handleMatchMaking);

    on<JoinMatchEvent>(_handleJoinMatch);
  }

  FutureOr<void> _handleMatchMaking(
    MatchMakingStartEvent event,
    Emitter<MatchMakingState> emit,
  ) async {
    socket = NakamaWebsocketClient.init(
      host: dotenv.env["NAKAMA_HOST"] as String,
      ssl: false,
      token: event.session.token,
    );

    _matchmakerSubscription = socket!.onMatchmakerMatched.listen((
      MatchmakerMatched data,
    ) {
      add(JoinMatchEvent(data.matchId as String));
    });

    var ticket = await socket!.addMatchmaker(
      query: "*",
      minCount: 2,
      maxCount: 2,
      stringProperties: {"fast": "true", "ai": "false"},
      numericProperties: {"coin": event.amount},
    );
    logger.d(ticket);
  }

  FutureOr<void> _handleChipSelection(
    ChipSelectEvent event,
    Emitter<MatchMakingState> emit,
  ) {
    emit(ChipSelectedState(event.chip));
  }

  FutureOr<void> _handleJoinMatch(
    JoinMatchEvent event,
    Emitter<MatchMakingState> emit,
  ) async {
    var matchId = event.matchId;
    var match = await socket?.joinMatch(matchId);
    logger.d("Joined match: $match");
  }

  @override
  Future<void> close() {
    logger.d("Closing MatchMakingBloc");
    _matchmakerSubscription.cancel();
    return super.close();
  }
}
