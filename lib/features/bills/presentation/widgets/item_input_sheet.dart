import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/entities/bill_item.dart';

class ItemInputResult {
  final String name;
  final int quantity;
  final double unitPrice;

  const ItemInputResult({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}

class ItemInputSheet extends StatefulWidget {
  final BillItem? initialItem;
  final String currency;

  const ItemInputSheet({super.key, this.initialItem, required this.currency});

  static Future<ItemInputResult?> show(
    BuildContext context, {
    BillItem? initialItem,
    required String currency,
  }) {
    return showModalBottomSheet<ItemInputResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: ItemInputSheet(
          initialItem: initialItem,
          currency: currency,
        ),
      ),
    );
  }

  @override
  State<ItemInputSheet> createState() => _ItemInputSheetState();
}

class _ItemInputSheetState extends State<ItemInputSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _priceController = TextEditingController(
      text: widget.initialItem?.unitPrice.toStringAsFixed(2) ?? '',
    );
    _quantity = widget.initialItem?.quantity ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double get _calculatedTotal {
    final price = double.tryParse(_priceController.text) ?? 0;
    return price * _quantity;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ItemInputResult(
        name: _nameController.text.trim(),
        quantity: _quantity,
        unitPrice: double.parse(_priceController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialItem != null;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                isEditing
                    ? context.l10n.t('edit_item')
                    : context.l10n.t('add_item'),
                style: context.textStyles.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.t('item_name'),
                  hintText: context.l10n.t('item_name_hint'),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '—' : null,
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: context.l10n.t('item_price'),
                  suffixText: widget.currency == 'EGP'
                      ? context.l10n.t('common_currency_egp')
                      : context.l10n.t('common_currency_usd'),
                ),
                validator: (v) {
                  final parsed = double.tryParse(v ?? '');
                  if (parsed == null || parsed <= 0) return '—';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Row(
                children: [
                  Text(
                    context.l10n.t('item_quantity'),
                    style: context.textStyles.bodyLarge,
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.numberStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    Text(
                      context.l10n.t('item_total'),
                      style: context.textStyles.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      '${_calculatedTotal.toStringAsFixed(2)} ${widget.currency}',
                      style: AppTextStyles.numberStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: context.colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: context.l10n.t('common_cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: PrimaryButton(
                      text: context.l10n.t('common_save'),
                      onPressed: _onSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
