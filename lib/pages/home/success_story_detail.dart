import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/widgets/share_button.dart';

class SuccessStoryDetail extends StatefulWidget {
  SuccessStoryDetail({Key? key}) : super(key: key);

  @override
  _SuccessStoryDetailState createState() => _SuccessStoryDetailState();
}

class _SuccessStoryDetailState extends State<SuccessStoryDetail> {
  bool _isValidUrl(String? url) =>
      url != null && url.isNotEmpty && url != 'null' && url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = Get.find<HomeController>();
      final story = ctrl.successStoryDetail.value;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ctrl.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFF00BFA5),
                strokeWidth: 3,
              ))
            : CustomScrollView(
                slivers: [
                  // ── Collapsible Hero AppBar ──────────────────
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: MyColors.primaryDark,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        "Success Story",
                        style: DesignSystem.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      background: _isValidUrl(story.photo?.toString())
                          ? Image.network(
                              story.photo.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _heroPlaceholder(),
                            )
                          : _heroPlaceholder(),
                    ),
                  ),

                  // ── Body Content ─────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(DesignSystem.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          if ((story.title ?? '').toString().isNotEmpty &&
                              story.title.toString() != 'null')
                            Text(
                              story.title.toString(),
                              style: DesignSystem.h2,
                            ),
                          const SizedBox(height: DesignSystem.spacingM),

                          // Description
                          if ((story.longDescription ?? '')
                                  .toString()
                                  .isNotEmpty &&
                              story.longDescription.toString() != 'null')
                            Text(
                              story.longDescription.toString(),
                              style: DesignSystem.body.copyWith(height: 1.7),
                            ),

                          const SizedBox(height: DesignSystem.spacingXL),

                          // ── Impact Section ───────────────────
                          if (_isValidUrl(
                                  story.previousCondition?.toString()) ||
                              _isValidUrl(
                                  story.presentCondition?.toString())) ...[
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: MyColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text("Impact Photos", style: DesignSystem.h3),
                              ],
                            ),
                            const SizedBox(height: DesignSystem.spacingM),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildImpactCard(
                                    "Before",
                                    story.previousCondition?.toString(),
                                  ),
                                ),
                                const SizedBox(width: DesignSystem.spacingM),
                                Expanded(
                                  child: _buildImpactCard(
                                    "After",
                                    story.presentCondition?.toString(),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: DesignSystem.spacingL),
                          // Share Button
                          SizedBox(
                            width: double.infinity,
                            child: ShareButton(
                              shareUrl:
                                  'https://helpnhelper.com/success-stories/${story.id}',
                              shareTitle: story.title ??
                                  'Check this success story on helpNhelper!',
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacingXL),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _heroPlaceholder() {
    return Container(
      color: MyColors.primaryDark,
      child: const Center(
        child: Icon(Icons.volunteer_activism, color: Colors.white30, size: 80),
      ),
    );
  }

  Widget _buildImpactCard(String label, String? imageUrl) {
    final bool isValid = _isValidUrl(imageUrl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: label == "Before"
                ? Colors.red.withOpacity(0.12)
                : Colors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(DesignSystem.radiusS),
          ),
          child: Text(
            label,
            style: DesignSystem.caption.copyWith(
              color: label == "Before" ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignSystem.radiusM),
          child: isValid
              ? Image.network(
                  imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _impactPlaceholder(),
                )
              : _impactPlaceholder(),
        ),
      ],
    );
  }

  Widget _impactPlaceholder() {
    return Container(
      height: 160,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: Colors.grey, size: 36),
      ),
    );
  }
}
