import 'package:get/get.dart';
import 'package:helpnhelper/models/transaction.dart';
import 'package:helpnhelper/models/transaction_method_model.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
import 'package:helpnhelper/service/volunteer_service.dart';

class VolunteerController extends GetxController {
  var isLoading = false.obs;
  List<TransactionMethodModel> transactionMethodList =
      <TransactionMethodModel>[].obs;
  List<TransactionModel> transactionList = <TransactionModel>[].obs;
  var service = VolunteerService();

  Rx<VolunteerHistoryModel> applicationDetail = VolunteerHistoryModel().obs;

  @override
  onInit() async {
    super.onInit();
    getBankList();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getBankList() async {
    transactionMethodList.clear();
    isLoading.value = true;
    return await service.getBankList();
  }

  Future<void> getTransactions() async {
    transactionList.clear();
    isLoading.value = true;
    return await service.getTransactions();
  }

  addTransactionMethod(var data) {
    return service.addTransactionMethod(data);
  }

  updateStatus(var data, String id) {
    return service.updateStatus(data, id);
  }
}
