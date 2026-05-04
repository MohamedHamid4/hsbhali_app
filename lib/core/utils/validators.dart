class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? name(String? value) {
    final required0 = required(value, fieldName: 'الاسم');
    if (required0 != null) return required0;
    if (value!.trim().length < 2) return 'الاسم قصير جدًا';
    if (value.trim().length > 30) return 'الاسم طويل جدًا';
    return null;
  }

  static String? amount(String? value) {
    final required0 = required(value, fieldName: 'المبلغ');
    if (required0 != null) return required0;
    final parsed = double.tryParse(value!.trim());
    if (parsed == null) return 'أدخل رقمًا صحيحًا';
    if (parsed <= 0) return 'المبلغ يجب أن يكون أكبر من صفر';
    return null;
  }

  static String? percentage(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'أدخل نسبة صحيحة';
    if (parsed < 0 || parsed > 100) return 'النسبة بين 0 و 100';
    return null;
  }
}
