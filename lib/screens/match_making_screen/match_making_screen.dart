import 'package:flutter/material.dart';

class MatchMakingScreen extends StatelessWidget {
  const MatchMakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Making')),
      body: Center(child: Column(children: [Text('Match Making Screen')])),
    );
  }
}
