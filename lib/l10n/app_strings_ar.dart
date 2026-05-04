/// النصوص العربية (لهجة مصرية).
///
/// كل النصوص هنا بالمصري الدارج. ممنوع استخدام كلمات شامية/فلسطينية
/// (فيض، بدك، شو، ليش، كيف، هلق، منيح، إلخ)، و ممنوع الفصحى
/// لما الكلمة المصرية تكون أوضح.
class AppStringsAr {
  AppStringsAr._();

  static const Map<String, String> strings = {
    // ─── App Identity ───────────────────────────────────
    'app_name': 'حسبهالي',
    'app_tagline': 'قسّم فاتورة المطعم في ثواني',

    // ─── Onboarding ─────────────────────────────────────
    'onboarding_skip': 'تخطي',
    'onboarding_next': 'التالي',
    'onboarding_start': 'يلا نبدأ',
    'onboarding_1_title': 'صوّر الفاتورة',
    'onboarding_1_desc': 'خد صورة لفاتورة المطعم و خلي AI يقراهالك',
    'onboarding_2_title': 'قسّم على الشِلة',
    'onboarding_2_desc': 'ضيف صحابك و قسّم الفاتورة بالعدل في ثواني',
    'onboarding_3_title': 'شير بطاقة شيك',
    'onboarding_3_desc': 'ابعت لكل واحد نصيبه على الواتس بطريقة أنيقة',

    // ─── Home ───────────────────────────────────────────
    'home_greeting_morning': 'صباح الخير',
    'home_greeting_evening': 'مساء النور',
    'home_subtitle': 'يلا نقسّم فاتورة!',
    'home_new_bill': 'فاتورة جديدة',
    'home_new_bill_desc': 'صوّر الفاتورة و خلصنا',
    'home_quick_calculate': 'حسبة سريعة',
    'home_my_bills': 'فواتيري',
    'home_recent_bills': 'آخر الفواتير',
    'home_no_bills_title': 'لسه مفيش فواتير',
    'home_no_bills_desc': 'يلا اعمل أول فاتورة و هتبان هنا',
    'home_stats_count': 'عدد الفواتير',
    'home_stats_total': 'إجمالي الشهر',
    'home_stats_top_place': 'أكتر مكان',

    // ─── Quick Calculate ────────────────────────────────
    'quick_calc_title': 'حسبة سريعة',
    'quick_calc_amount': 'المبلغ',
    'quick_calc_people': 'عدد الناس',
    'quick_calc_tip': 'البقشيش (اختياري)',
    'quick_calc_tip_none': 'من غير',
    'quick_calc_per_person': 'نصيب كل واحد',
    'quick_calc_total': 'المجموع',
    'quick_calc_grand_total': 'الإجمالي',

    // ─── Settings ───────────────────────────────────────
    'settings_title': 'الإعدادات',
    'settings_appearance': 'المظهر',
    'settings_theme': 'الثيم',
    'settings_theme_light': 'فاتح',
    'settings_theme_dark': 'داكن',
    'settings_theme_system': 'حسب النظام',
    'settings_language': 'اللغة',
    'settings_language_ar': 'العربية',
    'settings_language_en': 'English',
    'settings_currency': 'العملة',
    'settings_about': 'عن التطبيق',
    'settings_share': 'شير التطبيق',
    'settings_rate': 'قيّم التطبيق',
    'settings_privacy': 'سياسة الخصوصية',
    'settings_terms': 'الشروط و الأحكام',
    'settings_version': 'الإصدار',

    // ─── Navigation ─────────────────────────────────────
    'nav_home': 'الرئيسية',
    'nav_bills': 'الفواتير',
    'nav_calculator': 'حاسبة',
    'nav_settings': 'الإعدادات',

    // ─── Common ─────────────────────────────────────────
    'common_cancel': 'إلغاء',
    'common_save': 'احفظ',
    'common_delete': 'امسح',
    'common_share': 'شير',
    'common_edit': 'عدّل',
    'common_back': 'رجوع',
    'common_continue': 'كمّل',
    'common_done': 'تمام',
    'common_yes': 'أيوه',
    'common_no': 'لأ',
    'common_currency_egp': 'ج.م',
    'common_currency_usd': 'دولار',
    'common_coming_soon': 'قريب قوي',
    'common_loading': 'استنى شوية...',
    'common_error': 'في حاجة غلط',
    'common_retry': 'حاول تاني',
    'common_confirm': 'تأكيد',
    'common_ok': 'تمام',

    // ─── Bills ──────────────────────────────────────────
    'bills_title': 'الفواتير',
    'bills_empty_title': 'لسه مفيش فواتير',
    'bills_empty_desc': 'يلا اعمل أول فاتورة',
    'bills_create_first': 'فاتورة جديدة',
    'bills_delete_all': 'امسح الكل',
    'bills_delete_all_confirm': 'متأكد إنك عايز تمسح كل الفواتير؟ مفيش رجوع.',
    'bill_untitled': 'فاتورة من غير اسم',
    'bill_people_count': '{count} ناس',

    // ─── Create Bill ────────────────────────────────────
    'create_bill_title': 'فاتورة جديدة',
    'create_bill_capture': 'صوّر الفاتورة',
    'create_bill_capture_desc': 'صوّرها و هنحلل الأصناف بالذكاء',
    'create_bill_manual': 'هكتبها بإيدي',
    'create_bill_manual_desc': 'من غير صورة، هكتب الأصناف بنفسي',
    'create_bill_step_place': 'المكان و التاريخ',
    'create_bill_step_items': 'الأصناف',
    'create_bill_step_review': 'المراجعة',
    'place_name': 'اسم المكان',
    'place_name_optional': 'اسم المكان (اختياري)',
    'place_name_hint': 'مثلاً: ماك التجمع',
    'date': 'التاريخ',
    'currency': 'العملة',
    'add_item': 'ضيف صنف',
    'edit_item': 'عدّل الصنف',
    'item_name': 'اسم الصنف',
    'item_name_hint': 'مثلاً: بيج ماك',
    'item_quantity': 'الكمية',
    'item_price': 'السعر',
    'item_total': 'الإجمالي',
    'no_items_yet': 'يلا ضيف أول صنف',
    'subtotal': 'المجموع',
    'tax': 'الضريبة',
    'tip': 'البقشيش',
    'service_charge': 'الخدمة',
    'total': 'الإجمالي',
    'save_bill': 'احفظ الفاتورة',
    'delete_bill': 'امسح الفاتورة',
    'delete_bill_confirm': 'متأكد إنك عايز تمسح الفاتورة دي؟',
    'bill_saved': 'الفاتورة اتحفظت',
    'bill_deleted': 'الفاتورة اتمسحت',
    'bill_save_error': 'مفيش فايدة، الفاتورة معتحفظتش',

    // ─── Camera ─────────────────────────────────────────
    'capture_receipt': 'صوّر',
    'choose_from_gallery': 'من الصور',
    'retake': 'صوّر تاني',
    'use_this_photo': 'استخدم الصورة دي',
    'permission_camera_denied': 'لازم تسمحلنا نستخدم الكاميرا',
    'permission_storage_denied': 'لازم تسمحلنا ندخل على الصور',
    'open_settings': 'افتح الإعدادات',

    // ─── Date helpers ──────────────────────────────────
    'today': 'النهارده',
    'yesterday': 'إمبارح',
    'days_ago': 'من {days} يوم',

    // ─── Bill Details ──────────────────────────────────
    'bill_details_title': 'تفاصيل الفاتورة',
    'bill_items': 'الأصناف',
    'bill_no_items': 'مفيش أصناف',
    'bill_receipt_image': 'صورة الفاتورة',
    'bill_updated': 'الفاتورة اتعدّلت',
    'edit_bill': 'عدّل الفاتورة',

    // ─── People ─────────────────────────────────────────
    'add_people_title': 'مين معاك؟',
    'add_person': 'ضيف حد',
    'person_name': 'اسم الشخص',
    'person_name_hint': 'مثلاً: أحمد',
    'select_color': 'اختار لون',
    'no_people_yet': 'ضيف صحابك',
    'no_people_desc': 'ضيف الناس اللي معاك في الفاتورة',
    'remove_person': 'شيل',
    'people_count_n': '{count} ناس',

    // ─── Shillati ───────────────────────────────────────
    'shillati': 'شِللي',
    'my_shillas': 'الشِلل المحفوظة',
    'create_shilla': 'اعمل شِلة',
    'save_as_shilla': 'احفظهم كشِلة',
    'shilla_name': 'اسم الشِلة',
    'shilla_name_hint': 'مثلاً: شلة الشغل',
    'shilla_saved': 'الشِلة اتحفظت',
    'use_shilla': 'استخدم',
    'used_times': 'استخدمتها {count} مرة',
    'no_shillas': 'مفيش شِلل محفوظة',
    'no_shillas_desc': 'احفظ شِللك اللي بتطلع معاهم كتير',
    'delete_shilla_confirm': 'تمسح الشِلة دي؟',
    'shilla_deleted': 'الشِلة اتمسحت',

    // ─── Item Assignment ────────────────────────────────
    'assign_items_title': 'مين أكل إيه؟',
    'split_equally': 'نص و نص',
    'split_among': 'تقسيم على {count}',
    'unassigned_items': 'في أصناف من غير حد',
    'tap_to_assign': 'دوس على الناس عشان تقسّم',
    'split_mode_equal': 'نص و نص',
    'split_mode_quantity': 'بالكمية',
    'split_mode_hint_equal': 'اختار الناس اللي أكلت من الصنف ده',
    'split_mode_hint_quantity': 'كل واحد كم حصة أخد؟',
    'portions_total_match': 'المجموع: {current} / {total} ✅',
    'portions_total_mismatch': 'باقي {missing} حصة',
    'portions_total_excess': 'زيادة {excess} حصة',

    // ─── Tip & Extras ───────────────────────────────────
    'tip_label': 'بقشيش',
    'tip_percentage': 'نسبة',
    'tip_fixed': 'مبلغ محدد',
    'tip_none': 'من غير',
    'tip_custom': 'حدد المبلغ',
    'tip_custom_amount': 'مبلغ البقشيش',
    'tax_label': 'ضريبة',
    'service_label': 'خدمة',
    'tax_optional': 'ضريبة (اختياري)',
    'service_optional': 'خدمة (اختياري)',
    'extras_title': 'إضافات',

    // ─── Result Screen ──────────────────────────────────
    'result_title': 'خلصنا!',
    'per_person': 'نصيب كل واحد',
    'owes': 'عليه',
    'total_amount': 'الإجمالي',
    'view_details': 'شوف التفاصيل',
    'share_bill': 'شير الفاتورة',
    'view_items': 'شوف الأصناف',

    // ─── Validation ─────────────────────────────────────
    'add_at_least_one_person': 'ضيف على الأقل واحد',
    'assign_all_items': 'لازم تقسّم كل الأصناف',
    'tip_invalid': 'البقشيش غلط',

    // ─── OCR ────────────────────────────────────────────
    'ocr_processing': 'في السكة، دقيقة و بجيبلك كل حاجة ⚡',
    'ocr_processing_desc': 'سيبهالي.. أنا بقرا الفاتورة و بطلعلك الأصناف',
    'ocr_review_title': 'راجع الأصناف',
    'ocr_low_confidence': 'النتايج محتاجة مراجعة كويس',
    'ocr_failed_title': 'مقدرتش أقرا الفاتورة',
    'ocr_failed_desc': 'تكتب الأصناف بإيدك؟',
    'ocr_try_again': 'حاول تاني',
    'ocr_manual_entry': 'أكتبها بإيدي',
    'ocr_detected_place': 'المكان اللي لقيته',
    'ocr_detected_date': 'التاريخ اللي لقيته',
    'ocr_extracted_count': 'لقيت {count} صنف',
    'add_item_to_table': '+ ضيف صنف',
    'item_name_field': 'اسم الصنف',
    'qty_short': 'كمية',
    'price_short': 'سعر',
    'continue_to_people': 'كمّل',

    // ─── Sharing ────────────────────────────────────────
    'share_bill_title': 'شير الفاتورة',
    'share_bill_button': 'شير',
    'share_mode_group': 'الكل',
    'share_mode_individual': 'فردي',
    'select_person_to_share': 'اختار حد',
    'save_to_gallery': 'احفظ في الصور',
    'share_now': 'شير دلوقتي',
    'image_saved': 'الصورة اتحفظت',
    'share_failed': 'الشير فشل',
    'permission_gallery_denied': 'لازم تسمحلنا ندخل على الصور',
    'share_bill_caption': 'حسبهالي - فاتورة متقسّمة',
    'sharing_loading': 'بنحضّر...',

    // ─── Receipt Card ───────────────────────────────────
    'receipt_subtotal': 'المجموع',
    'receipt_tax': 'ضريبة',
    'receipt_tip': 'بقشيش',
    'receipt_service': 'خدمة',
    'receipt_total': 'الإجمالي',
    'receipt_per_person': 'نصيب كل واحد',
    'receipt_your_items': 'طلباتك',
    'receipt_your_total': 'إجمالي نصيبك',
    'receipt_your_tax': 'نصيبك من الضريبة',
    'receipt_your_tip': 'نصيبك من البقشيش',
    'receipt_your_service': 'نصيبك من الخدمة',
    'receipt_branding': 'محسوبة بـ "حسبهالي"',
    'receipt_participants': 'المشاركين و الحساب',
    'receipt_thanks_footer': 'محسوب بـ تطبيق حسبهالي',

    // ─── Smart Memory (تكرار الفواتير) ─────────────────
    'home_repeat_bills': 'تكرار فواتيرك',
    'repeat_last_bill': 'تكرار نفس الطلب',
    'last_visit': 'آخر مرة',
    'visits_count': '{count} زيارة',
    'avg_amount': 'متوسط الفاتورة',

    // ─── Shilla Suggestions ────────────────────────────
    'shilla_suggestion_title': 'فيه شلة بتفكرني فيك',
    'shilla_suggestion_use': 'استخدم',
    'shilla_suggestion_dismiss': 'مش هي',
    'shilla_used_times_text': 'مستخدمها {count} مرة قبل كده',

    // ─── WhatsApp ───────────────────────────────────────
    'send_whatsapp': 'ابعت واتساب',
    'person_phone_optional': 'رقم التليفون (اختياري)',
    'person_phone_hint': 'مثال: 201001234567',
    'whatsapp_template': 'قالب رسالة الواتساب',
    'whatsapp_template_desc': 'الرسالة اللي بتتبعت لكل شخص',
    'whatsapp_template_save': 'احفظ القالب',
    'whatsapp_template_reset': 'رجّع الافتراضي',
    'whatsapp_template_placeholders':
        'علامات متاحة: {name}, {place}, {amount}, {currency}',
    'whatsapp_template_saved': 'القالب اتحفظ',
    'whatsapp_message_default':
        'السلام عليكم {name} 👋\nنصيبك من {place} = {amount} {currency} 🍽\n\nمحسوبة بـ "حسبهالي"',
    'whatsapp_not_installed': 'الواتساب مش مثبّت — اتعملت مشاركة عادية',
    'whatsapp_send_failed': 'الإرسال فشل، حاول تاني',

    // ─── Insights / تقاريري ────────────────────────────
    'insights_section': 'التقارير',
    'monthly_insights': 'تقريرك الشهري',
    'monthly_insights_title': 'تقاريري',
    'this_month': 'الشهر ده',
    'last_month': 'الشهر اللي فات',
    'change_increased': 'أكتر بـ {percent}%',
    'change_decreased': 'أقل بـ {percent}%',
    'change_same': 'نفس الشهر اللي فات',
    'top_places': 'أكتر الأماكن',
    'top_companions': 'أكتر الناس اللي طلعت معاهم',
    'weekly_breakdown': 'الصرف بالأسبوع',
    'week_n': 'أسبوع {n}',
    'no_data_this_month': 'مفيش فواتير الشهر ده',
    'monthly_total': 'الإجمالي الشهري',
    'monthly_count': 'عدد الفواتير',
    'monthly_avg': 'متوسط الفاتورة',
    'visits_n_times': '{count} مرة',
    'shared_n_bills': 'طلعتوا مع بعض {count} مرة',
    'change_month': 'شوف شهر تاني',
    'select_month': 'اختار الشهر',

    // ─── About / عن التطبيق ─────────────────────────────
    'about_app': 'عن حسبهالي',
    'about_title': 'عن حسبهالي',
    'about_version': 'النسخة',
    'about_developer': 'المطوّر',
    'about_made_with_love': 'صُنع بحب لكل اللي بيقسموا الفاتورة 💚',
    'about_description':
        'حسبهالي تطبيق ذكي لتقسيم فواتير المطاعم و الكافيهات. اتصمم خصيصاً عشان يخليك تقسّم الحساب مع صحابك في ثواني، من غير وجع دماغ. بيدعم تصوير الفاتورة و قرايتها بالذكاء الصناعي، حفظ الشِلل اللي بتطلع معاهم كتير، إرسال نصيب كل واحد على الواتساب، و تقارير شهرية بصرفك.',
    'about_developed_by': 'تم التطوير بواسطة',
    'about_visit_website': 'شوف موقع المطوّر',

    // ─── Privacy Policy ─────────────────────────────────
    'privacy_policy_title': 'سياسة الخصوصية',
    'privacy_intro_title': 'مقدمة',
    'privacy_intro_body':
        'إحنا في "حسبهالي" بناخد خصوصيتك على محمل الجد. الصفحة دي بتشرحلك إيه البيانات اللي بنجمعها، إزاي بنستخدمها، و إزاي بنحميها.',
    'privacy_data_collected_title': 'البيانات اللي بنجمعها',
    'privacy_data_collected_body':
        '• بيانات الفواتير (الأصناف، الأسعار، الأسماء) — بتتخزن على جهازك بس\n• صور الفواتير اللي بتصوّرها — بتتخزن على جهازك بس\n• إعدادات التطبيق (اللغة، الثيم) — على جهازك بس\n• بيانات إحصائية مجهولة الهوية لتحسين التطبيق',
    'privacy_data_usage_title': 'إزاي بنستخدم البيانات',
    'privacy_data_usage_body':
        'البيانات بتاعتك بتفضل على جهازك. إحنا مش بنرفع أي بيانات شخصية على سيرفرات. الاستثناء الوحيد هو لما تستخدم خاصية قراية الفاتورة بالذكاء الصناعي، فبتترفع الصورة لخدمة Google Gemini عشان تقراها و بعدين بتتمسح فوراً.',
    'privacy_third_parties_title': 'الخدمات الخارجية',
    'privacy_third_parties_body':
        'التطبيق بيستخدم الخدمات دي:\n• Google Gemini AI — لقراية الفواتير (الصورة بتتمسح فوراً بعد القراية)\n• Google AdMob — لعرض الإعلانات\n• Firebase Analytics — لإحصائيات مجهولة\n• Firebase Crashlytics — للإبلاغ عن الأخطاء\n\nكل خدمة منهم عندها سياسة خصوصية خاصة بيها تقدر تشوفها على موقعها.',
    'privacy_storage_title': 'تخزين البيانات',
    'privacy_storage_body':
        'كل بياناتك (الفواتير، الصور، الإعدادات) بتتخزن محلياً على جهازك باستخدام قاعدة بيانات Hive. لما تمسح التطبيق، البيانات كلها بتتمسح معاه.',
    'privacy_ads_title': 'الإعلانات',
    'privacy_ads_body':
        'بنستخدم Google AdMob لعرض الإعلانات. AdMob ممكن يستخدم معرّفات الإعلانات الخاصة بجهازك لعرض إعلانات مناسبة ليك. تقدر تتحكم في إعدادات الإعلانات من إعدادات جهازك. لو عايز إعلانات خالص، تقدر تشتري الترقية من إعدادات التطبيق.',
    'privacy_children_title': 'الأطفال',
    'privacy_children_body':
        'تطبيقنا مش موجه للأطفال تحت ١٣ سنة. مش بنجمع عمداً أي بيانات شخصية عن الأطفال.',
    'privacy_changes_title': 'تغييرات على السياسة',
    'privacy_changes_body':
        'ممكن نحدّث سياسة الخصوصية دي من وقت للتاني. أي تغييرات هتظهر في التطبيق و على الصفحة دي. استمرار استخدامك للتطبيق بعد التغييرات معناه إنك موافق عليها.',
    'privacy_contact_title': 'تواصل معانا',
    'privacy_contact_body':
        'لو عندك أي أسئلة عن سياسة الخصوصية دي، تقدر تتواصل مع المطوّر عبر موقعه الرسمي.',
    'privacy_last_updated': 'آخر تحديث: مايو ٢٠٢٦',

    // ─── Terms of Service ───────────────────────────────
    'terms_of_service_title': 'شروط الاستخدام',
    'terms_intro_title': 'مقدمة',
    'terms_intro_body':
        'مرحباً بيك في "حسبهالي"! باستخدامك للتطبيق، إنت موافق على الشروط دي. لو مش موافق، الرجاء عدم استخدام التطبيق.',
    'terms_usage_title': 'استخدام التطبيق',
    'terms_usage_body':
        '"حسبهالي" تطبيق مجاني لتقسيم فواتير المطاعم. تقدر تستخدمه للأغراض الشخصية أو التجارية. التطبيق فيه نسخة مجانية بإعلانات، و نسخة مدفوعة بدون إعلانات.',
    'terms_user_responsibilities_title': 'مسؤوليات المستخدم',
    'terms_user_responsibilities_body':
        '• إنت مسؤول عن دقة البيانات اللي بتدخّلها\n• إنت مسؤول عن حماية جهازك و البيانات اللي عليه\n• ممنوع استخدام التطبيق لأي غرض غير قانوني\n• ممنوع محاولة كسر الحماية أو إساءة استخدام التطبيق',
    'terms_intellectual_property_title': 'الملكية الفكرية',
    'terms_intellectual_property_body':
        'كل حقوق التطبيق (التصميم، الكود، الاسم، اللوجو) محفوظة للمطوّر. ممنوع نسخ أو إعادة توزيع التطبيق بدون إذن.',
    'terms_disclaimers_title': 'إخلاء المسؤولية',
    'terms_disclaimers_body':
        '• التطبيق بيتقدّم "كما هو" بدون أي ضمانات\n• الحسابات اللي بيعملها التطبيق هي للمساعدة فقط، و إنت مسؤول عن التأكد منها\n• قراية الفواتير بالذكاء الصناعي ممكن ما تكونش ١٠٠٪ دقيقة\n• المطوّر مش مسؤول عن أي خسائر مالية ناتجة عن استخدام التطبيق',
    'terms_limitations_title': 'حدود المسؤولية',
    'terms_limitations_body':
        'في أقصى حدود السماح القانوني، المطوّر مش مسؤول عن أي أضرار مباشرة أو غير مباشرة أو عرضية ناتجة عن استخدامك للتطبيق.',
    'terms_changes_title': 'تغييرات على الشروط',
    'terms_changes_body':
        'محتفظين بحق تعديل الشروط دي في أي وقت. التغييرات هتسري من وقت نشرها في التطبيق.',
    'terms_contact_title': 'تواصل معانا',
    'terms_contact_body':
        'لو عندك أي أسئلة عن شروط الاستخدام، تقدر تتواصل مع المطوّر عبر موقعه الرسمي.',

    // ─── أيام الأسبوع (مصري) ───────────────────────────
    'day_sunday': 'الأحد',
    'day_monday': 'الاتنين',
    'day_tuesday': 'التلات',
    'day_wednesday': 'الأربع',
    'day_thursday': 'الخميس',
    'day_friday': 'الجمعة',
    'day_saturday': 'السبت',

    // ─── Clear All Data ────────────────────────────────
    'clear_all_data': 'مسح جميع البيانات',
    'clear_all_data_subtitle': 'هتمسح كل الفواتير و الشِلل و الإعدادات',
    'clear_all_data_warning':
        'هتفقد كل الفواتير، الشلل، و الإعدادات اللي حفظتها.. متأكد إنك عايز تكمل؟',
    'clear_all_data_confirm': 'آه، امسح كل حاجة',
    'clear_all_data_success': 'تم مسح جميع البيانات بنجاح',
    'clear_all_data_error': 'مفيش فايدة، حصل خطأ',

    // ─── AdMob ──────────────────────────────────────────
    'ad_loading': 'إعلان...',
    'ad_remove_title': 'شيل الإعلانات',
    'ad_remove_desc': 'مرة واحدة بـ 0.99 دولار و خلاص',
    'ad_remove_button': 'اشتري دلوقتي',
    'ad_remove_restore': 'استرجع المشتريات',
    'ad_purchase_success': 'تمام! الإعلانات اتشالت',
    'ad_purchase_failed': 'الشراء فشل',
    'ad_purchase_pending': 'استنى الشراء...',
    'ad_watch_for_feature': 'شوف إعلان قصير عشان {feature}',
    'ad_watch_button': 'شوف الإعلان',
    'ad_skip_button': 'لأ شكراً',
    'ad_no_internet': 'مفيش إنترنت للإعلانات',
  };
}
