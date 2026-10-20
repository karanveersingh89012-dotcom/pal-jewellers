import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'Pal Jewellers',
      'heritage_subtitle': 'PAL JEWELLERS — Since 1880 — ਘੁੰਗਰਾਣੇ ਵਾਲੇ',
      'tagline': 'Customer Satisfaction is our Moto🙂',
      'google_rating': '4.9 / 5.0 Google Rated',
      'hallmark_guarantee': '22K BIS Hallmark Certified Jewellery',
      'catalog': 'Jewellery Catalog',
      'all': 'All',
      'necklaces': 'Necklaces',
      'rings': 'Rings',
      'earrings': 'Earrings',
      'bangles': 'Bangles',
      'wedding': 'Wedding Collection',
      'request_to_order': 'Request to Order',
      'inquire_price': 'Price on Inquiry',
      'customer_name': 'Your Full Name',
      'phone_number': 'Phone Number (+91)',
      'customization_note': 'Special size or customization notes',
      'submit_request': 'Submit Request',
      'request_success': 'Thank you! Mr. Sukhjinder Singh will contact you shortly.',
      'visit_us': 'Visit Showroom',
      'call_us': 'Call Us',
      'whatsapp': 'WhatsApp Us',
      'orders_admin': 'Order Inquiries',
      'add_product': 'Add New Jewellery',
    },
    'pa': {
      'app_title': 'ਪਾਲ ਜਵੈਲਰਜ਼',
      'heritage_subtitle': 'ਪਾਲ ਜਵੈਲਰਜ਼ — ਸੰਨ 1880 ਤੋਂ — ਘੁੰਗਰਾਣੇ ਵਾਲੇ',
      'tagline': 'ਗਾਹਕਾਂ ਦੀ ਸੰਤੁਸ਼ਟੀ ਸਾਡਾ ਮਨੋਰਥ ਹੈ🙂',
      'google_rating': '4.9 / 5.0 ਗੂਗਲ ਰੇਟਿੰਗ',
      'hallmark_guarantee': '22 ਕੈਰੇਟ ਬੀ.ਆਈ.ਐਸ. ਹਾਲਮਾਰਕ ਪ੍ਰਮਾਣਿਤ ਗਹਿਣੇ',
      'catalog': 'ਗਹਿਣਿਆਂ ਦਾ ਕੈਟਾਲਾਗ',
      'all': 'ਸਾਰੇ',
      'necklaces': 'ਹਾਰ (ਨੈਕਲੈਸ)',
      'rings': 'ਮੁੰਦਰੀਆਂ / ਛਾਪਾਂ',
      'earrings': 'ਕੰਨਾਂ ਦੇ ਝੁਮਕੇ',
      'bangles': 'ਚੂੜੀਆਂ / ਕੰਗਣ',
      'wedding': 'ਵਿਆਹ ਸ਼ਗਨਾਂ ਦੇ ਗਹਿਣੇ',
      'request_to_order': 'ਆਰਡਰ ਲਈ ਬੇਨਤੀ ਕਰੋ',
      'inquire_price': 'ਰੇਟ ਪੁੱਛਗਿੱਛ ਲਈ ਸੰਪਰਕ ਕਰੋ',
      'customer_name': 'ਤੁਹਾਡਾ ਪੂਰਾ ਨਾਮ',
      'phone_number': 'ਫ਼ੋਨ ਨੰਬਰ (+91)',
      'customization_note': 'ਆਪਣਾ ਨਾਪ ਜਾਂ ਖ਼ਾਸ ਪਸੰਦ ਲਿਖੋ',
      'submit_request': 'ਬੇਨਤੀ ਭੇਜੋ',
      'request_success': 'ਧੰਨਵਾਦ! ਸੁਖਜਿੰਦਰ ਸਿੰਘ ਜੀ ਤੁਹਾਡੇ ਨਾਲ ਜਲਦੀ ਰਾਬਤਾ ਕਾਇਮ ਕਰਨਗੇ।',
      'visit_us': 'ਸ਼ੋਅਰੂਮ ਦੇ ਦਰਸ਼ਨ ਕਰੋ',
      'call_us': 'ਫ਼ੋਨ ਕਰੋ',
      'whatsapp': 'ਵ੍ਹਟਸਐਪ ਕਰੋ',
      'orders_admin': 'ਗਾਹਕ ਪੁੱਛਗਿੱਛ',
      'add_product': 'ਨਵੇਂ ਗਹਿਣੇ ਸ਼ਾਮਲ ਕਰੋ',
    },
    'hi': {
      'app_title': 'पाल ज्वेलर्स',
      'heritage_subtitle': 'पाल ज्वेलर्स — सन् 1880 से — घुंगराणे वाले',
      'tagline': 'ग्राहकों की संतुष्टि हमारा उद्देश्य है🙂',
      'google_rating': '4.9 / 5.0 गूगल रेटिंग',
      'hallmark_guarantee': '22 कैरेट बी.आई.एस. हॉलमार्क प्रमाणित आभूषण',
      'catalog': 'आभूषण कैटलॉग',
      'all': 'सभी',
      'necklaces': 'हार (नेकलेस)',
      'rings': 'अंगूठियां',
      'earrings': 'झुमके',
      'bangles': 'चूड़ियां और कंगन',
      'wedding': 'विवाह संग्रह',
      'request_to_order': 'ऑर्डर हेतु अनुरोध करें',
      'inquire_price': 'मूल्य पूछताछ पर उपलब्ध',
      'customer_name': 'आपका पूरा नाम',
      'phone_number': 'फ़ोन नंबर (+91)',
      'customization_note': 'आकार या विशेष पसंद लिखें',
      'submit_request': 'अनुरोध भेजें',
      'request_success': 'धन्यवाद! सुखजिंदर सिंह जी शीघ्र ही आपसे संपर्क करेंगे।',
      'visit_us': 'शोरूम पधारें',
      'call_us': 'कॉल करें',
      'whatsapp': 'व्हाट्सएप करें',
      'orders_admin': 'ऑर्डर पूछताछ सूची',
      'add_product': 'नया आभूषण जोड़ें',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pa', 'hi'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}