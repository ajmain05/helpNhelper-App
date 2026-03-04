import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/pages/donation/donation_page.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/custom_button.dart';
import 'package:helpnhelper/widgets/share_button.dart';

class CampaignDetail extends StatefulWidget {
  CampaignDetail({Key? key}) : super(key: key);

  @override
  _CampaignDetailState createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  var campaign = Get.find<HomeController>().campaignDetail.value;
  @override
  Widget build(BuildContext context) {
    var campaign = Get.find<HomeController>().campaignDetail.value;
    double raised = double.tryParse(
            campaign.totalDonation ?? campaign.totalRaised ?? '0') ??
        0.0;
    double goal = double.tryParse(campaign.amount.toString()) ?? 1.0;
    double progress = (raised / goal).clamp(0.0, 1.0);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.iconTheme.color ?? MyColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text("Campaign Details", style: DesignSystem.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignSystem.radiusL),
              child: Image.network(
                campaign.photo.toString(),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingL),

            // Category & Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: MyColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusS),
              ),
              child: Text(
                campaign.category?.title ?? "Campaign",
                style: DesignSystem.caption.copyWith(
                  color: MyColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingS),
            Text(
              campaign.title.toString(),
              style: DesignSystem.h2,
            ),
            const SizedBox(height: DesignSystem.spacingL),

            // Progress Section
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(DesignSystem.radiusM),
                boxShadow: DesignSystem.softShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Progress", style: DesignSystem.bodyBold),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style: DesignSystem.bodyBold
                            .copyWith(color: MyColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSystem.spacingS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusS),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: MyColors.primaryLight,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(MyColors.primary),
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingM),
                  Row(
                    children: [
                      _buildStatItem(
                          "Raised", "Tk ${raised.toStringAsFixed(0)}"),
                      _buildStatItem("Goal", "Tk ${goal.toStringAsFixed(0)}"),
                      _buildStatItem("Donors", campaign.totalDonors.toString()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),

            // Description
            Text("Description", style: DesignSystem.h3),
            const SizedBox(height: DesignSystem.spacingM),
            if ((campaign.shortDescription ?? '').isNotEmpty) ...[
              Text(
                campaign.shortDescription!,
                style: DesignSystem.body
                    .copyWith(height: 1.6, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: DesignSystem.spacingM),
            ],
            Text(
              campaign.longDescription ?? '',
              style: DesignSystem.body.copyWith(height: 1.6),
            ),
            const SizedBox(height: DesignSystem.spacingXL),

            // Footer Buttons
            CustomButton(
              text: "Donate Now",
              onTap: () => Get.to(() => DonationPage(campaign: campaign)),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            SizedBox(
              width: double.infinity,
              child: ShareButton(
                shareUrl: 'https://helpnhelper.com/campaign/${campaign.id}',
                shareTitle:
                    campaign.title ?? 'Check this campaign on helpNhelper!',
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: DesignSystem.caption),
          const SizedBox(height: 4),
          Text(value, style: DesignSystem.bodyBold.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
