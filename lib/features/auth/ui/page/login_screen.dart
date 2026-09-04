import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';
import 'package:shopnepal/common/widgets/auth_app_logo.dart';
import 'package:shopnepal/features/auth/ui/widget/login_sheet.dart';

/// Entry point for an unauthenticated session. There is no back destination —
/// an internal tool has no browsable guest mode.
@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginBusy = false;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: ThemeColors.primaryColor,
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: AbsorbPointer(
          absorbing: _isLoginBusy,
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: _isLoginBusy
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: AuthAppLogo(
                    expandedHeight: 180,
                    isKeyboardOpen: isKeyboardOpen,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ThemeColors.pageBackGroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(34),
                      ),
                    ),
                    child: LoginSheet(
                      onBusyChanged: (isBusy) {
                        if (_isLoginBusy == isBusy) return;
                        setState(() => _isLoginBusy = isBusy);
                      },
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
