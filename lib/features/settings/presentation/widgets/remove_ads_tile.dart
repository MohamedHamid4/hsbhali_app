import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/services/ads_service.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import 'settings_tile.dart';

class RemoveAdsTile extends ConsumerWidget {
  const RemoveAdsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsService = ref.watch(adsServiceProvider);

    if (adsService.areAdsRemoved) {
      return SettingsTile(
        icon: PhosphorIconsRegular.checkCircle,
        label: context.l10n.t('ad_purchase_success'),
        showChevron: false,
      );
    }

    return SettingsTile(
      icon: PhosphorIconsRegular.crown,
      label: context.l10n.t('ad_remove_title'),
      trailingText: '\$0.99',
      onTap: () {
        ref.read(analyticsServiceProvider).trackRemoveAdsTapped();
        _showPurchaseDialog(context, ref);
      },
    );
  }

  Future<void> _showPurchaseDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.t('ad_remove_title')),
        content: Text(context.l10n.t('ad_remove_desc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.t('common_cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.t('common_coming_soon')),
                ),
              );
            },
            child: Text(context.l10n.t('ad_remove_button')),
          ),
        ],
      ),
    );
  }
}
