import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bills/domain/entities/person.dart';
import 'person_avatar.dart';

class SaveShillaDialog extends StatefulWidget {
  final List<Person> people;

  const SaveShillaDialog({super.key, required this.people});

  static Future<String?> show(
    BuildContext context, {
    required List<Person> people,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => SaveShillaDialog(people: people),
    );
  }

  @override
  State<SaveShillaDialog> createState() => _SaveShillaDialogState();
}

class _SaveShillaDialogState extends State<SaveShillaDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.t('save_as_shilla')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppDimensions.spacingXs,
            runSpacing: AppDimensions.spacingXs,
            children: widget.people
                .map((p) => PersonAvatar(
                      name: p.name,
                      colorIndex: p.colorIndex,
                      size: AvatarSize.small,
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onSave(),
            decoration: InputDecoration(
              labelText: context.l10n.t('shilla_name'),
              hintText: context.l10n.t('shilla_name_hint'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.t('common_cancel')),
        ),
        FilledButton(
          onPressed: _onSave,
          child: Text(context.l10n.t('common_save')),
        ),
      ],
    );
  }
}
