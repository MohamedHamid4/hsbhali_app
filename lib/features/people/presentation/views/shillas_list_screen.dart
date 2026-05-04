import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../viewmodels/shillas_list_viewmodel.dart';
import '../widgets/shilla_card.dart';

class ShillasListScreen extends ConsumerWidget {
  const ShillasListScreen({super.key});

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.t('delete_shilla_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.t('common_cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.t('common_delete')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(shillasListViewModelProvider.notifier).deleteShilla(id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.t('shilla_deleted'))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shillasListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('shillati'))),
      body: RefreshIndicator(
        onRefresh: () => ref.read(shillasListViewModelProvider.notifier).load(),
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ShillasListState state) {
    if (state.isLoading && state.shillas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.shillas.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: EmptyStateWidget(
              icon: PhosphorIconsRegular.usersThree,
              title: context.l10n.t('no_shillas'),
              description: context.l10n.t('no_shillas_desc'),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      itemCount: state.shillas.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.spacingSm),
      itemBuilder: (_, i) {
        final s = state.shillas[i];
        return ShillaCard(
          shilla: s,
          onLongPress: () => _confirmAndDelete(context, ref, s.id),
        );
      },
    );
  }
}
