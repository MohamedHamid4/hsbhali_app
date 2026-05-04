import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../viewmodels/quick_calculate_viewmodel.dart';

class ResultCard extends ConsumerWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickCalculateViewModelProvider);
    final currency = context.l10n.t('common_currency_egp');

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXl),
          topRight: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Row(
              label: context.l10n.t('quick_calc_total'),
              value: '${state.amount.toStringAsFixed(2)} $currency',
              isMuted: true,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            _Row(
              label: context.l10n.t('quick_calc_tip'),
              value: '${state.tipAmount.toStringAsFixed(2)} $currency',
              isMuted: true,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            _Row(
              label: context.l10n.t('quick_calc_grand_total'),
              value: '${state.grandTotal.toStringAsFixed(2)} $currency',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.spacingMd,
              ),
              child: Divider(color: Colors.white30, height: 1),
            ),
            Text(
              context.l10n.t('quick_calc_per_person'),
              style: context.textStyles.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              '${state.perPerson.toStringAsFixed(2)} $currency',
              style: AppTextStyles.numberStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isMuted;

  const _Row({
    required this.label,
    required this.value,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMuted
        ? Colors.white.withValues(alpha: 0.85)
        : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.bodyMedium?.copyWith(color: color),
        ),
        Text(
          value,
          style: AppTextStyles.numberStyle(
            fontSize: 14,
            fontWeight: isMuted ? FontWeight.w500 : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
