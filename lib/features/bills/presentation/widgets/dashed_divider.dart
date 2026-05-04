import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';

class DashedDivider extends StatelessWidget {
  final Color? color;
  final double height;

  const DashedDivider({
    super.key,
    this.color,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.outlineVariant;
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: c),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
