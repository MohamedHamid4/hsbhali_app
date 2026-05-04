import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/bill.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BillCard({
    super.key,
    required this.bill,
    this.onTap,
    this.onLongPress,
  });

  String _relativeDate(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final billDate =
        DateTime(bill.createdAt.year, bill.createdAt.month, bill.createdAt.day);
    final diff = today.difference(billDate).inDays;

    if (diff == 0) return context.l10n.t('today');
    if (diff == 1) return context.l10n.t('yesterday');
    if (diff < 7) {
      return context.l10n.t('days_ago').replaceAll('{days}', '$diff');
    }
    return bill.createdAt.formattedArabic;
  }

  @override
  Widget build(BuildContext context) {
    final placeName = bill.placeName?.trim().isNotEmpty == true
        ? bill.placeName!
        : context.l10n.t('bill_untitled');

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: CustomCard(
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
                PhosphorIconsBold.receipt,
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
                    placeName,
                    style: context.textStyles.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _relativeDate(context),
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bill.total.toStringAsFixed(2),
                  style: AppTextStyles.numberStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: context.colors.onSurface,
                  ),
                ),
                Text(
                  bill.currency == 'EGP'
                      ? context.l10n.t('common_currency_egp')
                      : context.l10n.t('common_currency_usd'),
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
