import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/models/campaign_category_model.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/models/seeker_history_model.dart';
import 'package:helpnhelper/models/successStoryModel.dart';
import 'package:helpnhelper/models/volunteer_historyModel.dart';
import 'package:helpnhelper/models/donation_history_model.dart';
import 'package:helpnhelper/models/volunteer_leaderboard_model.dart';
import 'package:helpnhelper/utils/api_url.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:helpnhelper/controllers/home_controller.dart';

class HomeService {
  Future<void> getCampaignCategory() async {
    var url = Uri.parse(getCampaignCategoryApi);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        Get.find<HomeController>()
            .campaignCategoryList
            .add(CampaignCategoryModel.fromJson({
              "id": 0,
              "title": "All",
              "slug": "medical",
            }));
        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .campaignCategoryList
              .add(CampaignCategoryModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getAllCampaign() async {
    var url = Uri.parse(getCampaignApi);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .campaignList
              .add(CampaignModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    } finally {
      Get.find<HomeController>().isLoadingCampaign.value = false;
    }
  }

  Future<void> getSeekerHistory() async {
    var url = Uri.parse(getHistoryApi);
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
        print(response.body);
        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .seekerHistoryList
              .add(SeekerHistoryModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getVolunteerHistory() async {
    var url = Uri.parse(getHistoryApi);
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
        print(box.read("access_token"));
        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .volunteerHistoryList
              .add(VolunteerHistoryModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getCampaignByCategory(String id) async {
    var url = Uri.parse(getCampaignApi + "?category_id=" + id);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .campaignList
              .add(CampaignModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    } finally {
      Get.find<HomeController>().isLoadingCampaign.value = false;
    }
  }

  Future<void> getSuccessStoryDetail(String id) async {
    var url = Uri.parse(getSuccessStoryApi + "/" + id);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        Get.find<HomeController>().successStoryDetail.value =
            SuccessStoryModel.fromJson(jsonData['data']);
      }
    } catch (exception) {
      print(exception);
    } finally {
      Get.find<HomeController>().isLoading.value = false;
    }
  }

  Future<void> getFeaturedCampaign() async {
    var url = Uri.parse(getCampaignApi + "?is_featured=1");
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .featuredCampaignList
              .add(CampaignModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getSuccessStory() async {
    var url = Uri.parse(getSuccessStoryApi);
    var response = await http.get(
      url,
    );
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        for (var product in jsonData['data']) {
          Get.find<HomeController>()
              .successStoryList
              .add(SuccessStoryModel.fromJson(product));
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getStats() async {
    try {
      var url = Uri.parse(getStatsApi);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        final ctrl = Get.find<HomeController>();
        ctrl.totalDonated.value = data['total_donated'] ?? 0;
        ctrl.totalReceived.value = data['total_donations_received'] ?? 0;
        ctrl.totalCampaigns.value = data['total_campaigns'] ?? 0;
      }
    } catch (e) {
      print('Stats fetch error: $e');
    }
  }

  Future<void> getDonationHistory() async {
    var url = Uri.parse(donationHistoryApi);
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
        final ctrl = Get.find<HomeController>();
        ctrl.donationHistoryList.clear();
        for (var data in jsonData['data']) {
          ctrl.donationHistoryList.add(DonationHistoryModel.fromJson(data));
        }
        ctrl.checkTrustNotifications(); // Trigger the notification logic after fetching
      }
    } catch (e) {
      print('Donation history fetch error: $e');
    } finally {
      Get.find<HomeController>().isLoadingDonationHistory.value = false;
    }
  }

  Future<void> getVolunteerLeaderboard() async {
    var url = Uri.parse(getVolunteerLeaderboardApi);
    var response = await http.get(url, headers: {"Accept": "application/json"});
    try {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        final ctrl = Get.find<HomeController>();
        ctrl.volunteerLeaderboardList.clear();
        for (var data in jsonData['data']) {
          ctrl.volunteerLeaderboardList.add(VolunteerLeaderboardModel.fromJson(data));
        }
      }
    } catch (e) {
      print('Volunteer leaderboard fetch error: $e');
    }
  }

  // Future<void> getTags() async {
  //   var url = Uri.parse(getTagApi);
  //   var response = await http.get(
  //     url,
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       for (var product in jsonData) {
  //         if (product['name'] != "Flash Sales") {
  //           Get.find<HomeController>().tagList.add(TagModel.fromJson(product));
  //         } else {
  //           Get.find<HomeController>().flashSales.value =
  //               TagModel.fromJson(product);
  //         }
  //       }
  //     }
  //   } catch (exception) {
  //     // Get.snackbar(" Error", response.body.toString(),
  //     //     duration: Duration(seconds: 2),
  //     //     snackPosition: SnackPosition.BOTTOM,
  //     //     colorText: Colors.white,
  //     //     backgroundColor: SGColors.blue);
  //   }
  // }

  // Future<void> getCategory() async {
  //   var url = Uri.parse(getCategoryApi);
  //   var response = await http.get(
  //     url,
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       for (var product in jsonData) {
  //         Get.find<HomeController>()
  //             .categoryList
  //             .add(CategoryModel.fromJson(product));
  //         Get.find<HomeController>()
  //             .categoryNames
  //             .add(CategoryModel.fromJson(product));
  //       }
  //     }
  //   } catch (exception) {
  //     // Get.snackbar(" Error", response.body.toString(),
  //     //     duration: Duration(seconds: 2),
  //     //     snackPosition: SnackPosition.BOTTOM,
  //     //     colorText: Colors.white,
  //     //     backgroundColor: SGColors.blue);
  //   }
  // }

  // Future<void> getBrand() async {
  //   var url = Uri.parse(getBrandApi);
  //   var response = await http.get(
  //     url,
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       for (var product in jsonData) {
  //         Get.find<HomeController>()
  //             .brandList
  //             .add(BrandModel.fromJson(product));
  //       }
  //     }
  //   } catch (exception) {
  //     // Get.snackbar(" Error", response.body.toString(),
  //     //     duration: Duration(seconds: 2),
  //     //     snackPosition: SnackPosition.BOTTOM,
  //     //     colorText: Colors.white,
  //     //     backgroundColor: SGColors.blue);
  //   }
  // }

  // Future<void> getCategoryProducts(String id) async {
  //   var url = Uri.parse(getCategoryProductApi + "?category_id=" + id);
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //     },
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       for (var product in jsonData) {
  //         Get.find<HomeController>()
  //             .filteredProductList
  //             .add(ProductModel.fromJson(product));
  //       }
  //     }
  //   } catch (exception) {}
  // }

  // Future<void> getSearchedProducts(String query) async {
  //   var url = Uri.parse(getProductApi + "?search=" + query);
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //     },
  //   );

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);

  //       for (var product in jsonData['data']) {
  //         Get.find<HomeController>()
  //             .filteredProductList
  //             .add(ProductModel.fromJson(product));
  //       }
  //     }
  //   } catch (exception) {}
  // }
}
