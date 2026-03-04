import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/volunteer_controller.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key? key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var controller = Get.find<VolunteerController>();
  List method = ['Accept', 'Decline'];

  @override
  void initState() {
    super.initState();
    Get.find<VolunteerController>().getTransactions();
  }

  Color _statusColor(String? status) {
    switch ((status ?? 'pending').toLowerCase()) {
      case 'accepted':
        return const Color(0xFF00C896);
      case 'declined':
        return const Color(0xFFFF5C7C);
      default:
        return const Color(0xFFFFA62B);
    }
  }

  IconData _statusIcon(String? status) {
    switch ((status ?? 'pending').toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'declined':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

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

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Hero Header ──────────────────────────────────────────
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
                    // Back button
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
                          child: const Icon(Icons.receipt_long_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transactions',
                                style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800)),
                            Text('Review and update payment status',
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

          // ── Transaction Cards ────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            sliver: Obx(() {
              if (controller.transactionList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Icon(Icons.receipt_outlined,
                            size: 72, color: subColor.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text('No transactions found',
                            style: GoogleFonts.poppins(
                                color: subColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final data = controller.transactionList[index];
                    final status = data.receiveStatus?.toString() ?? 'pending';
                    final statusColor = _statusColor(status);
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
                          // ── Card Header ───────────────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.primary.withOpacity(0.1),
                                  MyColors.primary.withOpacity(0.03),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            MyColors.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                          Icons.receipt_long_rounded,
                                          color: MyColors.primary,
                                          size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Invoice',
                                            style: GoogleFonts.poppins(
                                                color: subColor, fontSize: 11)),
                                        Text(
                                            '#${data.invoice?.sid?.toString() ?? 'N/A'}',
                                            style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: statusColor.withOpacity(0.3),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(_statusIcon(status),
                                          color: statusColor, size: 14),
                                      const SizedBox(width: 5),
                                      Text(status.toUpperCase(),
                                          style: GoogleFonts.poppins(
                                              color: statusColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Amount + Date ─────────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _infoTile(
                                    icon: Icons.attach_money_rounded,
                                    label: 'Amount',
                                    value: '৳${data.amount ?? '0'}',
                                    textColor: textColor,
                                    subColor: subColor,
                                    highlight: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _infoTile(
                                    icon: Icons.calendar_today_rounded,
                                    label: 'Date',
                                    value: data.date ?? 'N/A',
                                    textColor: textColor,
                                    subColor: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Type + SubType ───────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _infoTile(
                                    icon: Icons.label_outline_rounded,
                                    label: 'Type',
                                    value: data.type?.toUpperCase() ?? 'N/A',
                                    textColor: textColor,
                                    subColor: subColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _infoTile(
                                    icon: Icons.account_tree_outlined,
                                    label: 'Sub Type',
                                    value: data.subType?.toUpperCase() ?? 'N/A',
                                    textColor: textColor,
                                    subColor: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Bank Info ────────────────────────────
                          if (data.bankInfo?.name != null &&
                              data.bankInfo!.name.toString() != 'null') ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                              child: Divider(
                                  color: isDark
                                      ? Colors.white12
                                      : Colors.grey.shade100),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_rounded,
                                      color: MyColors.primary, size: 16),
                                  const SizedBox(width: 6),
                                  Text('Bank Details',
                                      style: GoogleFonts.poppins(
                                          color: MyColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _infoTile(
                                      icon: Icons.account_balance_outlined,
                                      label: 'Bank',
                                      value: data.bankInfo?.name ?? 'N/A',
                                      textColor: textColor,
                                      subColor: subColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _infoTile(
                                      icon: Icons.credit_card_rounded,
                                      label: 'Account',
                                      value:
                                          data.bankAccountInfo?.accountNumber ??
                                              'N/A',
                                      textColor: textColor,
                                      subColor: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // ── Update Status Button ─────────────────
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: GestureDetector(
                              onTap: () => _showStatusSheet(context, data),
                              child: Container(
                                width: double.infinity,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00BFA5),
                                      Color(0xFF00897B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.update_rounded,
                                          color: Colors.white, size: 16),
                                      const SizedBox(width: 8),
                                      Text('Update Status',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: controller.transactionList.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subColor,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252840) : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: highlight ? MyColors.primary : subColor.withOpacity(0.7),
              size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(color: subColor, fontSize: 10)),
                Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: highlight ? MyColors.primary : textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusSheet(BuildContext context, dynamic data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);

    _createWalletDialog() {
      showDialog(
          context: context,
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Update Transaction Status',
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Choose an action for this transaction',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(ctx);
                      var map = <String, dynamic>{};
                      map['_method'] = "PATCH";
                      map['receive_status'] = "accepted";
                      await Get.find<VolunteerController>()
                          .updateStatus(map, data.id.toString());
                      _createWalletDialog();
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BFA5).withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Accept',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(ctx);
                      var map = <String, dynamic>{};
                      map['_method'] = "PATCH";
                      map['receive_status'] = "declined";
                      await Get.find<VolunteerController>()
                          .updateStatus(map, data.id.toString());
                      _createWalletDialog();
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5C7C), Color(0xFFD63850)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5C7C).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cancel_outlined,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Decline',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
