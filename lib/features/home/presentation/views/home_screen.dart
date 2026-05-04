import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/banner_ad_widget.dart';
import '../../../bills/presentation/widgets/repeat_bill_card.dart';
import '../../../insights/presentation/providers/insights_providers.dart';
import '../../../main_navigation/presentation/viewmodels/navigation_viewmodel.dart';
import '../widgets/home_header.dart';
import '../widgets/primary_action_card.dart';
import '../widgets/recent_bills_section.dart';
import '../widgets/secondary_actions_row.dart';
import '../widgets/stats_summary.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _goToBillsTab(WidgetRef ref) {
    ref.read(navigationViewModelProvider.notifier).setIndex(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                children: [
                  const HomeHeader(),
                  const SizedBox(height: AppDimensions.spacingXl),
                  PrimaryActionCard(
                    onTap: () => context.push(RouteNames.createBill),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  SecondaryActionsRow(
                    onQuickCalculateTap: () =>
                        context.push(RouteNames.quickCalculate),
                    onMyBillsTap: () => _goToBillsTab(ref),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const StatsSummary(),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const _RepeatBillsSection(),
                  const RecentBillsSection(),
                ],
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _RepeatBillsSection extends ConsumerWidget {
  const _RepeatBillsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternsAsync = ref.watch(billPatternsProvider);

    return patternsAsync.maybeWhen(
      data: (patterns) {
        if (patterns.isEmpty) return const SizedBox.shrink();
        final top = patterns.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.t('home_repeat_bills'),
              style: context.textStyles.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            ...top.map(
              (p) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.spacingSm,
                ),
                child: RepeatBillCard(
                  pattern: p,
                  onTap: () => context.push(
                    RouteNames.repeatBill,
                    extra: p.lastBill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
