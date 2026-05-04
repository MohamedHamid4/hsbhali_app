/// English strings for the app.
class AppStringsEn {
  AppStringsEn._();

  static const Map<String, String> strings = {
    // ─── General ────────────────────────────────────────
    'app_name': 'Hsbhali',
    'app_tagline': 'Split restaurant bills in seconds',

    // ─── Onboarding ─────────────────────────────────────
    'onboarding_skip': 'Skip',
    'onboarding_next': 'Next',
    'onboarding_start': 'Get Started',
    'onboarding_1_title': 'Snap the Receipt',
    'onboarding_1_desc': 'Take a photo and let AI read it for you',
    'onboarding_2_title': 'Split with Friends',
    'onboarding_2_desc': 'Add your friends and split fairly in seconds',
    'onboarding_3_title': 'Share Beautiful Card',
    'onboarding_3_desc': 'Send everyone their share via WhatsApp elegantly',

    // ─── Home ───────────────────────────────────────────
    'home_greeting_morning': 'Good Morning',
    'home_greeting_evening': 'Good Evening',
    'home_subtitle': "Let's split a bill!",
    'home_new_bill': 'New Bill',
    'home_new_bill_desc': 'Scan the receipt and we are done',
    'home_quick_calculate': 'Quick Split',
    'home_my_bills': 'My Bills',
    'home_recent_bills': 'Recent Bills',
    'home_no_bills_title': 'No bills yet',
    'home_no_bills_desc': 'Start your first bill and it will appear here',
    'home_stats_count': 'Bills Count',
    'home_stats_total': 'Month Total',
    'home_stats_top_place': 'Top Place',

    // ─── Quick Calculate ────────────────────────────────
    'quick_calc_title': 'Quick Split',
    'quick_calc_amount': 'Amount',
    'quick_calc_people': 'People Count',
    'quick_calc_tip': 'Tip (Optional)',
    'quick_calc_tip_none': 'None',
    'quick_calc_per_person': 'Per Person',
    'quick_calc_total': 'Subtotal',
    'quick_calc_grand_total': 'Total',

    // ─── Settings ───────────────────────────────────────
    'settings_title': 'Settings',
    'settings_appearance': 'Appearance',
    'settings_theme': 'Theme',
    'settings_theme_light': 'Light',
    'settings_theme_dark': 'Dark',
    'settings_theme_system': 'System',
    'settings_language': 'Language',
    'settings_language_ar': 'العربية',
    'settings_language_en': 'English',
    'settings_currency': 'Currency',
    'settings_about': 'About',
    'settings_share': 'Share App',
    'settings_rate': 'Rate App',
    'settings_privacy': 'Privacy Policy',
    'settings_terms': 'Terms & Conditions',
    'settings_version': 'Version',

    // ─── Navigation ─────────────────────────────────────
    'nav_home': 'Home',
    'nav_bills': 'Bills',
    'nav_calculator': 'Calculator',
    'nav_settings': 'Settings',

    // ─── Common ─────────────────────────────────────────
    'common_cancel': 'Cancel',
    'common_save': 'Save',
    'common_delete': 'Delete',
    'common_share': 'Share',
    'common_edit': 'Edit',
    'common_back': 'Back',
    'common_continue': 'Continue',
    'common_done': 'Done',
    'common_yes': 'Yes',
    'common_no': 'No',
    'common_currency_egp': 'EGP',
    'common_currency_usd': 'USD',
    'common_coming_soon': 'Coming Soon',
    'common_loading': 'Loading...',
    'common_error': 'An error occurred',
    'common_retry': 'Retry',
    'common_confirm': 'Confirm',
    'common_ok': 'OK',

    // ─── Bills ──────────────────────────────────────────
    'bills_title': 'Bills',
    'bills_empty_title': 'No bills yet',
    'bills_empty_desc': 'Create your first bill',
    'bills_create_first': 'Create Bill',
    'bills_delete_all': 'Delete All',
    'bills_delete_all_confirm': 'Delete all bills? This cannot be undone.',
    'bill_untitled': 'Untitled bill',
    'bill_people_count': '{count} people',

    // ─── Create Bill ────────────────────────────────────
    'create_bill_title': 'New Bill',
    'create_bill_capture': 'Capture Receipt',
    'create_bill_capture_desc': 'Take a photo & add items manually',
    'create_bill_manual': 'Manual Entry',
    'create_bill_manual_desc': 'No photo, I will type everything',
    'create_bill_step_place': 'Place & Date',
    'create_bill_step_items': 'Items',
    'create_bill_step_review': 'Review',
    'place_name': 'Place Name',
    'place_name_optional': 'Place Name (Optional)',
    'place_name_hint': 'e.g. McDonald\'s Tagamoa',
    'date': 'Date',
    'currency': 'Currency',
    'add_item': 'Add Item',
    'edit_item': 'Edit Item',
    'item_name': 'Item Name',
    'item_name_hint': 'e.g. Big Mac',
    'item_quantity': 'Quantity',
    'item_price': 'Unit Price',
    'item_total': 'Total',
    'no_items_yet': 'Start by adding your first item',
    'subtotal': 'Subtotal',
    'tax': 'Tax',
    'tip': 'Tip',
    'service_charge': 'Service',
    'total': 'Total',
    'save_bill': 'Save Bill',
    'delete_bill': 'Delete Bill',
    'delete_bill_confirm': 'Are you sure you want to delete this bill?',
    'bill_saved': 'Bill saved',
    'bill_deleted': 'Bill deleted',
    'bill_save_error': 'Failed to save bill',

    // ─── Camera ─────────────────────────────────────────
    'capture_receipt': 'Take Photo',
    'choose_from_gallery': 'Choose from Gallery',
    'retake': 'Retake',
    'use_this_photo': 'Use this photo',
    'permission_camera_denied': 'Camera permission required',
    'permission_storage_denied': 'Storage permission required',
    'open_settings': 'Open Settings',

    // ─── Date helpers ──────────────────────────────────
    'today': 'Today',
    'yesterday': 'Yesterday',
    'days_ago': '{days} days ago',

    // ─── Bill Details ──────────────────────────────────
    'bill_details_title': 'Bill Details',
    'bill_items': 'Items',
    'bill_no_items': 'No items',
    'bill_receipt_image': 'Receipt Image',
    'bill_updated': 'Bill updated',
    'edit_bill': 'Edit Bill',

    // ─── People ─────────────────────────────────────────
    'add_people_title': "Who's with you?",
    'add_person': 'Add Person',
    'person_name': 'Person Name',
    'person_name_hint': 'e.g., Ahmed',
    'select_color': 'Select Color',
    'no_people_yet': 'Add your friends',
    'no_people_desc': 'Add the people sharing this bill',
    'remove_person': 'Remove',
    'people_count_n': '{count} people',

    // ─── Shillati ───────────────────────────────────────
    'shillati': 'My Groups',
    'my_shillas': 'Saved Groups',
    'create_shilla': 'Create Group',
    'save_as_shilla': 'Save as Group',
    'shilla_name': 'Group Name',
    'shilla_name_hint': 'e.g., Work Friends',
    'shilla_saved': 'Group saved',
    'use_shilla': 'Use',
    'used_times': 'Used {count} times',
    'no_shillas': 'No saved groups',
    'no_shillas_desc': 'Save groups you use often',
    'delete_shilla_confirm': 'Delete this group?',
    'shilla_deleted': 'Group deleted',

    // ─── Item Assignment ────────────────────────────────
    'assign_items_title': 'Who ate what?',
    'split_equally': 'Split Equally',
    'split_among': 'Split among {count}',
    'unassigned_items': 'Some items unassigned',
    'tap_to_assign': 'Tap people to assign',
    'split_mode_equal': 'Split Equal',
    'split_mode_quantity': 'By Quantity',
    'split_mode_hint_equal': 'Select who had this item',
    'split_mode_hint_quantity': 'How many portions did each person have?',
    'portions_total_match': 'Total: {current} / {total} ✅',
    'portions_total_mismatch': '{missing} portion(s) remaining',
    'portions_total_excess': '{excess} extra portion(s)',

    // ─── Tip & Extras ───────────────────────────────────
    'tip_label': 'Tip',
    'tip_percentage': 'Percentage',
    'tip_fixed': 'Fixed Amount',
    'tip_none': 'None',
    'tip_custom': 'Custom',
    'tip_custom_amount': 'Tip Amount',
    'tax_label': 'Tax',
    'service_label': 'Service',
    'tax_optional': 'Tax (Optional)',
    'service_optional': 'Service (Optional)',
    'extras_title': 'Extras',

    // ─── Result Screen ──────────────────────────────────
    'result_title': 'All Done!',
    'per_person': 'Per Person',
    'owes': 'Owes',
    'total_amount': 'Total Amount',
    'view_details': 'View Details',
    'share_bill': 'Share Bill',
    'view_items': 'View Items',

    // ─── Validation ─────────────────────────────────────
    'add_at_least_one_person': 'Add at least one person',
    'assign_all_items': 'Assign all items to people',
    'tip_invalid': 'Invalid tip',

    // ─── OCR ────────────────────────────────────────────
    'ocr_processing': 'On it! Give me a sec to read your receipt ⚡',
    'ocr_processing_desc': 'Hang tight — I\'m pulling out the items for you',
    'ocr_review_title': 'Review Items',
    'ocr_low_confidence': 'Results may need careful review',
    'ocr_failed_title': 'Couldn\'t read the receipt',
    'ocr_failed_desc': 'Want to enter items manually?',
    'ocr_try_again': 'Try Again',
    'ocr_manual_entry': 'Manual Entry',
    'ocr_detected_place': 'Detected Place',
    'ocr_detected_date': 'Detected Date',
    'ocr_extracted_count': 'Extracted {count} items',
    'add_item_to_table': '+ Add Item',
    'item_name_field': 'Item Name',
    'qty_short': 'Qty',
    'price_short': 'Price',
    'continue_to_people': 'Continue',

    // ─── Sharing ────────────────────────────────────────
    'share_bill_title': 'Share Bill',
    'share_bill_button': 'Share Bill',
    'share_mode_group': 'All',
    'share_mode_individual': 'Individual',
    'select_person_to_share': 'Select Person',
    'save_to_gallery': 'Save to Gallery',
    'share_now': 'Share',
    'image_saved': 'Image saved to gallery',
    'share_failed': 'Sharing failed',
    'permission_gallery_denied': 'Gallery permission required',
    'share_bill_caption': 'Hsbhali - Split Bill',
    'sharing_loading': 'Preparing...',

    // ─── Receipt Card ───────────────────────────────────
    'receipt_subtotal': 'Subtotal',
    'receipt_tax': 'Tax',
    'receipt_tip': 'Tip',
    'receipt_service': 'Service',
    'receipt_total': 'Total',
    'receipt_per_person': 'Per Person',
    'receipt_your_items': 'Your Items',
    'receipt_your_total': 'Your Total',
    'receipt_your_tax': 'Your Tax Share',
    'receipt_your_tip': 'Your Tip Share',
    'receipt_your_service': 'Your Service Share',
    'receipt_branding': 'Calculated with "Hsbhali"',
    'receipt_participants': 'Who paid for what',
    'receipt_thanks_footer': 'Split with the Hsbhali app',

    // ─── Smart Memory (repeat bills) ────────────────────
    'home_repeat_bills': 'Repeat your bills',
    'repeat_last_bill': 'Repeat last order',
    'last_visit': 'Last visit',
    'visits_count': '{count} visits',
    'avg_amount': 'Average bill',

    // ─── Shilla Suggestions ─────────────────────────────
    'shilla_suggestion_title': 'A familiar group',
    'shilla_suggestion_use': 'Use it',
    'shilla_suggestion_dismiss': 'Not this',
    'shilla_used_times_text': 'Used {count} times before',

    // ─── WhatsApp ───────────────────────────────────────
    'send_whatsapp': 'Send via WhatsApp',
    'person_phone_optional': 'Phone (optional)',
    'person_phone_hint': 'e.g. 201001234567',
    'whatsapp_template': 'WhatsApp message template',
    'whatsapp_template_desc': 'The message sent to each person',
    'whatsapp_template_save': 'Save template',
    'whatsapp_template_reset': 'Reset to default',
    'whatsapp_template_placeholders':
        'Placeholders: {name}, {place}, {amount}, {currency}',
    'whatsapp_template_saved': 'Template saved',
    'whatsapp_message_default':
        'Hey {name} 👋\nYour share at {place} = {amount} {currency} 🍽\n\nCalculated with "Hsbhali"',
    'whatsapp_not_installed': 'WhatsApp not installed — used regular share',
    'whatsapp_send_failed': 'Send failed, please try again',

    // ─── Insights / My Reports ──────────────────────────
    'insights_section': 'Reports',
    'monthly_insights': 'Monthly report',
    'monthly_insights_title': 'My Reports',
    'this_month': 'This month',
    'last_month': 'Last month',
    'change_increased': '{percent}% more',
    'change_decreased': '{percent}% less',
    'change_same': 'Same as last month',
    'top_places': 'Top places',
    'top_companions': 'Most frequent companions',
    'weekly_breakdown': 'Weekly spending',
    'week_n': 'Week {n}',
    'no_data_this_month': 'No bills this month',
    'monthly_total': 'Monthly total',
    'monthly_count': 'Bills count',
    'monthly_avg': 'Average bill',
    'visits_n_times': '{count} visits',
    'shared_n_bills': 'Shared {count} bills with you',
    'change_month': 'Pick another month',
    'select_month': 'Select a month',

    // ─── About ──────────────────────────────────────────
    'about_app': 'About Hsbhali',
    'about_title': 'About Hsbhali',
    'about_version': 'Version',
    'about_developer': 'Developer',
    'about_made_with_love':
        'Made with love for everyone splitting the bill 💚',
    'about_description':
        'Hsbhali is a smart app for splitting restaurant and café bills. It is built to let you split the check with friends in seconds, hassle-free. It supports AI-based receipt scanning, saved frequent groups, sending each person their share over WhatsApp, and monthly spending reports.',
    'about_developed_by': 'Developed by',
    'about_visit_website': 'Visit developer website',

    // ─── Privacy Policy ─────────────────────────────────
    'privacy_policy_title': 'Privacy Policy',
    'privacy_intro_title': 'Introduction',
    'privacy_intro_body':
        'At "Hsbhali", we take your privacy seriously. This page explains what data we collect, how we use it, and how we protect it.',
    'privacy_data_collected_title': 'Data we collect',
    'privacy_data_collected_body':
        '• Bill data (items, prices, names) — stored only on your device\n• Receipt photos you take — stored only on your device\n• App settings (language, theme) — only on your device\n• Anonymous usage statistics to improve the app',
    'privacy_data_usage_title': 'How we use the data',
    'privacy_data_usage_body':
        'Your data stays on your device. We do not upload any personal data to servers. The only exception is when you use the AI receipt-reading feature: the photo is sent to Google Gemini to read it, then deleted immediately.',
    'privacy_third_parties_title': 'Third-party services',
    'privacy_third_parties_body':
        'The app uses these services:\n• Google Gemini AI — for reading receipts (image discarded after reading)\n• Google AdMob — to display ads\n• Firebase Analytics — for anonymous statistics\n• Firebase Crashlytics — for crash reporting\n\nEach has its own privacy policy on its respective website.',
    'privacy_storage_title': 'Data storage',
    'privacy_storage_body':
        'All your data (bills, photos, settings) is stored locally on your device using a Hive database. When you uninstall the app, all data is removed with it.',
    'privacy_ads_title': 'Advertising',
    'privacy_ads_body':
        'We use Google AdMob to display ads. AdMob may use your device advertising identifiers to show you relevant ads. You can control ad settings from your device settings. If you want no ads at all, you can purchase the upgrade from the app settings.',
    'privacy_children_title': 'Children',
    'privacy_children_body':
        'Our app is not directed to children under 13. We do not knowingly collect any personal information from children.',
    'privacy_changes_title': 'Changes to this policy',
    'privacy_changes_body':
        'We may update this Privacy Policy from time to time. Any changes will appear in the app and on this page. Continued use of the app after changes means you agree to them.',
    'privacy_contact_title': 'Contact us',
    'privacy_contact_body':
        'If you have any questions about this Privacy Policy, please contact the developer via the official website.',
    'privacy_last_updated': 'Last updated: May 2026',

    // ─── Terms of Service ───────────────────────────────
    'terms_of_service_title': 'Terms of Service',
    'terms_intro_title': 'Introduction',
    'terms_intro_body':
        'Welcome to "Hsbhali". By using the app you agree to these terms. If you do not agree, please do not use the app.',
    'terms_usage_title': 'App usage',
    'terms_usage_body':
        '"Hsbhali" is a free app for splitting restaurant bills. You may use it for personal or commercial purposes. The app offers a free version with ads, and a paid version without ads.',
    'terms_user_responsibilities_title': 'User responsibilities',
    'terms_user_responsibilities_body':
        '• You are responsible for the accuracy of the data you enter\n• You are responsible for protecting your device and its data\n• Using the app for any unlawful purpose is prohibited\n• Attempting to bypass app protection or misuse the app is prohibited',
    'terms_intellectual_property_title': 'Intellectual property',
    'terms_intellectual_property_body':
        'All app rights (design, code, name, logo) are reserved by the developer. Copying or redistributing the app without permission is prohibited.',
    'terms_disclaimers_title': 'Disclaimers',
    'terms_disclaimers_body':
        '• The app is provided "as is" without any warranties\n• Calculations performed by the app are aids only — you are responsible for verifying them\n• AI-based receipt reading may not be 100% accurate\n• The developer is not liable for any financial losses from using the app',
    'terms_limitations_title': 'Limitation of liability',
    'terms_limitations_body':
        'To the maximum extent permitted by law, the developer is not liable for any direct, indirect, or incidental damages resulting from your use of the app.',
    'terms_changes_title': 'Changes to terms',
    'terms_changes_body':
        'We reserve the right to modify these terms at any time. Changes take effect when published in the app.',
    'terms_contact_title': 'Contact us',
    'terms_contact_body':
        'If you have any questions about these Terms, please contact the developer via the official website.',

    // ─── Days of Week ───────────────────────────────────
    'day_sunday': 'Sunday',
    'day_monday': 'Monday',
    'day_tuesday': 'Tuesday',
    'day_wednesday': 'Wednesday',
    'day_thursday': 'Thursday',
    'day_friday': 'Friday',
    'day_saturday': 'Saturday',

    // ─── Clear All Data ────────────────────────────────
    'clear_all_data': 'Clear All Data',
    'clear_all_data_subtitle':
        'Erase all bills, groups, and settings',
    'clear_all_data_warning':
        'You will lose all bills, groups, and settings. Are you sure you want to continue?',
    'clear_all_data_confirm': 'Yes, delete everything',
    'clear_all_data_success': 'All data cleared successfully',
    'clear_all_data_error': 'Something went wrong',

    // ─── AdMob ──────────────────────────────────────────
    'ad_loading': 'Ad...',
    'ad_remove_title': 'Remove Ads',
    'ad_remove_desc': 'One-time \$0.99 and you\'re done',
    'ad_remove_button': 'Buy Now',
    'ad_remove_restore': 'Restore Purchases',
    'ad_purchase_success': 'Done! Ads removed',
    'ad_purchase_failed': 'Purchase failed',
    'ad_purchase_pending': 'Purchase pending...',
    'ad_watch_for_feature': 'Watch a short ad for {feature}',
    'ad_watch_button': 'Watch Ad',
    'ad_skip_button': 'No thanks',
    'ad_no_internet': 'No internet for ads',
  };
}
