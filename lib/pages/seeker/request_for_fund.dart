import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class RequestForFund extends StatefulWidget {
  RequestForFund({Key? key}) : super(key: key);

  @override
  _RequestForFundState createState() => _RequestForFundState();
}

class _RequestForFundState extends State<RequestForFund> {
  final _formKey = GlobalKey<FormState>();
  var controller = Get.find<SeekerController>();

  _createWallet(context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(builderContext).pop();
            Get.back();
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade500;
    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFB);
    final fieldBg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2D3147) : Colors.grey.shade200;

    return Obx(() => Visibility(
          visible: !(Get.find<SeekerController>().isLoading.value),
          replacement: Container(
            color: bgColor,
            child: Center(
              child: CircularProgressIndicator(
                color: MyColors.primary,
                strokeWidth: 3,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: bgColor,
            body: CustomScrollView(
              slivers: [
                // Hero Header
                SliverToBoxAdapter(
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF2D3147), const Color(0xFF1A1D27)]
                            : [
                                const Color(0xFF00BFA5),
                                const Color(0xFF004D40)
                              ],
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
                          Text("Apply for Fund",
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800)),
                          Text(
                              "Fill in the details below to submit your request",
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 13)),
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
                            _buildSectionLabel("Fund Information", textColor),
                            const SizedBox(height: 12),
                            _buildField(
                                "Title",
                                controller.titleController,
                                Icons.title,
                                textColor,
                                hintColor,
                                fieldBg,
                                borderColor),
                            const SizedBox(height: 16),
                            _buildField(
                                "Description",
                                controller.descController,
                                Icons.description_outlined,
                                textColor,
                                hintColor,
                                fieldBg,
                                borderColor,
                                maxLines: 4),
                            const SizedBox(height: 16),
                            _buildField(
                                "Requested Amount",
                                controller.requestedAmountController,
                                Icons.attach_money,
                                textColor,
                                hintColor,
                                fieldBg,
                                borderColor,
                                keyboardType: TextInputType.number),
                            const SizedBox(height: 16),
                            _buildDateField(
                                textColor, hintColor, fieldBg, borderColor),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: Get.find<SeekerController>()
                                          .terms
                                          .value,
                                      onChanged: (value) {
                                        setState(() {
                                          Get.find<SeekerController>()
                                                  .terms
                                                  .value =
                                              !Get.find<SeekerController>()
                                                  .terms
                                                  .value;
                                        });
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
                                      "I agree to the terms and conditions for this fund application.",
                                      style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.primary,
                                  elevation: 4,
                                  shadowColor: isDark
                                      ? Colors.black.withOpacity(0.5)
                                      : MyColors.primary.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  if (!Get.find<SeekerController>()
                                      .terms
                                      .value) {
                                    Get.snackbar(
                                        "Error", "Please agree to the terms",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white);
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    controller
                                        .applyForFund()
                                        .then((value) async {
                                      if (value == true) {
                                        _createWallet(context);
                                      }
                                    });
                                  }
                                },
                                child: Text("Apply",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1)),
                              ),
                            ),
                            const SizedBox(height: 40),
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

  Widget _buildSectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: color, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildField(String hint, TextEditingController ctrl, IconData icon,
      Color textColor, Color hintColor, Color fieldBg, Color borderColor,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: MyColors.primary,
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        prefixIcon:
            Icon(icon, color: MyColors.primary.withOpacity(0.7), size: 20),
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
      validator: (v) => (v == null || v.isEmpty) ? "Please enter $hint" : null,
    );
  }

  Widget _buildDateField(
      Color textColor, Color hintColor, Color fieldBg, Color borderColor) {
    return TextFormField(
      readOnly: true,
      controller: controller.deadlineController,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        ).then((selectedDate) {
          if (selectedDate != null) {
            controller.deadlineController.text =
                selectedDate.toString().substring(0, 10);
          }
        });
      },
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: "Completion Date",
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        prefixIcon: Icon(Icons.calendar_today,
            color: MyColors.primary.withOpacity(0.7), size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Please select date" : null,
    );
  }
}
