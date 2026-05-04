import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../viewmodels/bill_extras_viewmodel.dart';

class TipSelector extends ConsumerStatefulWidget {
  final double subtotal;

  const TipSelector({super.key, required this.subtotal});

  @override
  ConsumerState<TipSelector> createState() => _TipSelectorState();
}

class _TipSelectorState extends ConsumerState<TipSelector> {
  late final TextEditingController _customController;
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billExtrasViewModelProvider(widget.subtotal));
    final vm = ref.read(billExtrasViewModelProvider(widget.subtotal).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: true,
              label: Text(context.l10n.t('tip_percentage')),
            ),
            ButtonSegment(
              value: false,
              label: Text(context.l10n.t('tip_fixed')),
            ),
          ],
          selected: {state.isTipPercentage},
          onSelectionChanged: (s) {
            vm.toggleTipMode(s.first);
            setState(() => _showCustomInput = false);
          },
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        if (state.isTipPercentage) ...[
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: [
              ...kTipPresets.map((value) {
                final isSelected =
                    !_showCustomInput && state.tipPercentage == value;
                return ChoiceChip(
                  label: Text(value == 0
                      ? context.l10n.t('tip_none')
                      : '${value.toInt()}%'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _showCustomInput = false);
                    vm.setTipPercentage(value);
                  },
                );
              }),
              ChoiceChip(
                label: Text(context.l10n.t('tip_custom')),
                selected: _showCustomInput,
                onSelected: (_) => setState(() => _showCustomInput = true),
              ),
            ],
          ),
          if (_showCustomInput) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: context.l10n.t('tip_custom'),
                suffixText: '%',
              ),
              onChanged: (v) => vm.setTipPercentage(double.tryParse(v) ?? 0),
            ),
          ],
        ] else ...[
          TextField(
            controller: _customController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: context.l10n.t('tip_custom_amount'),
            ),
            onChanged: (v) => vm.setTipFixedAmount(double.tryParse(v) ?? 0),
          ),
        ],
      ],
    );
  }
}
