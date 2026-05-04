import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/shilla_suggestion.dart';

class ShillaSuggestionBanner extends StatelessWidget {
  final ShillaSuggestion suggestion;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  const ShillaSuggestionBanner({
    super.key,
    required this.suggestion,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(
        AppDimensions.spacingLg,
        AppDimensions.spacingSm,
        AppDimensions.spacingLg,
        AppDimensions.spacingSm,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.30),
          width: AppDimensions.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  PhosphorIconsBold.lightbulb,
                  color: AppColors.primary,
                  size: AppDimensions.iconMedium,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${context.l10n.t('shilla_suggestion_title')} (${suggestion.shilla.name})',
                      style: context.textStyles.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      suggestion.reason,
                      style: context.textStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Row(
            children: [
              SizedBox(
                height: AppDimensions.buttonSmall,
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(
                    PhosphorIconsBold.check,
                    size: AppDimensions.iconSmall,
                  ),
                  label: Text(context.l10n.t('shilla_suggestion_use')),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              SizedBox(
                height: AppDimensions.buttonSmall,
                child: TextButton(
                  onPressed: onDismiss,
                  child: Text(context.l10n.t('shilla_suggestion_dismiss')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
