import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_dimensions.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../shared/widgets/custom_card.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../viewmodels/bill_extras_viewmodel.dart';
import '../../viewmodels/create_bill_viewmodel.dart';
import '../../widgets/tip_selector.dart';

class TipExtrasStep extends ConsumerWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;

  const TipExtrasStep({super.key, required this.state, required this.vm});

  void _onContinue(WidgetRef ref) {
    final extras = ref.read(billExtrasViewModelProvider(state.subtotal));
    vm.setExtras(
      tipPercentage: extras.tipPercentage,
      tipAmount: extras.tipFixedAmount,
      isTipPercentage: extras.isTipPercentage,
      taxAmount: extras.taxAmount,
      serviceCharge: extras.serviceCharge,
    );
    vm.nextStep();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(billExtrasViewModelProvider(state.subtotal));
    final extrasVM =
        ref.read(billExtrasViewModelProvider(state.subtotal).notifier);
    final currency = state.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            children: [
              Text(
                context.l10n.t('extras_title'),
                style: context.textStyles.headlineMedium,
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.t('tip_label'),
                      style: context.textStyles.labelLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    TipSelector(subtotal: state.subtotal),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.t('tax_optional'),
                      style: context.textStyles.labelLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0',
                        suffixText: currency,
                      ),
                      onChanged: (v) =>
                          extrasVM.setTax(double.tryParse(v) ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.t('service_optional'),
                      style: context.textStyles.labelLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0',
                        suffixText: currency,
                      ),
                      onChanged: (v) =>
                          extrasVM.setService(double.tryParse(v) ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: context.l10n.t('subtotal'),
                      value: '${state.subtotal.toStringAsFixed(2)} $currency',
                      isMuted: true,
                    ),
                    if (extras.tipAmount > 0)
                      _SummaryRow(
                        label: context.l10n.t('tip_label'),
                        value:
                            '${extras.tipAmount.toStringAsFixed(2)} $currency',
                        isMuted: true,
                      ),
                    if (extras.taxAmount > 0)
                      _SummaryRow(
                        label: context.l10n.t('tax_label'),
                        value:
                            '${extras.taxAmount.toStringAsFixed(2)} $currency',
                        isMuted: true,
                      ),
                    if (extras.serviceCharge > 0)
                      _SummaryRow(
                        label: context.l10n.t('service_label'),
                        value:
                            '${extras.serviceCharge.toStringAsFixed(2)} $currency',
                        isMuted: true,
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingSm),
                      child: Divider(color: Colors.white30, height: 1),
                    ),
                    _SummaryRow(
                      label: context.l10n.t('total'),
                      value: '${extras.total.toStringAsFixed(2)} $currency',
                      isLarge: true,
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
            text: context.l10n.t('common_continue'),
            icon: PhosphorIconsBold.arrowLeft,
            onPressed: () => _onContinue(ref),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMuted;
  final bool isLarge;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isMuted = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMuted ? Colors.white.withValues(alpha: 0.85) : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: isLarge
                ? context.textStyles.headlineSmall?.copyWith(color: color)
                : context.textStyles.bodyMedium?.copyWith(color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: isLarge ? 24 : 14,
              fontWeight: isLarge ? FontWeight.w900 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
