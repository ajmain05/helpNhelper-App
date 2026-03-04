import 'package:get/get.dart';
import 'package:helpnhelper/models/campaign_category_model.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/models/seeker_history_model.dart';
import 'package:helpnhelper/models/successStoryModel.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
import 'package:helpnhelper/pages/donation/donation_page.dart';
import 'package:helpnhelper/pages/home/in_app_web_page.dart';
import 'package:helpnhelper/service/home_service.dart';

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

  final count = 0.obs;
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
    service.getAllCampaign();
  }

  getCampaignByCategory(String id) {
    isLoadingCampaign.value = true;

    campaignList.clear();
    service.getCampaignByCategory(id);
  }

  getSuccessStoryDetail(String id) {
    isLoading.value = true;
    successStoryDetail.value = new SuccessStoryModel();
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
}
