import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/primary_button.dart';

class EmptyBillsState extends StatelessWidget {
  final VoidCallback? onCreateBill;

  const EmptyBillsState({super.key, this.onCreateBill});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: PhosphorIconsRegular.receipt,
      title: context.l10n.t('bills_empty_title'),
      description: context.l10n.t('bills_empty_desc'),
      actionButton: onCreateBill == null
          ? null
          : SizedBox(
              width: 200,
              child: PrimaryButton(
                text: context.l10n.t('bills_create_first'),
                icon: PhosphorIconsBold.plus,
                onPressed: onCreateBill,
              ),
            ),
    );
  }
}
