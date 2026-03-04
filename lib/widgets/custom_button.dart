import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/my_colors.dart';
import '../utils/design_system.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  final double? width;
  final double height;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isPrimary = true,
    this.width,
    this.height = 50,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width,
        height: height,
        decoration: BoxDecoration(
          color: isPrimary ? MyColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignSystem.radiusM),
          border:
              isPrimary ? null : Border.all(color: MyColors.primary, width: 2),
          boxShadow: isPrimary ? DesignSystem.softShadow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isPrimary ? Colors.white : MyColors.primary,
                size: 20,
              ),
              const SizedBox(width: DesignSystem.spacingS),
            ],
            Text(
              text,
              style: DesignSystem.buttonText.copyWith(
                color: isPrimary ? Colors.white : MyColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
