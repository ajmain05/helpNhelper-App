import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/core/my_app_bar.dart';
import 'package:helpnhelper/core/my_drawer.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/pages/home/campaign_detail.dart';
import 'package:helpnhelper/pages/home/home_page.dart';
import 'package:helpnhelper/pages/profile/profile_page.dart';
import 'package:helpnhelper/pages/succesStories/success_stories_page.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/campaign_card.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';

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
      bottomNavigationBar: _ColorfulNavBar(isDark: isDark),
    );
  }

  Widget _getBody() {
    List<Widget> pages = [
      HomePage(),
      const _CurrentCampaignsTab(),
      SuccessStories(),
      const ProfilePage(showBackButton: false),
    ];
    return Obx(() => IndexedStack(
          index: Get.find<HomeController>().currentIndex.value,
          children: pages,
        ));
  }
}

// ── Colorful Bottom Navigation Bar ───────────────────────────────────────────
class _ColorfulNavBar extends StatelessWidget {
  final bool isDark;
  const _ColorfulNavBar({required this.isDark});

  // Each tab has a unique accent color
  static const List<Color> _tabColors = [
    Color(0xFF2979FF), // Home — Vibrant Blue
    Color(0xFF00C853), // Current — Vibrant Green
    Color(0xFFD500F9), // Our Works — Vibrant Purple
    Color(0xFFFF3D00), // Profile — Vibrant Deep Orange
  ];

  static const List<IconData> _tabIcons = [
    Icons.other_houses_rounded,
    Icons.data_usage_rounded,
    Icons.auto_awesome_mosaic_rounded,
    Icons.manage_accounts_rounded,
  ];

  List<String> get _tabLabels => [
        'home'.tr,
        'current_campaigns'.tr,
        'our_works'.tr,
        'profile'.tr,
      ];

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1A1D27) : Colors.white;

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      final selected = ctrl.currentIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: List.generate(4, (i) {
              final isSelected = selected == i;
              final color = _tabColors[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ctrl.currentIndex.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with animated pill background
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 14 : 0,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            _tabIcons[i],
                            size: isSelected ? 30 : 26,
                            color: isSelected ? color : color.withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Wrap in a FittedBox to guarantee it never overflows laterally
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _tabLabels[i],
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: isSelected ? 11.0 : 10.0,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color:
                                  isSelected ? color : color.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

// ── Current Campaigns Tab ─────────────────────────────────────────────────────
/// Shows campaigns that are still active (not yet at 100% goal).
class _CurrentCampaignsTab extends StatelessWidget {
  const _CurrentCampaignsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? Colors.white38 : Colors.grey.shade400;

    return Obx(() {
      if (controller.isLoadingCampaign.value) {
        return const Center(
            child: CircularProgressIndicator(color: MyColors.primary));
      }

      final list = controller.ongoingCampaigns;

      if (list.isEmpty) {
        return _emptyState(
          icon: Icons.timelapse_rounded,
          message: 'No current campaigns right now',
          color: const Color(0xFFFFA62B),
          subColor: subColor,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: list.length,
        itemBuilder: (context, index) =>
            _campaignListItem(context, list[index], controller),
      );
    });
  }
}

// ── Shared Helpers ────────────────────────────────────────────────────────────

Widget _emptyState({
  required IconData icon,
  required String message,
  required Color color,
  required Color subColor,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: color),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: GoogleFonts.poppins(
            color: subColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _campaignListItem(
    BuildContext context, CampaignModel campaign, HomeController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: GestureDetector(
      onTap: () {
        controller.campaignDetail.value = campaign;
        Get.to(() => CampaignDetail());
      },
      child: CampaignCard(
        campaign: campaign,
        onTap: () {
          controller.campaignDetail.value = campaign;
          Get.to(() => CampaignDetail());
        },
        onDonateTap: () => controller.openUrlDonation(campaign),
      ),
    ),
  );
}
