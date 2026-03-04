import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/pages/history/seeker_history_detail.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class SeekerHistory extends StatefulWidget {
  const SeekerHistory({Key? key}) : super(key: key);

  @override
  _SeekerHistoryState createState() => _SeekerHistoryState();
}

class _SeekerHistoryState extends State<SeekerHistory> {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getSeekerHistory();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF00C896);
      case 'rejected':
      case 'declined':
        return const Color(0xFFFF5C7C);
      case 'investigating':
        return const Color(0xFF64B5F6);
      default:
        return const Color(0xFFFFA62B);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
      case 'declined':
        return Icons.cancel_rounded;
      case 'investigating':
        return Icons.search_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final subColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;
    final scaffoldBg =
        isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final fieldBg = isDark ? const Color(0xFF252840) : const Color(0xFFF7F9FC);

    // Accent color for seeker — indigo/purple
    const accentColor = Color(0xFF5C6BC0);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Hero Header ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1A1D27), const Color(0xFF2D3147)]
                      : [const Color(0xFF5C6BC0), const Color(0xFF283593)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 24,
                  right: 24,
                  bottom: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.support_agent_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Support History',
                                style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800)),
                            Text('Your fund requests & outcomes',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── History Cards ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: accentColor),
                  ),
                );
              }
              if (controller.seekerHistoryList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_outlined,
                            size: 72, color: subColor.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text('No history found',
                            style: GoogleFonts.poppins(
                                color: subColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Text('Your fund requests will appear here',
                            style: GoogleFonts.poppins(
                                color: subColor.withOpacity(0.7),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = controller.seekerHistoryList[index];
                    final status = item.status?.toString() ?? 'pending';
                    final statusColor = _statusColor(status);

                    return GestureDetector(
                      onTap: () {
                        controller.seekerHistoryDetail.value = item;
                        Get.to(() => SeekerHistoryDetail());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    accentColor.withOpacity(0.1),
                                    accentColor.withOpacity(0.03),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.receipt_long_rounded,
                                        color: accentColor,
                                        size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.title?.toString() ?? 'Fund Request',
                                      style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: statusColor.withOpacity(0.3),
                                          width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_statusIcon(status),
                                            color: statusColor, size: 12),
                                        const SizedBox(width: 4),
                                        Text(status.toUpperCase(),
                                            style: GoogleFonts.poppins(
                                                color: statusColor,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Details
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 14, 20, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _infoTile(
                                          icon: Icons.attach_money_rounded,
                                          label: 'Requested',
                                          value:
                                              '৳${item.requestedAmount ?? 0}',
                                          textColor: textColor,
                                          subColor: subColor,
                                          highlight: true,
                                          fieldBg: fieldBg,
                                          highlightColor: accentColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _infoTile(
                                          icon: Icons.calendar_today_rounded,
                                          label: 'Date',
                                          value:
                                              item.completionDate?.toString() ??
                                                  'N/A',
                                          textColor: textColor,
                                          subColor: subColor,
                                          fieldBg: fieldBg,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.description != null &&
                                      item.description
                                          .toString()
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      item.description.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          color: subColor, fontSize: 12),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  // View details button
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: accentColor.withOpacity(0.2)),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.visibility_outlined,
                                              color: accentColor, size: 14),
                                          const SizedBox(width: 6),
                                          Text('View Details',
                                              style: GoogleFonts.poppins(
                                                  color: accentColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: controller.seekerHistoryList.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subColor,
    required Color fieldBg,
    bool highlight = false,
    Color highlightColor = MyColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: highlight ? highlightColor : subColor.withOpacity(0.7),
              size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(color: subColor, fontSize: 9)),
                Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: highlight ? highlightColor : textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
