import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/models/transaction.dart';
import 'package:helpnhelper/models/transaction_method_model.dart';
import 'package:helpnhelper/models/volunteer_points_model.dart';
import 'package:helpnhelper/utils/api_url.dart';
import 'package:http/http.dart' as http;

class VolunteerService {
  Future<void> getBankList() async {
    var url = Uri.parse(getTransactionMethodsApi);

    var box = GetStorage();
    print(box.read("access_token"));
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer ${box.read("access_token")}'
      },
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Get.find<VolunteerController>().transactionMethodList.clear(); // Clear to prevent duplicates
        for (var product in jsonData['data']) {
          Get.find<VolunteerController>()
              .transactionMethodList
              .add(TransactionMethodModel.fromJson(product));
        }
      } else if (response.statusCode == 401) {
        logOut();
      }
    } catch (exception) {
      print(exception);
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  Future<void> getTransactions() async {
    var url = Uri.parse(getTransactionApi);

    var box = GetStorage();
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer ${box.read("access_token")}'
      },
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Get.find<VolunteerController>().transactionList.clear(); // Clear to prevent duplicates
        for (var product in jsonData['data']) {
          Get.find<VolunteerController>()
              .transactionList
              .add(TransactionModel.fromJson(product));
        }
      } else if (response.statusCode == 401) {
        logOut();
      }
    } catch (exception) {
      print(exception);
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  Future<void> getMyPoints() async {
    var url = Uri.parse(getVolunteerMyPointsApi);
    var box = GetStorage();
    if (box.read("access_token") == null) return;
    
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer ${box.read("access_token")}'
      },
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Get.find<VolunteerController>().myPointsData.value = VolunteerPointsModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        logOut();
      }
    } catch (exception) {
      print('Volunteer points fetch error: $exception');
    }
  }

  Future<bool> addTransactionMethod(var data) async {
    // print(data);
    var url = Uri.parse(getTransactionMethodsApi);
    GetStorage box = GetStorage();

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });
    request.fields['type'] = data['type'];
    if (data['type'] == "bank") {
      request.fields['bank_name'] = data['bank_name'];
      request.fields['branch_name'] = data['branch_name'];
      request.fields['account_number'] = data['account_number'];
      request.fields['holder_name'] = data['holder_name'];
      request.fields['routing_number'] = data['routing_number'];
    } else {
      if (data['bkash'] != null) {
        request.fields['bkash'] = data['bkash'].toString();
      }
      if (data['nagad'] != null) {
        request.fields['nagad'] = data['nagad'].toString();
      }
    }

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        Get.find<VolunteerController>().getBankList();

        return true;
      } else {
        Get.snackbar(" Error", responsedData["message"],
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      return false;
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  Future<bool> updateTransactionMethod(var data, int id) async {
    var url = Uri.parse("$getTransactionMethodsApi/$id");
    GetStorage box = GetStorage();

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });
    request.fields['_method'] = 'PUT';
    request.fields['type'] = data['type'];
    if (data['type'] == "bank") {
      request.fields['bank_name'] = data['bank_name'];
      request.fields['branch_name'] = data['branch_name'];
      request.fields['account_number'] = data['account_number'];
      request.fields['holder_name'] = data['holder_name'];
      request.fields['routing_number'] = data['routing_number'];
    } else {
      if (data['bkash'] != null) {
        request.fields['bkash'] = data['bkash'].toString();
      }
      if (data['nagad'] != null) {
        request.fields['nagad'] = data['nagad'].toString();
      }
    }

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        Get.find<VolunteerController>().getBankList();
        return true;
      } else {
        Get.snackbar(" Error", responsedData["message"],
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      return false;
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  Future<bool> deleteTransactionMethod(int id) async {
    var url = Uri.parse("$getTransactionMethodsApi/$id");
    GetStorage box = GetStorage();
    final response = await http.delete(url, headers: {
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });
    try {
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.find<VolunteerController>().getBankList();
        return true;
      } else {
        final responsedData = json.decode(response.body);
        Get.snackbar(" Error", responsedData["message"] ?? "Could not delete",
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      return false;
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  Future<bool> updateStatus(var data, String id) async {
    var url = Uri.parse(updateTransactionStatusApi + id);
    GetStorage box = GetStorage();

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${box.read("access_token")}",
      "Accept": "application/json"
    });
    request.fields['_method'] = data['_method'];
    request.fields['receive_status'] = data['receive_status'];

    final response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    try {
      if (response.statusCode == 200) {
        Get.find<VolunteerController>().getTransactions();

        return true;
      } else {
        Get.snackbar(" Error", responsedData["message"],
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
        return false;
      }
    } catch (exception) {
      return false;
    } finally {
      Get.find<VolunteerController>().isLoading.value = false;
    }
  }

  logOut() {
    GetStorage box = GetStorage();
    box.remove("access_token");
    box.erase();
    Get.offAll(const Dashboard());
  }
}
