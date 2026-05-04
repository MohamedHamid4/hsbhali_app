import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: AppDimensions.spacingXs,
            left: AppDimensions.spacingXs,
            bottom: AppDimensions.spacingSm,
          ),
          child: Text(
            title,
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: _withDividers(context, children),
          ),
        ),
      ],
    );
  }

  List<Widget> _withDividers(BuildContext context, List<Widget> items) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(Divider(
          height: 1,
          color: context.colors.outlineVariant,
        ));
      }
    }
    return result;
  }
}
