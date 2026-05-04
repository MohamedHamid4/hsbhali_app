import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/whatsapp_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bills/domain/entities/person.dart';

const Color _whatsAppGreen = Color(0xFF25D366);

class WhatsAppButton extends ConsumerWidget {
  final Person person;
  final String place;
  final double amount;
  final String currency;

  const WhatsAppButton({
    super.key,
    required this.person,
    required this.place,
    required this.amount,
    required this.currency,
  });

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    final service = ref.read(whatsappServiceProvider);
    final message = service.formatMessage(
      name: person.name,
      place: place,
      amount: amount,
      currency: currency,
    );
    final result = await service.sendMessage(
      message: message,
      phoneNumber: person.phoneNumber,
    );

    if (result == WhatsAppSendResult.opened ||
        result == WhatsAppSendResult.shared ||
        result == WhatsAppSendResult.fallbackShared) {
      await ref.read(analyticsServiceProvider).trackWhatsAppSent();
    }

    if (!context.mounted) return;

    if (result == WhatsAppSendResult.failed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('whatsapp_send_failed'))),
      );
    } else if (result == WhatsAppSendResult.fallbackShared) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('whatsapp_not_installed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: context.l10n.t('send_whatsapp'),
      icon: const Icon(
        PhosphorIconsBold.whatsappLogo,
        color: _whatsAppGreen,
        size: AppDimensions.iconMedium,
      ),
      onPressed: () => _onPressed(context, ref),
    );
  }
}
