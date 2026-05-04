import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart' hide ServerException;

import '../constants/api_keys.dart';
import '../errors/exceptions.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ApiKeys.gemini,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        responseMimeType: 'application/json',
      ),
    );
  }

  Future<Map<String, dynamic>> extractReceiptData(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw const ServerException('الصورة غير موجودة');
      }

      final imageBytes = await file.readAsBytes();
      final mimeType = _detectMimeType(imagePath);
      debugPrint(
        '🤖 Gemini: sending image ($mimeType, ${imageBytes.length} bytes)',
      );

      final prompt = TextPart(_buildPrompt());
      final imagePart = DataPart(mimeType, imageBytes);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      final text = response.text;
      debugPrint('🤖 Gemini: response length=${text?.length ?? 0}');
      if (text == null || text.isEmpty) {
        throw const ServerException('فشل قراءة الفاتورة');
      }

      final parsed = json.decode(text) as Map<String, dynamic>;
      final itemCount = (parsed['items'] as List?)?.length ?? 0;
      final confidence = (parsed['confidence'] as num?)?.toDouble() ?? 0.0;
      debugPrint(
        '🤖 Gemini: parsed items=$itemCount, confidence=${confidence.toStringAsFixed(2)}',
      );
      return parsed;
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('🤖 Gemini: error $e');
      throw ServerException('AI error: ${e.toString()}');
    }
  }

  String _detectMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _buildPrompt() => '''
أنت مساعد ذكي متخصص في قراءة فواتير المطاعم باللغتين العربية والإنجليزية.
حلل صورة الفاتورة المرفقة واستخرج البيانات التالية بدقة عالية.

أرجع JSON فقط بهذا الشكل بالضبط:
{
  "place_name": "اسم المطعم أو null",
  "detected_date": "YYYY-MM-DD أو null",
  "items": [
    {
      "name": "اسم الصنف",
      "quantity": 1,
      "unit_price": 50.0
    }
  ],
  "subtotal": 100.0,
  "tax": 14.0,
  "service": 10.0,
  "total": 124.0,
  "confidence": 0.85
}

قواعد مهمة:
1. أسماء الأصناف بنفس لغة الفاتورة (عربي أو إنجليزي)
2. الأسعار أرقام عشرية (double)، الكميات أرقام صحيحة
3. لو ما قدرت تقرأ شي، حط null بدل ما تخترع
4. confidence من 0.0 إلى 1.0 حسب وضوح الفاتورة
5. لو الفاتورة مش واضحة أبداً أو مش فاتورة، رد:
   {"items": [], "confidence": 0.0}
6. ما ترجع أي نص خارج JSON، JSON فقط
7. تجاهل أي عناصر مش طعام (شعار المطعم، رقم الفاتورة، إلخ)
''';
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});
