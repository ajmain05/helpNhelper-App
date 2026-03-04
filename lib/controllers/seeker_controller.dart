import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
import 'package:helpnhelper/service/seeker_service.dart';

class SeekerController extends GetxController {
  var isLoading = false.obs;
  var terms = false.obs;
  var service = SeekerService();
  Rx<VolunteerHistoryModel> applicationDetail = VolunteerHistoryModel().obs;
  RxList<File> investigateDoc = <File>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController requestedAmountController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  @override
  onInit() async {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
  }

  clear() {
    titleController.text = '';
    descController.text = '';
    requestedAmountController.text = '';
    deadlineController.text = '';
    terms.value = false;
  }

  Future<bool> applyForFund() async {
    isLoading.value = true;
    SeekerService service = SeekerService();
    return await service.applyForFund();
  }

  Future<bool> uploadDoc(String comment) async {
    isLoading.value = true;
    SeekerService service = SeekerService();
    return await service.uploadDoc(comment);
  }
}
