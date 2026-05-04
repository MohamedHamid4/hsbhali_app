import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_dimensions.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../shared/widgets/custom_card.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../../../../shared/widgets/secondary_button.dart';
import '../../../../insights/presentation/providers/insights_providers.dart';
import '../../../../people/presentation/widgets/add_person_dialog.dart';
import '../../../../people/presentation/widgets/person_avatar.dart';
import '../../../../people/presentation/widgets/save_shilla_dialog.dart';
import '../../../../people/presentation/widgets/shilla_card.dart';
import '../../../../people/presentation/widgets/shilla_suggestion_banner.dart';
import '../../viewmodels/bill_people_viewmodel.dart';
import '../../viewmodels/create_bill_viewmodel.dart';

class AddPeopleStep extends ConsumerStatefulWidget {
  final CreateBillState state;
  final CreateBillViewModel vm;

  const AddPeopleStep({super.key, required this.state, required this.vm});

  @override
  ConsumerState<AddPeopleStep> createState() => _AddPeopleStepState();
}

class _AddPeopleStepState extends ConsumerState<AddPeopleStep> {
  bool _initialized = false;
  bool _suggestionDismissed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;
      _initialized = true;
      if (widget.state.people.isNotEmpty) {
        final people = ref.read(billPeopleViewModelProvider).people;
        if (people.isEmpty) {
          for (final p in widget.state.people) {
            ref.read(billPeopleViewModelProvider.notifier).addPerson(
                  p.name,
                  p.colorIndex,
                  phoneNumber: p.phoneNumber,
                );
          }
        }
      }
    });
  }

  Future<void> _addPersonDialog() async {
    final currentPeople = ref.read(billPeopleViewModelProvider).people;
    final result = await AddPersonDialog.show(
      context,
      defaultColorIndex: currentPeople.length,
    );
    if (result == null || !mounted) return;
    ref.read(billPeopleViewModelProvider.notifier).addPerson(
          result.name,
          result.colorIndex,
          phoneNumber: result.phoneNumber,
        );
  }

  Future<void> _saveAsShilla() async {
    final people = ref.read(billPeopleViewModelProvider).people;
    if (people.length < 2) return;
    final name = await SaveShillaDialog.show(context, people: people);
    if (name == null || !mounted) return;
    final ok =
        await ref.read(billPeopleViewModelProvider.notifier).saveAsShilla(name);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('shilla_saved'))),
      );
    }
  }

  void _onContinue() {
    final people = ref.read(billPeopleViewModelProvider).people;
    if (people.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('add_at_least_one_person'))),
      );
      return;
    }
    widget.vm.setPeople(people);
    widget.vm.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final pState = ref.watch(billPeopleViewModelProvider);
    final suggestionAsync = ref.watch(shillaSuggestionProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacingLg,
            AppDimensions.spacingMd,
            AppDimensions.spacingLg,
            AppDimensions.spacingSm,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              context.l10n.t('add_people_title'),
              style: context.textStyles.headlineMedium,
            ),
          ),
        ),

        if (!_suggestionDismissed && pState.people.isEmpty)
          suggestionAsync.maybeWhen(
            data: (suggestion) {
              if (suggestion == null) return const SizedBox.shrink();
              return ShillaSuggestionBanner(
                suggestion: suggestion,
                onAccept: () {
                  setState(() => _suggestionDismissed = true);
                  ref
                      .read(billPeopleViewModelProvider.notifier)
                      .loadShilla(suggestion.shilla.id);
                },
                onDismiss: () =>
                    setState(() => _suggestionDismissed = true),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),

        if (pState.savedShillas.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                context.l10n.t('my_shillas'),
                style: context.textStyles.labelLarge,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingLg,
              ),
              itemCount: pState.savedShillas.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.spacingSm),
              itemBuilder: (_, i) => SizedBox(
                width: 160,
                child: ShillaCard(
                  shilla: pState.savedShillas[i],
                  onTap: () => ref
                      .read(billPeopleViewModelProvider.notifier)
                      .loadShilla(pState.savedShillas[i].id),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],

        Expanded(
          child: pState.people.isEmpty
              ? EmptyStateWidget(
                  icon: PhosphorIconsRegular.usersThree,
                  title: context.l10n.t('no_people_yet'),
                  description: context.l10n.t('no_people_desc'),
                  iconSize: 56,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingLg,
                  ),
                  itemCount: pState.people.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.spacingSm),
                  itemBuilder: (_, i) {
                    final p = pState.people[i];
                    return CustomCard(
                      child: Row(
                        children: [
                          PersonAvatar(
                            name: p.name,
                            colorIndex: p.colorIndex,
                            size: AvatarSize.medium,
                          ),
                          const SizedBox(width: AppDimensions.spacingMd),
                          Expanded(
                            child: Text(
                              p.name,
                              style: context.textStyles.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: context.l10n.t('remove_person'),
                            icon: const Icon(
                              PhosphorIconsRegular.trash,
                              color: AppColors.error,
                            ),
                            onPressed: () => ref
                                .read(billPeopleViewModelProvider.notifier)
                                .removePerson(p.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: context.l10n.t('add_person'),
                      icon: PhosphorIconsBold.userPlus,
                      onPressed: _addPersonDialog,
                    ),
                  ),
                  if (pState.people.length >= 2) ...[
                    const SizedBox(width: AppDimensions.spacingSm),
                    Expanded(
                      child: SecondaryButton(
                        text: context.l10n.t('save_as_shilla'),
                        icon: PhosphorIconsBold.bookmarkSimple,
                        onPressed: _saveAsShilla,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              PrimaryButton(
                text: context.l10n.t('common_continue'),
                icon: PhosphorIconsBold.arrowLeft,
                onPressed: pState.people.isEmpty ? null : _onContinue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
