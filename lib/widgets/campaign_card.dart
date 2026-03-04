import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../utils/design_system.dart';
import '../utils/app_theme.dart';
import '../models/campaign_model.dart';

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
    double progress = (raised / goal).clamp(0.0, 1.0);

    if (isFeatured) {
      return _buildFeaturedCard(context, raised, progress);
    }

    return _buildRegularCard(context, raised, progress);
  }

  Widget _buildFeaturedCard(
      BuildContext context, double raised, double progress) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 300,
        margin: const EdgeInsets.only(
            right: DesignSystem.spacingM, bottom: DesignSystem.spacingS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
          boxShadow: DesignSystem.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                campaign.photo.toString(),
                fit: BoxFit.cover,
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius:
                            BorderRadius.circular(DesignSystem.radiusS),
                      ),
                      child: Text(
                        campaign.category?.title ?? "Featured",
                        style: DesignSystem.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingS),
                    Text(
                      campaign.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DesignSystem.bodyBold
                          .copyWith(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: DesignSystem.spacingS),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(MyColors.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: DesignSystem.spacingS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tk ${raised.toStringAsFixed(0)} raised",
                          style: DesignSystem.caption
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: DesignSystem.bodyBold
                              .copyWith(color: MyColors.primary, fontSize: 12),
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

  Widget _buildRegularCard(
      BuildContext context, double raised, double progress) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280,
        margin: const EdgeInsets.only(
            right: DesignSystem.spacingM, bottom: DesignSystem.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
          boxShadow: AppTheme.shadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(DesignSystem.radiusL)),
                  child: Image.network(
                    campaign.photo.toString(),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MyColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(DesignSystem.radiusS),
                    ),
                    child: Text(
                      campaign.category?.title ?? "Campaign",
                      style: DesignSystem.caption.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: DesignSystem.bodyBold,
                  ),
                  const SizedBox(height: DesignSystem.spacingS),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusS),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: MyColors.primaryLight,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(MyColors.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingS),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Tk ${raised.toStringAsFixed(0)}",
                              style: DesignSystem.bodyBold.copyWith(
                                  color: MyColors.primary, fontSize: 14),
                            ),
                            TextSpan(
                              text: " raised",
                              style:
                                  DesignSystem.caption.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: DesignSystem.bodyBold.copyWith(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignSystem.spacingS),

                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onDonateTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DesignSystem.radiusM),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text("Donate Now",
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
}
