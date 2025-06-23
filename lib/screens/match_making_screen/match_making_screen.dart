import 'package:bakku/global_widgets/chips.dart';
import 'package:bakku/tic_tac_toe/blocs/match_making_bloc/match_making_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nakama/nakama.dart';

class MatchMakingScreen extends StatelessWidget {
  final Session session;
  const MatchMakingScreen({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Making Screen')),

      body: BlocBuilder<MatchMakingBloc, MatchMakingState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Chips(amount: 20),
                  Chips(amount: 50),
                  Chips(amount: 100),
                ],
              ),
              if (state is MatchMakingSuccess) Text(state.matchId),
              if (state is ChipSelectedState)
                TextButton(
                  onPressed: () {
                    context.read<MatchMakingBloc>().add(
                      MatchMakingStartEvent(
                        session: session,
                        amount: state.chip,
                      ),
                    );
                  },
                  child: Text('Start Match Making'),
                ),
            ],
          );
        },
      ),

      // body: Center(
      //   child: Column(
      //     children: [
      //       // Join Match Using Id
      //       BlocBuilder<MatchMakingBloc, MatchMakingState>(
      //         builder: (context, state) {
      //           if (state is MatchMakingSuccess) {
      //             return Text(state.matchId);
      //           }
      //           return Text('No Id Found');
      //         },
      //       ),

      //       TextField(
      //         decoration: InputDecoration(
      //           labelText: 'Enter Match ID',
      //           border: OutlineInputBorder(),
      //         ),
      //         onSubmitted: (matchId) {
      //           // Dispatch event to join match
      //           context.read<MatchMakingBloc>().add(JoinMatchEvent(matchId));
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
