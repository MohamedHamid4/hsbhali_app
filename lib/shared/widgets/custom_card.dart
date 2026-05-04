import 'package:flutter/material.dart';

import '../../app/theme/app_dimensions.dart';
import '../../core/utils/extensions.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.spacingLg),
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.borderRadius = AppDimensions.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final isDark = context.isDark;

    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null
            ? (backgroundColor ?? context.colors.surfaceContainerHighest)
            : null,
        gradient: gradient,
        borderRadius: radius,
        border: gradient == null
            ? Border.all(
                color: context.colors.outlineVariant,
                width: AppDimensions.borderThin,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: container,
      ),
    );
  }
}
