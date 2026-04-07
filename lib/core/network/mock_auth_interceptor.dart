import 'dart:async';

import 'package:auth_app/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class MockAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      final Map<String, dynamic> data =
          (options.data as Map?)?.cast<String, dynamic>() ?? {};

      if (options.path == ApiEndpoints.register) {
        if ((data['email'] as String?)?.contains('@') != true ||
            (data['password'] as String?) == null ||
            (data['password'] as String).length < 8) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 400,
                data: {'message': 'Invalid register payload'},
              ),
            ),
          );
          return;
        }
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'message': 'Registered successfully. Enter OTP 123456',
              'otpRequired': true,
            },
          ),
        );
        return;
      }

      if (options.path == ApiEndpoints.login) {
        if (data['email'] == 'demo@mail.com' &&
            data['password'] == '123456789') {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'message': 'Login success', 'token': 'token_abc_123'},
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 401,
                data: {'message': 'Email or password is incorrect'},
              ),
            ),
          );
        }
        return;
      }

      if (options.path == ApiEndpoints.verifyOtp) {
        if (data['otp'] == '123456') {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'message': 'OTP verified', 'token': 'verified_token_xyz'},
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 400,
                data: {'message': 'Invalid OTP'},
              ),
            ),
          );
        }
        return;
      }

      handler.next(options);
    });
  }
}
