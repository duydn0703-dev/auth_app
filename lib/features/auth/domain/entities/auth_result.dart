class AuthResult {
  const AuthResult({
    required this.message,
    this.token,
    this.otpRequired = false,
  });

  final String message;
  final String? token;
  final bool otpRequired;
}
