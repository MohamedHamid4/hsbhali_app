import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class EmptyRecentBills extends StatelessWidget {
  const EmptyRecentBills({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: EmptyStateWidget(
        icon: PhosphorIconsRegular.receipt,
        title: context.l10n.t('home_no_bills_title'),
        description: context.l10n.t('home_no_bills_desc'),
        iconSize: 48,
      ),
    );
  }
}
