import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/providers/preferences_provider.dart';
import 'preferences_service.dart';

const String kWhatsAppTemplateKey = 'whatsapp_message_template';

const String kDefaultWhatsAppTemplate =
    'السلام عليكم {name} 👋\n'
    'نصيبك من {place} = {amount} {currency} 🍽\n\n'
    'محسوبة بـ "حسبهالي"';

enum WhatsAppSendResult {
  opened,

  shared,

  fallbackShared,

  failed,
}

class WhatsAppService {
  final PreferencesService _prefs;

  const WhatsAppService(this._prefs);

  String getTemplate() {
    return _prefs.getString(kWhatsAppTemplateKey) ?? kDefaultWhatsAppTemplate;
  }

  Future<void> setTemplate(String template) async {
    await _prefs.setString(kWhatsAppTemplateKey, template);
  }

  String formatMessage({
    required String name,
    required String place,
    required double amount,
    String currency = 'EGP',
  }) {
    final template = getTemplate();
    final placeText = place.trim().isEmpty ? '—' : place.trim();
    return template
        .replaceAll('{name}', name)
        .replaceAll('{place}', placeText)
        .replaceAll('{amount}', amount.toStringAsFixed(2))
        .replaceAll('{currency}', currency);
  }

  Future<WhatsAppSendResult> sendMessage({
    required String message,
    String? phoneNumber,
  }) async {
    final cleanNumber = _cleanNumber(phoneNumber);

    if (cleanNumber.isEmpty) {
      try {
        await Share.share(message);
        return WhatsAppSendResult.shared;
      } catch (_) {
        return WhatsAppSendResult.failed;
      }
    }

    final encodedMessage = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$cleanNumber?text=$encodedMessage');

    try {
      final canOpen = await canLaunchUrl(url);
      if (canOpen) {
        final ok = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        if (ok) return WhatsAppSendResult.opened;
      }
    } catch (_) {
    }

    try {
      await Share.share(message);
      return WhatsAppSendResult.fallbackShared;
    } catch (_) {
      return WhatsAppSendResult.failed;
    }
  }

  String _cleanNumber(String? raw) {
    if (raw == null) return '';
    return raw
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim();
  }
}

final whatsappServiceProvider = Provider<WhatsAppService>((ref) {
  return WhatsAppService(ref.watch(preferencesServiceProvider));
});
