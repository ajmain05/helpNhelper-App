import 'package:flutter/material.dart';
import '../utils/design_system.dart';
import '../utils/my_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM, vertical: DesignSystem.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: DesignSystem.h2,
          ),
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              child: Text(
                "See All",
                style: DesignSystem.caption.copyWith(
                  color: MyColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
