import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_shell.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});

  final String email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      OtpVerificationRequested(
        email: widget.email,
        otp: _otpController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success && state.token != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
            arguments: state.token!,
          );
        }
      },
      builder: (context, state) {
        final loading = state.status == AuthStatus.loading;
        return AuthShell(
          title: 'OTP Verification',
          subtitle: 'Use OTP 123456 for demo.',
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AuthTextField(
                  controller: _otpController,
                  label: 'OTP code',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'OTP is required';
                    if (v.length != 6) return 'OTP must be 6 digits';
                    if (int.tryParse(v) == null) return 'OTP must be numeric';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
