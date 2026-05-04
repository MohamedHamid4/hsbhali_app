import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/bill_pattern.dart';

class RepeatBillCard extends StatelessWidget {
  final BillPattern pattern;
  final VoidCallback? onTap;

  const RepeatBillCard({
    super.key,
    required this.pattern,
    this.onTap,
  });

  String _relativeDate(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final visit = DateTime(
      pattern.lastVisit.year,
      pattern.lastVisit.month,
      pattern.lastVisit.day,
    );
    final diff = today.difference(visit).inDays;

    if (diff == 0) return context.l10n.t('today');
    if (diff == 1) return context.l10n.t('yesterday');
    if (diff < 7) {
      return context.l10n.t('days_ago').replaceAll('{days}', '$diff');
    }
    return pattern.lastVisit.formattedArabic;
  }

  @override
  Widget build(BuildContext context) {
    final currency = pattern.lastBill.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');
    final visitsText = context.l10n
        .t('visits_count')
        .replaceAll('{count}', '${pattern.visitCount}');

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              PhosphorIconsBold.arrowClockwise,
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
                  pattern.placeName,
                  style: context.textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.l10n.t('last_visit')}: ${_relativeDate(context)} • $visitsText',
                  style: context.textStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pattern.averageAmount.toStringAsFixed(0),
                style: AppTextStyles.numberStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.colors.onSurface,
                ),
              ),
              Text(
                currency,
                style: context.textStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
