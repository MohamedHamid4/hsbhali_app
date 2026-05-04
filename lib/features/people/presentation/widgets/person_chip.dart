import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bills/domain/entities/person.dart';
import 'person_avatar.dart';

class PersonChip extends StatelessWidget {
  final Person person;
  final bool isSelected;
  final VoidCallback onTap;

  const PersonChip({
    super.key,
    required this.person,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorForIndex(person.colorIndex);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSm,
            vertical: AppDimensions.spacingXs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: isSelected ? color : context.colors.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PersonAvatar(
                name: person.name,
                colorIndex: person.colorIndex,
                size: AvatarSize.small,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                person.name,
                style: context.textStyles.labelMedium?.copyWith(
                  color:
                      isSelected ? Colors.white : context.colors.onSurface,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingXs),
            ],
          ),
        ),
      ),
    );
  }
}
