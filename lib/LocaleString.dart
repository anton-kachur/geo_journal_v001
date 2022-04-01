import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>>get keys => {
    'en-US': {
      'admin_page_text': 'Admin Page',
    },

    'ru-UA': {
      'admin_page_text': 'Сторінка адміністратора',
    },

  };
}