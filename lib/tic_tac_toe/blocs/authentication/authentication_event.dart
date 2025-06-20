part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthenticationLoginEvent({this.email = "", this.password = ""});

  @override
  List<Object> get props => [email, password];
}

class AuthenticationLogoutEvent extends AuthenticationEvent {}

class AuthenticationErrorEvent extends AuthenticationEvent {
  final String errorMessage;

  const AuthenticationErrorEvent(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
