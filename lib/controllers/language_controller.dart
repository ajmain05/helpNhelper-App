import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  static const _key = 'app_language';

  // Default language: English
  String get currentLang => _box.read(_key) ?? 'en';
  bool get isBangla => currentLang == 'bn';
  bool get isArabic => currentLang == 'ar';

  void changeLanguage(String langCode) {
    _box.write(_key, langCode);
    Locale locale;
    if (langCode == 'bn') {
      locale = const Locale('bn', 'BD');
    } else if (langCode == 'ar') {
      locale = const Locale('ar', 'SA');
    } else {
      locale = const Locale('en', 'US');
    }
    Get.updateLocale(locale);
    update();
  }
}
