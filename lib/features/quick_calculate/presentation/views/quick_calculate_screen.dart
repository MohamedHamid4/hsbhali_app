import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/amount_input.dart';
import '../widgets/people_counter.dart';
import '../widgets/result_card.dart';
import '../widgets/tip_selector.dart';

class QuickCalculateScreen extends ConsumerWidget {
  const QuickCalculateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('quick_calc_title')),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: context.unfocus,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                children: const [
                  AmountInput(),
                  SizedBox(height: AppDimensions.spacingMd),
                  PeopleCounter(),
                  SizedBox(height: AppDimensions.spacingMd),
                  TipSelector(),
                ],
              ),
            ),
          ),
          const ResultCard(),
        ],
      ),
    );
  }
}
