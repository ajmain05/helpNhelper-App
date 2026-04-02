import 'package:helpnhelper/models/transaction_method_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class TransactionMethodList extends StatefulWidget {
  TransactionMethodList({Key? key}) : super(key: key);

  @override
  _TransactionMethodListState createState() => _TransactionMethodListState();
}

class _TransactionMethodListState extends State<TransactionMethodList> {
  var controller = Get.find<VolunteerController>();
  TextEditingController methodTypeController = TextEditingController();
  TextEditingController mfsTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController routeController = TextEditingController();
  TextEditingController holderController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List method = ['BANK', 'MFS'];
  List mfs = ['Bkash', 'Nogod'];

  @override
  void initState() {
    super.initState();
    Get.find<VolunteerController>().getBankList();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    required Color textColor,
    required Color hintColor,
    required Color borderColor,
    required Color fieldBg,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      cursorColor: MyColors.primary,
      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBg,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 14),
        prefixIcon:
            Icon(icon, color: MyColors.primary.withOpacity(0.7), size: 20),
        suffixIcon: readOnly
            ? Icon(Icons.expand_more_rounded, color: MyColors.primary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
    );
  }

  Widget _buildLabel(String label, Color textColor) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 16),
        child: Text(label,
            style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final subColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;
    final scaffoldBg =
        isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final fieldBg = isDark ? const Color(0xFF252840) : const Color(0xFFF7F9FC);
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade500;
    final sheetBg = isDark ? const Color(0xFF1A1D27) : Colors.white;

    _createWallet(BuildContext ctx) {
      showDialog(
          context: ctx,
          builder: (BuildContext builderContext) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(builderContext).pop();
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

    void _showMethodPicker(BuildContext ctx, StateSetter setS) {
      showModalBottomSheet(
        context: ctx,
        backgroundColor: sheetBg,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (bCtx) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Method',
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ...method.map((m) => GestureDetector(
                    onTap: () {
                      setS(() {
                        methodTypeController.text = m;
                        mfsTypeController.clear();
                        phoneController.clear();
                        bankNameController.clear();
                        branchNameController.clear();
                        routeController.clear();
                        holderController.clear();
                        accountNumberController.clear();
                      });
                      Navigator.pop(bCtx);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: methodTypeController.text == m
                            ? MyColors.primary.withOpacity(0.1)
                            : fieldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: methodTypeController.text == m
                              ? MyColors.primary
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                              m == 'MFS'
                                  ? Icons.account_balance_wallet_rounded
                                  : Icons.account_balance_rounded,
                              color: methodTypeController.text == m
                                  ? MyColors.primary
                                  : subColor,
                              size: 20),
                          const SizedBox(width: 12),
                          Text(
                              m == 'MFS'
                                  ? 'Mobile Financial Service (MFS)'
                                  : 'Bank Transfer',
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );
    }

    void _showMfsPicker(BuildContext ctx, StateSetter setS) {
      showModalBottomSheet(
        context: ctx,
        backgroundColor: sheetBg,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (bCtx) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select MFS Provider',
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ...mfs.map((m) => GestureDetector(
                    onTap: () {
                      setS(() => mfsTypeController.text = m);
                      Navigator.pop(bCtx);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: mfsTypeController.text == m
                            ? MyColors.primary.withOpacity(0.1)
                            : fieldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: mfsTypeController.text == m
                              ? MyColors.primary
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mobile_friendly_rounded,
                              color: MyColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text(m,
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );
    }

    void _showMethodDialog(BuildContext context, {TransactionMethodModel? editItem}) {
      if (editItem != null) {
        if (editItem.type == 'mfs') {
          methodTypeController.text = 'MFS';
          if (editItem.bkash != null && editItem.bkash.toString() != 'null' && editItem.bkash.toString().isNotEmpty) {
            mfsTypeController.text = 'Bkash';
            phoneController.text = editItem.bkash.toString();
          } else {
            mfsTypeController.text = 'Nagad';
            phoneController.text = editItem.nagad.toString();
          }
        } else {
          methodTypeController.text = 'BANK';
          bankNameController.text = editItem.bankName ?? '';
          branchNameController.text = editItem.branchName ?? '';
          routeController.text = editItem.routingNumber ?? '';
          holderController.text = editItem.holderName ?? '';
          accountNumberController.text = editItem.accountNumber ?? '';
        }
      } else {
        methodTypeController.clear();
        mfsTypeController.clear();
        phoneController.clear();
        bankNameController.clear();
        branchNameController.clear();
        routeController.clear();
        holderController.clear();
        accountNumberController.clear();
      }

      showDialog(

            context: context,
            builder: (ctx) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: StatefulBuilder(
                  builder: (ctx, setS) {
                    return Container(
                      decoration: BoxDecoration(
                        color: sheetBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Obx(
                          () => Visibility(
                            visible:
                                !Get.find<VolunteerController>().isLoading.value,
                            replacement: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                    color: MyColors.primary),
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Dialog title
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              MyColors.primary.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.add_card_rounded,
                                            color: MyColors.primary,
                                            size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(editItem != null ? 'Edit Payment Method' : 'Add Payment Method',
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  Divider(height: 28, color: borderColor),

                                  // Method type
                                  _buildLabel('Payment Method', textColor),
                                  _buildField(
                                    ctrl: methodTypeController,
                                    hint: 'Select method',
                                    icon: Icons.payment_rounded,
                                    readOnly: true,
                                    textColor: textColor,
                                    hintColor: hintColor,
                                    borderColor: borderColor,
                                    fieldBg: fieldBg,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Please select a method'
                                        : null,
                                    onTap: () => _showMethodPicker(ctx, setS),
                                  ),

                                  // MFS fields
                                  if (methodTypeController.text == 'MFS') ...[
                                    _buildLabel('MFS Provider', textColor),
                                    _buildField(
                                      ctrl: mfsTypeController,
                                      hint: 'Select MFS provider',
                                      icon:
                                          Icons.account_balance_wallet_rounded,
                                      readOnly: true,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please select MFS'
                                          : null,
                                      onTap: () => _showMfsPicker(ctx, setS),
                                    ),
                                    _buildLabel('Account Number', textColor),
                                    _buildField(
                                      ctrl: phoneController,
                                      hint: 'e.g. 01XXXXXXXXX',
                                      icon: Icons.phone_android_rounded,
                                      keyboardType: TextInputType.phone,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter number'
                                          : null,
                                    ),
                                  ],

                                  // BANK fields
                                  if (methodTypeController.text == 'BANK') ...[
                                    _buildLabel('Bank Name', textColor),
                                    _buildField(
                                      ctrl: bankNameController,
                                      hint: 'e.g. Dutch-Bangla Bank',
                                      icon: Icons.account_balance_rounded,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter bank name'
                                          : null,
                                    ),
                                    _buildLabel('Branch Name', textColor),
                                    _buildField(
                                      ctrl: branchNameController,
                                      hint: 'e.g. Gulshan Branch',
                                      icon: Icons.business_rounded,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter branch name'
                                          : null,
                                    ),
                                    _buildLabel('Routing Number', textColor),
                                    _buildField(
                                      ctrl: routeController,
                                      hint: 'e.g. 090274234',
                                      icon: Icons.confirmation_number_outlined,
                                      keyboardType: TextInputType.number,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter routing number'
                                          : null,
                                    ),
                                    _buildLabel('Account Holder', textColor),
                                    _buildField(
                                      ctrl: holderController,
                                      hint: 'Full name',
                                      icon: Icons.person_outline_rounded,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter holder name'
                                          : null,
                                    ),
                                    _buildLabel('Account Number', textColor),
                                    _buildField(
                                      ctrl: accountNumberController,
                                      hint: 'e.g. 123456789012',
                                      icon: Icons.credit_card_rounded,
                                      keyboardType: TextInputType.number,
                                      textColor: textColor,
                                      hintColor: hintColor,
                                      borderColor: borderColor,
                                      fieldBg: fieldBg,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Please enter account number'
                                          : null,
                                    ),
                                  ],

                                  const SizedBox(height: 24),

                                  // Submit & Cancel buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            side:
                                                BorderSide(color: borderColor),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          child: Text('Cancel',
                                              style: GoogleFonts.poppins(
                                                  color: subColor,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: MyColors.primary,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              var map = <String, dynamic>{};
                                              if (methodTypeController.text ==
                                                  'MFS') {
                                                map['type'] = 'mfs';
                                                var lowerMfsType = mfsTypeController.text.toLowerCase();
                                                if (lowerMfsType == 'bkash') {
                                                  map['bkash'] = phoneController.text;
                                                } else {
                                                  map['nagad'] = phoneController.text;
                                                }
                                              } else {
                                                map['type'] = 'bank';
                                                map['bank_name'] =
                                                    bankNameController.text;
                                                map['branch_name'] =
                                                    branchNameController.text;
                                                map['routing_number'] =
                                                    routeController.text;
                                                map['holder_name'] =
                                                    holderController.text;
                                                map['account_number'] =
                                                    accountNumberController
                                                        .text;
                                              }
                                              if (editItem != null && editItem.id != null) {
                                                Get.find<VolunteerController>().updateTransactionMethod(map, editItem.id!).then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(ctx);
                                                    _createWallet(context);
                                                  }
                                                });
                                              } else {
                                                Get.find<VolunteerController>()
                                                    .addTransactionMethod(map)
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(ctx);
                                                    _createWallet(context);
                                                  }
                                                });
                                              }
                                            }
                                          },
                                          child: Text(editItem != null ? 'Update Method' : 'Add Method',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
    }

    void _deleteConfirm(BuildContext context, TransactionMethodModel item) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: sheetBg,
          title: Text('Delete Method', style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w600)),
          content: Text('Are you sure you want to delete this transaction method?', style: GoogleFonts.poppins(color: subColor)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: subColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                if (item.id != null) {
                  Get.find<VolunteerController>().deleteTransactionMethod(item.id!);
                }
              },
              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Hero Header ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1A1D27), const Color(0xFF2D3147)]
                      : [const Color(0xFF00BFA5), const Color(0xFF004D40)],
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
                  left: 24,
                  right: 24,
                  bottom: 28,
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 24),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transaction Methods',
                                style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            Text('Manage your payout accounts',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Method Cards ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            sliver: Obx(() {
              if (controller.transactionMethodList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 72, color: subColor.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text('No methods added yet',
                            style: GoogleFonts.poppins(
                                color: subColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Text('Tap + to add a payment method',
                            style: GoogleFonts.poppins(
                                color: subColor.withOpacity(0.7),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                    final item = controller.transactionMethodList[index];
                    final isMfs = item.type == 'mfs';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (isMfs
                                          ? const Color(0xFF7C4DFF)
                                          : MyColors.primary)
                                      .withOpacity(0.1),
                                  (isMfs
                                          ? const Color(0xFF7C4DFF)
                                          : MyColors.primary)
                                      .withOpacity(0.03),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (isMfs
                                            ? const Color(0xFF7C4DFF)
                                            : MyColors.primary)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                      isMfs
                                          ? Icons.account_balance_wallet_rounded
                                          : Icons.account_balance_rounded,
                                      color: isMfs
                                          ? const Color(0xFF7C4DFF)
                                          : MyColors.primary,
                                      size: 22),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        isMfs
                                            ? 'Mobile Financial Service'
                                            : 'Bank Account',
                                        style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                        isMfs
                                            ? (item.bkash?.toString() != 'null'
                                                ? 'Bkash • ${item.bkash}'
                                                : 'Nagad • ${item.nagad ?? 'N/A'}')
                                            : (item.bankName?.toString() ??
                                                'Bank'),
                                        style: GoogleFonts.poppins(
                                            color: subColor, fontSize: 12)),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: MyColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(isMfs ? 'MFS' : 'BANK',
                                          style: GoogleFonts.poppins(
                                              color: isMfs
                                                  ? const Color(0xFF7C4DFF)
                                                  : MyColors.primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 4),
                                    PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.more_vert, color: subColor, size: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                           _showMethodDialog(context, editItem: item);
                                        } else if (val == 'delete') {
                                           _deleteConfirm(context, item);
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit, size: 18), const SizedBox(width: 8), const Text('Edit')])),
                                        PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete, color: Colors.red, size: 18), const SizedBox(width: 8), const Text('Delete', style: TextStyle(color: Colors.red))])),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Details
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                            child: Column(
                              children: isMfs
                                  ? [
                                      if (item.bkash != null && item.bkash.toString() != 'null' && item.bkash.toString().isNotEmpty) ...[
                                        _detailRow(
                                            Icons.phone_android_rounded,
                                            'Bkash',
                                            item.bkash.toString(),
                                            textColor,
                                            subColor,
                                            fieldBg),
                                      ],
                                      if (item.bkash != null && item.nagad != null && item.bkash.toString() != 'null' && item.nagad.toString() != 'null' && item.bkash.toString().isNotEmpty && item.nagad.toString().isNotEmpty)
                                        const SizedBox(height: 8),
                                      if (item.nagad != null && item.nagad.toString() != 'null' && item.nagad.toString().isNotEmpty) ...[
                                        _detailRow(
                                            Icons.account_balance_wallet_outlined,
                                            'Nagad',
                                            item.nagad.toString(),
                                            textColor,
                                            subColor,
                                            fieldBg),
                                      ],
                                    ]
                                  : [
                                      _detailRow(
                                          Icons.account_balance_outlined,
                                          'Bank Name',
                                          item.bankName?.toString() ?? 'N/A',
                                          textColor,
                                          subColor,
                                          fieldBg),
                                      const SizedBox(height: 8),
                                      _detailRow(
                                          Icons.business_rounded,
                                          'Branch',
                                          item.branchName?.toString() ?? 'N/A',
                                          textColor,
                                          subColor,
                                          fieldBg),
                                      const SizedBox(height: 8),
                                      _detailRow(
                                          Icons.person_outline_rounded,
                                          'Holder',
                                          item.holderName?.toString() ?? 'N/A',
                                          textColor,
                                          subColor,
                                          fieldBg),
                                      const SizedBox(height: 8),
                                      _detailRow(
                                          Icons.credit_card_rounded,
                                          'Account No.',
                                          item.accountNumber?.toString() ??
                                              'N/A',
                                          textColor,
                                          subColor,
                                          fieldBg),
                                      const SizedBox(height: 8),
                                      _detailRow(
                                          Icons.confirmation_number_outlined,
                                          'Routing No.',
                                          item.routingNumber?.toString() ??
                                              'N/A',
                                          textColor,
                                          subColor,
                                          fieldBg),
                                    ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: controller.transactionMethodList.length,
                ),
              );
            }),
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.primary,
        onPressed: () {
          _showMethodDialog(context);
        },
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Method',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, Color textColor,
      Color subColor, Color fieldBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: MyColors.primary.withOpacity(0.7), size: 16),
          const SizedBox(width: 10),
          Text(label,
              style: GoogleFonts.poppins(color: subColor, fontSize: 12)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
