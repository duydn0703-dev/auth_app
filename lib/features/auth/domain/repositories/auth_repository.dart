import 'package:auth_app/core/error/failure.dart';
import 'package:auth_app/core/utils/either.dart';
import 'package:auth_app/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  });
}
