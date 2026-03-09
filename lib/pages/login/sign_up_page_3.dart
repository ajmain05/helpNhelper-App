import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/pages/login/sign_in_page.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class SignUpPage3 extends StatefulWidget {
  SignUpPage3({Key? key}) : super(key: key);

  @override
  _SignUpPage3State createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      Get.find<AuthController>().profileImage.add(_pickedFile!);
    }
  }

  void _createWallet(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(builderContext).pop();
            Get.to(SignIn());
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
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade500;
    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFB);
    final fieldBg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2D3147) : Colors.grey.shade200;
    final authCtrl = Get.find<AuthController>();
    final isVolunteerOrSeeker =
        authCtrl.type.value == 'seeker' || authCtrl.type.value == 'volunteer';

    return Obx(() => Visibility(
          visible: !authCtrl.isLoading.value,
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
            body: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00BFA5), Color(0xFF004D40)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 20,
                        right: 20,
                        bottom: 24,
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
                          const SizedBox(height: 16),
                          Text("security_profile".tr,
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                          Text("set_pass_photo".tr,
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 14),
                          _buildStepIndicator(3),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Photo
                            if (isVolunteerOrSeeker) ...[
                              _sectionHeader("Profile Photo",
                                  Icons.person_pin_circle_outlined, textColor),
                              const SizedBox(height: 12),
                              Obx(
                                () => authCtrl.profileImage.isEmpty
                                    ? GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: fieldBg,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                                color: MyColors.primary
                                                    .withOpacity(0.4),
                                                width: 1.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: MyColors.primary
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                    Icons.add_a_photo,
                                                    color: MyColors.primary,
                                                    size: 24),
                                              ),
                                              const SizedBox(height: 8),
                                              Text("upload_profile_photo".tr,
                                                  style: GoogleFonts.poppins(
                                                      color: MyColors.primary,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text("supported_format".tr,
                                                  style: GoogleFonts.poppins(
                                                      color: hintColor,
                                                      fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 110,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              authCtrl.profileImage.length,
                                          itemBuilder: (_, index) => Stack(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: FileImage(File(
                                                        authCtrl
                                                            .profileImage[index]
                                                            .path)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 14,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      authCtrl.profileImage
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Password Section
                            _sectionHeader("password_security".tr,
                                Icons.lock_outline, textColor),
                            const SizedBox(height: 12),

                            // Password field
                            TextFormField(
                              controller: authCtrl.passwordController,
                              obscureText: _obscurePassword,
                              cursorColor: MyColors.primary,
                              style: GoogleFonts.poppins(
                                  color: textColor, fontSize: 14),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: fieldBg,
                                hintText: "password".tr,
                                hintStyle: GoogleFonts.poppins(
                                    color: hintColor, fontSize: 14),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: MyColors.primary.withOpacity(0.7),
                                    size: 20),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: hintColor,
                                    size: 20,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: MyColors.primary, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please enter password";
                                }
                                if (v.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Confirm Password field
                            TextFormField(
                              controller: authCtrl.confirmPasswordController,
                              obscureText: _obscureConfirm,
                              cursorColor: MyColors.primary,
                              style: GoogleFonts.poppins(
                                  color: textColor, fontSize: 14),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: fieldBg,
                                hintText: "confirm_password".tr,
                                hintStyle: GoogleFonts.poppins(
                                    color: hintColor, fontSize: 14),
                                prefixIcon: Icon(Icons.lock_person_outlined,
                                    color: MyColors.primary.withOpacity(0.7),
                                    size: 20),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: hintColor,
                                    size: 20,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: MyColors.primary, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (v != authCtrl.passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Terms Checkbox
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1A1D27)
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF2D3147)
                                        : Colors.blue.shade100),
                              ),
                              child: Obx(
                                () => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: authCtrl.terms.value,
                                        onChanged: (value) {
                                          authCtrl.terms.value =
                                              !authCtrl.terms.value;
                                        },
                                        activeColor: MyColors.primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "i_agree".tr,
                                        style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.primary,
                                  elevation: 4,
                                  shadowColor:
                                      MyColors.primary.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  final needsImage =
                                      authCtrl.type.value == 'seeker' ||
                                          authCtrl.type.value == 'volunteer';

                                  if (needsImage &&
                                      authCtrl.profileImage.isEmpty) {
                                    Get.snackbar(
                                      "Photo Required",
                                      "Please upload your profile photo",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                    );
                                    return;
                                  }
                                  if (!authCtrl.terms.value) {
                                    Get.snackbar(
                                      "Terms Required",
                                      "Please agree to the terms and conditions",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    authCtrl.isLoading.value = true;
                                    authCtrl.signUp().then((value) async {
                                      if (value == true) {
                                        _createWallet(context);
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text("create_account".tr,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _sectionHeader(String title, IconData icon, Color textColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: MyColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: MyColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildStepIndicator(int current) {
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
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check, color: MyColors.primary, size: 12)
                      : Text("$step",
                          style: TextStyle(
                              color:
                                  isActive ? MyColors.primary : Colors.white70,
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
                      color:
                          isDone ? Colors.white : Colors.white.withOpacity(0.3),
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
}
