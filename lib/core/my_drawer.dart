import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
import 'package:helpnhelper/pages/profile/wallet_dashboard.dart';
import 'package:helpnhelper/pages/seeker/request_for_fund.dart';
import 'package:helpnhelper/pages/volunteer/transaction_list.dart';
import 'package:helpnhelper/pages/volunteer/transaction_method_list.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    // Background based on theme
    final bgColor = isDark ? const Color(0xFF1E2235) : Colors.white;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF2D3142);

    return Drawer(
      width: Get.width * 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // --- Colorful Gradient Header ---
            _buildColorfulHeader(isDark, isLoggedIn, userType, context),

            // --- Menu Items (Smooth scrolling) ---
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _menuSectionTitle('dashboard'.tr, isDark),
                  _buildNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'home'.tr,
                    color: const Color(0xFF3B82F6), // Blue
                    onTap: () {
                      Get.find<HomeController>().currentIndex.value = 0;
                      Get.offAll(() => const Dashboard());
                    },
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    icon: Icons.volunteer_activism_rounded,
                    label: 'current_campaigns'.tr,
                    color: const Color(0xFF10B981), // Emerald Green
                    onTap: () {
                      Get.find<HomeController>().currentIndex.value = 1;
                      Get.offAll(() => const Dashboard());
                    },
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    icon: Icons.check_circle_rounded,
                    label: 'our_works'.tr,
                    color: const Color(0xFFF59E0B), // Amber
                    onTap: () {
                      Get.find<HomeController>().currentIndex.value = 2;
                      Get.offAll(() => const Dashboard());
                    },
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _menuSectionTitle('explore'.tr, isDark),
                  _buildNavItem(
                    icon: Icons.info_rounded,
                    label: 'about_us'.tr,
                    color: const Color(0xFF8B5CF6), // Purple
                    onTap: () => Get.to(() => AboutUsPage()),
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    icon: Icons.help_rounded,
                    label: 'faq'.tr,
                    color: const Color(0xFFEC4899), // Pink
                    onTap: () => Get.to(() => FAQPage()),
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    icon: Icons.support_agent_rounded,
                    label: 'contact'.tr,
                    color: const Color(0xFF06B6D4), // Cyan
                    onTap: () => Get.to(() => const ContactPage()),
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  if (isLoggedIn) ...[
                    const SizedBox(height: 16),
                    _menuSectionTitle('personal'.tr, isDark),
                    _buildNavItem(
                      icon: Icons.history_edu_rounded,
                      label: 'history'.tr,
                      color: const Color(0xFF6366F1), // Indigo
                      onTap: () {
                        if (userType == "seeker") {
                          Get.to(() => SeekerHistory());
                        } else if (userType == "corporate-donor") {
                          Get.to(() => const WalletDashboard());
                        } else if (userType == "donor" ||
                            userType == "organization") {
                          Get.to(() => DonorHistory());
                        } else if (userType == "volunteer") {
                          Get.to(() => VolunteerHistory());
                        } else {
                          Get.to(() => DonorHistory());
                        }
                      },
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    if (userType == "seeker")
                      _buildNavItem(
                        icon: Icons.request_quote_rounded,
                        label: 'request_for_fund'.tr,
                        color: const Color(0xFFF43F5E), // Rose
                        onTap: () => Get.to(RequestForFund()),
                        textColor: textColor,
                        isDark: isDark,
                      ),
                    if (userType == "volunteer") ...[
                      _buildNavItem(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'transaction_methods'.tr,
                        color: const Color(0xFF14B8A6), // Teal
                        onTap: () => Get.to(TransactionMethodList()),
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      _buildNavItem(
                        icon: Icons.receipt_long_rounded,
                        label: 'transactions'.tr,
                        color: const Color(0xFF84CC16), // Lime
                        onTap: () => Get.to(TransactionList()),
                        textColor: textColor,
                        isDark: isDark,
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  _menuSectionTitle('settings'.tr, isDark),
                  _buildToggles(isDark),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // --- Footer Login / Logout ---
            _buildFooter(isDark, isLoggedIn, context),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildColorfulHeader(
      bool isDark, bool isLoggedIn, String userType, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 30,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2A2D43), const Color(0xFF1E2235)]
              : [
                  MyColors.primary,
                  MyColors.primaryDark
                ], // Beautiful brand gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : MyColors.primary).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Circle
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Image.asset("assets/log.png",
                height: 50, width: 50, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text(
            "Help N Helper",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (isLoggedIn && userType.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                userType.replaceAll('_', ' ').toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 6),
            Text(
              "Welcome to HnH",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ]
        ],
      ),
    );
  }

  // ─── Section Title ────────────────────────────────────────────────────────
  Widget _menuSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white54 : Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ─── Menu Item ────────────────────────────────────────────────────────────
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required Color textColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withOpacity(0.15),
          highlightColor: color.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Inner colorful icon box
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: isDark ? Colors.white24 : Colors.black12, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Settings Toggles ─────────────────────────────────────────────────────
  Widget _buildToggles(bool isDark) {
    return Column(
      children: [
        // Theme Toggle
        GetBuilder<ThemeController>(
          builder: (themeCtrl) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFDBA74).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color:
                        isDark ? const Color(0xFFFDBA74) : Colors.grey.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'dark_mode'.tr,
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : const Color(0xFF2D3142),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: themeCtrl.isDark,
                  onChanged: (_) => themeCtrl.toggle(),
                  activeColor: const Color(0xFFFDBA74),
                ),
              ],
            ),
          ),
        ),
        // Language Segmented Control
        GetBuilder<LanguageController>(
          builder: (langCtrl) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF6366F1).withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.translate_rounded,
                    color: Color(0xFF6366F1), // Indigo
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'language'.tr,
                        style: GoogleFonts.inter(
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3142),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Modern Colorful Language Cards
                      Column(
                        children: [
                          _buildModernLangBtn('en', 'EN',
                              const Color(0xFF3B82F6), langCtrl, isDark),
                          _buildModernLangBtn('bn', 'BN',
                              const Color(0xFF10B981), langCtrl, isDark),
                          _buildModernLangBtn('ar', 'AR',
                              const Color(0xFF8B5CF6), langCtrl, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Modern Language Card ───────────────────────────────────────────────
  // ─── Compact Language Card ───────────────────────────────────────────────
  Widget _buildModernLangBtn(String code, String shortLabel, Color accentColor,
      LanguageController langCtrl, bool isDark) {
    final isSelected = langCtrl.currentLang == code;
    // We override accent color to match the design (Blue for selected, grey for unselected)
    final activeColor = const Color(0xFF4285F4);

    return GestureDetector(
      onTap: () => langCtrl.changeLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.12)
              : (isDark ? Colors.transparent : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? activeColor.withOpacity(0.5)
                : (isDark ? Colors.white12 : Colors.grey.shade300),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text Info
            Text(
              shortLabel,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? activeColor
                    : (isDark ? Colors.white : const Color(0xFF2D3142)),
                letterSpacing: 2.0,
              ),
            ),
            // Checkmark ring (Radio Style)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? activeColor
                      : (isDark ? Colors.white24 : Colors.grey.shade300),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────
  Widget _buildFooter(bool isDark, bool isLoggedIn, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2235) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            offset: const Offset(0, -5),
            blurRadius: 10,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (isLoggedIn) {
            Get.find<AuthController>().logOut();
          } else {
            Get.to(LandingPage());
          }
        },
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLoggedIn
                  ? [const Color(0xFFFF5252), const Color(0xFFD32F2F)]
                  : [const Color(0xFF6366F1), const Color(0xFF4338CA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (isLoggedIn ? Colors.redAccent : const Color(0xFF6366F1))
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isLoggedIn ? 'logout'.tr : 'login'.tr,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
