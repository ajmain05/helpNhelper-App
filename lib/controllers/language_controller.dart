import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  static const _key = 'app_language';

  // Default language: English
  String get currentLang => _box.read(_key) ?? 'en';
  bool get isBangla => currentLang == 'bn';

  void changeLanguage(String langCode) {
    _box.write(_key, langCode);
    final locale =
        langCode == 'bn' ? const Locale('bn', 'BD') : const Locale('en', 'US');
    Get.updateLocale(locale);
    update();
  }
}
