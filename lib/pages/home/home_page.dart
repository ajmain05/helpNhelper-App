import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/pages/home/campaign_detail.dart';
import 'package:helpnhelper/pages/home/campaign_list.dart';
import 'package:helpnhelper/pages/home/success_story_detail.dart';
import 'package:helpnhelper/pages/succesStories/success_stories_page.dart';
import 'package:helpnhelper/widgets/success_story_card.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/campaign_card.dart';
import 'package:helpnhelper/widgets/custom_button.dart';
import 'package:helpnhelper/widgets/section_header.dart';
import 'package:helpnhelper/widgets/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.getAllCampaign();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner ──────────────────────────────────────────────────
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

              // ── Statistics Row ───────────────────────────────────────────────
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

              // ── Campaign Categories (Icon Cards) ──────────────────────────────
              Obx(() => controller.campaignCategoryList.isNotEmpty
                  ? SizedBox(
                      height: 108,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spacingM),
                        itemCount: controller.campaignCategoryList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final cat = controller.campaignCategoryList[index];

                          // ── Hide sub-categories (which are actually campaign titles in this DB) ──
                          if (cat.parentId != null)
                            return const SizedBox.shrink();

                          // ── Hide mosque/graveyard categories ──
                          final tLow = (cat.title ?? '').toLowerCase();
                          final bool isHidden = tLow.contains('mosque') ||
                              tLow.contains('masjid') ||
                              tLow.contains('মসজিদ') ||
                              tLow.contains('কবর') ||
                              tLow.contains('kabor') ||
                              tLow.contains('tube well') ||
                              tLow.contains('নলকূপ') ||
                              tLow.contains('শহীদ') ||
                              tLow.contains('martyr');
                          if (isHidden) return const SizedBox.shrink();

                          final bool isSelected = index == selectedCategory;
                          final _CategoryMeta meta =
                              _CategoryMeta.from(cat.title ?? '');

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                                if (cat.id == 0) {
                                  controller.getAllCampaign();
                                } else {
                                  controller
                                      .getCampaignByCategory(cat.id.toString());
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 76,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  // ── Icon Container ──
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSelected
                                            ? meta.gradientSelected
                                            : meta.gradientUnselected,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: meta.gradientSelected[0]
                                                    .withOpacity(0.40),
                                                blurRadius: 12,
                                                offset: const Offset(0, 5),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Icon(
                                      meta.icon,
                                      color: isSelected
                                          ? Colors.white
                                          : meta.gradientSelected[0],
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  // ── Label ──
                                  Text(
                                    meta.label,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? meta.gradientSelected[0]
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: DesignSystem.spacingL),

              // ── Ongoing Campaigns ──────────────────────────────────────────────
              SectionHeader(
                title: "Current Campaigns",
                onSeeAllTap: () => Get.to(CampaignList(
                    title: "Current Campaigns",
                    list: controller.ongoingCampaigns)),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.isLoadingCampaign.value) {
                  return const SizedBox(
                    height: 380,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: MyColors.primary)),
                  );
                }
                return SizedBox(
                  height: 415,
                  child: _CampaignTabContent(
                    campaigns: controller.ongoingCampaigns,
                    emptyMessage: 'No ongoing campaigns',
                    emptyIcon: Icons.timelapse_outlined,
                    accentColor: const Color(0xFFFFA62B),
                  ),
                );
              }),

              const SizedBox(height: DesignSystem.spacingL),

              // ── Successful Campaigns ─────────────────────────────────────────
              // Shows campaigns that have reached 100% of their goal.
              // These are filtered from the same campaignList, so when an
              // ongoing campaign hits 100%, it automatically moves here.
              SectionHeader(
                title: "Ongoing Campaigns",
                onSeeAllTap: () => Get.to(SuccessStories()),
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (controller.isLoadingCampaign.value) {
                  return const SizedBox(
                    height: 260,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: MyColors.primary)),
                  );
                }
                final successful = controller.successfulCampaigns;
                if (successful.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text("No successful campaigns yet",
                          style: DesignSystem.caption),
                    ),
                  );
                }
                return SizedBox(
                  height: 415,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DesignSystem.spacingM),
                    scrollDirection: Axis.horizontal,
                    itemCount: successful.length,
                    itemBuilder: (context, index) {
                      final campaign = successful[index];
                      return Stack(
                        children: [
                          CampaignCard(
                            campaign: campaign,
                            onTap: () {
                              controller.campaignDetail.value = campaign;
                              Get.to(CampaignDetail());
                            },
                            onDonateTap: () =>
                                controller.openUrlDonation(campaign),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: DesignSystem.spacingL),

              // ── Our Work / Success Stories ────────────────────────────────────
              // Shows success stories from the admin panel (before/after photos).
              SectionHeader(
                title: "Our Works",
                onSeeAllTap: () => Get.to(SuccessStories()),
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (controller.isLoadingCampaign.value) {
                  return const SizedBox(
                    height: 260,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: MyColors.primary)),
                  );
                }
                return controller.successStoryList.isNotEmpty
                    ? SizedBox(
                        height: 280,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text("No stories yet",
                              style: DesignSystem.caption),
                        ),
                      );
              }),

              const SizedBox(height: DesignSystem.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Campaign Tab Content Widget ─────────────────────────────────────
class _CampaignTabContent extends StatelessWidget {
  final List<CampaignModel> campaigns;
  final String emptyMessage;
  final IconData emptyIcon;
  final Color accentColor;

  const _CampaignTabContent({
    required this.campaigns,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final subColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white38
        : Colors.grey.shade400;

    if (campaigns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 56, color: subColor),
            const SizedBox(height: 12),
            Text(emptyMessage,
                style: GoogleFonts.poppins(
                    color: subColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
      scrollDirection: Axis.horizontal,
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        return Stack(
          children: [
            CampaignCard(
              campaign: campaign,
              onTap: () {
                controller.campaignDetail.value = campaign;
                Get.to(CampaignDetail());
              },
              onDonateTap: () => controller.openUrlDonation(campaign),
            ),
          ],
        );
      },
    );
  }
}

// ── Category metadata: icon + gradient colours ────────────────────────────────
class _CategoryMeta {
  final IconData icon;
  final List<Color> gradientSelected; // full colour when active
  final List<Color> gradientUnselected; // soft tint background when inactive
  final String label;

  const _CategoryMeta({
    required this.icon,
    required this.gradientSelected,
    required this.gradientUnselected,
    required this.label,
  });

  /// Maps an API category title to display metadata.
  /// Unrecognised categories fall back to "Social Service" styling.
  factory _CategoryMeta.from(String title) {
    final t = title.toLowerCase();

    // ─── All ──────────────────────────────────────────────
    if (t == 'all' || t.isEmpty) {
      return _CategoryMeta(
        icon: Icons.grid_view_rounded,
        gradientSelected: const [Color(0xFF00BFA5), Color(0xFF00796B)],
        gradientUnselected: const [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
        label: 'All',
      );
    }

    // ─── Relief ───────────────────────────────────────────
    if (t.contains('relief') || t.contains('ত্রাণ') || t.contains('রিলিফ')) {
      return _CategoryMeta(
        icon: Icons.volunteer_activism_rounded,
        gradientSelected: const [Color(0xFFFF6F61), Color(0xFFE53935)],
        gradientUnselected: const [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        label: 'Relief',
      );
    }

    // ─── Treatment / Medical ──────────────────────────────
    if (t.contains('treatment') ||
        t.contains('medical') ||
        t.contains('health') ||
        t.contains('চিকিৎসা')) {
      return _CategoryMeta(
        icon: Icons.local_hospital_rounded,
        gradientSelected: const [Color(0xFF2196F3), Color(0xFF1565C0)],
        gradientUnselected: const [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        label: 'Treatment',
      );
    }

    // ─── Education ────────────────────────────────────────
    if (t.contains('education') ||
        t.contains('শিক্ষা') ||
        t.contains('study')) {
      return _CategoryMeta(
        icon: Icons.school_rounded,
        gradientSelected: const [Color(0xFF7C4DFF), Color(0xFF512DA8)],
        gradientUnselected: const [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
        label: 'Education',
      );
    }

    // ─── Rehabilitation ───────────────────────────────────
    if (t.contains('rehab') || t.contains('পুনর্বাসন')) {
      return _CategoryMeta(
        icon: Icons.healing_rounded,
        gradientSelected: const [Color(0xFF43A047), Color(0xFF1B5E20)],
        gradientUnselected: const [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        label: 'Rehab',
      );
    }

    // ─── Hygiene ──────────────────────────────────────────
    if (t.contains('hygiene') ||
        t.contains('sanit') ||
        t.contains('স্বাস্থ্যবিধি')) {
      return _CategoryMeta(
        icon: Icons.sanitizer_rounded,
        gradientSelected: const [Color(0xFF00BCD4), Color(0xFF00838F)],
        gradientUnselected: const [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
        label: 'Hygiene',
      );
    }

    // ─── Food / Meal ──────────────────────────────────────
    if (t.contains('food') ||
        t.contains('meal') ||
        t.contains('খাদ্য') ||
        t.contains('খাবার')) {
      return _CategoryMeta(
        icon: Icons.restaurant_rounded,
        gradientSelected: const [Color(0xFFFB8C00), Color(0xFFE65100)],
        gradientUnselected: const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        label: 'Food',
      );
    }

    // ─── Mosque / Religious ───────────────────────────────
    if (t.contains('mosque') ||
        t.contains('masjid') ||
        t.contains('মসজিদ') ||
        t.contains('religious') ||
        t.contains('কবর')) {
      return _CategoryMeta(
        icon: Icons.place_rounded,
        gradientSelected: const [Color(0xFF8D6E63), Color(0xFF4E342E)],
        gradientUnselected: const [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
        label: title.length > 10 ? '${title.substring(0, 8)}…' : title,
      );
    }

    // ─── Van / Rickshaw / Pushcart ────────────────────────
    if (t.contains('ভ্যান') ||
        t.contains('rickshaw') ||
        t.contains('pushcart')) {
      return _CategoryMeta(
        icon: Icons.pedal_bike_rounded, // Alternative to rickshaw/van
        gradientSelected: const [Color(0xFF8D6E63), Color(0xFF5D4037)],
        gradientUnselected: const [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
        label: title.length > 12 ? '${title.substring(0, 10)}…' : title,
      );
    }

    // ─── Martyr / Shaheed Family ─────────────────────────
    if (t.contains('শহীদ') || t.contains('martyr') || t.contains('পরিবা')) {
      return _CategoryMeta(
        icon: Icons.diversity_1_rounded,
        gradientSelected: const [Color(0xFFD32F2F), Color(0xFFC62828)],
        gradientUnselected: const [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        label: title.length > 12 ? '${title.substring(0, 10)}…' : title,
      );
    }

    // ─── Small Business / Micro Enterprise ────────────────
    if (t.contains('ক্ষুদ্র') ||
        t.contains('business') ||
        t.contains('ব্যবসা')) {
      return _CategoryMeta(
        icon: Icons.storefront_rounded,
        gradientSelected: const [Color(0xFFFBC02D), Color(0xFFF57F17)],
        gradientUnselected: const [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
        label: title.length > 12 ? '${title.substring(0, 10)}…' : title,
      );
    }

    // ─── Default → show actual API title ────────────────────
    // Unknown categories show their real title so duplicates are identifiable
    final shortLabel = title.length > 12 ? '${title.substring(0, 10)}…' : title;
    return _CategoryMeta(
      icon: Icons.people_alt_rounded,
      gradientSelected: const [Color(0xFF26A69A), Color(0xFF00695C)],
      gradientUnselected: const [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
      label: shortLabel,
    );
  }
}
