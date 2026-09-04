import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shopnepal/common/theme/app_spacing.dart';
import 'package:shopnepal/common/theme/theme_colors.dart';
import 'package:shopnepal/navigation/navigation.dart';

/// The signed-in shell. Each tab is filled in by its own feature slice in a
/// later sprint; for now they are placeholders so the app is navigable.
@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const _tabs = <_DashboardTab>[
    _DashboardTab(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      placeholder: 'Import orders from supplier photos will appear here.',
    ),
    _DashboardTab(
      label: 'Stock',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      placeholder: 'Per-size stock on hand will appear here.',
    ),
    _DashboardTab(
      label: 'Catalog',
      icon: Icons.style_outlined,
      activeIcon: Icons.style,
      placeholder: 'Products and suppliers will appear here.',
    ),
    _DashboardTab(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      placeholder: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_currentIndex];

    return Scaffold(
      backgroundColor: ThemeColors.pageBackGroundColor,
      appBar: AppBar(
        title: Text(tab.label),
        backgroundColor: ThemeColors.pageBackGroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _currentIndex == 3
          ? const _SettingsTabLauncher()
          : _EmptyTab(message: tab.placeholder),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.activeIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _DashboardTab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String placeholder;

  const _DashboardTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.placeholder,
  });
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeColors.midGrayColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SettingsTabLauncher extends StatelessWidget {
  const _SettingsTabLauncher();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => AppNavigator.toSettings(),
        icon: const Icon(Icons.settings_outlined),
        label: const Text('Open settings'),
      ),
    );
  }
}
