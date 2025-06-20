import 'package:bakku/tic_tac_toe/blocs/match_making_bloc/match_making_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchMakingScreen extends StatelessWidget {
  const MatchMakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Match')),
      body: Center(
        child: Column(
          children: [
            Text('Match Making Screen'),
            // Join Match Using Id
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Match ID',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (matchId) {
                // Dispatch event to join match
                context.read<MatchMakingBloc>().add(JoinMatchEvent(matchId));
              },
            ),
          ],
        ),
      ),
    );
  }
}
