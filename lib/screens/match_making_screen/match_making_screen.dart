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
      appBar: AppBar(title: const Text('Match Making Screen'), actions: [
        
        ],
      ),

      body: BlocConsumer<MatchMakingBloc, MatchMakingState>(
        listener: (context, state) => {},
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
              Text('User Id: ${session.userId}'),

              if (state is MatchMakingSuccess)
                Text("Oppon Id: ${state.opponentId}"),

              if (state is ChipSelectedState)
                if (state is! MatchMakingSuccess)
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
              if (state is MatchMakingSuccess)
                TextButton(
                  onPressed: () {
                    context.read<MatchMakingBloc>().add(
                      JoinMatchEvent(state.matchId),
                    );
                  },
                  child: Text("Join Match"),
                ),
            ],
          );
        },
      ),
    );
  }
}
