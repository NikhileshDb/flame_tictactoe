import 'package:bakku/global_widgets/chips.dart';
import 'package:bakku/tic_tac_toe/blocs/match_making_bloc/match_making_bloc.dart';
import 'package:bakku/tic_tac_toe/cubits/match_timer_cubit/match_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nakama/nakama.dart';

class MatchMakingScreen extends StatelessWidget {
  final Session session;
  const MatchMakingScreen({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MatchTimerCubit>().stream.listen((remaining) {
      if (remaining == 0 &&
          context.read<MatchMakingBloc>().state is MatchMakingStartEvent) {
        // context.read<MatchMakingBloc>().add(MatchTimeout());
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Match Making Screen')),

      body: BlocConsumer<MatchMakingBloc, MatchMakingState>(
        listener: (context, state) => {
          if (state is MatchMakingSuccess)
            {context.read<MatchTimerCubit>().stopTimer()},
        },
        builder: (context, state) {
          return Column(
            children: [
              BlocBuilder<MatchTimerCubit, MatchTimerState>(
                builder: (context, state) {
                  if (state is MatchTimerTicking) {
                    return Column(
                      children: [
                        Text(state.message, style: TextStyle(fontSize: 18)),
                        Text(
                          '${state.secondsLeft}s',
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    );
                  } else if (state is MatchTimerTimeout) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (state is MatchTimerStopped) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.green),
                    );
                  }
                  // else if (state is MatchTimerAllocateTime) {
                  //   return Text(
                  //     'Allocated ${state.allocatedTime}s for matchmaking...',
                  //   );
                  // }

                  return Text("Idle");
                },
              ),
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
                TextButton(
                  onPressed: () {
                    context.read<MatchTimerCubit>().startCountdown();
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
    );
  }
}
