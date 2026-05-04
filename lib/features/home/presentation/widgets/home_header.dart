import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greetingKey = ref.watch(greetingKeyProvider);

    return Row(
      children: [
        const AppLogoSmall(),
        const SizedBox(width: AppDimensions.spacingMd),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.t(greetingKey)}!',
                style: context.textStyles.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                context.l10n.t('home_subtitle'),
                style: context.textStyles.headlineLarge,
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Icon(
            PhosphorIconsRegular.bell,
            size: AppDimensions.iconMedium,
            color: context.colors.onSurface,
          ),
        ),
      ],
    );
  }
}
