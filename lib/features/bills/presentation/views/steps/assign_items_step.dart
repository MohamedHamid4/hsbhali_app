import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_dimensions.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../shared/widgets/custom_card.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../../../../shared/widgets/secondary_button.dart';
import '../../../../people/presentation/widgets/person_avatar.dart';
import '../../../../people/presentation/widgets/person_chip.dart';
import '../../../domain/entities/bill_item.dart';
import '../../../domain/entities/person.dart';
import '../../viewmodels/create_bill_viewmodel.dart';
import '../../viewmodels/item_assignment_viewmodel.dart';

class AssignItemsStep extends ConsumerWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;

  const AssignItemsStep({super.key, required this.state, required this.vm});

  void _onContinue(BuildContext context, WidgetRef ref) {
    final assignmentVM =
        ref.read(itemAssignmentViewModelProvider(state.items).notifier);
    final aState = ref.read(itemAssignmentViewModelProvider(state.items));

    if (!aState.isFullyAssigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('assign_all_items'))),
      );
      return;
    }
    vm.applyAssignments(assignmentVM.getItemsWithAssignments());
    vm.nextStep();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aState = ref.watch(itemAssignmentViewModelProvider(state.items));
    final aVM = ref.read(itemAssignmentViewModelProvider(state.items).notifier);
    final allPersonIds = state.people.map((p) => p.id).toList();
    final currency = state.currency == 'EGP'
        ? context.l10n.t('common_currency_egp')
        : context.l10n.t('common_currency_usd');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacingLg,
            AppDimensions.spacingMd,
            AppDimensions.spacingLg,
            AppDimensions.spacingSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.t('assign_items_title'),
                style: context.textStyles.headlineMedium,
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                context.l10n.t('tap_to_assign'),
                style: context.textStyles.bodySmall,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
          ),
          child: SecondaryButton(
            text: context.l10n.t('split_equally'),
            icon: PhosphorIconsBold.usersThree,
            onPressed: () => aVM.assignAllItemsToAll(allPersonIds),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            itemCount: state.items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.spacingSm),
            itemBuilder: (_, i) {
              final item = state.items[i];
              return _ItemAssignmentCard(
                item: item,
                people: state.people,
                aState: aState,
                aVM: aVM,
                currency: currency,
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: PrimaryButton(
            text: context.l10n.t('common_continue'),
            icon: PhosphorIconsBold.arrowLeft,
            onPressed:
                aState.isFullyAssigned ? () => _onContinue(context, ref) : null,
          ),
        ),
      ],
    );
  }
}

class _ItemAssignmentCard extends StatelessWidget {
  final BillItem item;
  final List<Person> people;
  final ItemAssignmentState aState;
  final ItemAssignmentViewModel aVM;
  final String currency;

  const _ItemAssignmentCard({
    required this.item,
    required this.people,
    required this.aState,
    required this.aVM,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final mode = aState.modeFor(item.id);
    final assigned = aState.itemToPeopleMap[item.id] ?? const <String>[];
    final showQuantityMode = item.quantity > 1;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.quantity}× ${item.name}',
                  style: context.textStyles.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${item.totalPrice.toStringAsFixed(2)} $currency',
                style: AppTextStyles.numberStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
          if (showQuantityMode) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            _ModeToggle(
              currentMode: mode,
              onSelect: (m) => aVM.setMode(item.id, m),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            mode == SplitMode.quantity
                ? context.l10n.t('split_mode_hint_quantity')
                : context.l10n.t('split_mode_hint_equal'),
            style: context.textStyles.bodySmall,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          if (mode == SplitMode.quantity)
            _QuantityModeBody(
              item: item,
              people: people,
              aState: aState,
              aVM: aVM,
              currency: currency,
            )
          else
            _EqualModeBody(
              item: item,
              people: people,
              assigned: assigned,
              aVM: aVM,
            ),
        ],
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final String currentMode;
  final ValueChanged<String> onSelect;

  const _ModeToggle({required this.currentMode, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeOption(
              label: context.l10n.t('split_mode_equal'),
              icon: PhosphorIconsBold.usersThree,
              isSelected: currentMode == SplitMode.equal,
              onTap: () => onSelect(SplitMode.equal),
            ),
          ),
          Expanded(
            child: _ModeOption(
              label: context.l10n.t('split_mode_quantity'),
              icon: PhosphorIconsBold.hash,
              isSelected: currentMode == SplitMode.quantity,
              onTap: () => onSelect(SplitMode.quantity),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingSm,
            horizontal: AppDimensions.spacingMd,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSmall,
                color: isSelected ? Colors.white : context.colors.onSurface,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.labelMedium?.copyWith(
                    color:
                        isSelected ? Colors.white : context.colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EqualModeBody extends StatelessWidget {
  final BillItem item;
  final List<Person> people;
  final List<String> assigned;
  final ItemAssignmentViewModel aVM;

  const _EqualModeBody({
    required this.item,
    required this.people,
    required this.assigned,
    required this.aVM,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.spacingXs,
          runSpacing: AppDimensions.spacingXs,
          children: people.map((p) {
            return PersonChip(
              person: p,
              isSelected: assigned.contains(p.id),
              onTap: () => aVM.toggleAssignment(item.id, p.id),
            );
          }).toList(),
        ),
        if (assigned.length > 1) ...[
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            context.l10n
                .t('split_among')
                .replaceAll('{count}', '${assigned.length}'),
            style: context.textStyles.bodySmall,
          ),
        ],
        if (assigned.isEmpty) ...[
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            context.l10n.t('unassigned_items'),
            style: context.textStyles.bodySmall?.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuantityModeBody extends StatelessWidget {
  final BillItem item;
  final List<Person> people;
  final ItemAssignmentState aState;
  final ItemAssignmentViewModel aVM;
  final String currency;

  const _QuantityModeBody({
    required this.item,
    required this.people,
    required this.aState,
    required this.aVM,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final pricePerPortion = item.quantity > 0
        ? (item.totalPrice / item.quantity).toStringAsFixed(2)
        : '0.00';
    final totalPortions = aState.totalPortionsFor(item.id);
    final remaining = item.quantity - totalPortions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...people.map((person) {
          final portions = aState.itemPortions[item.id]?[person.id] ?? 0;
          return _PortionRow(
            person: person,
            portions: portions,
            canIncrement: totalPortions < item.quantity,
            pricePerPortion: pricePerPortion,
            currency: currency,
            onIncrement: () => aVM.incrementPortion(item.id, person.id),
            onDecrement: () => aVM.decrementPortion(item.id, person.id),
          );
        }),
        const SizedBox(height: AppDimensions.spacingSm),
        _PortionStatus(
          totalPortions: totalPortions,
          targetPortions: item.quantity,
          remaining: remaining,
        ),
      ],
    );
  }
}

class _PortionRow extends StatelessWidget {
  final Person person;
  final int portions;
  final bool canIncrement;
  final String pricePerPortion;
  final String currency;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _PortionRow({
    required this.person,
    required this.portions,
    required this.canIncrement,
    required this.pricePerPortion,
    required this.currency,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        children: [
          PersonAvatar(
            name: person.name,
            colorIndex: person.colorIndex,
            size: AvatarSize.small,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              person.name,
              style: context.textStyles.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _StepperButton(
            icon: PhosphorIconsBold.minus,
            onTap: portions > 0 ? onDecrement : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$portions',
              textAlign: TextAlign.center,
              style: AppTextStyles.numberStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: portions > 0
                    ? AppColors.primary
                    : context.colors.onSurfaceVariant,
              ),
            ),
          ),
          _StepperButton(
            icon: PhosphorIconsBold.plus,
            onTap: canIncrement ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? AppColors.primary.withValues(alpha: 0.12)
                : context.colors.surfaceContainerHighest,
            border: Border.all(
              color: enabled
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : context.colors.outlineVariant,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? AppColors.primary
                : context.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _PortionStatus extends StatelessWidget {
  final int totalPortions;
  final int targetPortions;
  final int remaining;

  const _PortionStatus({
    required this.totalPortions,
    required this.targetPortions,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final isMatch = remaining == 0;
    final isExcess = remaining < 0;

    final String label;
    if (isMatch) {
      label = context.l10n
          .t('portions_total_match')
          .replaceAll('{current}', '$totalPortions')
          .replaceAll('{total}', '$targetPortions');
    } else if (isExcess) {
      label = context.l10n
          .t('portions_total_excess')
          .replaceAll('{excess}', '${-remaining}');
    } else {
      label = context.l10n
          .t('portions_total_mismatch')
          .replaceAll('{missing}', '$remaining');
    }

    final color = isMatch
        ? AppColors.success
        : (isExcess ? AppColors.error : AppColors.warning);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: context.textStyles.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
