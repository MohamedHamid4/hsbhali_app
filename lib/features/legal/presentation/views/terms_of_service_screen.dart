import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';

class TermsOfServiceScreen extends ConsumerStatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  ConsumerState<TermsOfServiceScreen> createState() =>
      _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends ConsumerState<TermsOfServiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).trackTermsViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('terms_of_service_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(text: context.l10n.t('terms_intro_title')),
            _SectionBody(text: context.l10n.t('terms_intro_body')),

            _SectionTitle(text: context.l10n.t('terms_usage_title')),
            _SectionBody(text: context.l10n.t('terms_usage_body')),

            _SectionTitle(
              text: context.l10n.t('terms_user_responsibilities_title'),
            ),
            _SectionBody(
              text: context.l10n.t('terms_user_responsibilities_body'),
            ),

            _SectionTitle(
              text: context.l10n.t('terms_intellectual_property_title'),
            ),
            _SectionBody(
              text: context.l10n.t('terms_intellectual_property_body'),
            ),

            _SectionTitle(text: context.l10n.t('terms_disclaimers_title')),
            _SectionBody(text: context.l10n.t('terms_disclaimers_body')),

            _SectionTitle(text: context.l10n.t('terms_limitations_title')),
            _SectionBody(text: context.l10n.t('terms_limitations_body')),

            _SectionTitle(text: context.l10n.t('terms_changes_title')),
            _SectionBody(text: context.l10n.t('terms_changes_body')),

            _SectionTitle(text: context.l10n.t('terms_contact_title')),
            _SectionBody(text: context.l10n.t('terms_contact_body')),

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
