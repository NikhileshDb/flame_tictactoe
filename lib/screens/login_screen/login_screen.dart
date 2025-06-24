import 'package:bakku/screens/match_making_screen/match_making_screen.dart';
import 'package:bakku/tic_tac_toe/blocs/authentication/authentication_bloc.dart';
import 'package:bakku/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess) {
            // logger.d(state.session);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MatchMakingScreen(session: state.session),
              ),
            );
          }
        },

        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                    AuthenticationLoginEvent(email: null, password: null),
                  );
                },
                child: Text('Authenticate'),
              ),
            ],
          );
        },
      ),
    );
  }
}
