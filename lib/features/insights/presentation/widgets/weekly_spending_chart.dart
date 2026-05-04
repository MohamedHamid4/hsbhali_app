import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/monthly_insights.dart';

class WeeklySpendingChart extends StatelessWidget {
  final List<WeeklySpending> weeks;

  const WeeklySpendingChart({super.key, required this.weeks});

  @override
  Widget build(BuildContext context) {
    final maxAmount = weeks.fold<double>(
      0,
      (m, w) => w.amount > m ? w.amount : m,
    );

    final maxY = maxAmount == 0 ? 100.0 : (maxAmount * 1.2);

    return CustomCard(
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,
            barGroups: weeks.map((w) {
              return BarChartGroupData(
                x: w.weekNumber,
                barRods: [
                  BarChartRodData(
                    toY: w.amount,
                    width: 22,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ],
              );
            }).toList(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (_) => FlLine(
                color: context.colors.outlineVariant,
                strokeWidth: 1,
                dashArray: const [4, 4],
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  getTitlesWidget: (value, meta) {
                    final n = value.toInt();
                    if (n < 1 || n > 5) return const SizedBox.shrink();
                    final label = context.l10n
                        .t('week_n')
                        .replaceAll('{n}', '$n');
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.spacingXs,
                      ),
                      child: Text(
                        label,
                        style: context.textStyles.labelSmall,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: maxY / 4,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 4),
                      child: Text(
                        value.toInt().toString(),
                        style: AppTextStyles.numberStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => context.colors.surface,
                tooltipRoundedRadius: AppDimensions.radiusSm,
                getTooltipItem: (group, _, rod, __) {
                  return BarTooltipItem(
                    rod.toY.toStringAsFixed(0),
                    AppTextStyles.numberStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.colors.onSurface,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
