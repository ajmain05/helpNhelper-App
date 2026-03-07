import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/core/my_app_bar.dart';
import 'package:helpnhelper/core/my_drawer.dart';
import 'package:helpnhelper/pages/home/campaign_detail.dart';
import 'package:helpnhelper/pages/profile/profile_page.dart';
import 'package:helpnhelper/pages/succesStories/success_stories_page.dart';
import 'package:helpnhelper/utils/my_colors.dart';

import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';
import '../pages/home/home_page.dart';

const List<TabItem> items = [
  TabItem(
    icon: Icons.home_outlined,
    title: 'Home',
  ),
  TabItem(
    icon: Icons.timelapse_rounded,
    title: 'Ongoing',
  ),
  TabItem(
    icon: Icons.emoji_events_rounded,
    title: 'Successful',
  ),
  TabItem(
    icon: Icons.person_outline_rounded,
    title: 'Profile',
  )
];

/// NOTE: Dashboard no longer wraps in a new MaterialApp.
/// The root GetMaterialApp in HelpNHelper handles theming.
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(SeekerController(), permanent: true);
    Get.put(VolunteerController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: _getBody(),
      ),
      appBar: CustomAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: Obx(() => BottomBarDefault(
            items: items,
            paddingVertical: 14,
            backgroundColor:
                isDark ? const Color(0xFF1A1D27) : MyColors.surface,
            color: isDark ? const Color(0xFF7B8299) : const Color(0xFF9E9E9E),
            colorSelected: MyColors.primary,
            indexSelected: Get.find<HomeController>().currentIndex.value,
            onTap: (int index) =>
                Get.find<HomeController>().currentIndex.value = index,
          )),
    );
  }

  Widget _getBody() {
    List<Widget> pages = [
      HomePage(),
      const _TabCampaignList(),
      SuccessStories(),
      const ProfilePage(showBackButton: false),
    ];
    return Obx(() => IndexedStack(
          index: Get.find<HomeController>().currentIndex.value,
          children: pages,
        ));
  }
}

class _TabCampaignList extends StatelessWidget {
  const _TabCampaignList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();

    return Obx(() {
      final displayList = controller.ongoingCampaigns;

      if (displayList.isEmpty) {
        return Center(
          child: controller.isLoadingCampaign.value
              ? const CircularProgressIndicator(color: MyColors.primary)
              : const Text("No ongoing campaigns.",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final campaign = displayList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.campaignDetail.value = campaign;
                    Get.to(() => CampaignDetail());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (campaign.photo != null)
                              Image.network(
                                campaign.photo!,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: double.infinity,
                                    height: 160,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image,
                                        size: 40, color: Colors.grey)),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    campaign.title ?? 'Campaign',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Raised: ৳${campaign.totalRaised ?? 0}',
                                        style: TextStyle(
                                            color: MyColors.primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Goal: ৳${campaign.amount ?? 0}',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
