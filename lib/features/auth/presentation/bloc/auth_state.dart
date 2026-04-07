part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure, otpRequired }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.message,
    this.token,
    this.pendingEmail,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  final AuthStatus status;
  final String? message;
  final String? token;
  final String? pendingEmail;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    String? token,
    String? pendingEmail,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      token: token ?? this.token,
      pendingEmail: pendingEmail ?? this.pendingEmail,
    );
  }

  @override
  List<Object?> get props => [status, message, token, pendingEmail];
}
