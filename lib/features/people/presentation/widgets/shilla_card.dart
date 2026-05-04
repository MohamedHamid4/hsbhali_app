import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/shilla.dart';
import 'person_avatar.dart';

class ShillaCard extends StatelessWidget {
  final Shilla shilla;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool compact;

  const ShillaCard({
    super.key,
    required this.shilla,
    this.onTap,
    this.onLongPress,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shilla.name,
            style: context.textStyles.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          _AvatarStack(people: shilla.people),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            shilla.useCount > 0
                ? context.l10n
                    .t('used_times')
                    .replaceAll('{count}', '${shilla.useCount}')
                : context.l10n
                    .t('people_count_n')
                    .replaceAll('{count}', '${shilla.people.length}'),
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );

    if (onLongPress != null) {
      return GestureDetector(
        onLongPress: onLongPress,
        child: card,
      );
    }
    return card;
  }
}

class _AvatarStack extends StatelessWidget {
  final List<dynamic> people;

  const _AvatarStack({required this.people});

  @override
  Widget build(BuildContext context) {
    const maxVisible = 4;
    final visible = people.take(maxVisible).toList();
    final remaining = people.length - visible.length;

    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            PositionedDirectional(
              start: i * 22.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.surface,
                    width: 2,
                  ),
                ),
                child: PersonAvatar(
                  name: visible[i].name as String,
                  colorIndex: visible[i].colorIndex as int,
                  size: AvatarSize.small,
                ),
              ),
            ),
          if (remaining > 0)
            PositionedDirectional(
              start: visible.length * 22.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.surface,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: context.textStyles.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
