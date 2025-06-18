part of 'nakama_bloc.dart';

/// Base class for all Nakama-related events.
///
/// Events dispatched to [NakamaBloc] for authentication and connection operations.
sealed class NakamaEvent extends Equatable {
  const NakamaEvent();

  @override
  List<Object> get props => [];
}

/// Initiates user authentication with Nakama server.
///
/// Contains user credentials (email and password) for login.
class NakamaLoginEvent extends NakamaEvent {
  /// The user's email address for authentication
  final String email;

  /// The user's password for authentication
  final String password;

  const NakamaLoginEvent({this.email = "", this.password = ""});

  @override
  List<Object> get props => [email, password];
}

/// Logs out the current user from Nakama server.
///
/// Ends user session and clears authentication state.
class NakamaLogoutEvent extends NakamaEvent {}

/// Represents an error during Nakama operations.
///
/// Contains error message describing what went wrong.
class NakamaErrorEvent extends NakamaEvent {
  /// Descriptive error message
  final String errorMessage;

  const NakamaErrorEvent(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class NakamaWebSocketAuthenticateEvent extends NakamaEvent {
  /// The session to authenticate with the WebSocket
  final Session session;

  const NakamaWebSocketAuthenticateEvent(this.session);

  @override
  List<Object> get props => [session];
}

class NakamaStartMatchMakingEvent extends NakamaEvent {
  final NakamaWebsocketClient socket;

  const NakamaStartMatchMakingEvent(this.socket);

  @override
  List<Object> get props => [socket];
}
