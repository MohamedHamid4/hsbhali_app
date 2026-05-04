import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/banner_ad_widget.dart';
import '../viewmodels/bills_list_viewmodel.dart';
import '../viewmodels/home_stats_viewmodel.dart';
import '../widgets/bill_card.dart';
import '../widgets/empty_bills_state.dart';

class BillsListScreen extends ConsumerWidget {
  const BillsListScreen({super.key});

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.t('delete_bill')),
        content: Text(context.l10n.t('delete_bill_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.t('common_cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.t('common_delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(billsListViewModelProvider.notifier).deleteBill(id);
      if (!context.mounted) return;
      ref.invalidate(homeStatsAsyncProvider);
      ref.invalidate(recentBillsAsyncProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('bill_deleted'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billsListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('bills_title')),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(billsListViewModelProvider.notifier).loadBills(),
              child: _buildBody(context, ref, state),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.createBill),
        icon: const Icon(PhosphorIconsBold.plus),
        label: Text(context.l10n.t('create_bill_title')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BillsListState state) {
    if (state.isLoading && state.bills.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.bills.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: EmptyBillsState(
              onCreateBill: () => context.push(RouteNames.createBill),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      itemCount: state.bills.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.spacingSm),
      itemBuilder: (_, i) {
        final bill = state.bills[i];
        return RepaintBoundary(
          child: BillCard(
            bill: bill,
            onTap: () =>
                context.push('${RouteNames.billDetails}/${bill.id}'),
            onLongPress: () => _confirmAndDelete(context, ref, bill.id),
          ),
        );
      },
    );
  }
}
