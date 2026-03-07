import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/controllers/theme_controller.dart';
import 'package:helpnhelper/controllers/language_controller.dart';

void main() {
  testWidgets('Test dashboard build to catch Obx error',
      (WidgetTester tester) async {
    await GetStorage.init();
    Get.put(LanguageController());
    Get.put(ThemeController());

    // Catch Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      print('FLUTTER ERROR CAUGHT:');
      print(details.exception);
      print(details.stack);
    };

    await tester.pumpWidget(GetMaterialApp(
      home: Dashboard(),
    ));

    await tester.pumpAndSettle();
  });
}
