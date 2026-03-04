import 'package:flutter/material.dart';
import '../utils/design_system.dart';
import '../utils/my_colors.dart';
import '../utils/app_theme.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatsCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingS),
      decoration: BoxDecoration(
        color: AppTheme.isDark(context)
            ? MyColors.primary.withOpacity(0.12)
            : MyColors.primaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(DesignSystem.radiusM),
      ),
      child: Column(
        children: [
          Icon(icon, color: MyColors.primary, size: 24),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            value,
            style: DesignSystem.bodyBold.copyWith(fontSize: 14),
          ),
          Text(
            label,
            style: DesignSystem.caption.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
