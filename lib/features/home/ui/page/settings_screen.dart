import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/common/cubit/data_state.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme.dart';
import 'package:shopnepal/common/utils/card_boxshadow_utils.dart';
import 'package:shopnepal/common/utils/user_listener.dart';
import 'package:shopnepal/common/widgets/page_wrapper.dart';
import 'package:shopnepal/features/auth/bloc/logout_cubit.dart';
import 'package:shopnepal/features/home/ui/widget/settings_switch_row.dart';
import 'package:shopnepal/navigation/navigation.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonSuccess) {
          AppNavigator.toLogin();
        }
      },
      child: PageWrapper(
        title: 'Settings',
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SettingsCard(child: _AccountSection()),
              const SizedBox(height: AppSpacing.s16),
              _SettingsCard(child: _AppearanceSection()),
              const SizedBox(height: AppSpacing.s16),
              const _SettingsCard(child: _SecuritySection()),
              const SizedBox(height: AppSpacing.s24),
              const _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        boxShadow: [CardBoxShadowUtils.cardBoxShadow],
      ),
      child: child,
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    return UserListener(
      builder: (context, model) {
        final user = model.userModel;
        final name = [
          user?.firstName ?? '',
          user?.lastName ?? '',
        ].where((part) => part.isNotEmpty).join(' ');
        final contact = (user?.email?.isNotEmpty ?? false)
            ? user!.email!
            : (user?.phone ?? '');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.isEmpty ? 'Signed in' : name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThemeColors.black,
              ),
            ),
            if (contact.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                contact,
                style: const TextStyle(
                  fontSize: 13,
                  color: ThemeColors.midGrayColor,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeManager(),
      builder: (context, child) {
        return SettingsSwitchRow(
          title: 'Dark theme',
          value: ThemeManager().isDark,
          showDivider: false,
          onChanged: (_) => ThemeManager().toggleTheme(),
        );
      },
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.toChangePassword(),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Change password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: ThemeColors.black,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: ThemeColors.midGrayColor),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.read<LogoutCubit>().logout(),
      icon: const Icon(Icons.logout, color: ThemeColors.red),
      label: const Text(
        'Log out',
        style: TextStyle(color: ThemeColors.red, fontWeight: FontWeight.w600),
      ),
    );
  }
}
