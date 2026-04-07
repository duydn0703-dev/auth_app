import 'package:auth_app/core/error/app_exception.dart';
import 'package:auth_app/core/error/failure.dart';
import 'package:auth_app/core/utils/either.dart';
import 'package:auth_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth_app/features/auth/domain/entities/auth_result.dart';
import 'package:auth_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remote.login(email: email, password: password);
      return Right(result);
    } on AppException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remote.register(email: email, password: password);
      return Right(result);
    } on AppException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _remote.verifyOtp(email: email, otp: otp);
      return Right(result);
    } on AppException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure('Unexpected error'));
    }
  }
}
