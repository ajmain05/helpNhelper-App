import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/language_controller.dart';
import 'package:helpnhelper/controllers/theme_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/pages/history/donor_history.dart';
import 'package:helpnhelper/pages/history/seeker_history.dart';
import 'package:helpnhelper/pages/history/volunteer_history.dart';
import 'package:helpnhelper/pages/login/landing_page.dart';
import 'package:helpnhelper/pages/seeker/request_for_fund.dart';
import 'package:helpnhelper/pages/volunteer/transaction_list.dart';
import 'package:helpnhelper/pages/volunteer/transaction_method_list.dart';
import 'package:helpnhelper/utils/global_size.dart';

import '../pages/aboutUs/about_us_page.dart';
import '../pages/home/faq.dart';
import '../pages/home/contact_page.dart';
import '../utils/my_colors.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    final bool isLoggedIn = (box.read('access_token') ?? '') != '';
    final String userType = box.read('type') ?? '';

    final theme = Theme.of(context);
    final surfaceColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? MyColors.textPrimary;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      width: Get.width / 1.7,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Logo ---
                    Container(
                      margin: const EdgeInsets.only(
                          top: 40, left: 20, right: 20, bottom: 8),
                      height: GlobalSize.height(130),
                      width: GlobalSize.width(130),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/log.png")),
                      ),
                    ),

                    const Divider(color: MyColors.divider, height: 1),
                    const SizedBox(height: 8),

                    // --- Menu Items ---
                    _drawerItem(
                      icon: CupertinoIcons.home,
                      label: 'home'.tr,
                      onTap: () {
                        Get.find<HomeController>().currentIndex.value = 0;
                        Get.offAll(() => const Dashboard());
                      },
                    ),
                    _drawerItem(
                      icon: Icons.list_alt,
                      label: 'about_us'.tr,
                      onTap: () => Get.to(() => AboutUsPage()),
                    ),
                    _drawerItem(
                      icon: Icons.event_available,
                      label: 'current_campaigns'.tr,
                      onTap: () {
                        Get.find<HomeController>().currentIndex.value = 1;
                        Get.offAll(() => const Dashboard());
                      },
                    ),

                    if (isLoggedIn)
                      _drawerItem(
                        icon: Icons.history,
                        label: 'history'.tr,
                        onTap: () {
                          if (userType == "seeker") {
                            Get.to(() => SeekerHistory());
                          } else if (userType == "donor") {
                            Get.to(() => DonorHistory());
                          } else if (userType == "volunteer") {
                            Get.to(() => VolunteerHistory());
                          } else {
                            // organization / corporate_donor — show donor history as fallback
                            Get.to(() => DonorHistory());
                          }
                        },
                      ),

                    if (isLoggedIn && userType == "seeker")
                      _drawerItem(
                        icon: Icons.money_off,
                        label: 'request_for_fund'.tr,
                        onTap: () => Get.to(RequestForFund()),
                      ),

                    if (isLoggedIn && userType == "volunteer")
                      _drawerItem(
                        icon: Icons.money_off,
                        label: 'transaction_methods'.tr,
                        onTap: () => Get.to(TransactionMethodList()),
                      ),

                    if (isLoggedIn && userType == "volunteer")
                      _drawerItem(
                        icon: Icons.money,
                        label: 'transactions'.tr,
                        onTap: () => Get.to(TransactionList()),
                      ),

                    _drawerItem(
                      icon: Icons.help_outline,
                      label: 'faq'.tr,
                      onTap: () => Get.to(() => FAQPage()),
                    ),
                    _drawerItem(
                      icon: Icons.phone_outlined,
                      label: 'contact'.tr,
                      onTap: () => Get.to(() => const ContactPage()),
                    ),

                    const Spacer(),

                    // --- Dark Mode Toggle ---
                    GetBuilder<ThemeController>(
                      builder: (themeCtrl) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: themeCtrl.isDark
                              ? MyColors.primary.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              themeCtrl.isDark
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: MyColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'dark_mode'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Switch.adaptive(
                              value: themeCtrl.isDark,
                              onChanged: (_) => themeCtrl.toggle(),
                              activeColor: MyColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Language Toggle ---
                    GetBuilder<LanguageController>(
                      builder: (langCtrl) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: langCtrl.isBangla
                              ? MyColors.primary.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.language,
                                color: MyColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'language'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            // EN button
                            GestureDetector(
                              onTap: () => langCtrl.changeLanguage('en'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: !langCtrl.isBangla
                                      ? MyColors.primary
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(8)),
                                  border: Border.all(
                                      color: MyColors.primary, width: 1.2),
                                ),
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    color: !langCtrl.isBangla
                                        ? Colors.white
                                        : MyColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            // বাং button
                            GestureDetector(
                              onTap: () => langCtrl.changeLanguage('bn'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: langCtrl.isBangla
                                      ? MyColors.primary
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(8)),
                                  border: Border.all(
                                      color: MyColors.primary, width: 1.2),
                                ),
                                child: Text(
                                  'বাং',
                                  style: TextStyle(
                                    color: langCtrl.isBangla
                                        ? Colors.white
                                        : MyColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: MyColors.divider, height: 1),

                    // --- Login / Logout Button ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: GestureDetector(
                        onTap: () {
                          if (isLoggedIn) {
                            Get.find<AuthController>().logOut();
                          } else {
                            Get.to(LandingPage());
                          }
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isLoggedIn
                                  ? [MyColors.primaryDark, MyColors.accent]
                                  : [MyColors.primary, MyColors.primaryDark],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isLoggedIn ? 'logout'.tr : 'login'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final itemTextColor = Theme.of(Get.context!).textTheme.bodyMedium?.color ??
        MyColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: MyColors.primary, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: itemTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
