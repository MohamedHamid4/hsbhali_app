import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bills/presentation/viewmodels/home_stats_viewmodel.dart';
import '../../../bills/presentation/widgets/bill_card.dart';
import 'empty_recent_bills.dart';

class RecentBillsSection extends ConsumerWidget {
  const RecentBillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBills = ref.watch(recentBillsAsyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.t('home_recent_bills'),
          style: context.textStyles.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        asyncBills.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingXl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            child: Text(e.toString(), style: context.textStyles.bodySmall),
          ),
          data: (bills) {
            if (bills.isEmpty) return const EmptyRecentBills();
            return Column(
              children: [
                ...bills.map((bill) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: BillCard(
                        bill: bill,
                        onTap: () => context
                            .push('${RouteNames.billDetails}/${bill.id}'),
                      ),
                    )),
              ],
            );
          },
        ),
      ],
    );
  }
}
