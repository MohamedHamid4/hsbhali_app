import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/custom_card.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  static const String _developerName = 'Mohamed Hamid';
  static const String _developerWebsite =
      'https://mohamedhamid4.github.io/MohamedHamid.com/';

  String _version = AppConstants.appVersion;
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).trackAboutOpened();
    });
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } catch (_) {
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('about_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.spacingXl),
            const AppLogo(size: 140),
            const SizedBox(height: AppDimensions.spacingLg),

            Text(
              AppConstants.appName,
              style: AppTextStyles.displayLarge(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              context.l10n.t('app_tagline'),
              style: context.textStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
              ),
              child: Text(
                context.l10n.t('about_description'),
                style: context.textStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),

            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingLg),
                    child: Column(
                      children: [
                        const Icon(
                          PhosphorIconsFill.code,
                          size: 32,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Text(
                          context.l10n.t('about_developed_by'),
                          style: context.textStyles.bodySmall,
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          _developerName,
                          style: AppTextStyles.headingSmall(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: context.colors.outlineVariant,
                  ),
                  ListTile(
                    leading: const Icon(PhosphorIconsRegular.globe),
                    title: Text(
                      context.l10n.t('about_visit_website'),
                      style: context.textStyles.bodyMedium,
                    ),
                    trailing: const Icon(
                      PhosphorIconsRegular.arrowSquareOut,
                      size: AppDimensions.iconSmall,
                    ),
                    onTap: () => _openUrl(_developerWebsite),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),

            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(
                    label: context.l10n.t('about_version'),
                    value: '$_version (build $_buildNumber)',
                  ),
                  Divider(
                    height: 1,
                    color: context.colors.outlineVariant,
                  ),
                  ListTile(
                    leading: const Icon(PhosphorIconsRegular.shield),
                    title: Text(
                      context.l10n.t('privacy_policy_title'),
                      style: context.textStyles.bodyMedium,
                    ),
                    trailing: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? PhosphorIconsRegular.caretLeft
                          : PhosphorIconsRegular.caretRight,
                      size: AppDimensions.iconSmall,
                    ),
                    onTap: () => context.push(RouteNames.privacyPolicy),
                  ),
                  Divider(
                    height: 1,
                    color: context.colors.outlineVariant,
                  ),
                  ListTile(
                    leading: const Icon(PhosphorIconsRegular.fileText),
                    title: Text(
                      context.l10n.t('terms_of_service_title'),
                      style: context.textStyles.bodyMedium,
                    ),
                    trailing: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? PhosphorIconsRegular.caretLeft
                          : PhosphorIconsRegular.caretRight,
                      size: AppDimensions.iconSmall,
                    ),
                    onTap: () => context.push(RouteNames.termsOfService),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            Text(
              context.l10n.t('about_made_with_love'),
              style: context.textStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              '© ${DateTime.now().year} $_developerName',
              style: AppTextStyles.bodySmall(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
