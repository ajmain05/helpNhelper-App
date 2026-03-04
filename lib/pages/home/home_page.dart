import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/pages/home/campaign_detail.dart';
import 'package:helpnhelper/pages/home/campaign_list.dart';
import 'package:helpnhelper/pages/home/success_story_detail.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/campaign_card.dart';
import 'package:helpnhelper/widgets/custom_button.dart';
import 'package:helpnhelper/widgets/section_header.dart';
import 'package:helpnhelper/widgets/stats_card.dart';
import 'package:helpnhelper/widgets/success_story_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Banner
            Stack(
              children: [
                Container(
                  height: 220,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Text(
                        "We Need Your Powerful Hands To Change The World",
                        textAlign: TextAlign.center,
                        style: DesignSystem.h1.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Donate Now",
                        width: 180,
                        icon: Icons.volunteer_activism,
                        onTap: () => Get.to(CampaignList(
                            title: "Donate to a Campaign",
                            list: controller.campaignList)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: DesignSystem.spacingL),

            // Statistics Row
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingM),
                  child: Row(
                    children: [
                      Expanded(
                          child: StatsCard(
                              label: "Donated",
                              value: "Tk ${controller.totalDonated.value}+",
                              icon: Icons.favorite)),
                      const SizedBox(width: DesignSystem.spacingS),
                      Expanded(
                          child: StatsCard(
                              label: "Received",
                              value: "Tk ${controller.totalReceived.value}+",
                              icon: Icons.account_balance_wallet)),
                      const SizedBox(width: DesignSystem.spacingS),
                      Expanded(
                          child: StatsCard(
                              label: "Campaigns",
                              value: "${controller.totalCampaigns.value}+",
                              icon: Icons.campaign)),
                    ],
                  ),
                )),

            const SizedBox(height: DesignSystem.spacingL),

            // Categories
            Obx(() => controller.campaignCategoryList.isNotEmpty
                ? SizedBox(
                    height: 40,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingM),
                      itemCount: controller.campaignCategoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selected;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = index;
                              if (controller.campaignCategoryList[index].id ==
                                  0) {
                                controller.getAllCampaign();
                              } else {
                                controller.getCampaignByCategory(
                                  controller.campaignCategoryList[index].id
                                      .toString(),
                                );
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? MyColors.primary
                                  : Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(DesignSystem.radiusXL),
                              border: Border.all(
                                color: isSelected
                                    ? MyColors.primary
                                    : Theme.of(context).dividerColor,
                              ),
                              boxShadow:
                                  isSelected ? DesignSystem.softShadow : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              controller.campaignCategoryList[index].title
                                  .toString(),
                              style: DesignSystem.caption.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: DesignSystem.spacingL),

            // Current Campaigns
            SectionHeader(
              title: "Current Campaigns",
              onSeeAllTap: () => Get.to(CampaignList(
                  title: "Current Campaigns", list: controller.campaignList)),
            ),

            Obx(() => controller.campaignList.isNotEmpty
                ? SizedBox(
                    height: 400,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingM),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.campaignList.length,
                      itemBuilder: (context, index) {
                        return CampaignCard(
                          campaign: controller.campaignList[index],
                          onTap: () {
                            controller.campaignDetail.value =
                                controller.campaignList[index];
                            Get.to(CampaignDetail());
                          },
                          onDonateTap: () => controller
                              .openUrlDonation(controller.campaignList[index]),
                        );
                      },
                    ),
                  )
                : Center(
                    child: controller.isLoadingCampaign.value
                        ? const CircularProgressIndicator()
                        : Text("No campaigns found",
                            style: DesignSystem.caption),
                  )),
            const SizedBox(height: DesignSystem.spacingL),

            // Featured Campaigns
            SectionHeader(
              title: "Featured Campaigns",
              onSeeAllTap: () => Get.to(CampaignList(
                  title: "Featured Campaigns",
                  list: controller.featuredCampaignList)),
            ),

            Obx(() => controller.featuredCampaignList.isNotEmpty
                ? SizedBox(
                    height: 400,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingM),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.featuredCampaignList.length,
                      itemBuilder: (context, index) {
                        return CampaignCard(
                          campaign: controller.featuredCampaignList[index],
                          isFeatured: true,
                          onTap: () {
                            controller.campaignDetail.value =
                                controller.featuredCampaignList[index];
                            Get.to(CampaignDetail());
                          },
                          onDonateTap: () => controller.openUrlDonation(
                              controller.featuredCampaignList[index]),
                        );
                      },
                    ),
                  )
                : Center(
                    child: controller.isLoadingCampaign.value
                        ? const CircularProgressIndicator()
                        : Text("No featured campaigns found",
                            style: DesignSystem.caption),
                  )),

            const SizedBox(height: DesignSystem.spacingL),

            // Success Stories
            SectionHeader(
              title: "Success Stories",
              onSeeAllTap:
                  null, // No list page for success stories in provided files
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
              child: Text(
                "Don’t let complicated software get in the way of your mission. Our tools are easy, free, and fun to use.",
                style: DesignSystem.caption,
              ),
            ),

            const SizedBox(height: DesignSystem.spacingM),

            Obx(() => controller.successStoryList.isNotEmpty
                ? SizedBox(
                    height: 260,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingM),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.successStoryList.length,
                      itemBuilder: (context, index) {
                        final story = controller.successStoryList[index];
                        return SuccessStoryCard(
                          title: story.title.toString(),
                          description: story.shortDescription.toString(),
                          imageUrl: story.photo.toString(),
                          onTap: () {
                            Get.find<HomeController>()
                                .getSuccessStoryDetail(story.id.toString());
                            Get.to(SuccessStoryDetail());
                          },
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text("No success stories found",
                        style: DesignSystem.caption))),

            const SizedBox(height: DesignSystem.spacingXL),
          ],
        ),
      ),
    );
  }
}
