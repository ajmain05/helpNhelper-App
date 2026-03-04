import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/theme_controller.dart';
import 'package:helpnhelper/utils/global_size.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      iconTheme: const IconThemeData(color: MyColors.primary),
      toolbarHeight: 62,
      // Logo in the center / title area
      title: Image.asset(
        'assets/log.png',
        height: 48,
        fit: BoxFit.contain,
      ),
      centerTitle: false,
      actions: [
        // Dark mode toggle
        GetBuilder<ThemeController>(
          builder: (themeCtrl) => GestureDetector(
            onTap: themeCtrl.toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: themeCtrl.isDark
                    ? MyColors.primary.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    themeCtrl.isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 17,
                    color: themeCtrl.isDark
                        ? MyColors.primary
                        : Colors.orange.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    themeCtrl.isDark ? "Dark" : "Light",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: themeCtrl.isDark
                          ? MyColors.primary
                          : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: GlobalSize.width(8)),
      ],
    );
  }
}
