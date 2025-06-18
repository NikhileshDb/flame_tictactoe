import 'dart:async';
import 'dart:io';
import 'package:bakku/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:nakama/nakama.dart';

final client = getNakamaClient(
  host: '127.0.0.1',
  ssl: false,
  serverKey: 'defaultkey',
  grpcPort: 7349, // optional
  httpPort: 7350, // optional
);

FutureOr<void> authenticateWithDevice() async {
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Grabbing the device id from device_info_plus packages for ios and android
  if (Platform.isAndroid) {
    deviceId = (await deviceInfo.androidInfo).id; // Unique ID on Android
  } else if (Platform.isWindows) {
    deviceId = (await deviceInfo.windowsInfo).deviceId; // Unique ID on Windows
  } else {
    final uuid = Uuid();
    deviceId = uuid.v4(); // Generate a random UUID for other platforms
  }

  try {
    final session = await client.authenticateDevice(deviceId: deviceId);
    var account = await client.getAccount(session);

    final socket = NakamaWebsocketClient.init(
      host: '127.0.0.1',
      port: 7350,
      ssl: false,
      token: session.token,
    );

    logger.i(socket);

    await socket.addMatchmaker(minCount: 2, maxCount: 2);
  } catch (e) {
    logger.d('Error authenticating with device ID: $e');
  }
}
