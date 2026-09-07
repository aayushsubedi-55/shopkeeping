import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopnepal/features/auth/presentation/widgets/auth_labeled_field.dart';
import 'package:shopnepal/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shopnepal/features/auth/presentation/widgets/auth_contact_utils.dart';
import 'package:shopnepal/navigation/navigation.dart';

/// Staff sign-in: email or phone, plus a password.
///
/// Accounts are created by the owner, so there is deliberately no sign-up,
/// OTP or password-reset path here.
class LoginSheet extends StatefulWidget {
  const LoginSheet({super.key, this.onBusyChanged});

  final ValueChanged<bool>? onBusyChanged;

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final identifier = AuthContactUtils.normalizeEmailOrPhone(
      value: _identifierController.text,
    );

    FocusScope.of(context).unfocus();

    context.read<LoginCubit>().login(
      emailOrPhone: identifier,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: BlocConsumer<LoginCubit, CommonState>(
        listener: (context, state) {
          widget.onBusyChanged?.call(state is CommonLoading);

          if (state is CommonSuccess) {
            AppNavigator.toDashboard();
          } else if (state is CommonError) {
            AppNavigator.showSnackBar(message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is CommonLoading;

          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s22,
              AppSpacing.s32,
              AppSpacing.s22,
              AppSpacing.s22,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(
                      color: ThemeColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const Text(
                    'Use the account details your administrator gave you.',
                    style: TextStyle(
                      color: ThemeColors.midGrayColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s28),

                  AuthLabeledField(
                    label: 'Email or phone',
                    field: AuthTextField(
                      controller: _identifierController,
                      hintText: 'you@example.com or 98XXXXXXXX',
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email or phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),

                  AuthLabeledField(
                    label: 'Password',
                    field: AuthTextField(
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ThemeColors.midGrayColor,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),

                  PrimaryButton(
                    text: 'Sign in',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: AppSpacing.s16),

                  const Text(
                    'Forgotten your password? Ask your administrator to reset it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.midGrayColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
