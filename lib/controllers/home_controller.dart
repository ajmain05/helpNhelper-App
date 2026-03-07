import 'package:get/get.dart';
import 'package:helpnhelper/models/campaign_category_model.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/models/seeker_history_model.dart';
import 'package:helpnhelper/models/successStoryModel.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
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
  var service = HomeService();
  List<CampaignModel> campaignList = <CampaignModel>[].obs;
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
}
