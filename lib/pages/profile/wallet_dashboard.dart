import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/models/wallet_model.dart';
import 'package:helpnhelper/pages/profile/wallet_deposit_screen.dart';
import 'package:helpnhelper/service/wallet_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class WalletDashboard extends StatefulWidget {
  const WalletDashboard({Key? key}) : super(key: key);

  @override
  State<WalletDashboard> createState() => _WalletDashboardState();
}

class _WalletDashboardState extends State<WalletDashboard>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final WalletService _svc = WalletService();

  late TabController _tabCtrl;
  bool _isLoading = true;
  CorporateWalletData? _walletData;
  List<CorporateDepositRecord> _deposits = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    _fetchAll();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _svc.fetchWalletHistory(),
      _svc.fetchDepositHistory(),
    ]);
    if (mounted) {
      setState(() {
        _walletData = results[0] as CorporateWalletData?;
        _deposits = results[1] as List<CorporateDepositRecord>;
        _isLoading = false;
      });
    }
  }

  // ── SSLCommerz deposit (≤ ৳1,00,000)
  Future<void> _handleSSLDeposit() async {
    final ctrl = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SSLDepositSheet(ctrl: ctrl, svc: _svc),
    );
    if (ok == true) _fetchAll();
  }

  // ── Cheque deposit (any amount)
  Future<void> _handleChequeDeposit() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChequeDepositSheet(svc: _svc),
    );
    if (ok == true) {
      _fetchAll();
      Get.snackbar(
        '✅ Submitted!',
        'Your cheque request is under review. Wallet will be credited after admin approval.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  String _fmt(double v) {
    if (v >= 1000) {
      return v.truncate().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') +
          (v - v.truncateToDouble() > 0
              ? v
                  .toStringAsFixed(2)
                  .substring(v.toStringAsFixed(2).indexOf('.'))
              : '');
    }
    return v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF13151A) : const Color(0xFFF7F9FC);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final cardBg = isDark ? const Color(0xFF1F222E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Fund Tracker',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textColor),
            onPressed: _fetchAll,
          ),
        ],
        bottom: _isLoading
            ? null
            : TabBar(
                controller: _tabCtrl,
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 12),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                indicatorColor: MyColors.primary,
                labelColor: MyColors.primary,
                unselectedLabelColor: textColor.withOpacity(0.5),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Deposits'),
                  Tab(text: 'Allocations'),
                ],
              ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: MyColors.primary))
          : TabBarView(
              controller: _tabCtrl,
              children: [
                // ── TAB 1: Balance Overview
                _OverviewTab(
                  walletData: _walletData,
                  deposits: _deposits,
                  isDark: isDark,
                  textColor: textColor,
                  cardBg: cardBg,
                  fmt: _fmt,
                  onSSLDeposit: _handleSSLDeposit,
                  onChequeDeposit: _handleChequeDeposit,
                ),

                // ── TAB 2: Deposit History
                _DepositHistoryTab(
                  deposits: _deposits,
                  isDark: isDark,
                  textColor: textColor,
                  cardBg: cardBg,
                  fmt: _fmt,
                  onRefresh: _fetchAll,
                ),

                // ── TAB 3: Allocation/Campaign History
                _AllocationHistoryTab(
                  walletData: _walletData,
                  isDark: isDark,
                  textColor: textColor,
                  cardBg: cardBg,
                  fmt: _fmt,
                  onRefresh: _fetchAll,
                ),
              ],
            ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 1 — Overview
// ══════════════════════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final CorporateWalletData? walletData;
  final List<CorporateDepositRecord> deposits;
  final bool isDark;
  final Color textColor, cardBg;
  final String Function(double) fmt;
  final VoidCallback onSSLDeposit, onChequeDeposit;

  const _OverviewTab({
    required this.walletData,
    required this.deposits,
    required this.isDark,
    required this.textColor,
    required this.cardBg,
    required this.fmt,
    required this.onSSLDeposit,
    required this.onChequeDeposit,
  });

  @override
  Widget build(BuildContext context) {
    final wallet = walletData?.wallet;
    final total = wallet?.totalDeposited ?? 0;
    final balance = wallet?.balance ?? 0;
    final used = total - balance;
    final pending = deposits.where((d) => d.isUnderReview).length;

    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Balance Card
          _GradientBalanceCard(
              balance: balance, total: total, used: used, fmt: fmt),

          const SizedBox(height: 16),

          // ── Pending Badge (if any)
          if (pending > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hourglass_top_rounded,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$pending cheque deposit(s) awaiting admin approval',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Deposit Buttons
          Text('Add Funds',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _ActionBtn(
                icon: Icons.credit_card_rounded,
                label: 'SSLCommerz',
                subtitle: 'Up to ৳1,00,000',
                color: const Color(0xFF4CAF50),
                onTap: onSSLDeposit,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionBtn(
                icon: Icons.receipt_long_rounded,
                label: 'Cheque / NEFT',
                subtitle: 'Any amount',
                color: const Color(0xFF2196F3),
                onTap: onChequeDeposit,
              ),
            ),
          ]),

          const SizedBox(height: 28),

          // ── Recent Allocations (last 3)
          if ((walletData?.allocations ?? []).isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Allocations',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
              ],
            ),
            const SizedBox(height: 12),
            ...(walletData!.allocations.take(3).map((a) => _AllocationTile(
                allocation: a,
                cardBg: cardBg,
                textColor: textColor,
                isDark: isDark,
                fmt: fmt))),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 2 — Deposit History
// ══════════════════════════════════════════════════════════════════════════════
class _DepositHistoryTab extends StatelessWidget {
  final List<CorporateDepositRecord> deposits;
  final bool isDark;
  final Color textColor, cardBg;
  final String Function(double) fmt;
  final Future<void> Function() onRefresh;

  const _DepositHistoryTab({
    required this.deposits,
    required this.isDark,
    required this.textColor,
    required this.cardBg,
    required this.fmt,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (deposits.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.receipt_long_outlined,
              size: 80, color: textColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text('No deposits yet',
              style: GoogleFonts.poppins(color: textColor.withOpacity(0.5))),
        ]),
      );
    }

    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deposits.length,
        itemBuilder: (_, i) {
          final d = deposits[i];
          return _DepositTile(
              dep: d,
              cardBg: cardBg,
              textColor: textColor,
              isDark: isDark,
              fmt: fmt);
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 3 — Allocation History
// ══════════════════════════════════════════════════════════════════════════════
class _AllocationHistoryTab extends StatelessWidget {
  final CorporateWalletData? walletData;
  final bool isDark;
  final Color textColor, cardBg;
  final String Function(double) fmt;
  final Future<void> Function() onRefresh;

  const _AllocationHistoryTab({
    required this.walletData,
    required this.isDark,
    required this.textColor,
    required this.cardBg,
    required this.fmt,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final allocs = walletData?.allocations ?? [];
    if (allocs.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.volunteer_activism_outlined,
              size: 80, color: textColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text('No campaign allocations yet',
              style: GoogleFonts.poppins(color: textColor.withOpacity(0.5))),
          const SizedBox(height: 8),
          Text('Funds have not been distributed to campaigns yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: textColor.withOpacity(0.4))),
        ]),
      );
    }

    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allocs.length,
        itemBuilder: (_, i) => _AllocationTile(
          allocation: allocs[i],
          cardBg: cardBg,
          textColor: textColor,
          isDark: isDark,
          fmt: fmt,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _GradientBalanceCard extends StatelessWidget {
  final double balance, total, used;
  final String Function(double) fmt;

  const _GradientBalanceCard(
      {required this.balance,
      required this.total,
      required this.used,
      required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [MyColors.primary, MyColors.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: MyColors.primary.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 12))
        ],
      ),
      child: Stack(children: [
        Positioned(
          right: -40,
          top: -40,
          child: Icon(Icons.account_balance_wallet_rounded,
              size: 140, color: Colors.white.withOpacity(0.08)),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.wallet_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Text('Available Balance',
                style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('৳ ',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 28,
                      fontWeight: FontWeight.w600)),
              Text(fmt(balance),
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      height: 1.1)),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Deposited',
                          style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('৳ ${fmt(total)}',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
              Container(
                  width: 1, height: 30, color: Colors.white.withOpacity(0.2)),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Allocated',
                          style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('৳ ${fmt(used)}',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
            ]),
          ),
        ]),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F222E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isDark ? Colors.white : const Color(0xFF1A1C1E))),
          Text(subtitle,
              style: GoogleFonts.poppins(fontSize: 11, color: color)),
        ]),
      ),
    );
  }
}

class _DepositTile extends StatelessWidget {
  final CorporateDepositRecord dep;
  final Color cardBg, textColor;
  final bool isDark;
  final String Function(double) fmt;

  const _DepositTile(
      {required this.dep,
      required this.cardBg,
      required this.textColor,
      required this.isDark,
      required this.fmt});

  @override
  Widget build(BuildContext context) {
    // Status chip config
    Color chipColor;
    String chipLabel;
    IconData chipIcon;

    if (dep.isCompleted) {
      chipColor = Colors.green;
      chipLabel = 'Credited';
      chipIcon = Icons.check_circle_rounded;
    } else if (dep.isUnderReview) {
      chipColor = Colors.orange;
      chipLabel = 'Under Review';
      chipIcon = Icons.hourglass_top_rounded;
    } else if (dep.isRejected) {
      chipColor = Colors.red;
      chipLabel = 'Rejected';
      chipIcon = Icons.cancel_rounded;
    } else {
      chipColor = Colors.grey;
      chipLabel = dep.status;
      chipIcon = Icons.info_outline_rounded;
    }

    String dateStr = '';
    try {
      dateStr = DateFormat('dd MMM yyyy, hh:mm a')
          .format(DateTime.parse(dep.createdAt));
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)
        ],
      ),
      child: Row(children: [
        // Method icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                (dep.isCheque ? Colors.blue : Colors.green).withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            dep.isCheque
                ? Icons.receipt_long_rounded
                : Icons.credit_card_rounded,
            color: dep.isCheque ? Colors.blue : Colors.green,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dep.isCheque ? 'Cheque Deposit' : 'SSLCommerz',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: textColor)),
            if (dep.chequeNo != null)
              Text('Cheque: ${dep.chequeNo} · ${dep.bankName ?? ''}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: textColor.withOpacity(0.55))),
            if (dep.adminNote != null && dep.isRejected)
              Text('Reason: ${dep.adminNote}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.red.withOpacity(0.8))),
            Text(dateStr,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: textColor.withOpacity(0.4))),
          ]),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('৳ ${fmt(dep.amount)}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: dep.isCompleted ? Colors.green : textColor)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: chipColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(chipIcon, size: 11, color: chipColor),
              const SizedBox(width: 4),
              Text(chipLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: chipColor,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
      ]),
    );
  }
}

class _AllocationTile extends StatelessWidget {
  final CorporateAllocation allocation;
  final Color cardBg, textColor;
  final bool isDark;
  final String Function(double) fmt;

  const _AllocationTile(
      {required this.allocation,
      required this.cardBg,
      required this.textColor,
      required this.isDark,
      required this.fmt});

  @override
  Widget build(BuildContext context) {
    String dateStr = '';
    try {
      dateStr = DateFormat('MMM dd, yyyy')
          .format(DateTime.parse(allocation.allocatedAt));
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)
        ],
      ),
      child: Row(children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: allocation.campaign.image != null &&
                  allocation.campaign.image!.isNotEmpty
              ? Image.network(allocation.campaign.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                      Icons.volunteer_activism_rounded,
                      color: isDark ? Colors.white24 : Colors.grey[300],
                      size: 28))
              : Icon(Icons.volunteer_activism_rounded,
                  color: isDark ? Colors.white24 : Colors.grey[300], size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(allocation.campaign.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textColor)),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.calendar_today_rounded,
                  size: 11, color: textColor.withOpacity(0.45)),
              const SizedBox(width: 4),
              Text(dateStr,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: textColor.withOpacity(0.55))),
            ]),
          ]),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: const Color(0xFF00C896).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Text('− ৳${fmt(allocation.amount)}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: const Color(0xFF00C896))),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM SHEETS
// ══════════════════════════════════════════════════════════════════════════════

class _SSLDepositSheet extends StatelessWidget {
  final TextEditingController ctrl;
  final WalletService svc;

  const _SSLDepositSheet({required this.ctrl, required this.svc});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1F222E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: BoxDecoration(
            color: bg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.credit_card_rounded,
                      color: Colors.green, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Online Payment',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
              ]),
              const SizedBox(height: 6),
              Text('Powered by SSLCommerz · Max ৳1,00,000 per transaction',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: textColor.withOpacity(0.5))),
              const SizedBox(height: 24),
              TextField(
                controller: ctrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor),
                decoration: InputDecoration(
                  prefixText: '৳ ',
                  prefixStyle: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textColor.withOpacity(0.4)),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0),
                  onPressed: () async {
                    final amount = double.tryParse(ctrl.text) ?? 0;
                    if (amount < 10) {
                      Get.snackbar('Invalid Amount', 'Minimum deposit is ৳10',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    if (amount > 100000) {
                      Get.snackbar('Limit Exceeded',
                          'For amounts over ৳1,00,000 please use Cheque/NEFT',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    Get.dialog(const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false);
                    final url = await svc.initiateDeposit(amount);
                    Get.back();
                    if (url != null) {
                      Navigator.pop(context);
                      final ok = await Get.to(
                          () => WalletDepositScreen(uploadUrl: url));
                      if (ok == true) Navigator.pop(context, true);
                    }
                  },
                  child: Text('Proceed to Payment',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ]),
      ),
    );
  }
}

class _ChequeDepositSheet extends StatefulWidget {
  final WalletService svc;
  const _ChequeDepositSheet({required this.svc});

  @override
  State<_ChequeDepositSheet> createState() => _ChequeDepositSheetState();
}

class _ChequeDepositSheetState extends State<_ChequeDepositSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _chequeCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  File? _chequeImage;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1F222E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final fieldFill =
        isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]!;

    InputDecoration _field(String label, {String? hint}) => InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: fieldFill,
          labelStyle: GoogleFonts.poppins(
              color: textColor.withOpacity(0.6), fontSize: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        );

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: BoxDecoration(
            color: bg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28))),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.receipt_long_rounded,
                          color: Colors.blue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cheque / NEFT Deposit',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textColor)),
                          Text('Admin will verify and credit your wallet',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5))),
                        ]),
                  ]),
                  const SizedBox(height: 20),

                  // Amount
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: textColor),
                    decoration: _field('Amount (৳)', hint: 'e.g. 500000'),
                    validator: (v) {
                      final a = double.tryParse(v ?? '');
                      if (a == null || a < 1) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Cheque No
                  TextFormField(
                    controller: _chequeCtrl,
                    style: GoogleFonts.poppins(color: textColor),
                    decoration: _field('Cheque Number', hint: 'e.g. 001234567'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Bank Name
                  TextFormField(
                    controller: _bankCtrl,
                    style: GoogleFonts.poppins(color: textColor),
                    decoration:
                        _field('Bank Name', hint: 'e.g. Dutch Bangla Bank'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Cheque Image
                  GestureDetector(
                    onTap: () async {
                      final src = await showModalBottomSheet<ImageSource>(
                        context: context,
                        builder: (_) => SafeArea(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt_rounded),
                              title:
                                  Text('Camera', style: GoogleFonts.poppins()),
                              onTap: () =>
                                  Navigator.pop(context, ImageSource.camera),
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library_rounded),
                              title:
                                  Text('Gallery', style: GoogleFonts.poppins()),
                              onTap: () =>
                                  Navigator.pop(context, ImageSource.gallery),
                            ),
                          ]),
                        ),
                      );
                      if (src != null) {
                        final picked = await ImagePicker()
                            .pickImage(source: src, imageQuality: 80);
                        if (picked != null)
                          setState(() => _chequeImage = File(picked.path));
                      }
                    },
                    child: Container(
                      height: _chequeImage != null ? 140 : 64,
                      decoration: BoxDecoration(
                        color: fieldFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: _chequeImage != null
                                ? Colors.blue.withOpacity(0.4)
                                : Colors.transparent),
                      ),
                      child: _chequeImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Stack(fit: StackFit.expand, children: [
                                Image.file(_chequeImage!, fit: BoxFit.cover),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _chequeImage = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(Icons.add_photo_alternate_rounded,
                                      color: Colors.blue.withOpacity(0.6),
                                      size: 22),
                                  const SizedBox(width: 10),
                                  Text('Attach Cheque Image (optional)',
                                      style: GoogleFonts.poppins(
                                          color: textColor.withOpacity(0.45),
                                          fontSize: 13)),
                                ]),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info note
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Colors.blue, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your wallet will be credited once the admin verifies this cheque.',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.blue.shade700),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0),
                      onPressed: _submitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _submitting = true);
                              final ok = await widget.svc.submitChequeDeposit(
                                amount: double.parse(_amountCtrl.text),
                                chequeNo: _chequeCtrl.text.trim(),
                                bankName: _bankCtrl.text.trim(),
                                chequeImage: _chequeImage,
                              );
                              setState(() => _submitting = false);
                              if (ok) Navigator.pop(context, true);
                            },
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : Text('Submit for Review',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
