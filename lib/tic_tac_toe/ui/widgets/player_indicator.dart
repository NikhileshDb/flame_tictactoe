import 'package:flutter/material.dart';
import '../../core/enums/player_type.dart';

class PlayerIndicatorWidget extends StatelessWidget {
  final PlayerType playerType;
  final bool isActive;
  final int score;

  const PlayerIndicatorWidget({
    super.key,
    required this.playerType,
    required this.isActive,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (playerType == PlayerType.x ? Colors.blue : Colors.red)
                  .withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: playerType == PlayerType.x ? Colors.blue : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            playerType == PlayerType.x ? 'Player X' : 'Player O',
            style: TextStyle(
              color: playerType == PlayerType.x ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Score: $score',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
