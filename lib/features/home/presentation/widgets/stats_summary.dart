import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../bills/domain/entities/bill_stats.dart';
import '../../../bills/presentation/viewmodels/home_stats_viewmodel.dart';

class StatsSummary extends ConsumerWidget {
  const StatsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsAsyncProvider);

    final stats = statsAsync.maybeWhen(
      data: (s) => s,
      orElse: () => BillStats.empty,
    );

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: PhosphorIconsBold.receipt,
            color: AppColors.primary,
            label: context.l10n.t('home_stats_count'),
            value: stats.totalBillsCount.toString(),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: _StatCard(
            icon: PhosphorIconsBold.wallet,
            color: AppColors.secondary,
            label: context.l10n.t('home_stats_total'),
            value: stats.monthTotal.toStringAsFixed(0),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: _StatCard(
            icon: PhosphorIconsBold.mapPin,
            color: AppColors.accentDark,
            label: context.l10n.t('home_stats_top_place'),
            value: stats.topPlace ?? '—',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppDimensions.iconSmall),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            label,
            style: context.textStyles.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
