import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/utils/form_validator.dart';
import 'package:shopnepal/core/utils/toast_message_utils.dart';
import 'package:shopnepal/core/widgets/auth_app_logo.dart';
import 'package:shopnepal/core/widgets/back_button.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:shopnepal/features/auth/domain/auth_error_codes.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopnepal/features/auth/presentation/widgets/auth_labeled_field.dart';
import 'package:shopnepal/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shopnepal/features/auth/presentation/widgets/password_requirements_hint.dart';
import 'package:shopnepal/navigation/navigation.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    final current = _currentPasswordController.text;
    context.read<ChangePasswordCubit>().changePassword(
      currentPassword: current,
      newPassword: _newPasswordController.text,
    );
  }

  String? _validateCurrentPassword(String? value) {
    return FormValidator.password(value);
  }

  String? _validateNewPassword(String? value) {
    // Same rules as signup password.
    final error = FormValidator.password(value);
    if (error != null) return error;

    if (value == _currentPasswordController.text &&
        (_currentPasswordController.text).isNotEmpty) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    // Same rules as signup confirm password.
    return FormValidator.confirmPassword(value, _newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return BlocProvider(
      create: (context) => ChangePasswordCubit(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: BlocListener<ChangePasswordCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonSuccess) {
            ToastMessageUtils.show(AppStrings.changePasswordSuccess);
            AppNavigator.pop();
          }
          if (state is CommonError) {
            if (state.code == AuthErrorCodes.wrongPassword) {
              ToastMessageUtils.error(
                state.message.isNotEmpty
                    ? state.message
                    : 'Current password is incorrect',
              );
              return;
            }
            ToastMessageUtils.error(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: ThemeColors.primaryColor,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      AuthAppLogo(isKeyboardOpen: isKeyboardOpen),
                      const Positioned(
                        top: 15,
                        left: 15,
                        child: AuthBackButton(),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Container(
                    color: ThemeColors.pageBackGroundColor,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.s22,
                        AppSpacing.s26,
                        AppSpacing.s22,
                        AppSpacing.s18,
                      ),
                      child: BlocBuilder<ChangePasswordCubit, CommonState>(
                        builder: (context, state) {
                          final isLoading = state is CommonLoading;

                          return Form(
                            key: _formKey,
                            autovalidateMode: _autovalidateMode,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        AppStrings.changePasswordTitle,
                                        style: TextStyle(fontFamily: AppFonts.primary, 
                                          color: ThemeColors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.s8),
                                      Text(
                                        AppStrings.changePasswordSubtitle,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: ThemeColors.lightTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s22),
                                AuthLabeledField(
                                  required: true,
                                  label: AppStrings.currentPassword,
                                  field: AuthTextField(
                                    controller: _currentPasswordController,
                                    hintText: AppStrings.currentPasswordHint,
                                    obscureText: _obscureCurrentPassword,
                                    validator: _validateCurrentPassword,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureCurrentPassword =
                                              !_obscureCurrentPassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscureCurrentPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: ThemeColors.grey.withValues(
                                          alpha: 200,
                                        ),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s18),
                                AuthLabeledField(
                                  required: true,
                                  label: AppStrings.newPassword,
                                  helper: const PasswordRequirementsHint(),
                                  field: AuthTextField(
                                    controller: _newPasswordController,
                                    hintText: AppStrings.newPasswordHint,
                                    obscureText: _obscureNewPassword,
                                    validator: _validateNewPassword,
                                    onChanged: (_) {
                                      if (_autovalidateMode ==
                                          AutovalidateMode.onUserInteraction) {
                                        _formKey.currentState?.validate();
                                      }
                                    },
                                    suffix: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureNewPassword =
                                              !_obscureNewPassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscureNewPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: ThemeColors.grey.withValues(
                                          alpha: 200,
                                        ),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s18),
                                AuthLabeledField(
                                  required: true,
                                  label: AppStrings.confirmNewPassword,
                                  field: AuthTextField(
                                    controller: _confirmPasswordController,
                                    hintText: AppStrings.confirmNewPasswordHint,
                                    obscureText: _obscureConfirmPassword,
                                    validator: _validateConfirmPassword,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: ThemeColors.grey.withValues(
                                          alpha: 200,
                                        ),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s22),
                                SizedBox(
                                  width: double.infinity,
                                  child: AbsorbPointer(
                                    absorbing: isLoading,
                                    child: Opacity(
                                      opacity: isLoading ? 0.85 : 1,
                                      child: PrimaryButton(
                                        text: AppStrings.changePassword,
                                        isLoading: isLoading,
                                        onPressed: () => _onSubmit(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
