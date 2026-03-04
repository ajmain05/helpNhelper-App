import 'package:get/get.dart';

class GlobalSize {
  static double height(double height) {
    return Get.height / (844 / height);
  }

  static double width(double width) {
    return Get.width / (390 / width);
  }
}
