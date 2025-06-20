import 'dart:async';
import 'dart:io';

import 'package:bakku/utils/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nakama/nakama.dart';
import 'package:uuid/uuid.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final NakamaBaseClient nakamaBaseClient;
  AuthenticationBloc({required this.nakamaBaseClient})
    : super(AuthenticationInitial()) {
    on<AuthenticationLoginEvent>(_handleLogin);
  }

  FutureOr<void> _handleLogin(
    AuthenticationLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    Session session;
    try {
      emit(AuthenticationLoading());
      Future.delayed(Duration(seconds: 2));
      if (event.email.isEmpty || event.password.isEmpty) {
        // No email or password provided
        // Login with anonymous/deviceId

        String deviceId;
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // Grabbing the device id from device_info_plus packages for ios and android
        if (Platform.isAndroid) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId = (await deviceInfo.androidInfo).id; // Unique ID on Android
          session = await nakamaBaseClient.authenticateDevice(
            deviceId: deviceId,
          );
          emit(AuthenticationSuccess(session));
        } else if (Platform.isIOS) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId = (await deviceInfo.iosInfo).identifierForVendor as String;
          session = await nakamaBaseClient.authenticateDevice(
            deviceId: deviceId,
          );
          emit(AuthenticationSuccess(session));
        } else if (Platform.isWindows) {
          logger.d("Nakama Login Triggered: ${Platform.operatingSystem}");
          deviceId =
              (await deviceInfo.windowsInfo).deviceId; // Unique ID on Windows
          session = await nakamaBaseClient.authenticateDevice(
            deviceId: deviceId,
          );
          emit(AuthenticationSuccess(session));
        } else {
          logger.d("Nakama Login Triggered: Unknown Platform");
          final uuid = Uuid();
          deviceId = uuid.v4(); // Generate a random UUID for other platforms
          session = await nakamaBaseClient.authenticateDevice(
            deviceId: deviceId,
          );
          emit(AuthenticationSuccess(session));
        }
      } else {
        // Login Using Email And Password
        logger.d("Nakama Login Triggered: Using Email and Password");
        session = await nakamaBaseClient.authenticateEmail(
          password: event.password,
          email: event.password,
        );
        emit(AuthenticationSuccess(session));
      }
    } catch (e) {
      emit(AuthenticationError("$e")); // Emit error state on failure
      return;
    }
    return null;
  }
}
