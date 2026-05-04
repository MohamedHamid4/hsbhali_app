import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../viewmodels/quick_calculate_viewmodel.dart';

class PeopleCounter extends ConsumerWidget {
  const PeopleCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickCalculateViewModelProvider);
    final vm = ref.read(quickCalculateViewModelProvider.notifier);

    return CustomCard(
      child: Column(
        children: [
          Text(
            context.l10n.t('quick_calc_people'),
            style: context.textStyles.labelLarge,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CounterButton(
                icon: PhosphorIconsBold.minus,
                onPressed: vm.decrementPeople,
              ),
              SizedBox(
                width: 80,
                child: Text(
                  state.peopleCount.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.numberStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              _CounterButton(
                icon: PhosphorIconsBold.plus,
                onPressed: vm.incrementPeople,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CounterButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppDimensions.buttonMedium,
          height: AppDimensions.buttonMedium,
          child: Icon(
            icon,
            color: Colors.white,
            size: AppDimensions.iconMedium,
          ),
        ),
      ),
    );
  }
}
