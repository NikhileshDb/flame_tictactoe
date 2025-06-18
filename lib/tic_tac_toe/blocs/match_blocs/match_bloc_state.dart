part of 'match_bloc.dart';

sealed class MatchBlocState extends Equatable {
  const MatchBlocState();

  @override
  List<Object> get props => [];
}

final class MatchBlocInitial extends MatchBlocState {}
