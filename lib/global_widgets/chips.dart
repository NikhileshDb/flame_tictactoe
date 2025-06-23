import 'package:bakku/tic_tac_toe/blocs/match_making_bloc/match_making_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chips extends StatelessWidget {
  final double amount;
  const Chips({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<MatchMakingBloc>().add(ChipSelectEvent(amount));
      },
      child: Text("$amount"),
    );
  }
}
