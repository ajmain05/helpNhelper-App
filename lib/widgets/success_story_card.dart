import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../utils/design_system.dart';
import '../utils/app_theme.dart';

class SuccessStoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final double? width;

  const SuccessStoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    this.width,
  }) : super(key: key);

  bool get _hasValidImage =>
      imageUrl.isNotEmpty && imageUrl != 'null' && imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    // Card total height budget = 260px
    // image: 150 | text area: 110
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 240,
        height: 260,
        margin: const EdgeInsets.only(right: DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
          boxShadow: AppTheme.shadow(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image (top half) ──────────────────────────────────
            SizedBox(
              height: 148,
              width: double.infinity,
              child: _hasValidImage
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),

            // ── Teal accent line ──────────────────────────────────
            Container(height: 3, color: MyColors.primary),

            // ── Text content ──────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DesignSystem.bodyBold.copyWith(
                        fontSize: 13.5,
                        height: 1.35,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                    // Read Story link
                    Row(
                      children: [
                        Text(
                          "Read Story",
                          style: DesignSystem.caption.copyWith(
                            color: MyColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.arrow_forward_ios,
                            size: 10, color: MyColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Builder(
      builder: (context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: Colors.grey, size: 36),
        ),
      ),
    );
  }
}
