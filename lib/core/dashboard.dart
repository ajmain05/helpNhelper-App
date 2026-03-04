import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/core/my_app_bar.dart';
import 'package:helpnhelper/core/my_drawer.dart';
import 'package:helpnhelper/pages/home/campaign_list.dart';
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
    icon: Icons.volunteer_activism,
    title: 'Current Campaigns',
  ),
  TabItem(
    icon: Icons.book,
    title: 'Our Works',
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
    List<Widget> pages = [HomePage(), CampaignList(), SuccessStories()];
    return Obx(() => IndexedStack(
          index: Get.find<HomeController>().currentIndex.value,
          children: pages,
        ));
  }
}
