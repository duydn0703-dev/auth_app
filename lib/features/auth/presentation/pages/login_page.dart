import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_shell.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@mail.com');
  final _passwordController = TextEditingController(text: '123456789');
  final _formKey = GlobalKey<FormState>();

  static final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpRequired &&
            state.pendingEmail != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.otp,
            arguments: state.pendingEmail!,
          );
        }
        if (state.status == AuthStatus.success && state.token != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
            arguments: state.token!,
          );
        }
        if (state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final loading = state.status == AuthStatus.loading;
        return AuthShell(
          title: 'Welcome back',
          subtitle: 'Login to continue your flow.',
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Email is required';
                    if (!_emailRegex.hasMatch(v)) return 'Invalid email format';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Password is required';
                    if (v.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: loading
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : SizedBox(
                          key: const ValueKey('button'),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Login'),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthResetRequested());
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: const Text('No account? Register'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
