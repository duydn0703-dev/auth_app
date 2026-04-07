import 'package:auth_app/core/constants/api_endpoints.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/features/auth/data/models/auth_result_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final DioClient _client;

  Future<AuthResultModel> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return AuthResultModel.fromJson(json);
  }

  Future<AuthResultModel> register({
    required String email,
    required String password,
  }) async {
    final json = await _client.post(
      ApiEndpoints.register,
      data: {'email': email, 'password': password},
    );
    return AuthResultModel.fromJson(json);
  }

  Future<AuthResultModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final json = await _client.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    return AuthResultModel.fromJson(json);
  }
}
