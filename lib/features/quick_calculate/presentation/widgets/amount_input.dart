import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../viewmodels/quick_calculate_viewmodel.dart';

class AmountInput extends ConsumerWidget {
  const AmountInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomCard(
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      child: Column(
        children: [
          Text(
            context.l10n.t('quick_calc_amount'),
            style: context.textStyles.labelLarge,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: AppTextStyles.numberStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: context.colors.onSurface,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 0;
                    ref
                        .read(quickCalculateViewModelProvider.notifier)
                        .setAmount(parsed);
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                context.l10n.t('common_currency_egp'),
                style: context.textStyles.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
