import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../viewmodels/quick_calculate_viewmodel.dart';

class TipSelector extends ConsumerWidget {
  const TipSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickCalculateViewModelProvider);
    final vm = ref.read(quickCalculateViewModelProvider.notifier);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.t('quick_calc_tip'),
            style: context.textStyles.labelLarge,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: kTipOptions.map((value) {
              final isSelected = state.tipPercentage == value;
              final label = value == 0
                  ? context.l10n.t('quick_calc_tip_none')
                  : '${value.toInt()}%';
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => vm.setTip(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
