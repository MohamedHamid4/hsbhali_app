import 'package:flutter/material.dart';

import '../../app/theme/app_dimensions.dart';
import '../../core/utils/extensions.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? actionButton;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionButton,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize * 1.6,
              height: iconSize * 1.6,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              title,
              style: context.textStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              description,
              style: context.textStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              const SizedBox(height: AppDimensions.spacingXl),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
