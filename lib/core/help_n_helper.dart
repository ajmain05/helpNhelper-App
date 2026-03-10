import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/language_controller.dart';
import 'package:helpnhelper/controllers/theme_controller.dart';
import 'package:helpnhelper/utils/app_translations.dart';
import 'package:helpnhelper/utils/my_colors.dart';

import 'splash_view.dart';

class HelpNHelper extends StatelessWidget {
  const HelpNHelper({Key? key}) : super(key: key);

  static ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: MyColors.primary,
      scaffoldBackgroundColor: MyColors.background,
      canvasColor: MyColors.background,
      cardColor: MyColors.surface,
      dividerColor: MyColors.divider,
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.surface,
        foregroundColor: MyColors.textPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.primary),
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: MyColors.textPrimary,
        displayColor: MyColors.textPrimary,
      ),
      colorScheme: const ColorScheme.light(
        primary: MyColors.primary,
        secondary: MyColors.primaryDark,
        surface: MyColors.surface,
        background: MyColors.background,
      ),
    );
  }

  static ThemeData _darkTheme() {
    const darkBg = Color(0xFF0F1117);
    const darkSurface = Color(0xFF1A1D27);
    const darkCard = Color(0xFF252836);
    const darkText = Color(0xFFE8EAF0);
    const darkDivider = Color(0xFF2D3147);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: MyColors.primary,
      scaffoldBackgroundColor: darkBg,
      canvasColor: darkBg,
      cardColor: darkCard,
      dividerColor: darkDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.primary),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      colorScheme: const ColorScheme.dark(
        primary: MyColors.primary,
        secondary: MyColors.primaryDark,
        surface: darkSurface,
        background: darkBg,
        onBackground: darkText,
        onSurface: darkText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LanguageController());
    final savedLang = GetStorage().read('app_language') ?? 'en';
    final initialLocale = savedLang == 'bn'
        ? const Locale('bn', 'BD')
        : (savedLang == 'ar'
            ? const Locale('ar', 'SA')
            : const Locale('en', 'US'));

    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeCtrl) => GetMaterialApp(
        title: "Help N Helper",
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: initialLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        themeMode: themeCtrl.themeMode,
        home: SplashView(),
      ),
    );
  }
}
