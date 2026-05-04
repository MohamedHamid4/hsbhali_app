import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../viewmodels/bill_details_viewmodel.dart';
import 'create_bill_screen.dart';

class EditBillScreen extends ConsumerWidget {
  final String billId;

  const EditBillScreen({super.key, required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billDetailsViewModelProvider(billId));

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.bill == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyStateWidget(
          icon: PhosphorIconsRegular.warning,
          title: context.l10n.t('common_error'),
          description: state.errorMessage ?? '',
        ),
      );
    }

    return CreateBillScreen(initialBill: state.bill);
  }
}
