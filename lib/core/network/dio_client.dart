import 'package:auth_app/core/error/app_exception.dart';
import 'package:auth_app/core/network/mock_auth_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://mock.local',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _dio.interceptors.add(MockAuthInterceptor());
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) {
    return _request(() => _dio.post<Map<String, dynamic>>(path, data: data));
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<Map<String, dynamic>> _request(
    Future<Response<Map<String, dynamic>>> Function() call,
  ) async {
    try {
      final response = await call();
      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message']?.toString() ??
                'Unexpected server error')
          : 'Network error';
      throw AppException(message);
    } catch (_) {
      throw const AppException('Something went wrong');
    }
  }
}
