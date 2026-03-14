import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/organization_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class OrgApplicationForm extends StatefulWidget {
  const OrgApplicationForm({Key? key}) : super(key: key);

  @override
  State<OrgApplicationForm> createState() => _OrgApplicationFormState();
}

class _OrgApplicationFormState extends State<OrgApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  late OrganizationController controller;

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final targetAmountCtrl = TextEditingController();
  final seekerNameCtrl = TextEditingController();
  final seekerLocationCtrl = TextEditingController();
  final paymentAccountCtrl = TextEditingController();

  String selectedCategory = 'Education';
  String selectedPaymentMethod = 'Bank Account';
  File? documentFile;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<OrganizationController>()) {
      Get.put(OrganizationController());
    }
    controller = Get.find<OrganizationController>();
  }

  final categories = [
    'Education',
    'Health & Medical',
    'Food & Hunger',
    'Shelter',
    'Disaster Relief',
    'Livelihood',
    'Other'
  ];

  final paymentMethods = ['Bank Account', 'bKash', 'Nagad', 'Rocket'];

  Future<void> _pickDocument() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        documentFile = File(image.path);
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      if (documentFile == null) {
        Get.snackbar(
          "Verification Required",
          "Please upload a document to proceed.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      final result = await controller.submitApplication(
        title: titleCtrl.text,
        description: descriptionCtrl.text,
        category: selectedCategory,
        targetAmount: targetAmountCtrl.text,
        seekerName: seekerNameCtrl.text,
        seekerLocation: seekerLocationCtrl.text,
        paymentMethod: selectedPaymentMethod,
        paymentAccount: paymentAccountCtrl.text,
        certImage: documentFile!,
      );

      if (result) {
        // Show success dialog then go to Dashboard
        await Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1FAE5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF059669), size: 56),
                  ),
                  const SizedBox(height: 20),
                  Text('Application Submitted!',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Your application has been sent for review. You can track its status from your Dashboard.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the dialog and returning to the form
                        Get.back();
                        // Close the form and return to the existing OrgDashboard
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Go to Dashboard',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
          "Submission Failed",
          "Something went wrong while submitting your application.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final bgSecondary = isDark ? const Color(0xFF1E2235) : Colors.white;

    const primaryAccent = Color(0xFF8B5CF6); // Purple for Org module

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: textColor, size: 18),
            ),
          ),
        ),
        title: Text(
          "Submit Fund Request",
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFF59E0B).withOpacity(0.15), const Color(0xFFFDE68A).withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Service Charge Notice", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309))),
                          const SizedBox(height: 4),
                          Obx(() => Text("A ${controller.orgServiceCharge.value.toStringAsFixed(0)}% admin service charge will be automatically deducted from your total collected amount before final payout to your account.", style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87, height: 1.4))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Campaign Details Section
              Text("Campaign Details", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),
              
              _buildInputField("Campaign Title", "Enter a clear, descriptive title", titleCtrl, isDark, bgSecondary, textColor),
              const SizedBox(height: 16),
              
              _buildInputField("Detailed Description", "Explain the cause and why you need funds", descriptionCtrl, isDark, bgSecondary, textColor, maxLines: 4),
              const SizedBox(height: 16),

              // Category & Target
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.7))),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: bgSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              dropdownColor: bgSecondary,
                              style: GoogleFonts.inter(color: textColor, fontSize: 14),
                              onChanged: (val) {
                                if (val != null) setState(() => selectedCategory = val);
                              },
                              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildInputField("Target (Tk)", "e.g. 50000", targetAmountCtrl, isDark, bgSecondary, textColor, isNumber: true),
                  )
                ],
              ),
              const SizedBox(height: 28),

              // Seeker Info
              Text("Beneficiary (Seeker) Info", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),
              _buildInputField("Beneficiary Name", "Who are these funds for?", seekerNameCtrl, isDark, bgSecondary, textColor),
              const SizedBox(height: 16),
              _buildInputField("Beneficiary Location", "City/District", seekerLocationCtrl, isDark, bgSecondary, textColor),
              const SizedBox(height: 28),

              // Payment Info
              Text("Payout Destination", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 8),
              Text("Where should we disburse the funds once the campaign is complete?", style: GoogleFonts.inter(fontSize: 12, color: textColor.withOpacity(0.6))),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPaymentMethod,
                    isExpanded: true,
                    dropdownColor: bgSecondary,
                    style: GoogleFonts.inter(color: textColor, fontSize: 14),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedPaymentMethod = val);
                    },
                    items: paymentMethods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField("Account Details", "Account Name, Number, Branch etc.", paymentAccountCtrl, isDark, bgSecondary, textColor, maxLines: 2),
              const SizedBox(height: 28),

              // Verification Document
              Text("Verification Document", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 8),
              Text("Upload medical records, prescription, or ID proving the requirement.", style: GoogleFonts.inter(fontSize: 12, color: textColor.withOpacity(0.6))),
              const SizedBox(height: 12),
              
              GestureDetector(
                onTap: _pickDocument,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: bgSecondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryAccent.withOpacity(0.5), width: 1.5, style: BorderStyle.solid),
                  ),
                  child: documentFile == null
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryAccent.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.upload_file_rounded, color: primaryAccent, size: 28),
                            ),
                            const SizedBox(height: 12),
                            Text("Tap to upload document image", style: GoogleFonts.inter(color: primaryAccent, fontWeight: FontWeight.w600)),
                          ],
                        )
                      : Column(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 36),
                            const SizedBox(height: 8),
                            Text("Document Selected", style: GoogleFonts.inter(color: Colors.green, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Tap to change/re-upload", style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12, decoration: TextDecoration.underline)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 40),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: controller.isSubmitting.value 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        "Submit Application",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, bool isDark, Color bgSecondary, Color textColor, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.7))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.inter(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: textColor.withOpacity(0.3), fontSize: 14),
            filled: true,
            fillColor: bgSecondary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
            ),
          ),
          validator: (value) => value!.isEmpty ? "Required" : null,
        ),
      ],
    );
  }
}
