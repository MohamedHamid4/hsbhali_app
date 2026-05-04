import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/entities/extracted_receipt.dart';
import '../widgets/editable_items_table.dart';

class OcrReviewScreen extends ConsumerStatefulWidget {
  final ExtractedReceipt receipt;

  const OcrReviewScreen({super.key, required this.receipt});

  @override
  ConsumerState<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends ConsumerState<OcrReviewScreen> {
  late TextEditingController _placeController;
  late DateTime _date;
  late List<BillItem> _items;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _placeController =
        TextEditingController(text: widget.receipt.placeName ?? '');
    _date = widget.receipt.detectedDate ?? DateTime.now();
    _items = List<BillItem>.from(widget.receipt.items);
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (s, i) => s + i.totalPrice);

  void _onItemUpdate(BillItem updated) {
    setState(() {
      final i = _items.indexWhere((it) => it.id == updated.id);
      if (i != -1) _items[i] = updated;
    });
  }

  void _onItemDelete(String id) {
    setState(() => _items.removeWhere((it) => it.id == id));
  }

  void _onItemAdd() {
    setState(() {
      _items.add(BillItem(
        id: _uuid.v4(),
        name: '',
        quantity: 1,
        unitPrice: 0.0,
        totalPrice: 0.0,
      ));
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _onContinue() {
    final cleaned = _items
        .where((i) => i.name.trim().isNotEmpty && i.unitPrice > 0)
        .toList();

    final result = ExtractedReceipt(
      placeName: _placeController.text.trim().isEmpty
          ? null
          : _placeController.text.trim(),
      detectedDate: _date,
      items: cleaned,
      detectedSubtotal: widget.receipt.detectedSubtotal,
      detectedTax: widget.receipt.detectedTax,
      detectedService: widget.receipt.detectedService,
      detectedTotal: widget.receipt.detectedTotal,
      confidence: widget.receipt.confidence,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        _items.any((i) => i.name.trim().isNotEmpty && i.unitPrice > 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('ocr_review_title')),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                children: [
                  if (widget.receipt.isLowConfidence)
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                        bottom: AppDimensions.spacingMd,
                      ),
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            PhosphorIconsRegular.warning,
                            color: AppColors.accentDark,
                            size: AppDimensions.iconMedium,
                          ),
                          const SizedBox(width: AppDimensions.spacingSm),
                          Expanded(
                            child: Text(
                              context.l10n.t('ocr_low_confidence'),
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Text(
                    context.l10n.t('create_bill_step_place'),
                    style: context.textStyles.labelLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  CustomCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _placeController,
                          decoration: InputDecoration(
                            labelText: context.l10n.t('place_name_optional'),
                            hintText: context.l10n.t('place_name_hint'),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(height: 1),
                        InkWell(
                          onTap: _pickDate,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.spacingMd,
                            ),
                            child: Row(
                              children: [
                                const Icon(PhosphorIconsRegular.calendar),
                                const SizedBox(
                                    width: AppDimensions.spacingMd),
                                Expanded(
                                  child: Text(
                                    _date.formattedArabic,
                                    style: context.textStyles.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(PhosphorIconsRegular.caretLeft),
                              ],
                            ),
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
                  EditableItemsTable(
                    items: _items,
                    onUpdate: _onItemUpdate,
                    onDelete: _onItemDelete,
                    onAdd: _onItemAdd,
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              decoration: BoxDecoration(
                color: context.colors.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colors.outlineVariant,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.t('subtotal'),
                        style: context.textStyles.bodyLarge,
                      ),
                      const Spacer(),
                      Text(
                        _subtotal.toStringAsFixed(2),
                        style: AppTextStyles.numberStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  PrimaryButton(
                    text: context.l10n.t('continue_to_people'),
                    icon: PhosphorIconsBold.arrowLeft,
                    onPressed: canContinue ? _onContinue : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
