import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:http/http.dart' as http;

class SeekerService {
  Future<bool> applyForFund1() async {
    var url = Uri.parse(seekerApplyFundApiaApi);
    GetStorage box = GetStorage();
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });

    request.fields['title'] = Get.find<SeekerController>().titleController.text;
    request.fields['description'] =
        Get.find<SeekerController>().descController.text;
    request.fields['completion_date'] =
        Get.find<SeekerController>().deadlineController.text;
    request.fields['requested_amount'] =
        Get.find<SeekerController>().requestedAmountController.text;

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        // final box = GetStorage();
        // box.write('access_token', responsedData["token"]);
        Get.find<SeekerController>().isLoading.value = false;
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
      Get.find<SeekerController>().isLoading.value = false;
    }
  }

  Future<bool> uploadDoc(String comment) async {
    var url = Uri.parse(uploadDocApi +
        Get.find<SeekerController>()
            .applicationDetail
            .value
            .seekerApplicationId
            .toString());
    GetStorage box = GetStorage();
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });
    if (comment != '') {
      request.fields['comment'] = comment;
    }

    request.files.add(await http.MultipartFile.fromPath("volunteer_document",
        Get.find<SeekerController>().investigateDoc[0].path));

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        // final box = GetStorage();
        // box.write('access_token', responsedData["token"]);
        Get.find<SeekerController>().isLoading.value = false;
        return true;
      } else {
        Get.snackbar(" Error", responsedData['message'],
            duration: Duration(seconds: 20),
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
      Get.find<SeekerController>().isLoading.value = false;
    }
  }

  Future<bool> applyForFund() async {
    var url = Uri.parse(seekerApplyFundApiaApi);
    GetStorage box = GetStorage();
    print(box.read("access_token"));

    var map = new Map<String, dynamic>();
    map['title'] = Get.find<SeekerController>().titleController.text;
    map['description'] = Get.find<SeekerController>().descController.text;
    map['completion_date'] =
        Get.find<SeekerController>().deadlineController.text;
    map['requested_amount'] =
        Get.find<SeekerController>().requestedAmountController.text;
    map['terms'] = Get.find<SeekerController>().terms.value.toString();
    var response = await http.post(
      url,
      body: map,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer ${box.read("access_token")}'
      },
    );
    try {
      if (response.statusCode == 200) {
        Get.find<SeekerController>().clear();
        return true;
      } else {
        Get.snackbar(" Error", response.body,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: MyColors.appColor);
        return false;
      }
    } catch (exception) {
      Get.snackbar(" Error", response.toString(),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: MyColors.appColor);
      return false;
    } finally {
      Get.find<SeekerController>().isLoading.value = false;
    }
  }
}
