import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/extensions.dart';
import '../../../bills/presentation/views/bills_list_screen.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../../../quick_calculate/presentation/views/quick_calculate_screen.dart';
import '../../../settings/presentation/views/settings_screen.dart';
import '../viewmodels/navigation_viewmodel.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const _screens = <Widget>[
    HomeScreen(),
    BillsListScreen(),
    QuickCalculateScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationViewModelProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) =>
            ref.read(navigationViewModelProvider.notifier).setIndex(i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(PhosphorIconsRegular.house),
            activeIcon: const Icon(PhosphorIconsFill.house),
            label: context.l10n.t('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(PhosphorIconsRegular.receipt),
            activeIcon: const Icon(PhosphorIconsFill.receipt),
            label: context.l10n.t('nav_bills'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(PhosphorIconsRegular.calculator),
            activeIcon: const Icon(PhosphorIconsFill.calculator),
            label: context.l10n.t('nav_calculator'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(PhosphorIconsRegular.gear),
            activeIcon: const Icon(PhosphorIconsFill.gear),
            label: context.l10n.t('nav_settings'),
          ),
        ],
      ),
    );
  }
}
