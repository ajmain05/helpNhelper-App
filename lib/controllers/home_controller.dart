import 'package:get/get.dart';
import 'package:helpnhelper/models/campaign_category_model.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/models/seeker_history_model.dart';
import 'package:helpnhelper/models/successStoryModel.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
import 'package:helpnhelper/models/donation_history_model.dart';
import 'package:helpnhelper/pages/donation/donation_page.dart';
import 'package:helpnhelper/pages/home/in_app_web_page.dart';
import 'package:helpnhelper/service/home_service.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isSignedUp = false.obs;
  var isLoading = false.obs;
  var isLoadingCampaign = false.obs;
  var isLoadingDonationHistory = false.obs;
  var service = HomeService();
  List<CampaignModel> campaignList = <CampaignModel>[].obs;
  List<DonationHistoryModel> donationHistoryList = <DonationHistoryModel>[].obs;
  List<SeekerHistoryModel> seekerHistoryList = <SeekerHistoryModel>[].obs;
  List<VolunteerHistoryModel> volunteerHistoryList =
      <VolunteerHistoryModel>[].obs;
  List<CampaignModel> featuredCampaignList = <CampaignModel>[].obs;
  List<CampaignModel> selectedCampaignList = <CampaignModel>[].obs;
  List<SuccessStoryModel> successStoryList = <SuccessStoryModel>[].obs;
  List<CampaignCategoryModel> campaignCategoryList =
      <CampaignCategoryModel>[].obs;
  Rx<CampaignModel> campaignDetail = CampaignModel().obs;
  Rx<SuccessStoryModel> successStoryDetail = SuccessStoryModel().obs;
  Rx<SeekerHistoryModel> seekerHistoryDetail = SeekerHistoryModel().obs;

  // Live stats from API
  var totalDonated = 0.obs;
  var totalReceived = 0.obs;
  var totalCampaigns = 0.obs;

  // Notification badge for campaigns that became successful
  var newSuccessNotificationCount = 0.obs;

  final count = 0.obs;

  // ────────────────────────────────────────────────────────────────────────────
  // Computed campaign categories (client-side, based on totalRaised vs amount)
  // ────────────────────────────────────────────────────────────────────────────
  List<CampaignModel> get currentCampaigns => campaignList.where((c) {
        final raised = double.tryParse(c.totalRaised?.toString() ?? '0') ?? 0;
        return raised == 0;
      }).toList();

  List<CampaignModel> get ongoingCampaigns => campaignList.where((c) {
        // Mirror the logic in campaign_card.dart: prefer totalDonation, fall back to totalRaised
        final raised =
            double.tryParse(c.totalDonation ?? c.totalRaised ?? '0') ?? 0;
        final goal = double.tryParse(c.amount?.toString() ?? '0') ?? 0;
        return goal == 0 || raised < goal;
      }).toList();

  List<CampaignModel> get successfulCampaigns => campaignList.where((c) {
        // Mirror the logic in campaign_card.dart: prefer totalDonation, fall back to totalRaised
        final raised =
            double.tryParse(c.totalDonation ?? c.totalRaised ?? '0') ?? 0;
        final goal = double.tryParse(c.amount?.toString() ?? '0') ?? 1;
        return goal > 0 && raised >= goal;
      }).toList();

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  getInitialData() {
    getDonationHistory();
    getCampaignCategory();
    getFeaturedCampaign();
    getAllCampaign();
    getSuccessStory();
    getStats();
  }

  getCampaignCategory() {
    campaignCategoryList.clear();
    service.getCampaignCategory();
  }

  getAllCampaign() {
    isLoadingCampaign.value = true;
    campaignList.clear();
    service.getAllCampaign().then((_) => _checkNewSuccesses());
  }

  getCampaignByCategory(String id) {
    isLoadingCampaign.value = true;
    campaignList.clear();
    service.getCampaignByCategory(id);
  }

  getSuccessStoryDetail(String id) {
    isLoading.value = true;
    successStoryDetail.value = SuccessStoryModel();
    service.getSuccessStoryDetail(id);
  }

  getFeaturedCampaign() {
    featuredCampaignList.clear();
    service.getFeaturedCampaign();
  }

  getSuccessStory() {
    successStoryList.clear();
    service.getSuccessStory();
  }

  getStats() {
    service.getStats();
  }

  openUrlDonation(CampaignModel campaign) {
    Get.to(() => DonationPage(campaign: campaign));
  }

  openUrl() {
    Get.to(() => const InAppWebPage(
          url: 'https://helpnhelper.com/',
          title: 'helpNhelper',
        ));
  }

  getSeekerHistory() {
    seekerHistoryList.clear();
    service.getSeekerHistory();
  }

  getDonationHistory() {
    isLoadingDonationHistory.value = true;
    donationHistoryList.clear();
    service.getDonationHistory();
  }

  getVolunteerHistory() {
    volunteerHistoryList.clear();
    service.getVolunteerHistory();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // In-App Notification: detect campaigns that newly became successful
  // ────────────────────────────────────────────────────────────────────────────
  void _checkNewSuccesses() {
    final box = GetStorage();
    // We store a JSON list of campaign IDs we've already notified about
    final List<dynamic> alreadyNotified =
        (box.read<List>('notified_success_ids') ?? []);

    final newlySuccessful = successfulCampaigns
        .where((c) => !alreadyNotified.contains(c.id))
        .toList();

    if (newlySuccessful.isNotEmpty) {
      newSuccessNotificationCount.value = newlySuccessful.length;
      // Persist so we don't re-notify
      final updatedIds = [
        ...alreadyNotified,
        ...newlySuccessful.map((c) => c.id)
      ];
      box.write('notified_success_ids', updatedIds);

      // Show snackbar notification
      Get.snackbar(
        '🎉 Campaign Success!',
        '${newlySuccessful.length} campaign(s) reached their goal. Tap to view.',
        backgroundColor: MyColors.primary,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.celebration_rounded, color: Colors.white),
      );
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // In-App Notification: detect supported campaigns that hit 100% or "Our Works"
  // ────────────────────────────────────────────────────────────────────────────
  void checkTrustNotifications() {
    if (donationHistoryList.isEmpty) return;

    final box = GetStorage();
    // Keep track of which (campaign_id + status) we already notified the donor about
    final List<dynamic> notifiedTrusts =
        (box.read<List>('notified_trust_campaigns') ?? []);

    int newlyFundedCount = 0;
    int newlyCompletedCount = 0;

    List<String> newTrustsToSave = [];

    for (var donation in donationHistoryList) {
      if (donation.campaign == null) continue;

      final campaign = donation.campaign!;
      final cId = campaign.id.toString();

      // Check 100% funded (ongoing)
      final raised = double.tryParse(campaign.totalRaised ?? '0') ?? 0;
      final goal = double.tryParse(campaign.amount ?? '1') ?? 1;

      if (goal > 0 && raised >= goal) {
        String key = "${cId}_funded";
        if (!notifiedTrusts.contains(key) && !newTrustsToSave.contains(key)) {
          newlyFundedCount++;
          newTrustsToSave.add(key);
        }
      }

      // Check Completed / Our Works
      // Usually status 'completed' or 'success' defines this in the backend
      if (campaign.status?.toLowerCase() == 'completed' ||
          campaign.status?.toLowerCase() == 'success') {
        String key = "${cId}_completed";
        if (!notifiedTrusts.contains(key) && !newTrustsToSave.contains(key)) {
          newlyCompletedCount++;
          newTrustsToSave.add(key);
        }
      }
    }

    if (newTrustsToSave.isNotEmpty) {
      final updatedTrusts = [...notifiedTrusts, ...newTrustsToSave];
      box.write('notified_trust_campaigns', updatedTrusts);

      // Trigger snackbar for newly funded supported campaigns
      if (newlyFundedCount > 0) {
        Get.snackbar(
          '💙 Thank you for your support!',
          '$newlyFundedCount of your supported campaigns reached 100% goal and work has started!',
          backgroundColor: Colors.blue.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.handshake, color: Colors.white),
        );
      }

      // Trigger snackbar for newly completed supported campaigns ("Our Works")
      if (newlyCompletedCount > 0) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.snackbar(
            '✅ Work Completed!',
            '$newlyCompletedCount of your supported campaigns has been successfully completed.',
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        });
      }
    }
  }
}
