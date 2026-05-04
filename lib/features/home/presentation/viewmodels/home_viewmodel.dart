import 'package:flutter_riverpod/flutter_riverpod.dart';

final greetingKeyProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  return hour < 17 ? 'home_greeting_morning' : 'home_greeting_evening';
});
