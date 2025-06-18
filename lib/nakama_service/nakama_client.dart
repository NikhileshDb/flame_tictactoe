import 'package:nakama/nakama.dart';

final client = getNakamaClient(
  host: '127.0.0.1',
  ssl: false,
  serverKey: 'defaultkey',
  grpcPort: 7349, // optional
  httpPort: 7350, // optional
);
