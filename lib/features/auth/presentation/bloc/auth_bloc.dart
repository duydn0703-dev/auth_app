import 'package:auth_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:auth_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<AuthResetRequested>((_, emit) => emit(const AuthState.initial()));
    on<LogoutRequested>((_, emit) => emit(const AuthState.initial()));
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: AuthStatus.success,
          message: success.message,
          token: success.token,
        ),
      ),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    final result = await _registerUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: AuthStatus.otpRequired,
          message: success.message,
          pendingEmail: event.email,
        ),
      ),
    );
  }

  Future<void> _onOtpVerificationRequested(
    OtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    final result = await _verifyOtpUseCase(email: event.email, otp: event.otp);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: AuthStatus.success,
          message: success.message,
          token: success.token,
        ),
      ),
    );
  }
}
