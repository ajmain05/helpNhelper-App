import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/pages/login/sign_up_page_3.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage2 extends StatefulWidget {
  SignUpPage2({Key? key}) : super(key: key);

  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  final _formKey = GlobalKey<FormState>();
  late AuthController controller;
  TextEditingController countryController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController upazilaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
  }

  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      controller.nidImage.add(_pickedFile!);
    }
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
    final sheetBg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final sheetHeaderColor =
        isDark ? const Color(0xFF0F1117) : const Color(0xFFF0F4F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
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
                    Text("verification".tr,
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    Text("upload_nid".tr,
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 14),
                    _buildStepIndicator(2, textColor: Colors.white),
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
                      // NID Upload Section
                      _sectionHeader(
                          "nid_doc".tr, Icons.badge_outlined, textColor),
                      const SizedBox(height: 12),
                      Obx(
                        () => controller.nidImage.length < 1
                            ? GestureDetector(
                                onTap: () {
                                  if (controller.nidImage.length < 1) {
                                    _pickImage();
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: fieldBg,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color:
                                            MyColors.primary.withOpacity(0.4),
                                        width: 1.5,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color:
                                              MyColors.primary.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.upload_file,
                                            color: MyColors.primary, size: 24),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("tap_upload_nid".tr,
                                          style: GoogleFonts.poppins(
                                              color: MyColors.primary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
                                      Text("supported_format".tr,
                                          style: GoogleFonts.poppins(
                                              color: hintColor, fontSize: 11)),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.nidImage.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          height: 100,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(controller
                                                    .nidImage[index].path),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          right: 16,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                controller.nidImage
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),

                      // Location Section
                      _sectionHeader(
                          "location".tr, Icons.location_on_outlined, textColor),
                      const SizedBox(height: 12),

                      _buildSelectField(
                        "select_country".tr,
                        countryController,
                        textColor,
                        hintColor,
                        fieldBg,
                        borderColor,
                        onTap: () => _showBottomSheet(
                          context,
                          "select_country".tr,
                          sheetBg,
                          sheetHeaderColor,
                          textColor,
                          controller.countryList.length,
                          (index) => InkWell(
                            onTap: () {
                              countryController.text =
                                  controller.countryList[index].name.toString();
                              divisionController.text = '';
                              controller.countryId.value =
                                  controller.countryList[index].id.toString();
                              controller.divisionId.value = '';
                              controller.districtId.value = '';
                              controller.upazilaId.value = '';
                              controller
                                  .getDivision(controller.countryId.value);
                              Navigator.of(context).pop();
                            },
                            child: _sheetItem(
                                controller.countryList[index].name.toString(),
                                isDark),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "Please select country"
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildSelectField(
                        "select_division".tr,
                        divisionController,
                        textColor,
                        hintColor,
                        fieldBg,
                        borderColor,
                        onTap: () => _showBottomSheet(
                          context,
                          "select_division".tr,
                          sheetBg,
                          sheetHeaderColor,
                          textColor,
                          controller.divisionList.length,
                          (index) => InkWell(
                            onTap: () {
                              divisionController.text = controller
                                  .divisionList[index].name
                                  .toString();
                              controller.divisionId.value =
                                  controller.divisionList[index].id.toString();
                              controller.districtId.value = '';
                              controller.upazilaId.value = '';
                              controller
                                  .getDistrict(controller.divisionId.value);
                              Navigator.of(context).pop();
                            },
                            child: _sheetItem(
                                controller.divisionList[index].name.toString(),
                                isDark),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "Please select division"
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildSelectField(
                        "select_district".tr,
                        districtController,
                        textColor,
                        hintColor,
                        fieldBg,
                        borderColor,
                        onTap: () => _showBottomSheet(
                          context,
                          "select_district".tr,
                          sheetBg,
                          sheetHeaderColor,
                          textColor,
                          controller.districtList.length,
                          (index) => InkWell(
                            onTap: () {
                              districtController.text = controller
                                  .districtList[index].name
                                  .toString();
                              controller.districtId.value =
                                  controller.districtList[index].id.toString();
                              controller.upazilaId.value = '';
                              controller
                                  .getUpazila(controller.districtId.value);
                              Navigator.of(context).pop();
                            },
                            child: _sheetItem(
                                controller.districtList[index].name.toString(),
                                isDark),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "Please select district"
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildSelectField(
                        "select_upazila".tr,
                        upazilaController,
                        textColor,
                        hintColor,
                        fieldBg,
                        borderColor,
                        onTap: () => _showBottomSheet(
                          context,
                          "select_upazila".tr,
                          sheetBg,
                          sheetHeaderColor,
                          textColor,
                          controller.upazilaList.length,
                          (index) => InkWell(
                            onTap: () {
                              upazilaController.text =
                                  controller.upazilaList[index].name.toString();
                              controller.upazilaId.value =
                                  controller.upazilaList[index].id.toString();
                              Navigator.of(context).pop();
                            },
                            child: _sheetItem(
                                controller.upazilaList[index].name.toString(),
                                isDark),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "Please select upazila"
                            : null,
                      ),

                      const SizedBox(height: 24),

                      // Address Section
                      _sectionHeader(
                          "address_details".tr, Icons.home_outlined, textColor),
                      const SizedBox(height: 12),

                      Obx(() => Column(
                              children: [
                                _buildFormField(
                                    "present_address".tr,
                                    controller.presentAddressController,
                                    textColor,
                                    hintColor,
                                    fieldBg,
                                    borderColor),
                                const SizedBox(height: 14),
                                _buildFormField(
                                    "permanent_address".tr,
                                    controller.permanentAddressController,
                                    textColor,
                                    hintColor,
                                    fieldBg,
                                    borderColor),
                              ],
                            )),

                      const SizedBox(height: 28),

                      // Next Button
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
                            if (controller.nidImage.isEmpty) {
                              Get.snackbar(
                                "NID Required",
                                "Please upload your NID/Passport document",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            } else if (_formKey.currentState!.validate()) {
                              Get.to(SignUpPage3());
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
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(
    BuildContext ctx,
    String title,
    Color sheetBg,
    Color headerBg,
    Color textColor,
    int count,
    Widget Function(int) itemBuilder,
  ) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollCtrl) => Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on,
                          color: MyColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(title,
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: count,
                  itemBuilder: (c, i) => itemBuilder(i),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetItem(String label, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252836) : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3147) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.place_outlined, color: MyColors.primary, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: GoogleFonts.poppins(
                  color: isDark
                      ? const Color(0xFFE8EAF0)
                      : const Color(0xFF1A1C1E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
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

  Widget _buildSelectField(
    String hint,
    TextEditingController ctrl,
    Color textColor,
    Color hintColor,
    Color fieldBg,
    Color borderColor, {
    required VoidCallback onTap,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      readOnly: true,
      controller: ctrl,
      cursorColor: MyColors.primary,
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        suffixIcon: Icon(Icons.expand_more, color: MyColors.primary),
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
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      onTap: onTap,
    );
  }

  Widget _buildFormField(
    String title,
    TextEditingController ctrl,
    Color textColor,
    Color hintColor,
    Color fieldBg,
    Color borderColor,
  ) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      minLines: 1,
      cursorColor: MyColors.primary,
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: title,
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: MyColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (v) => v == null || v.isEmpty ? "Please enter $title" : null,
    );
  }

  Widget _buildStepIndicator(int current, {Color textColor = Colors.white}) {
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
