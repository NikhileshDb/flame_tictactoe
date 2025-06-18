import '../core/enums/player_type.dart';

class PlayerModel {
  final PlayerType type;
  final String name;
  int score;

  PlayerModel({required this.type, required this.name, this.score = 0});

  void incrementScore() {
    score += 1;
  }

  PlayerModel copyWith({PlayerType? type, String? name, int? score}) {
    return PlayerModel(
      type: type ?? this.type,
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }
}
