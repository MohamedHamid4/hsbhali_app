import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/bill_item.dart';

class BillItemTile extends StatelessWidget {
  final BillItem item;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BillItemTile({
    super.key,
    required this.item,
    required this.currency,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingXs,
      ),
      title: Text(
        item.name,
        style: context.textStyles.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} $currency',
        style: context.textStyles.bodySmall,
      ),
      trailing: Text(
        '${item.totalPrice.toStringAsFixed(2)} $currency',
        style: AppTextStyles.numberStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: context.colors.onSurface,
        ),
      ),
      onTap: onTap,
    );

    if (onDelete == null) return tile;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete!(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: AppColors.error.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
        child: const Icon(
          PhosphorIconsBold.trash,
          color: AppColors.error,
        ),
      ),
      child: tile,
    );
  }
}
