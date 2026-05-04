import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/theme_provider.dart';
import '../../../../core/utils/extensions.dart';
import '../viewmodels/settings_viewmodel.dart';

class ThemeSelectorDialog extends ConsumerWidget {
  const ThemeSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const ThemeSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(settingsViewModelProvider);
    final current = ref.watch(themeProvider);

    return AlertDialog(
      title: Text(context.l10n.t('settings_theme')),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (selected) async {
          if (selected == null) return;
          await vm.setTheme(selected);
          if (context.mounted) Navigator.of(context).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              value: mode,
              title: Text(context.l10n.t(themeModeLabelKey(mode))),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.t('common_cancel')),
        ),
      ],
    );
  }
}
