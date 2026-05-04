import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/services/whatsapp_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class WhatsAppTemplateDialog extends ConsumerStatefulWidget {
  const WhatsAppTemplateDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
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
        child: const WhatsAppTemplateDialog(),
      ),
    );
  }

  @override
  ConsumerState<WhatsAppTemplateDialog> createState() =>
      _WhatsAppTemplateDialogState();
}

class _WhatsAppTemplateDialogState
    extends ConsumerState<WhatsAppTemplateDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final service = ref.read(whatsappServiceProvider);
    _controller = TextEditingController(text: service.getTemplate());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await ref.read(whatsappServiceProvider).setTemplate(text);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.t('whatsapp_template_saved'))),
    );
  }

  void _resetToDefault() {
    setState(() => _controller.text = kDefaultWhatsAppTemplate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
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
              context.l10n.t('whatsapp_template'),
              style: context.textStyles.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              context.l10n.t('whatsapp_template_desc'),
              style: context.textStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            TextField(
              controller: _controller,
              maxLines: 6,
              minLines: 4,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                helperText:
                    context.l10n.t('whatsapp_template_placeholders'),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: context.l10n.t('whatsapp_template_reset'),
                    onPressed: _resetToDefault,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: PrimaryButton(
                    text: context.l10n.t('whatsapp_template_save'),
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
