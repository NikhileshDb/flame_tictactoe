import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bakku/nakama_service/testing.dart';
import 'package:bakku/utils/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nakama/nakama.dart';
import 'package:uuid/uuid.dart';

part 'nakama_event.dart';
part 'nakama_state.dart';

class NakamaBloc extends Bloc<NakamaEvent, NakamaState> {
  final NakamaBaseClient nakamaClient;
  late StreamSubscription _matchmakerSubscription;
  NakamaBloc({required this.nakamaClient}) : super(NakamaInitialState()) {
    on<NakamaLoginEvent>(_handleNakamaLogin);
    on<NakamaWebSocketAuthenticateEvent>(_handleWebSocketAuthentication);
    on<NakamaStartMatchMakingEvent>(_handleNakamaStartMatchMaking);
    on<NakamaErrorEvent>(_handleNakamaError);
  }

  FutureOr<void> _handleNakamaLogin(
    NakamaLoginEvent event,
    Emitter<NakamaState> emit,
  ) async {
    emit(NakamaLoadingState()); //Emit loading state
    Session session;
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        // No email or password provided
        // Login with anonymous/deviceId

        String deviceId;
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // Grabbing the device id from device_info_plus packages for ios and android
        if (Platform.isAndroid) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId = (await deviceInfo.androidInfo).id; // Unique ID on Android
          session = await nakamaClient.authenticateDevice(deviceId: deviceId);
          emit(NakamaSessionAuthenticatedState(session));
        } else if (Platform.isIOS) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId = (await deviceInfo.iosInfo).identifierForVendor as String;
          session = await nakamaClient.authenticateDevice(deviceId: deviceId);
          emit(NakamaSessionAuthenticatedState(session));
        } else if (Platform.isWindows) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId =
              (await deviceInfo.windowsInfo).deviceId; // Unique ID on Windows
          session = await nakamaClient.authenticateDevice(deviceId: deviceId);
          emit(NakamaSessionAuthenticatedState(session));
        } else {
          logger.d("Nakama Login Triggered: Unknown Platform");
          final uuid = Uuid();
          deviceId = uuid.v4(); // Generate a random UUID for other platforms
          session = await nakamaClient.authenticateDevice(deviceId: deviceId);
          emit(NakamaSessionAuthenticatedState(session));
        }
      } else {
        // Login Using Email And Password
        logger.d("Nakama Login Triggered: Using Email and Password");
        session = await nakamaClient.authenticateEmail(
          password: event.password,
          email: event.password,
        );
        emit(NakamaSessionAuthenticatedState(session));
      }
    } catch (e) {
      emit(NakamaErrorState("$e")); // Emit initial state on error
      return;
    }
  }

  FutureOr<void> _handleNakamaError(
    NakamaErrorEvent event,
    Emitter<NakamaState> emit,
  ) {}

  FutureOr<void> _handleWebSocketAuthentication(
    NakamaWebSocketAuthenticateEvent event,
    Emitter<NakamaState> emit,
  ) {
    NakamaWebsocketClient socket = NakamaWebsocketClient.init(
      host: dotenv.env['NAKAMA_HOST'] ?? '127.0.0.1',
      port: dotenv.env['NAKAMA_PORT'] != null
          ? int.parse(dotenv.env['NAKAMA_PORT']!)
          : 7350,
      ssl: false,
      token: event.session.token,
    );
    emit(NakamaWebSocketAuthenticatedState(socket));
  }

  FutureOr<void> _handleNakamaStartMatchMaking(
    NakamaStartMatchMakingEvent event,
    Emitter<NakamaState> emit,
  ) async {
    MatchmakerTicket ticket = await event.socket.addMatchmaker(
      minCount: 2,
      maxCount: 2,
      query: "*",
    );
    logger.d("Matchmaking Ticket: ${ticket.ticket}");
    emit(NakamaMatchMakingTicketState(ticket: ticket));
    var res = await event.socket.rpc(
      id: 'find_match',
      payload: jsonEncode({"fast": true, "ai": false}),
    );
    logger.d(res.payload);
    // _matchmakerSubscription = event.socket.onMatchmakerMatched.listen((
    //   matchData,
    // ) {
    //   // add(NakamaMatchFoundEvent(matchData));
    //   logger.d("Match Found: ${matchData.matchId}");
    // });
  }

  @override
  Future<void> close() {
    _matchmakerSubscription.cancel();
    return super.close();
  }
}
