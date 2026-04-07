import 'package:auth_app/core/error/failure.dart';
import 'package:auth_app/core/utils/either.dart';
import 'package:auth_app/features/auth/domain/entities/auth_result.dart';
import 'package:auth_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String otp,
  }) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
