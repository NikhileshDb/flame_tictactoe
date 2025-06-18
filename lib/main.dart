import 'package:bakku/nakama_service/nakama_screen.dart';
import 'package:bakku/tic_tac_toe/blocs/nakama_blocs/nakama_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nakama/nakama.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Nakama client with default parameters
    var client = getNakamaClient(
      host: dotenv.env['NAKAMA_HOST'],
      ssl: false,
      serverKey: dotenv.env['NAKAMA_SERVER_KEY'],
      grpcPort: int.parse(dotenv.env['NAKAMA_GRPC_PORT'] as String),
      httpPort: int.parse(dotenv.env['NAKAMA_HTTP_PORT'] as String),
    );
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: NakamaScreen(),
      home: BlocProvider(
        create: (context) => NakamaBloc(nakamaClient: client),
        child: const NakamaScreen(),
      ),
    );
  }
}

// class TicGameTest extends FlameGame {
//   // Create a board

//   @override
//   FutureOr<void> onLoad() async {
//     super.onLoad();
//     final int boardSize = 3;
//     // --> 3 Columns, 3 Rows
//     for (int row = 0; row < boardSize; row++) {
//       for (int col = 0; col < boardSize; col++) {
//         final index = row * boardSize + col;
//         logger.d("Index: $index");
//         var cell = RectangleComponent(
//           size: Vector2(90, 90),
//           position: Vector2(col * 100.0, row * 100.0),
//           paint: Paint()..color = Colors.white.withOpacity(0.5),
//         );
//         logger.d(
//           "$row $col - Index: $index, Position: ${cell.position}, Size: ${cell.size}",
//         );
//         add(cell);
//       }
//     }
//   }
// }
