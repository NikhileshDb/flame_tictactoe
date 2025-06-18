import 'package:bakku/tic_tac_toe/blocs/nakama_blocs/nakama_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nakama/nakama.dart';

class NakamaScreen extends StatefulWidget {
  const NakamaScreen({super.key});

  @override
  State<NakamaScreen> createState() => _NakamaScreenState();
}

class _NakamaScreenState extends State<NakamaScreen> {
  late Session session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NakamaBloc, NakamaState>(
        builder: (context, state) {
          if (state is NakamaInitialState) {
            context.read<NakamaBloc>().add(NakamaLoginEvent());
          }

          if (state is NakamaLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NakamaErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          if (state is NakamaSessionAuthenticatedState) {
            session = state.session;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Authenticated as: ${session.userId}',
                    style: const TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NakamaBloc>().add(
                        NakamaWebSocketAuthenticateEvent(session),
                      );
                    },
                    child: const Text('Connect WebSocket'),
                  ),
                ],
              ),
            );
          }
          if (state is NakamaWebSocketAuthenticatedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WebSocket Authenticated',
                    style: const TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  Text(
                    'Session ID: ${state.socket}',
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<NakamaBloc>().add(
                        NakamaStartMatchMakingEvent(state.socket),
                      );
                    },
                    child: const Text('Start Matchmaking'),
                  ),
                ],
              ),
            );
          }

          if (state is NakamaMatchMakingTicketState) {
            return Center(
              child: Text(
                'Matchmaking Ticket: ${state.ticket.ticket}',
                style: const TextStyle(color: Colors.blue, fontSize: 16),
              ),
            );
          }
          return Column(children: []);
        },
      ),
    );
  }
}
