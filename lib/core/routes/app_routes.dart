import 'package:auth_app/features/auth/presentation/pages/home_page.dart';
import 'package:auth_app/features/auth/presentation/pages/login_page.dart';
import 'package:auth_app/features/auth/presentation/pages/otp_page.dart';
import 'package:auth_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterPage(),
        );
      case otp:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpPage(email: email),
        );
      case home:
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePage(token: token),
        );
      case login:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
    }
  }
}
