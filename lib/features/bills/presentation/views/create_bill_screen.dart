import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/ads_service.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/extracted_receipt.dart';
import '../viewmodels/create_bill_viewmodel.dart';
import '../viewmodels/home_stats_viewmodel.dart';
import '../widgets/bill_item_tile.dart';
import '../widgets/item_input_sheet.dart';
import 'steps/add_people_step.dart';
import 'steps/assign_items_step.dart';
import 'steps/tip_extras_step.dart';

class CreateBillScreen extends ConsumerStatefulWidget {
  final Bill? initialBill;
  final Bill? templateBill;

  const CreateBillScreen({
    super.key,
    this.initialBill,
    this.templateBill,
  });

  @override
  ConsumerState<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends ConsumerState<CreateBillScreen> {
  bool _templateApplied = false;

  @override
  void initState() {
    super.initState();
    if (widget.templateBill != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_templateApplied || !mounted) return;
        _templateApplied = true;
        ref
            .read(createBillViewModelProvider(widget.initialBill).notifier)
            .applyTemplate(widget.templateBill!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialBill = widget.initialBill;
    final state = ref.watch(createBillViewModelProvider(initialBill));
    final vm = ref.read(createBillViewModelProvider(initialBill).notifier);

    return PopScope(
      canPop: state.step == CreateBillStep.source ||
          (state.isSourceLocked && state.step == CreateBillStep.placeAndDate),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        vm.previousStep();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.isEditing
              ? context.l10n.t('edit_bill')
              : context.l10n.t('create_bill_title')),
          leading: IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowLeft),
            onPressed: () {
              final isAtStart = state.step == CreateBillStep.source ||
                  (state.isSourceLocked &&
                      state.step == CreateBillStep.placeAndDate);
              if (isAtStart) {
                Navigator.of(context).pop();
              } else {
                vm.previousStep();
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (state.step.index + 1) / CreateBillStep.values.length,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        body: SafeArea(
          child: switch (state.step) {
            CreateBillStep.source => _SourceStep(vm: vm),
            CreateBillStep.placeAndDate =>
              _PlaceAndDateStep(state: state, vm: vm),
            CreateBillStep.items => _ItemsStep(state: state, vm: vm),
            CreateBillStep.people => AddPeopleStep(state: state, vm: vm),
            CreateBillStep.assignment =>
              AssignItemsStep(state: state, vm: vm),
            CreateBillStep.extras => TipExtrasStep(state: state, vm: vm),
            CreateBillStep.review =>
              _ReviewStep(state: state, vm: vm, bill: initialBill),
          },
        ),
      ),
    );
  }
}

class _SourceStep extends ConsumerWidget {
  final CreateBillViewModel vm;
  const _SourceStep({required this.vm});

  Future<void> _captureReceipt(BuildContext context, WidgetRef ref) async {
    final path = await context.push<String?>(RouteNames.receiptCapture);
    if (path == null) {
      vm.nextStep();
      return;
    }

    vm.setReceiptImage(path);

    if (!context.mounted) return;

    final receipt = await context.push<ExtractedReceipt?>(
      RouteNames.ocrProcessing,
      extra: path,
    );

    debugPrint(
      '➡️ Source step received receipt: '
      '${receipt == null ? 'null' : 'items=${receipt.items.length}'}',
    );

    if (!context.mounted) return;

    if (receipt != null && receipt.items.isNotEmpty) {
      vm.applyExtractedReceipt(receipt);
    } else {
      vm.nextStep();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        children: [
          const Spacer(),
          CustomCard(
            onTap: () => _captureReceipt(context, ref),
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: _SourceCardContent(
              icon: PhosphorIconsBold.camera,
              color: AppColors.primary,
              title: context.l10n.t('create_bill_capture'),
              subtitle: context.l10n.t('create_bill_capture_desc'),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          CustomCard(
            onTap: vm.nextStep,
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: _SourceCardContent(
              icon: PhosphorIconsBold.pencilSimple,
              color: AppColors.secondary,
              title: context.l10n.t('create_bill_manual'),
              subtitle: context.l10n.t('create_bill_manual_desc'),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _SourceCardContent extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _SourceCardContent({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Icon(icon, color: color, size: AppDimensions.iconLarge),
        ),
        const SizedBox(width: AppDimensions.spacingLg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.headlineSmall),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(subtitle, style: context.textStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceAndDateStep extends StatefulWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;

  const _PlaceAndDateStep({required this.state, required this.vm});

  @override
  State<_PlaceAndDateStep> createState() => _PlaceAndDateStepState();
}

class _PlaceAndDateStepState extends State<_PlaceAndDateStep> {
  late final TextEditingController _placeController;

  @override
  void initState() {
    super.initState();
    _placeController =
        TextEditingController(text: widget.state.placeName ?? '');
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.state.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) widget.vm.setDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        children: [
          TextField(
            controller: _placeController,
            decoration: InputDecoration(
              labelText: context.l10n.t('place_name_optional'),
              hintText: context.l10n.t('place_name_hint'),
            ),
            onChanged: widget.vm.setPlaceName,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          CustomCard(
            onTap: _pickDate,
            child: Row(
              children: [
                const Icon(PhosphorIconsRegular.calendar),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.t('date'),
                          style: context.textStyles.bodySmall),
                      Text(
                        widget.state.date.formattedArabic,
                        style: context.textStyles.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(PhosphorIconsRegular.caretLeft),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          CustomCard(
            child: Row(
              children: [
                const Icon(PhosphorIconsRegular.currencyDollar),
                const SizedBox(width: AppDimensions.spacingMd),
                Text(context.l10n.t('currency'),
                    style: context.textStyles.bodyLarge),
                const Spacer(),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'EGP',
                      label: Text(context.l10n.t('common_currency_egp')),
                    ),
                    ButtonSegment(
                      value: 'USD',
                      label: Text(context.l10n.t('common_currency_usd')),
                    ),
                  ],
                  selected: {widget.state.currency},
                  onSelectionChanged: (s) => widget.vm.setCurrency(s.first),
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            text: context.l10n.t('common_continue'),
            icon: PhosphorIconsBold.arrowLeft,
            onPressed: widget.vm.nextStep,
          ),
        ],
      ),
    );
  }
}

class _ItemsStep extends StatelessWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;

  const _ItemsStep({required this.state, required this.vm});

  Future<void> _addItem(BuildContext context) async {
    final result = await ItemInputSheet.show(context, currency: state.currency);
    if (result != null) {
      vm.addItem(
        name: result.name,
        quantity: result.quantity,
        unitPrice: result.unitPrice,
      );
    }
  }

  Future<void> _editItem(BuildContext context, String id) async {
    final item = state.items.firstWhere((i) => i.id == id);
    final result = await ItemInputSheet.show(
      context,
      initialItem: item,
      currency: state.currency,
    );
    if (result != null) {
      vm.updateItem(
        id: id,
        name: result.name,
        quantity: result.quantity,
        unitPrice: result.unitPrice,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: state.items.isEmpty
              ? EmptyStateWidget(
                  icon: PhosphorIconsRegular.listPlus,
                  title: context.l10n.t('no_items_yet'),
                  description: context.l10n.t('add_item'),
                  iconSize: 56,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingSm,
                  ),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    indent: AppDimensions.spacingLg,
                    endIndent: AppDimensions.spacingLg,
                  ),
                  itemBuilder: (_, i) => BillItemTile(
                    item: state.items[i],
                    currency: state.currency,
                    onTap: () => _editItem(context, state.items[i].id),
                    onDelete: () => vm.removeItem(state.items[i].id),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            children: [
              SecondaryButton(
                text: context.l10n.t('add_item'),
                icon: PhosphorIconsBold.plus,
                onPressed: () => _addItem(context),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              PrimaryButton(
                text: context.l10n.t('common_continue'),
                icon: PhosphorIconsBold.arrowLeft,
                onPressed: state.items.isEmpty ? null : vm.nextStep,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;
  final Bill? bill;

  const _ReviewStep({required this.state, required this.vm, required this.bill});

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final ok = await vm.saveBill();
    if (!context.mounted) return;
    if (ok) {
      ref.invalidate(homeStatsAsyncProvider);
      ref.invalidate(recentBillsAsyncProvider);

      if (!state.isEditing) {
        unawaited(
          ref.read(analyticsServiceProvider).trackBillCreated(
                itemCount: state.items.length,
                totalAmount: state.total,
                currency: state.currency,
                fromOcr: state.receiptImagePath != null,
              ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.isEditing
            ? context.l10n.t('bill_updated')
            : context.l10n.t('bill_saved'))),
      );

      if (!state.isEditing) {
        await ref.read(adsServiceProvider).onBillSaved();
      }
      if (!context.mounted) return;

      final saved = ref.read(createBillViewModelProvider(bill)).savedBill;
      if (saved != null && saved.people.length >= 2) {
        context.go('${RouteNames.splitResult}/${saved.id}');
      } else {
        context.go(RouteNames.main);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? context.l10n.t('common_error'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = state.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            children: [
              if (state.receiptImagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  child: Image.file(
                    File(state.receiptImagePath!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
              ],

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.placeName != null) ...[
                      Text(state.placeName!,
                          style: context.textStyles.headlineSmall),
                      const SizedBox(height: AppDimensions.spacingXs),
                    ],
                    Text(state.date.formattedArabic,
                        style: context.textStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Text(context.l10n.t('bill_items'),
                  style: context.textStyles.labelLarge),
              const SizedBox(height: AppDimensions.spacingSm),
              CustomCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: state.items
                      .map((i) => BillItemTile(
                            item: i,
                            currency: state.currency,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              CustomCard(
                child: Column(
                  children: [
                    _ReviewRow(
                      label: context.l10n.t('subtotal'),
                      value: '${state.subtotal.toStringAsFixed(2)} $currency',
                    ),
                    if (state.taxAmount > 0)
                      _ReviewRow(
                        label: context.l10n.t('tax_label'),
                        value: '${state.taxAmount.toStringAsFixed(2)} $currency',
                      ),
                    if (state.effectiveTip > 0)
                      _ReviewRow(
                        label: context.l10n.t('tip_label'),
                        value:
                            '${state.effectiveTip.toStringAsFixed(2)} $currency',
                      ),
                    if (state.serviceCharge > 0)
                      _ReviewRow(
                        label: context.l10n.t('service_label'),
                        value:
                            '${state.serviceCharge.toStringAsFixed(2)} $currency',
                      ),
                    const Divider(),
                    Row(
                      children: [
                        Text(context.l10n.t('total'),
                            style: context.textStyles.headlineSmall),
                        const Spacer(),
                        Text(
                          '${state.total.toStringAsFixed(2)} $currency',
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: PrimaryButton(
            text: context.l10n.t('save_bill'),
            icon: PhosphorIconsBold.floppyDisk,
            isLoading: state.isSaving,
            onPressed: state.isSaving ? null : () => _onSave(context, ref),
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

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
