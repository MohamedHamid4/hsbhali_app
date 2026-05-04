import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;

  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final chevronIcon =
        isRtl ? PhosphorIconsRegular.caretLeft : PhosphorIconsRegular.caretRight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingMd,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppDimensions.iconMedium,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Text(label, style: context.textStyles.bodyLarge),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
              ],
              if (onTap != null && showChevron)
                Icon(
                  chevronIcon,
                  size: AppDimensions.iconSmall,
                  color: context.colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
