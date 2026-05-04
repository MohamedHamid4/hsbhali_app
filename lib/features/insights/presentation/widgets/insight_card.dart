import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';

class InsightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  final Color? accentColor;

  const InsightCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AppDimensions.iconMedium,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  label,
                  style: context.textStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: context.colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              subtitle!,
              style: context.textStyles.bodySmall?.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class TrendBadge extends StatelessWidget {
  final double percentage;
  final bool increased;

  const TrendBadge({
    super.key,
    required this.percentage,
    required this.increased,
  });

  @override
  Widget build(BuildContext context) {
    final color = increased ? AppColors.error : AppColors.success;
    final icon = increased
        ? PhosphorIconsBold.trendUp
        : PhosphorIconsBold.trendDown;

    final label = increased
        ? context.l10n
            .t('change_increased')
            .replaceAll('{percent}', percentage.abs().toStringAsFixed(0))
        : context.l10n
            .t('change_decreased')
            .replaceAll('{percent}', percentage.abs().toStringAsFixed(0));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppDimensions.iconSmall),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            label,
            style: AppTextStyles.numberStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
