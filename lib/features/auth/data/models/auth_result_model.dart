import 'package:auth_app/features/auth/domain/entities/auth_result.dart';

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.message,
    super.token,
    super.otpRequired,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString(),
      otpRequired: json['otpRequired'] == true,
    );
  }
}
