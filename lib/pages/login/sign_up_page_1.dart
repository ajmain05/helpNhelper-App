import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/pages/login/sign_up_page_2.dart';
import 'package:helpnhelper/pages/login/sign_up_page_3.dart';

import 'package:helpnhelper/utils/my_colors.dart';

class SignUpPage1 extends StatefulWidget {
  SignUpPage1({Key? key}) : super(key: key);

  @override
  _SignUpPage1State createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AuthController controller;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  List<_AccountType> _getTypes() => [
        _AccountType(
            value: 'volunteer',
            label: 'role_volunteer'.tr,
            icon: Icons.volunteer_activism,
            description: 'role_volunteer_desc'.tr,
            gradient: [const Color(0xFF00BFA5), const Color(0xFF00897B)]),
        _AccountType(
            value: 'seeker',
            label: 'role_seeker'.tr,
            icon: Icons.support_agent,
            description: 'role_seeker_desc'.tr,
            gradient: [const Color(0xFF5C6BC0), const Color(0xFF3949AB)]),
        _AccountType(
            value: 'donor',
            label: 'role_donor'.tr,
            icon: Icons.favorite,
            description: 'role_donor_desc'.tr,
            gradient: [const Color(0xFFEF5350), const Color(0xFFC62828)]),
        _AccountType(
            value: 'corporate-donor',
            label: 'role_corporate_donor'.tr,
            icon: Icons.business,
            description: 'role_corporate_donor_desc'.tr,
            gradient: [const Color(0xFFFF7043), const Color(0xFFE64A19)]),
        _AccountType(
            value: 'organization',
            label: 'role_organization'.tr,
            icon: Icons.account_balance,
            description: 'role_organization_desc'.tr,
            gradient: [const Color(0xFF26A69A), const Color(0xFF00796B)]),
      ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(AuthController());
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade500;
    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFB);
    final fieldBg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2D3147) : Colors.grey.shade200;
    final cardBg = isDark ? const Color(0xFF1A1D27) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // Hero Header
            SliverToBoxAdapter(
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF004D40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -10,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 24,
                        right: 24,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Image.asset("assets/log.png",
                              height: 44, fit: BoxFit.contain),
                          const SizedBox(height: 10),
                          Text("create_account".tr,
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800)),
                          Text("choose_join".tr,
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),

                  // Step indicator
                  _buildStepIndicator(1, textColor),
                  const SizedBox(height: 20),

                  // Role label
                  Text("select_role".tr,
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  // Account type grid
                  Obx(() => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                        children: _getTypes().map((t) {
                          final selected = controller.type.value == t.value;
                          return GestureDetector(
                            onTap: () => controller.type.value = t.value,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: selected ? null : cardBg,
                                gradient: selected
                                    ? LinearGradient(
                                        colors: t.gradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? Colors.transparent
                                      : borderColor,
                                  width: 1.2,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color:
                                              t.gradient[0].withOpacity(0.35),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        )
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.white.withOpacity(0.2)
                                          : t.gradient[0].withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(t.icon,
                                        color: selected
                                            ? Colors.white
                                            : t.gradient[0],
                                        size: 22),
                                  ),
                                  const Spacer(),
                                  Text(t.label,
                                      style: GoogleFonts.poppins(
                                          color: selected
                                              ? Colors.white
                                              : textColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12)),
                                  const SizedBox(height: 2),
                                  Text(t.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          color: selected
                                              ? Colors.white70
                                              : hintColor,
                                          fontSize: 9.5)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),

                  const SizedBox(height: 24),

                  // Section label
                  Text("personal_info".tr,
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildField(
                          "name".tr,
                          controller.nameController,
                          textColor,
                          hintColor,
                          fieldBg,
                          borderColor,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          "email".tr,
                          controller.emailController,
                          textColor,
                          hintColor,
                          fieldBg,
                          borderColor,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          "phone".tr,
                          controller.mobileController,
                          textColor,
                          hintColor,
                          fieldBg,
                          borderColor,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        elevation: 4,
                        shadowColor: MyColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (controller.type.value == 'donor' ||
                              controller.type.value == 'corporate-donor') {
                            Get.to(SignUpPage3());
                          } else {
                            // seeker, volunteer, organization → go to Step 2
                            Get.to(SignUpPage2());
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("continue".tr,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current, Color textColor) {
    return Row(
      children: List.generate(3, (i) {
        final step = i + 1;
        final isActive = step == current;
        final isDone = step < current;
        return Expanded(
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isActive ? 32 : 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive || isDone
                      ? MyColors.primary
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : Text("$step",
                          style: TextStyle(
                              color: isActive || isDone
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                ),
              ),
              if (i < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isDone
                          ? MyColors.primary
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController ctrl,
    Color textColor,
    Color hintColor,
    Color fieldBg,
    Color borderColor, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      cursorColor: MyColors.primary,
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        prefixIcon: icon != null
            ? Icon(icon, color: MyColors.primary.withOpacity(0.7), size: 20)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}

class _AccountType {
  final String value;
  final String label;
  final IconData icon;
  final String description;
  final List<Color> gradient;

  const _AccountType({
    required this.value,
    required this.label,
    required this.icon,
    required this.description,
    required this.gradient,
  });
}
