import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class DonorHistory extends StatefulWidget {
  DonorHistory({Key? key}) : super(key: key);

  @override
  _DonorHistoryState createState() => _DonorHistoryState();
}

class _DonorHistoryState extends State<DonorHistory> {
  var controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Get.find<HomeController>().getDonationHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2D3147), const Color(0xFF1A1D27)]
                      : [const Color(0xFFEF5350), const Color(0xFFC62828)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Donation History",
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      Text("Campaigns you've supported",
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 16),

                      // Summary stats
                      Obx(() {
                        double myTotal = 0;
                        for (var history in controller.donationHistoryList) {
                          myTotal +=
                              double.tryParse(history.amount ?? '0') ?? 0;
                        }

                        final totalDonated = myTotal.toStringAsFixed(0);
                        final campaigns = controller.donationHistoryList.length;
                        return Row(
                          children: [
                            _statCard("Total Donated", "Tk $totalDonated",
                                Icons.favorite),
                            const SizedBox(width: 12),
                            _statCard(
                                "Campaigns", "$campaigns", Icons.campaign),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: Obx(() {
              if (controller.isLoadingDonationHistory.value) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                        color: isDark
                            ? MyColors.primary
                            : const Color(0xFFEF5350)),
                  ),
                );
              }

              if (controller.donationHistoryList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: hintColor),
                        const SizedBox(height: 16),
                        Text(
                          "No campaigns found",
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start donating to campaigns\nto see your history here",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: hintColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final donation = controller.donationHistoryList[index];
                    final campaign = donation.campaign;

                    if (campaign == null) return const SizedBox();

                    // Calculate progress using totalRaised / amount safely
                    double percentage = 0;
                    try {
                      final raised =
                          double.parse(campaign.totalRaised?.toString() ?? '0');
                      final goal =
                          double.parse(campaign.amount?.toString() ?? '1');
                      percentage = goal > 0 ? (raised / goal) : 0;
                      if (percentage > 1) percentage = 1;
                    } catch (_) {}

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(DesignSystem.radiusM),
                        boxShadow: DesignSystem.softShadow,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(DesignSystem.radiusM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Color accent bar
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [MyColors.primary, MyColors.primaryDark]
                                      : [
                                          const Color(0xFFEF5350),
                                          const Color(0xFFC62828)
                                        ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title row
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF5350)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.campaign,
                                            color: Color(0xFFEF5350), size: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          campaign.title?.toString() ??
                                              "Campaign",
                                          style: DesignSystem.bodyBold,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Goal and raised amounts
                                  Row(
                                    children: [
                                      Icon(Icons.account_balance_wallet,
                                          size: 14,
                                          color: MyColors.primary
                                              .withOpacity(0.7)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Goal: Tk ${campaign.amount ?? 0}",
                                        style: DesignSystem.caption.copyWith(
                                            color: MyColors.primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(Icons.volunteer_activism,
                                          size: 14,
                                          color: const Color(0xFFEF5350)
                                              .withOpacity(0.8)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "You Donated: Tk ${donation.amount ?? 0}",
                                        style: DesignSystem.caption.copyWith(
                                            color: const Color(0xFFEF5350),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Progress bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      minHeight: 6,
                                      backgroundColor: isDark
                                          ? Colors.white12
                                          : Colors.grey.shade200,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFFEF5350)),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Stats row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${(percentage * 100).toStringAsFixed(0)}% funded",
                                        style: DesignSystem.caption.copyWith(
                                            color: hintColor, fontSize: 11),
                                      ),
                                      Text(
                                        "${campaign.totalDonors ?? 0} donors",
                                        style: DesignSystem.caption.copyWith(
                                            color: hintColor, fontSize: 11),
                                      ),
                                    ],
                                  ),

                                  // Short description
                                  if (campaign.shortDescription != null &&
                                      campaign
                                          .shortDescription!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      campaign.shortDescription.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: DesignSystem.body.copyWith(
                                          fontSize: 12, color: hintColor),
                                    ),
                                  ],

                                  // Date created
                                  if (donation.createdAt != null) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 12, color: hintColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          donation.createdAt.toString(),
                                          style: DesignSystem.caption.copyWith(
                                              fontSize: 11, color: hintColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: controller.donationHistoryList.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text(label,
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
