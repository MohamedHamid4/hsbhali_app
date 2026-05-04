import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).trackPrivacyViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('privacy_policy_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(text: context.l10n.t('privacy_intro_title')),
            _SectionBody(text: context.l10n.t('privacy_intro_body')),

            _SectionTitle(text: context.l10n.t('privacy_data_collected_title')),
            _SectionBody(text: context.l10n.t('privacy_data_collected_body')),

            _SectionTitle(text: context.l10n.t('privacy_data_usage_title')),
            _SectionBody(text: context.l10n.t('privacy_data_usage_body')),

            _SectionTitle(text: context.l10n.t('privacy_third_parties_title')),
            _SectionBody(text: context.l10n.t('privacy_third_parties_body')),

            _SectionTitle(text: context.l10n.t('privacy_storage_title')),
            _SectionBody(text: context.l10n.t('privacy_storage_body')),

            _SectionTitle(text: context.l10n.t('privacy_ads_title')),
            _SectionBody(text: context.l10n.t('privacy_ads_body')),

            _SectionTitle(text: context.l10n.t('privacy_children_title')),
            _SectionBody(text: context.l10n.t('privacy_children_body')),

            _SectionTitle(text: context.l10n.t('privacy_changes_title')),
            _SectionBody(text: context.l10n.t('privacy_changes_body')),

            _SectionTitle(text: context.l10n.t('privacy_contact_title')),
            _SectionBody(text: context.l10n.t('privacy_contact_body')),

            const SizedBox(height: AppDimensions.spacingXl),
            Text(
              context.l10n.t('privacy_last_updated'),
              style: AppTextStyles.bodySmall(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.spacingLg,
        bottom: AppDimensions.spacingSm,
      ),
      child: Text(
        text,
        style: AppTextStyles.headingSmall(color: AppColors.primary),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String text;
  const _SectionBody({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textStyles.bodyMedium,
      textAlign: TextAlign.justify,
    );
  }
}
