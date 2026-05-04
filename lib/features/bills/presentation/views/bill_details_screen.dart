import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../domain/entities/bill.dart';
import '../viewmodels/bill_details_viewmodel.dart';
import '../viewmodels/home_stats_viewmodel.dart';
import '../widgets/bill_item_tile.dart';

class BillDetailsScreen extends ConsumerWidget {
  final String billId;

  const BillDetailsScreen({super.key, required this.billId});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.t('common_coming_soon'))),
      );
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
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

    if (confirmed != true) return;
    final ok =
        await ref.read(billDetailsViewModelProvider(billId).notifier).delete();
    if (!context.mounted) return;
    if (ok) {
      ref.invalidate(homeStatsAsyncProvider);
      ref.invalidate(recentBillsAsyncProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('bill_deleted'))),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billDetailsViewModelProvider(billId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.bill?.placeName?.trim().isNotEmpty == true
              ? state.bill!.placeName!
              : context.l10n.t('bill_details_title'),
        ),
        actions: [
          if ((state.bill?.people.length ?? 0) >= 2)
            IconButton(
              tooltip: context.l10n.t('view_details'),
              icon: const Icon(PhosphorIconsRegular.usersThree),
              onPressed: () =>
                  context.push('${RouteNames.splitResult}/$billId'),
            ),
          IconButton(
            tooltip: context.l10n.t('common_share'),
            icon: const Icon(PhosphorIconsRegular.shareNetwork),
            onPressed: () => _showComingSoon(context),
          ),
          IconButton(
            tooltip: context.l10n.t('common_edit'),
            icon: const Icon(PhosphorIconsRegular.pencilSimple),
            onPressed: () => context.push('${RouteNames.editBill}/$billId'),
          ),
          IconButton(
            tooltip: context.l10n.t('common_delete'),
            icon: const Icon(PhosphorIconsRegular.trash),
            onPressed: () => _confirmAndDelete(context, ref),
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, BillDetailsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null || state.bill == null) {
      return EmptyStateWidget(
        icon: PhosphorIconsRegular.warning,
        title: context.l10n.t('common_error'),
        description: state.errorMessage ?? '',
      );
    }
    return _DetailsContent(bill: state.bill!);
  }
}

class _DetailsContent extends StatelessWidget {
  final Bill bill;
  const _DetailsContent({required this.bill});

  @override
  Widget build(BuildContext context) {
    final currency = bill.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      children: [
        if (bill.receiptImagePath != null) ...[
          GestureDetector(
            onTap: () => _openFullScreenImage(context, bill.receiptImagePath!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: Image.file(
                File(bill.receiptImagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: context.colors.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(PhosphorIconsRegular.imageBroken, size: 48),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
        ],

        CustomCard(
          child: Row(
            children: [
              const Icon(PhosphorIconsRegular.calendar),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.createdAt.formattedArabic,
                      style: context.textStyles.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      bill.createdAt.timeOnly,
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),

        Text(
          context.l10n.t('bill_items'),
          style: context.textStyles.labelLarge,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        if (bill.items.isEmpty)
          CustomCard(
            child: Text(
              context.l10n.t('bill_no_items'),
              style: context.textStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          CustomCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: bill.items
                  .map((i) => BillItemTile(item: i, currency: bill.currency))
                  .toList(),
            ),
          ),

        const SizedBox(height: AppDimensions.spacingLg),

        CustomCard(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            children: [
              _AmountRow(
                label: context.l10n.t('subtotal'),
                value: '${bill.subtotal.toStringAsFixed(2)} $currency',
              ),
              if (bill.taxAmount > 0)
                _AmountRow(
                  label: context.l10n.t('tax'),
                  value: '${bill.taxAmount.toStringAsFixed(2)} $currency',
                ),
              if (bill.tipAmount > 0)
                _AmountRow(
                  label: context.l10n.t('tip'),
                  value: '${bill.tipAmount.toStringAsFixed(2)} $currency',
                ),
              if (bill.serviceCharge > 0)
                _AmountRow(
                  label: context.l10n.t('service_charge'),
                  value: '${bill.serviceCharge.toStringAsFixed(2)} $currency',
                ),
              const Divider(height: AppDimensions.spacingLg),
              Row(
                children: [
                  Text(
                    context.l10n.t('total'),
                    style: context.textStyles.headlineSmall,
                  ),
                  const Spacer(),
                  Text(
                    '${bill.total.toStringAsFixed(2)} $currency',
                    style: AppTextStyles.numberStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openFullScreenImage(BuildContext context, String path) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: InteractiveViewer(
            child: Center(
              child: Image.file(File(path)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  const _AmountRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        children: [
          Text(label, style: context.textStyles.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
