import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class AddPersonResult {
  final String name;
  final int colorIndex;
  final String? phoneNumber;

  const AddPersonResult({
    required this.name,
    required this.colorIndex,
    this.phoneNumber,
  });
}

class AddPersonDialog extends StatefulWidget {
  final int defaultColorIndex;

  const AddPersonDialog({super.key, this.defaultColorIndex = 0});

  static Future<AddPersonResult?> show(
    BuildContext context, {
    int defaultColorIndex = 0,
  }) {
    return showModalBottomSheet<AddPersonResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: AddPersonDialog(defaultColorIndex: defaultColorIndex),
      ),
    );
  }

  @override
  State<AddPersonDialog> createState() => _AddPersonDialogState();
}

class _AddPersonDialogState extends State<AddPersonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late int _colorIndex;

  @override
  void initState() {
    super.initState();
    _colorIndex = widget.defaultColorIndex % AppColors.peopleColors.length;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();
    Navigator.of(context).pop(AddPersonResult(
      name: _nameController.text.trim(),
      colorIndex: _colorIndex,
      phoneNumber: phone.isEmpty ? null : phone,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                context.l10n.t('add_person'),
                style: context.textStyles.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              TextFormField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.t('person_name'),
                  hintText: context.l10n.t('person_name_hint'),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '—' : null,
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSave(),
                decoration: InputDecoration(
                  labelText: context.l10n.t('person_phone_optional'),
                  hintText: context.l10n.t('person_phone_hint'),
                  prefixIcon: const Icon(PhosphorIconsRegular.phone),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.l10n.t('select_color'),
                  style: context.textStyles.labelLarge,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingMd,
                runSpacing: AppDimensions.spacingSm,
                children: List.generate(
                  AppColors.peopleColors.length,
                  (i) => _ColorDot(
                    color: AppColors.peopleColors[i],
                    isSelected: i == _colorIndex,
                    onTap: () => setState(() => _colorIndex = i),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: context.l10n.t('common_cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: PrimaryButton(
                      text: context.l10n.t('common_save'),
                      onPressed: _onSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? context.colors.onSurface : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
