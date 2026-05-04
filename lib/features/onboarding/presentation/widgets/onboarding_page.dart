import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color illustrationColor;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.illustrationColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: illustrationColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 110,
              color: illustrationColor,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: AppDimensions.spacingXxxl),

          Text(
            title,
            style: context.textStyles.headlineLarge,
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppDimensions.spacingMd),

          Text(
            description,
            style: context.textStyles.bodyLarge,
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
