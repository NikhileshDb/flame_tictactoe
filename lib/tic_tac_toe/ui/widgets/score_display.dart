import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int playerXScore;
  final int playerOScore;

  const ScoreDisplay({
    super.key,
    required this.playerXScore,
    required this.playerOScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreItem('Player X', playerXScore, Colors.blue),
          Container(width: 2, height: 40, color: Colors.grey[600]),
          _buildScoreItem('Player O', playerOScore, Colors.red),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
