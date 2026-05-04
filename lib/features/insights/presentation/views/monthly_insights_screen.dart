import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../people/presentation/widgets/person_avatar.dart';
import '../../domain/entities/monthly_insights.dart';
import '../../domain/usecases/get_monthly_insights.dart';
import '../providers/insights_providers.dart';
import '../widgets/insight_card.dart';
import '../widgets/weekly_spending_chart.dart';

class MonthlyInsightsScreen extends ConsumerStatefulWidget {
  const MonthlyInsightsScreen({super.key});

  @override
  ConsumerState<MonthlyInsightsScreen> createState() =>
      _MonthlyInsightsScreenState();
}

class _MonthlyInsightsScreenState
    extends ConsumerState<MonthlyInsightsScreen> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = DateTime(now.year, now.month);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).trackInsightsViewed();
    });
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year, now.month),
      initialDatePickerMode: DatePickerMode.year,
      helpText: context.l10n.t('select_month'),
    );
    if (picked != null) {
      setState(() => _selected = DateTime(picked.year, picked.month));
    }
  }

  String _monthLabel(BuildContext context) {
    final localeCode =
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'ar_EG'
            : 'en_US';
    return DateFormat('MMMM yyyy', localeCode).format(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final params = GetMonthlyInsightsParams(
      year: _selected.year,
      month: _selected.month,
    );
    final asyncInsights = ref.watch(monthlyInsightsProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('monthly_insights_title')),
        actions: [
          IconButton(
            tooltip: context.l10n.t('change_month'),
            icon: const Icon(PhosphorIconsRegular.calendar),
            onPressed: _pickMonth,
          ),
        ],
      ),
      body: asyncInsights.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyStateWidget(
          icon: PhosphorIconsRegular.warning,
          title: context.l10n.t('common_error'),
          description: e.toString(),
        ),
        data: (insights) {
          if (insights == null || insights.isEmpty) {
            return _EmptyView(
              monthLabel: _monthLabel(context),
              onChangeMonth: _pickMonth,
            );
          }
          return _InsightsBody(
            insights: insights,
            monthLabel: _monthLabel(context),
            onChangeMonth: _pickMonth,
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String monthLabel;
  final VoidCallback onChangeMonth;

  const _EmptyView({
    required this.monthLabel,
    required this.onChangeMonth,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: PhosphorIconsRegular.chartBar,
      title: monthLabel,
      description: context.l10n.t('no_data_this_month'),
      actionButton: TextButton.icon(
        onPressed: onChangeMonth,
        icon: const Icon(PhosphorIconsRegular.calendar),
        label: Text(context.l10n.t('change_month')),
      ),
    );
  }
}

class _InsightsBody extends StatelessWidget {
  final MonthlyInsights insights;
  final String monthLabel;
  final VoidCallback onChangeMonth;

  const _InsightsBody({
    required this.insights,
    required this.monthLabel,
    required this.onChangeMonth,
  });

  String _currencySymbol(BuildContext context) =>
      context.l10n.t('common_currency_egp');

  @override
  Widget build(BuildContext context) {
    final currency = _currencySymbol(context);

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    PhosphorIconsBold.calendar,
                    color: Colors.white,
                    size: AppDimensions.iconMedium,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(
                    monthLabel,
                    style: context.textStyles.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                context.l10n.t('monthly_total'),
                style: context.textStyles.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                '${insights.totalSpending.toStringAsFixed(2)} $currency',
                style: AppTextStyles.numberStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              if (insights.hasPreviousData) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                TrendBadge(
                  percentage: insights.changePercentage,
                  increased: insights.spendingIncreased,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),

        Row(
          children: [
            Expanded(
              child: InsightCard(
                icon: PhosphorIconsBold.receipt,
                label: context.l10n.t('monthly_count'),
                value: insights.billsCount.toString(),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: InsightCard(
                icon: PhosphorIconsBold.wallet,
                label: context.l10n.t('monthly_avg'),
                value: insights.averageBillAmount.toStringAsFixed(0),
                subtitle: currency,
                accentColor: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXl),

        if (insights.topPlaces.isNotEmpty) ...[
          Text(
            context.l10n.t('top_places'),
            style: context.textStyles.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          ...insights.topPlaces.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingSm,
                  ),
                  child: _PlaceRow(
                    rank: e.key + 1,
                    place: e.value,
                    currency: currency,
                  ),
                ),
              ),
          const SizedBox(height: AppDimensions.spacingXl),
        ],

        if (insights.topCompanions.isNotEmpty) ...[
          Text(
            context.l10n.t('top_companions'),
            style: context.textStyles.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          ...insights.topCompanions.map(
            (p) => Padding(
              padding:
                  const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: _PersonRow(person: p),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),
        ],

        Text(
          context.l10n.t('weekly_breakdown'),
          style: context.textStyles.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        RepaintBoundary(
          child: WeeklySpendingChart(weeks: insights.weeklyBreakdown),
        ),
        const SizedBox(height: AppDimensions.spacingXl),

        Center(
          child: TextButton.icon(
            onPressed: onChangeMonth,
            icon: const Icon(PhosphorIconsRegular.calendar),
            label: Text(context.l10n.t('change_month')),
          ),
        ),
      ],
    );
  }
}

class _PlaceRow extends StatelessWidget {
  final int rank;
  final PlaceFrequency place;
  final String currency;

  const _PlaceRow({
    required this.rank,
    required this.place,
    required this.currency,
  });

  Color _rankColor(BuildContext context) {
    return switch (rank) {
      1 => AppColors.accentDark,
      2 => AppColors.secondary,
      _ => AppColors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _rankColor(context);
    final visitsText = context.l10n
        .t('visits_n_times')
        .replaceAll('{count}', place.visitCount.toString());

    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '#$rank',
              style: AppTextStyles.numberStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place.placeName,
                  style: context.textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  visitsText,
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${place.totalSpent.toStringAsFixed(0)} $currency',
            style: AppTextStyles.numberStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final PersonFrequency person;

  const _PersonRow({required this.person});

  @override
  Widget build(BuildContext context) {
    final sharedText = context.l10n
        .t('shared_n_bills')
        .replaceAll('{count}', person.sharedBillsCount.toString());

    return CustomCard(
      child: Row(
        children: [
          PersonAvatar(
            name: person.personName,
            colorIndex: person.colorIndex,
            size: AvatarSize.medium,
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  person.personName,
                  style: context.textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sharedText,
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
