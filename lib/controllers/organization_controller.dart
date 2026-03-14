import 'package:get/get.dart';
import 'package:helpnhelper/service/organization_service.dart';
import 'package:helpnhelper/models/org_application_model.dart';
import 'dart:io';

class OrganizationController extends GetxController {
  final service = OrganizationService();

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  
  var applicationList = <OrgApplicationModel>[].obs;
  
  var totalRaised = 0.0.obs;
  var activeApplicationsCount = 0.obs;
  var orgServiceCharge = 7.0.obs;

  @override
  void onInit() {
    super.onInit();
    getApplications();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    final charge = await service.getServiceCharge();
    orgServiceCharge.value = charge;
  }

  Future<void> getApplications() async {
    try {
      isLoading.value = true;
      final list = await service.getApplications();
      applicationList.assignAll(list);
      
      // Calculate stats
      totalRaised.value = list.fold(0.0, (sum, item) => sum + (item.collectedAmount ?? 0.0));
      activeApplicationsCount.value = list.where((a) => a.status == 'approved' || a.status == 'pending').length;
      
    } catch (e) {
      print('Error fetching org applications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitApplication({
    required String title,
    required String description,
    required String category,
    required String targetAmount,
    required String seekerName,
    required String seekerLocation,
    required String paymentMethod,
    required String paymentAccount,
    required File certImage,
  }) async {
    try {
      isSubmitting.value = true;
      final result = await service.submitApplication(
        title: title,
        description: description,
        category: category,
        targetAmount: targetAmount,
        seekerName: seekerName,
        seekerLocation: seekerLocation,
        paymentMethod: paymentMethod,
        paymentAccount: paymentAccount,
        certImage: certImage,
      );
      
      if (result) {
        await getApplications(); // Refresh list
      }
      return result;
    } catch (e) {
      print('Error submitting application: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
