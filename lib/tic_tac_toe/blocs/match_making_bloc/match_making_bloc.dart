import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bakku/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nakama/nakama.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  Session session;
  NakamaWebsocketClient? socket;
  late StreamSubscription _matchmakerSubscription;
  late StreamSubscription _onmatchDataStream;
  MatchMakingBloc({required this.session, this.socket})
    : super(MatchMakingInitial()) {
    socket = NakamaWebsocketClient.init(
      host: dotenv.env["NAKAMA_HOST"] as String,
      ssl: false,
      token: session.token,
    );

    _matchmakerSubscription = socket!.onMatchmakerMatched.listen((
      MatchmakerMatched data,
    ) {
      add(MatchFoundEvent(data: data));
    });

    _onmatchDataStream = socket!.onMatchData.listen((data) {
      // Uint8List.fromList(data.data as List<int>);

      // Decode
      String decoded = utf8.decode(Uint8List.fromList(data.data as List<int>));
      logger.d(decoded);
    });

    on<ChipSelectEvent>(_handleChipSelection);

    on<MatchMakingStartEvent>(_handleMatchMaking);

    on<MatchFoundEvent>(_matchFound);

    on<JoinMatchEvent>(_handleJoinMatch);

    on<CreateMatchAiEvent>(_handleCreateAiMatch);
  }

  FutureOr<void> _handleMatchMaking(
    MatchMakingStartEvent event,
    Emitter<MatchMakingState> emit,
  ) async {
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
    var match = await socket?.joinMatch(matchId); //Join the Match
    logger.d("Joined match: $match");
    emit(MatchJoinedState(matchId));
  }

  @override
  Future<void> close() {
    logger.d("===> Closing MatchMakingBloc");
    _matchmakerSubscription.cancel();
    _onmatchDataStream.cancel();
    socket!.close();
    return super.close();
  }

  FutureOr<void> _matchFound(
    MatchFoundEvent event,
    Emitter<MatchMakingState> emit,
  ) {
    logger.d("Match Found ${event.data}");

    final opponent = event.data.users.firstWhere(
      (user) => user.presence.userId != session.userId,
    );

    final opponentId = opponent.presence.userId;

    emit(MatchMakingSuccess(event.data.matchId as String, opponentId));
  }

  FutureOr<void> _handleCreateAiMatch(
    CreateMatchAiEvent event,
    Emitter<MatchMakingState> emit,
  ) async {
    var payload = {'ai': true, 'fast': true};
    var rpcResponse = await socket!.rpc(
      id: 'find_match',
      payload: jsonEncode(payload),
    );
    var incomingPayload = jsonDecode(rpcResponse.payload);
    logger.d("MatchId to Join => ${incomingPayload["matchIds"][0]}");
    add(JoinMatchEvent(incomingPayload["matchIds"][0]));
  }
}
