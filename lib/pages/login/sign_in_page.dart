import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/pages/login/otp_page.dart';
import 'package:helpnhelper/pages/login/sign_up_page_1.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/auth_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;

  _createWallet(context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
            Get.find<HomeController>().currentIndex.value = 0;
            Get.offAll(() => const Dashboard());
          });
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              constraints:
                  BoxConstraints(maxHeight: Get.height, maxWidth: Get.width),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Lottie.asset("assets/animations/ss.json")),
            ),
          );
        });
  }

  _otpSent(context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
            Get.to(() => OtpPage());
          });
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              constraints:
                  BoxConstraints(maxHeight: Get.height, maxWidth: Get.width),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Lottie.asset("assets/animations/ss.json")),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final fieldBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA);
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;

    Widget buildField(String hint, TextEditingController ctrl,
        {bool isPassword = false}) {
      return TextFormField(
        controller: ctrl,
        obscureText: isPassword ? isObscured : false,
        keyboardType: TextInputType.text,
        cursorColor: MyColors.primary,
        style: GoogleFonts.poppins(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: fieldBg,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
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
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off : Icons.visibility,
                    color: hintColor,
                  ),
                  onPressed: () => setState(() => isObscured = !isObscured),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      );
    }

    return Obx(() => Visibility(
          visible: !(Get.find<AuthController>().isLoading.value),
          replacement: Container(
            color: bgColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00BFA5),
                strokeWidth: 3,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Logo
                      Center(
                        child: Image.asset("assets/log.png",
                            height: 90, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text("Welcome Back",
                          style: GoogleFonts.playfairDisplay(
                              color: textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text("Sign in to continue",
                          style: GoogleFonts.poppins(
                              color: hintColor, fontSize: 14)),
                      const SizedBox(height: 28),

                      // Login method toggle
                      Container(
                        decoration: BoxDecoration(
                          color: fieldBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            _ToggleTab(
                                label: "Email",
                                selected: !controller.phoneLogin,
                                onTap: () => setState(
                                    () => controller.phoneLogin = false)),
                            _ToggleTab(
                                label: "Phone",
                                selected: controller.phoneLogin,
                                onTap: () => setState(
                                    () => controller.phoneLogin = true)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email / Phone field
                      buildField(
                          controller.phoneLogin ? "Phone Number" : "Email",
                          controller.emailController),
                      const SizedBox(height: 16),

                      // Password field (if passLogin)
                      if (controller.passLogin) ...[
                        buildField("Password", controller.passwordController,
                            isPassword: true),
                        const SizedBox(height: 20),
                      ],

                      // Primary action button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Get.find<AuthController>().isLoading.value = true;
                              if (controller.passLogin) {
                                Get.find<AuthController>()
                                    .signIn()
                                    .then((value) {
                                  if (value == true) _createWallet(context);
                                });
                              } else {
                                Get.find<AuthController>()
                                    .getOtp()
                                    .then((value) {
                                  if (value == true) _otpSent(context);
                                });
                              }
                            }
                          },
                          child: Text(
                            controller.passLogin ? "Sign In" : "Send OTP",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Toggle between OTP / Password
                      Center(
                        child: TextButton(
                          onPressed: () => setState(() =>
                              controller.passLogin = !controller.passLogin),
                          child: Text(
                            controller.passLogin
                                ? "Sign in with OTP instead"
                                : "Sign in with Password instead",
                            style: GoogleFonts.poppins(
                                color: MyColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(children: [
                        Expanded(child: Divider(color: borderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text("OR",
                              style: GoogleFonts.poppins(
                                  color: hintColor, fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: borderColor)),
                      ]),
                      const SizedBox(height: 24),

                      // Sign Up link
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.to(SignUpPage1()),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                  color: hintColor, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: GoogleFonts.poppins(
                                      color: MyColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleTab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? MyColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
