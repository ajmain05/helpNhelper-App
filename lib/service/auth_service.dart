import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/models/country_model.dart';
import 'package:helpnhelper/models/district_model.dart';
import 'package:helpnhelper/models/division_model.dart';
import 'package:helpnhelper/models/upazila_model.dart';
import 'package:helpnhelper/models/user_model.dart';
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/utils/my_colors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Future<void> authenticate(String phone, String otp) async {
  //   var url = Uri.parse(loginApi);

  //   var map = new Map<String, dynamic>();
  //   map['phone'] = '$phone';
  //   map['otp'] = '$otp';
  //   var response = await http.post(
  //     url,
  //     body: map,
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       final box = GetStorage();
  //       box.write('access_token', jsonData["token"]);
  //       print(jsonData["token"]);

  //       Get.find<CartController>().getData();
  //       Get.offAll(MyApp());
  //     } else {
  //       var jsonData = json.decode(response.body);
  //       Get.find<AuthController>().isLoading.value = false;

  //       Get.snackbar(" Error", jsonData['message'],
  //           duration: Duration(seconds: 2),
  //           snackPosition: SnackPosition.BOTTOM,
  //           colorText: Colors.white,
  //           backgroundColor: MyColors.appColor);
  //     }
  //   } catch (exception) {
  //     Get.find<AuthController>().isLoading.value = false;

  //     Get.snackbar(" Error", "Something went wrong",
  //         duration: Duration(seconds: 2),
  //         snackPosition: SnackPosition.BOTTOM,
  //         colorText: Colors.white,
  //         backgroundColor: MyColors.appColor);
  //   }
  // }

  // Future<void> login(String phone) async {
  //   var url = Uri.parse(otpApi);

  //   var map = new Map<String, dynamic>();
  //   map["phone"] = "$phone";
  //   var response = await http.post(
  //     url,
  //     body: map,
  //     headers: {
  //       "Accept": "application/json",
  //     },
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       Get.find<AuthController>().isLoading.value = false;
  //       Get.to(VerficationPage());
  //     } else if (response.statusCode == 400) {
  //       Get.find<AuthController>().isLoading.value = false;
  //       Get.snackbar(" Error", "Wait 5 minutes before login in again...",
  //           duration: Duration(seconds: 2),
  //           snackPosition: SnackPosition.BOTTOM,
  //           colorText: Colors.white,
  //           backgroundColor: MyColors.appColor);
  //     } else {
  //       Get.find<AuthController>().isLoading.value = false;

  //       Get.snackbar(" Error", "Invalid phone number",
  //           duration: Duration(seconds: 2),
  //           snackPosition: SnackPosition.BOTTOM,
  //           colorText: Colors.white,
  //           backgroundColor: MyColors.appColor);
  //     }
  //   } catch (exception) {
  //     Get.find<AuthController>().isLoading.value = false;

  //     Get.snackbar(" Error", response.body.toString(),
  //         duration: Duration(seconds: 2),
  //         snackPosition: SnackPosition.BOTTOM,
  //         colorText: Colors.white,
  //         backgroundColor: MyColors.appColor);
  //   }
  // }

  Future<bool> signUpUser(String type) async {
    var url = Uri.parse(signUpApi + type);

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({"Accept": "application/json"});

    request.fields['name'] = Get.find<AuthController>().nameController.text;
    request.fields['email'] = Get.find<AuthController>().emailController.text;
    request.fields['mobile'] = Get.find<AuthController>().mobileController.text;
    request.fields['password'] =
        Get.find<AuthController>().passwordController.text;
    request.fields['password_confirmation'] =
        Get.find<AuthController>().confirmPasswordController.text;
    if (Get.find<AuthController>().type.value != 'donor') {
      request.fields['upazila'] = Get.find<AuthController>().upazilaId.value;
      request.fields['permanent_address'] =
          Get.find<AuthController>().permanentAddressController.text;
      request.fields['present_address'] =
          Get.find<AuthController>().presentAddressController.text;
    }
    request.fields['terms'] = "1";
    if (Get.find<AuthController>().type.value != 'donor') {
      request.files.add(await http.MultipartFile.fromPath(
          "auth_file", Get.find<AuthController>().nidImage[0].path));
      request.files.add(await http.MultipartFile.fromPath(
          "photo", Get.find<AuthController>().profileImage[0].path));
    }

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        // final box = GetStorage();
        // box.write('access_token', responsedData["token"]);
        Get.find<AuthController>().isLoading.value = false;
        return true;
      } else {
        Get.snackbar(" Error", responsedData['message'],
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: MyColors.appColor);
        return false;
      }
    } catch (exception) {
      Get.snackbar(" Error", responsedData.toString(),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: MyColors.appColor);
      return false;
    } finally {
      Get.find<AuthController>().isLoading.value = false;
    }
  }

  Future<bool> signIn() async {
    var url = Uri.parse(signInApi);

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({"Accept": "application/json"});
    Get.find<AuthController>().phoneLogin
        ? request.fields['mobile'] =
            Get.find<AuthController>().emailController.text
        : request.fields['email'] =
            Get.find<AuthController>().emailController.text;

    Get.find<AuthController>().passLogin
        ? request.fields['password'] =
            Get.find<AuthController>().passwordController.text
        : request.fields['otp'] = Get.find<AuthController>().otpController.text;
    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        final box = GetStorage();
        print(responsedData["user"]);
        box.write('access_token', responsedData["token"]);
        box.write('type', responsedData["user"]['type']);
        Get.find<AuthController>().userData.value =
            UserModel.fromJson(responsedData['user']);
        Get.find<AuthController>().isLoading.value = false;
        print(box.read('access_token'));
        return true;
      } else {
        Get.snackbar(" Error", responsedData['message'],
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      Get.snackbar(" Error", responsedData.toString(),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: MyColors.appColor);
      return false;
    } finally {
      Get.find<AuthController>().isLoading.value = false;
    }
  }

  Future<bool> getOtp() async {
    var url = Uri.parse(otpApi);

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({"Accept": "application/json"});
    Get.find<AuthController>().phoneLogin
        ? request.fields['mobile'] =
            Get.find<AuthController>().emailController.text
        : request.fields['email'] =
            Get.find<AuthController>().emailController.text;

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar(" Error", responsedData['message'],
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      Get.snackbar(" Error", responsedData.toString(),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: MyColors.appColor);
      return false;
    } finally {
      Get.find<AuthController>().isLoading.value = false;
    }
  }

  Future<void> getCountry() async {
    var url = Uri.parse(countryApi);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var product in jsonData['data']) {
          Get.find<AuthController>()
              .countryList
              .add(CountryModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getDistrict(String id) async {
    var url = Uri.parse(districtApi + id);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var product in jsonData['data']) {
          Get.find<AuthController>()
              .districtList
              .add(DistrictModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getDivision(String id) async {
    var url = Uri.parse(divisionApi + id);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var product in jsonData['data']) {
          Get.find<AuthController>()
              .divisionList
              .add(DivisionModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getUpazila(String id) async {
    var url = Uri.parse(upazilaApi + id);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var product in jsonData['data']) {
          Get.find<AuthController>()
              .upazilaList
              .add(UpazilaModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> logOut() async {
    var url = Uri.parse(logOutApi);
    GetStorage box = GetStorage();
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer ${box.read("access_token")}'
      },
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 401) {
        box.remove("access_token");
        box.erase();
        Get.find<HomeController>().currentIndex.value = 0;
        Get.offAll(Dashboard());
      } else {
        Get.snackbar(" Error", response.body,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: MyColors.appColor);
      }
    } catch (exception) {
      Get.snackbar(" Error", response.toString(),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: MyColors.appColor);
    }
  }
}
