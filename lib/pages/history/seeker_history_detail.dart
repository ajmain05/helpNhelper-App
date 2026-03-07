import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import '../../utils/my_colors.dart';

class SeekerHistoryDetail extends StatelessWidget {
  const SeekerHistoryDetail({Key? key}) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF00C896);
      case 'rejected':
      case 'declined':
        return const Color(0xFFFF5C7C);
      case 'investigating':
        return const Color(0xFF64B5F6);
      case 'pending':
        return const Color(0xFFFFA62B);
      default:
        return MyColors.primary;
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
    final data = Get.find<HomeController>().seekerHistoryDetail.value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF2C3242);
    final subColor = isDark ? Colors.white60 : Colors.grey.shade600;

    final String status = data.status?.toString() ?? 'pending';
    final Color stColor = _statusColor(status);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Request Details',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Card ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.title ?? "Fund Request",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: stColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: stColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_statusIcon(status),
                                  color: stColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                status.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: stColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildInfoBlock(
                          icon: Icons.account_balance_wallet_rounded,
                          title: 'Requested Amount',
                          value: '৳${data.requestedAmount ?? 0}',
                          color: const Color(0xFF00BFA5),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                        _buildInfoBlock(
                          icon: Icons.category_rounded,
                          title: 'Category',
                          value: data.category ?? 'Other',
                          color: const Color(0xFF5C6BC0),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Description ────────────────────────────────────────────────
              Text('Description',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.description?.isNotEmpty == true
                      ? data.description!
                      : "No description provided for this request.",
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: subColor, height: 1.6),
                ),
              ),

              const SizedBox(height: 24),

              // ── Details Grid ───────────────────────────────────────────────
              Text('Additional Information',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.event_available_rounded,
                      title: 'Completion Date',
                      subtitle: data.completionDate?.toString() ?? 'Pending',
                      textColor: textColor,
                      subColor: subColor,
                    ),
                    Divider(color: subColor.withOpacity(0.2), height: 1),
                    _buildListTile(
                      icon: Icons.comment_rounded,
                      title: 'Admin Comment',
                      subtitle: data.comment?.isNotEmpty == true
                          ? data.comment!
                          : 'No comments yet',
                      textColor: textColor,
                      subColor: subColor,
                    ),
                    if (data.volunteerDocumentStatus != null) ...[
                      Divider(color: subColor.withOpacity(0.2), height: 1),
                      _buildListTile(
                        icon: Icons.fact_check_rounded,
                        title: 'Investigation Status',
                        subtitle:
                            data.volunteerDocumentStatus?.toUpperCase() ?? '',
                        textColor: textColor,
                        subColor: subColor,
                      ),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.black54)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color subColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MyColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.info_outline_rounded,
            color: MyColors.primary, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.poppins(
              fontSize: 12, color: subColor, fontWeight: FontWeight.w500)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(subtitle,
            style: GoogleFonts.poppins(
                fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
