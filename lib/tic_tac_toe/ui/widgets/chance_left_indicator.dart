import 'package:flutter/material.dart';

class ChanceLeftIndicator extends StatefulWidget {
  const ChanceLeftIndicator({super.key});

  @override
  State<ChanceLeftIndicator> createState() => _ChanceLeftIndicatorState();
}

class _ChanceLeftIndicatorState extends State<ChanceLeftIndicator> {
  int chanceLeft = 2; // Example initial value, can be dynamic

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: index >= (3 - chanceLeft) ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
