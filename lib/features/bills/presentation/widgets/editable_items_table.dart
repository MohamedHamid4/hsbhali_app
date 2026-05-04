import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/entities/bill_item.dart';

class EditableItemsTable extends StatelessWidget {
  final List<BillItem> items;
  final void Function(BillItem updated) onUpdate;
  final void Function(String id) onDelete;
  final VoidCallback onAdd;

  const EditableItemsTable({
    super.key,
    required this.items,
    required this.onUpdate,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: _EditableItemRow(
                key: ValueKey(item.id),
                item: item,
                onUpdate: onUpdate,
                onDelete: () => onDelete(item.id),
              ),
            )),
        const SizedBox(height: AppDimensions.spacingSm),
        SecondaryButton(
          text: context.l10n.t('add_item_to_table'),
          icon: PhosphorIconsBold.plus,
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _EditableItemRow extends StatefulWidget {
  final BillItem item;
  final void Function(BillItem updated) onUpdate;
  final VoidCallback onDelete;

  const _EditableItemRow({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_EditableItemRow> createState() => _EditableItemRowState();
}

class _EditableItemRowState extends State<_EditableItemRow> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _priceController = TextEditingController(
      text: widget.item.unitPrice == 0
          ? ''
          : widget.item.unitPrice.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _commitName(String value) {
    final updated = widget.item.copyWith(name: value.trim());
    widget.onUpdate(updated);
  }

  void _commitPrice(String value) {
    final price = double.tryParse(value.trim()) ?? 0.0;
    final qty = widget.item.quantity;
    final updated = widget.item.copyWith(
      unitPrice: price,
      totalPrice: qty * price,
    );
    widget.onUpdate(updated);
  }

  void _changeQuantity(int delta) {
    final newQty = (widget.item.quantity + delta).clamp(1, 999);
    final updated = widget.item.copyWith(
      quantity: newQty,
      totalPrice: newQty * widget.item.unitPrice,
    );
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: context.l10n.t('item_name_field'),
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: context.textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: _commitName,
                ),
              ),
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.trash,
                  color: AppColors.error,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: widget.onDelete,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          Row(
            children: [
              _QuantityControl(
                quantity: widget.item.quantity,
                onChanged: _changeQuantity,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: context.l10n.t('price_short'),
                    isDense: true,
                  ),
                  style: AppTextStyles.numberStyle(
                    fontSize: 14,
                    color: context.colors.onSurface,
                  ),
                  onChanged: _commitPrice,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Text(
                widget.item.totalPrice.toStringAsFixed(2),
                style: AppTextStyles.numberStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final void Function(int delta) onChanged;

  const _QuantityControl({
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconBtn(
            icon: PhosphorIconsBold.minus,
            onTap: () => onChanged(-1),
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.numberStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          _IconBtn(
            icon: PhosphorIconsBold.plus,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXs),
        child: Icon(
          icon,
          size: AppDimensions.iconSmall,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
