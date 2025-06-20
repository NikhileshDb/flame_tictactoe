import 'package:bakku/global_widgets/chips.dart';
import 'package:bakku/screens/match_making_screen/match_making_screen.dart';
import 'package:bakku/tic_tac_toe/blocs/authentication/authentication_bloc.dart';
import 'package:bakku/tic_tac_toe/blocs/match_making_bloc/match_making_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is AuthenticationLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AuthenticationInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to the Tic Tac Toe Game",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Trigger the authentication event
                    context.read<AuthenticationBloc>().add(
                      AuthenticationLoginEvent(),
                    );
                  },
                  child: Text("Authenticate Device"),
                ),
              ],
            );
          }

          if (state is AuthenticationSuccess) {
            AuthenticationSuccess successState = state;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Chips for selecting game options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Chips(amount: 20), Chips(amount: 50)],
                  ),

                  SizedBox(height: 20),
                  Text("Logged in as: ${state.session.userId}"),
                  SizedBox(height: 20),
                  BlocBuilder<MatchMakingBloc, MatchMakingState>(
                    builder: (context, state) {
                      bool isChipSelected = state is ChipSelectedState;

                      return Column(
                        children: [
                          Text(
                            'Selected chip: ${isChipSelected ? state.chip : 'None'}',
                          ),
                          if (isChipSelected)
                            ElevatedButton(
                              onPressed: () {
                                context.read<MatchMakingBloc>().add(
                                  MatchMakingStartEvent(
                                    session: successState.session,
                                  ),
                                );
                              },
                              child: Text("Start Matchmaking"),
                            ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MatchMakingScreen(),
                                ),
                              );
                            },
                            child: Text("JOIN MATCH"),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
          // If none of the above states match, show a loading indicator
          // This is a fallback case, ideally shouldn't be reached unless there's an unexpected state
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
