import 'dart:math';

class ReceiptPhrases {
  ReceiptPhrases._();

  static const List<String> phrases = [
    'ربنا يجمعنا دايماً يا حلوين 💚',
    'صحتين و عافية على قلبكم ❤️',
    'ده اللي طلع علينا.. و المرة الجاية تبقى أحلى 🌹',
    'الأكل كان زي الفل و الصحبة أحلى 🌸',
    'اللهم بارك.. ده كان يوم جميل ✨',

    'يلا بقى.. كل واحد يجيب فلوسه قبل ما الويتر يجي 😅',
    'محدش يقول مش معايا فلوس النهارده 👀',
    'اللي يقول "أنا مش جعان" هو اللي أكل أكتر 😂',
    'إحنا اتقسمنا الحساب.. مش الصداقة 😂',
    'مفيش "هدفعلك بكره".. النهارده كل واحد نصيبه 💪',
    'بعد الأكل ده.. الحساب حلو ولا مر؟ 🤣',
    'اللي عليه الأكتر النهارده.. يبقى المعزوم المرة الجاية 😎',
    'الفاتورة دي تحفة.. زي الأكل بالظبط 🤌',
    'صبر يا قلبي على دفع الحساب 😪',
    'اللي مش عاجبه الحساب.. يدفعه و يسكت 😜',
  ];

  static String getRandom([Random? random]) {
    final r = random ?? Random();
    return phrases[r.nextInt(phrases.length)];
  }

  static String pickFor(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (acc, c) => (acc + c) & 0x7fffffff);
    return phrases[hash % phrases.length];
  }
}
