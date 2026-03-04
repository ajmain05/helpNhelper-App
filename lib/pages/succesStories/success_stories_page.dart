import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/pages/home/campaign_list.dart';
import 'package:helpnhelper/pages/home/success_story_detail.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/widgets/success_story_card.dart';

class SuccessStories extends StatefulWidget {
  SuccessStories({Key? key}) : super(key: key);

  @override
  _SuccessStoriesState createState() => _SuccessStoriesState();
}

class _SuccessStoriesState extends State<SuccessStories> {
  List<String> campaign = [
    'Health',
    'Shelter',
    'Sanitation',
    'Health',
    'Shelter',
    'Sanitation',
  ];
  int selected = 0;
  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() => controller.successStoryList.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingM,
                  vertical: DesignSystem.spacingM),
              itemCount: controller.successStoryList.length,
              itemBuilder: (context, index) {
                final story = controller.successStoryList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
                  child: SuccessStoryCard(
                    title: story.title.toString(),
                    description: story.shortDescription.toString(),
                    imageUrl: story.photo.toString(),
                    width: double.infinity,
                    onTap: () {
                      Get.find<HomeController>()
                          .getSuccessStoryDetail(story.id.toString());
                      Get.to(SuccessStoryDetail());
                    },
                  ),
                );
              },
            )
          : Center(
              child: controller.isLoadingCampaign.value
                  ? const CircularProgressIndicator()
                  : Text("No success stories found",
                      style: DesignSystem.caption),
            )),
    );
  }
}

heading(String title, var data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style:
            GoogleFonts.philosopher(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      GestureDetector(
        onTap: () {
          if (data != null) {
            Get.find<HomeController>().selectedCampaignList = data;
            Get.to(CampaignList());
          }
        },
        child: const Text(
          "See all",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}
