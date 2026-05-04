import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/locale_provider.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../viewmodels/settings_viewmodel.dart';

class LanguageSelectorDialog extends ConsumerWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(settingsViewModelProvider);
    final current = ref.watch(localeProvider);

    return AlertDialog(
      title: Text(context.l10n.t('settings_language')),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: RadioGroup<String>(
        groupValue: current.languageCode,
        onChanged: (selected) async {
          if (selected == null) return;
          final newLocale = AppLocalizations.supportedLocales.firstWhere(
            (l) => l.languageCode == selected,
          );
          await vm.setLocale(newLocale);
          if (context.mounted) Navigator.of(context).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLocalizations.supportedLocales.map((locale) {
            return RadioListTile<String>(
              value: locale.languageCode,
              title: Text(context.l10n.t(localeLabelKey(locale))),
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
