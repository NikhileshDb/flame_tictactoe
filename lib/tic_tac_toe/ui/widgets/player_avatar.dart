import 'package:bakku/tic_tac_toe/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.playerType,
    required this.isOppenent,
  });
  final PlayerType playerType;
  final bool isOppenent;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xff41414B),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 168, 168, 168),
                child: Icon(Icons.person, size: 90, color: Colors.white),
              ),
              Positioned(
                top: -8,
                right: -10,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(137, 255, 0, 0),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.mic_off, size: 24, color: Colors.white),
                ),
              ),
            ],
          ),
          playerType == PlayerType.x
              ? SvgPicture.asset(
                  "assets/svgs/player_x.svg",
                  semanticsLabel: 'Player X Icon',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : playerType == PlayerType.o
              ? SvgPicture.asset(
                  "assets/svgs/player_o.svg",
                  semanticsLabel: 'Player O Icon',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : SizedBox.shrink(),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${isOppenent ? 2 : 1}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(2, -6),
                    child: Text(
                      isOppenent ? 'nd' : 'st',
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: ' mover',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
