import 'package:bakku/tic_tac_toe/blocs/bloc_exports.dart';
import 'package:bakku/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'match_bloc_event.dart';
part 'match_bloc_state.dart';

class MatchBloc extends Bloc<MatchBlocEvent, MatchBlocState> {
  final NakamaBloc nakamaBloc;
  MatchBloc({required this.nakamaBloc}) : super(MatchBlocInitial()) {
    on<MatchBlocEvent>((event, emit) {
      nakamaBloc.stream.listen((nakamaState) {
        if (nakamaState is NakamaWebSocketAuthenticatedState) {
          // Handle WebSocket authenticated state
          nakamaState.socket.onMatchmakerMatched.listen((matchData) {
            logger.d("Matchmaker matched: ${matchData.users}");
          });
        }
      });
    });
  }
}
