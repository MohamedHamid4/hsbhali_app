import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../providers/split_provider.dart';
import '../viewmodels/bill_details_viewmodel.dart';
import '../viewmodels/home_stats_viewmodel.dart';
import '../widgets/split_summary_card.dart';

class SplitResultScreen extends ConsumerWidget {
  final String billId;

  const SplitResultScreen({super.key, required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsState = ref.watch(billDetailsViewModelProvider(billId));

    return Scaffold(
      appBar: AppBar(
        title: Text(detailsState.bill?.placeName?.trim().isNotEmpty == true
            ? detailsState.bill!.placeName!
            : context.l10n.t('result_title')),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.house),
            onPressed: () => context.go(RouteNames.main),
          ),
        ],
      ),
      body: detailsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailsState.bill == null
              ? EmptyStateWidget(
                  icon: PhosphorIconsRegular.warning,
                  title: context.l10n.t('common_error'),
                  description: detailsState.errorMessage ?? '',
                )
              : _SplitContent(billId: billId),
    );
  }
}

class _SplitContent extends ConsumerWidget {
  final String billId;
  const _SplitContent({required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billState = ref.watch(billDetailsViewModelProvider(billId));
    final bill = billState.bill!;
    final asyncSplit = ref.watch(splitResultProvider(bill));
    final currency = bill.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');

    return asyncSplit.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyStateWidget(
        icon: PhosphorIconsRegular.warning,
        title: context.l10n.t('common_error'),
        description: e.toString(),
      ),
      data: (split) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingXl),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            PhosphorIconsBold.checkCircle,
                            color: Colors.white,
                            size: AppDimensions.iconLarge,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Text(
                          context.l10n.t('result_title'),
                          style: context.textStyles.headlineLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Text(
                          context.l10n.t('total_amount'),
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          '${split.grandTotal.toStringAsFixed(2)} $currency',
                          style: AppTextStyles.numberStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  Text(
                    context.l10n.t('per_person'),
                    style: context.textStyles.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  ...split.shares.map((share) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingSm,
                        ),
                        child: SplitSummaryCard(
                          share: share,
                          currency: currency,
                          place: bill.placeName ?? '',
                        ),
                      )),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Column(
                children: [
                  SecondaryButton(
                    text: context.l10n.t('share_bill'),
                    icon: PhosphorIconsBold.shareNetwork,
                    onPressed: () => context.push(
                      '${RouteNames.shareBill}/$billId',
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  PrimaryButton(
                    text: context.l10n.t('common_done'),
                    icon: PhosphorIconsBold.check,
                    onPressed: () {
                      ref.invalidate(homeStatsAsyncProvider);
                      ref.invalidate(recentBillsAsyncProvider);
                      context.go(RouteNames.main);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
