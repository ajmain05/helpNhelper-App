import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _box = GetStorage();
  static const _key = 'isDarkMode';

  bool _isDark = false;
  bool get isDark => _isDark;

  @override
  void onInit() {
    super.onInit();
    _isDark = _box.read(_key) ?? false;
  }

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggle() {
    _isDark = !_isDark;
    _box.write(_key, _isDark);
    update(); // triggers GetBuilder<ThemeController> rebuild → new themeMode
  }
}
