import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/pages/home/campaign_detail.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/campaign_card.dart';

class CampaignList extends StatefulWidget {
  final String? title;
  final List<dynamic>? list;
  const CampaignList({Key? key, this.title, this.list}) : super(key: key);

  @override
  _CampaignListState createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.title ?? "All Campaigns";

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(displayTitle, style: DesignSystem.h3),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: widget.title != null
            ? IconButton(
                icon: Icon(Icons.arrow_back,
                    color: theme.iconTheme.color ?? MyColors.textPrimary),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: Obx(() {
        List<dynamic> displayList = widget.list ?? controller.campaignList;

        if (displayList.isEmpty) {
          return Center(
            child: controller.isLoadingCampaign.value
                ? const CircularProgressIndicator()
                : Text("No campaigns found", style: DesignSystem.caption),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(DesignSystem.spacingM),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
              child: CampaignCard(
                campaign: displayList[index],
                width: double.infinity,
                onTap: () {
                  controller.campaignDetail.value = displayList[index];
                  Get.to(CampaignDetail());
                },
                onDonateTap: () =>
                    controller.openUrlDonation(displayList[index]),
              ),
            );
          },
        );
      }),
    );
  }
}
