import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';

class SecondaryActionsRow extends StatelessWidget {
  final VoidCallback onQuickCalculateTap;
  final VoidCallback onMyBillsTap;

  const SecondaryActionsRow({
    super.key,
    required this.onQuickCalculateTap,
    required this.onMyBillsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SecondaryActionCard(
            icon: PhosphorIconsBold.calculator,
            label: context.l10n.t('home_quick_calculate'),
            color: AppColors.secondary,
            onTap: onQuickCalculateTap,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _SecondaryActionCard(
            icon: PhosphorIconsBold.receipt,
            label: context.l10n.t('home_my_bills'),
            color: AppColors.accentDark,
            onTap: onMyBillsTap,
          ),
        ),
      ],
    );
  }
}

class _SecondaryActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SecondaryActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconMedium,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            label,
            style: context.textStyles.labelLarge,
          ),
        ],
      ),
    );
  }
}
