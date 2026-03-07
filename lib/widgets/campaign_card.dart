import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/my_colors.dart';
import '../models/campaign_model.dart';
import 'package:intl/intl.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onTap;
  final VoidCallback onDonateTap;
  final bool isFeatured;
  final double? width;

  const CampaignCard({
    Key? key,
    required this.campaign,
    required this.onTap,
    required this.onDonateTap,
    this.isFeatured = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double raised = double.tryParse(
            campaign.totalDonation ?? campaign.totalRaised ?? '0') ??
        0.0;
    double goal = double.tryParse(campaign.amount.toString()) ?? 1.0;
    double progress = (goal > 0) ? (raised / goal).clamp(0.0, 1.0) : 0.0;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isFeatured) {
      return _buildFeaturedCard(context, raised, progress, isDark);
    }

    return _buildColorfulCard(context, raised, goal, progress, isDark);
  }

  // ============== NEW HIGHLY COLORFUL & POPPING CARD ==============
  Widget _buildColorfulCard(BuildContext context, double raised, double goal,
      double progress, bool isDark) {
    final currencyFormat = NumberFormat.compact(locale: 'en_IN');
    final String formattedRaised = currencyFormat.format(raised);
    final String formattedGoal = currencyFormat.format(goal);

    // Color palette for the card
    final Color cardBgColor = isDark ? const Color(0xFF1E2430) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color progressBg =
        isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 290,
        margin: const EdgeInsets.only(right: 18, bottom: 20, top: 4),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
          // Deep, soft shadow for a "popping" 3D effect
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.5)
                  : MyColors.primary.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- TOP: Image Area with Floating Elements ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Image container with rounded top
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24), bottom: Radius.circular(8)),
                  child: Image.network(
                    campaign.photo.toString(),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),

                // Beautiful vibrant Category Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.primary,
                          MyColors.primaryDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      campaign.category?.title ?? "Campaign",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Floating Goal Percentage Badge
                Positioned(
                  bottom: -16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up_rounded,
                            color: const Color(0xFF10B981), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF10B981), // Vibrant Green
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- BOTTOM: Content Area ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 24, 16, 16), // Extra top padding for floating badge
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    campaign.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Thick, Colorful Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 10,
                      child: Stack(
                        children: [
                          Container(color: progressBg),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    MyColors.primary,
                                    const Color(0xFF14B8A6), // Vibrant Teal
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Data Row (Raised vs Goal)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Raised Stat (Highlighted)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: MyColors.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volunteer_activism_rounded,
                              size: 14,
                              color: MyColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Raised",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                "৳ $formattedRaised",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Goal Stat
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Goal",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            "৳ $formattedGoal",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Vibrant Donate Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.primary,
                          MyColors.primaryDark,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: onDonateTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Let gradient show
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Donate Now",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
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
  }

  // ============== FEATURED CARD (Updates to match styling if needed) ==============
  // ... (Keeping the Featured Card similar but ensuring it compiles correctly)
  Widget _buildFeaturedCard(
      BuildContext context, double raised, double progress, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 300,
        margin: const EdgeInsets.only(right: 16, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  isDark ? Colors.black38 : MyColors.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                campaign.photo.toString(),
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    Container(color: Colors.grey),
              ),
              // Beautiful Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.95),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [MyColors.primary, MyColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        campaign.category?.title ?? "Featured",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      campaign.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF10B981)), // Emerald
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tk ${raised.toStringAsFixed(0)} raised",
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    const Color(0xFF10B981).withOpacity(0.5)),
                          ),
                          child: Text(
                            "${(progress * 100).toStringAsFixed(0)}%",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF10B981),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}
