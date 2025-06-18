part of 'nakama_bloc.dart';

/// Base class for all Nakama-related states in the application.
///
/// This sealed class represents the different states that the NakamaBloc
/// can be in during authentication and connection operations with the Nakama server.
///
/// All states extend [Equatable] to enable proper comparison and testing.
sealed class NakamaState extends Equatable {
  const NakamaState();

  @override
  List<Object> get props => [];
}

/// The initial state of the NakamaBloc.
///
/// This state represents the bloc's initial condition when it's first created,
/// before any authentication attempts or operations have been performed.
/// The user is not authenticated and no operations are in progress.
final class NakamaInitialState extends NakamaState {}

/// State indicating that a Nakama operation is currently in progress.
///
/// This state is emitted when the bloc is processing an operation such as:
/// - User authentication (login)
/// - Connection establishment with Nakama server
/// - Any other asynchronous Nakama operation
///
/// UI components should typically show loading indicators when in this state.
class NakamaLoadingState extends NakamaState {}

/// State indicating that an error occurred during a Nakama operation.
///
/// This state is emitted when an error occurs during:
/// - Authentication attempts
/// - Connection to Nakama server
/// - Any other Nakama-related operations
///
/// **Parameters:**
/// - [message]: A descriptive error message explaining what went wrong
///
/// UI components should display the error message to inform the user
/// about the issue and potentially provide retry options.
class NakamaErrorState extends NakamaState {
  /// A descriptive error message explaining what went wrong
  final String message;

  const NakamaErrorState(this.message);

  @override
  List<Object> get props => [message];
}

/// State indicating that the user has been successfully authenticated with Nakama.
///
/// This state is emitted when:
/// - User login is successful
/// - A valid session has been established with the Nakama server
/// - The user is ready to perform authenticated operations
///
/// **Parameters:**
/// - [session]: The active Nakama session containing user authentication data
///
/// UI components can use this state to:
/// - Navigate to authenticated screens
/// - Access user session information
/// - Enable authenticated features and operations
class NakamaSessionAuthenticatedState extends NakamaState {
  /// The active Nakama session containing user authentication data
  final Session session;

  const NakamaSessionAuthenticatedState(this.session);

  @override
  List<Object> get props => [session];
}

class NakamaWebSocketAuthenticatedState extends NakamaState {
  /// The active Nakama session for WebSocket authentication
  final NakamaWebsocketClient socket;

  const NakamaWebSocketAuthenticatedState(this.socket);

  @override
  List<Object> get props => [socket];
}

class NakamaMatchMakingTicketState extends NakamaState {
  /// The active Nakama session for matchmaking
  final MatchmakerTicket ticket;
  const NakamaMatchMakingTicketState({required this.ticket});
  @override
  List<Object> get props => [ticket];
}
