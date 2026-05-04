import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/providers/locale_provider.dart';
import '../../../../app/providers/theme_provider.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/data_cleanup_service.dart';
import '../../../../core/utils/extensions.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/language_selector_dialog.dart';
import '../widgets/remove_ads_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector_dialog.dart';
import '../widgets/whatsapp_template_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isClearing = false;

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.t('common_coming_soon')),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _handleClearAllData() async {
    final confirmed = await _showClearConfirmationDialog();
    if (confirmed != true || !mounted) return;

    setState(() => _isClearing = true);
    try {
      final cleanup = ref.read(dataCleanupServiceProvider);
      await cleanup.clearAllData();
      await ref.read(analyticsServiceProvider).trackAllDataCleared();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('clear_all_data_success'))),
      );

      context.go(RouteNames.splash);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('clear_all_data_error'))),
      );
    } finally {
      if (mounted) setState(() => _isClearing = false);
    }
  }

  Future<bool?> _showClearConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          icon: const Icon(
            PhosphorIconsBold.warningOctagon,
            color: AppColors.error,
            size: 40,
          ),
          title: Text(
            dialogCtx.l10n.t('clear_all_data'),
            textAlign: TextAlign.center,
          ),
          content: Text(
            dialogCtx.l10n.t('clear_all_data_warning'),
            textAlign: TextAlign.center,
            style: dialogCtx.textStyles.bodyMedium,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: Text(dialogCtx.l10n.t('common_cancel')),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: Text(dialogCtx.l10n.t('clear_all_data_confirm')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(settingsViewModelProvider);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('settings_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        children: [
          SettingsSection(
            title: context.l10n.t('settings_appearance'),
            children: [
              SettingsTile(
                icon: PhosphorIconsRegular.palette,
                label: context.l10n.t('settings_theme'),
                trailingText: context.l10n.t(themeModeLabelKey(themeMode)),
                onTap: () => ThemeSelectorDialog.show(context),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.translate,
                label: context.l10n.t('settings_language'),
                trailingText: context.l10n.t(localeLabelKey(locale)),
                onTap: () => LanguageSelectorDialog.show(context),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.currencyDollar,
                label: context.l10n.t('settings_currency'),
                trailingText: context.l10n.t('common_currency_egp'),
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          SettingsSection(
            title: context.l10n.t('shillati'),
            children: [
              SettingsTile(
                icon: PhosphorIconsRegular.usersThree,
                label: context.l10n.t('my_shillas'),
                onTap: () => context.push(RouteNames.shillas),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          SettingsSection(
            title: context.l10n.t('insights_section'),
            children: [
              SettingsTile(
                icon: PhosphorIconsRegular.chartBar,
                label: context.l10n.t('monthly_insights'),
                onTap: () => context.push(RouteNames.monthlyInsights),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.chatCircleText,
                label: context.l10n.t('whatsapp_template'),
                onTap: () => WhatsAppTemplateDialog.show(context),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          SettingsSection(
            title: context.l10n.t('ad_remove_title'),
            children: const [
              RemoveAdsTile(),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          SettingsSection(
            title: context.l10n.t('settings_about'),
            children: [
              SettingsTile(
                icon: PhosphorIconsRegular.info,
                label: context.l10n.t('about_app'),
                onTap: () => context.push(RouteNames.about),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.share,
                label: context.l10n.t('settings_share'),
                onTap: () => _showComingSoon(context),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.star,
                label: context.l10n.t('settings_rate'),
                onTap: () => _showComingSoon(context),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.shieldCheck,
                label: context.l10n.t('settings_privacy'),
                onTap: () => context.push(RouteNames.privacyPolicy),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.fileText,
                label: context.l10n.t('settings_terms'),
                onTap: () => context.push(RouteNames.termsOfService),
              ),
              SettingsTile(
                icon: PhosphorIconsRegular.tag,
                label: context.l10n.t('settings_version'),
                trailingText: vm.appVersion,
                showChevron: false,
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          _DangerZone(
            isLoading: _isClearing,
            onClearAll: _handleClearAllData,
          ),

          const SizedBox(height: AppDimensions.spacingXl),
        ],
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onClearAll;

  const _DangerZone({
    required this.isLoading,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.radiusLg);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: isLoading ? null : onClearAll,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: radius,
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.4),
              width: AppDimensions.borderThin,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  PhosphorIconsBold.trash,
                  color: AppColors.error,
                  size: AppDimensions.iconMedium,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.t('clear_all_data'),
                      style: AppTextStyles.labelLarge(
                        color: AppColors.error,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.t('clear_all_data_subtitle'),
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
