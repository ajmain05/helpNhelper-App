import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/models/user_model.dart';
import 'package:helpnhelper/pages/login/sign_in_page.dart';
import 'package:helpnhelper/pages/login/sign_up_page_1.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:helpnhelper/pages/profile/wallet_dashboard.dart';

class ProfilePage extends StatefulWidget {
  final bool showBackButton;
  const ProfilePage({Key? key, this.showBackButton = true}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = GetStorage();
  late UserModel user;
  late String userType;
  bool get _isGuest => (box.read('access_token') == null);

  @override
  void initState() {
    super.initState();
    if (!_isGuest) {
      user = Get.find<AuthController>().userData.value;
      userType = box.read('type') ?? 'donor';

      final homeCtrl = Get.find<HomeController>();
      Future.delayed(Duration.zero, () {
        if (userType == 'volunteer') {
          if (homeCtrl.volunteerHistoryList.isEmpty)
            homeCtrl.getVolunteerHistory();
        } else if (userType == 'seeker') {
          if (homeCtrl.seekerHistoryList.isEmpty) homeCtrl.getSeekerHistory();
        }
      });
    } else {
      user = UserModel();
      userType = 'guest';
    }
  }

  // ── Color per user type ──────────────────────────────────────────────────────
  Color get _accentColor {
    switch (userType) {
      case 'volunteer':
        return MyColors.primary;
      case 'seeker':
        return const Color(0xFF5C6BC0);
      case 'organization':
        return const Color(0xFFFF7043);
      case 'corporate-donor':
        return const Color(0xFF7C4DFF);
      case 'guest':
        return const Color(0xFF78909C);
      default:
        return const Color(0xFFEF5350);
    }
  }

  String get _userTypeLabel {
    switch (userType) {
      case 'volunteer':
        return 'role_volunteer'.tr;
      case 'seeker':
        return 'fund_seeker'.tr;
      case 'organization':
        return 'role_organization'.tr;
      case 'corporate-donor':
        return 'role_corporate_donor'.tr;
      case 'guest':
        return 'guest'.tr;
      default:
        return 'role_donor'.tr;
    }
  }

  IconData get _userTypeIcon {
    switch (userType) {
      case 'volunteer':
        return Icons.volunteer_activism_rounded;
      case 'seeker':
        return Icons.support_agent_rounded;
      case 'organization':
        return Icons.business_rounded;
      case 'corporate-donor':
        return Icons.corporate_fare_rounded;
      case 'guest':
        return Icons.person_outline_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }

  void _openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        currentUser: user,
        accentColor: _accentColor,
        onSaved: () => setState(() {
          user = Get.find<AuthController>().userData.value;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ── Guest Screen ─────────────────────────────────────────────────────────
    if (_isGuest) {
      return _GuestProfileView(isDark: isDark);
    }

    // ── Logged-in Screen ─────────────────────────────────────────────────────
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final subColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;
    final scaffoldBg =
        isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final fieldBg = isDark ? const Color(0xFF252840) : const Color(0xFFF7F9FC);
    final accent = _accentColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Obx(() {
        // Reactively re-read userData so edits are reflected instantly
        final u = Get.find<AuthController>().userData.value;

        return CustomScrollView(
          slivers: [
            // ── Gradient Hero ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1A1D27), const Color(0xFF2D3147)]
                        : [accent, accent.withOpacity(0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 24,
                    right: 24,
                    bottom: 36,
                  ),
                  child: Column(
                    children: [
                      // Top row (back + title + edit button)
                      Row(
                        children: [
                          if (widget.showBackButton)
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
                          if (widget.showBackButton) const Spacer(),
                          Text('my_profile'.tr,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          // ✏️ Edit button
                          GestureDetector(
                            onTap: _openEditSheet,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.edit_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Avatar (tappable → opens edit sheet)
                      GestureDetector(
                        onTap: _openEditSheet,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 3),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 16)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                backgroundImage: (u.photo != null &&
                                        u.photo!.isNotEmpty &&
                                        u.photo!.startsWith('http'))
                                    ? NetworkImage(u.photo!)
                                    : null,
                                child: (u.photo == null ||
                                        u.photo!.isEmpty ||
                                        !u.photo!.startsWith('http'))
                                    ? Text(
                                        (u.name?.isNotEmpty == true)
                                            ? u.name![0].toUpperCase()
                                            : '?',
                                        style: GoogleFonts.playfairDisplay(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700))
                                    : null,
                              ),
                            ),
                            // Camera badge
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  size: 14, color: accent),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        u.name ?? 'User',
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),

                      // User type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_userTypeIcon, color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text(_userTypeLabel,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stats Row (donors) ──────────────────────────────────────────
            if (userType == 'donor' || userType == 'corporate-donor')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Obx(() {
                    final ctrl = Get.find<HomeController>();

                    double myTotal = 0;
                    for (var history in ctrl.donationHistoryList) {
                      myTotal += double.tryParse(history.amount ?? '0') ?? 0;
                    }

                    return Row(
                      children: [
                        _statCard(
                            'total_donated'.tr,
                            'Tk ${myTotal.toStringAsFixed(0)}',
                            Icons.favorite_rounded,
                            accent,
                            cardBg,
                            textColor),
                        const SizedBox(width: 12),
                        _statCard(
                            'campaigns'.tr,
                            '${ctrl.donationHistoryList.length}',
                            Icons.emoji_events_rounded,
                            const Color(0xFF00C896),
                            cardBg,
                            textColor),
                      ],
                    );
                  }),
                ),
              ),

            // ── Corporate Wallet Tracker CTA ─────────────────────────────────
            if (userType == 'corporate-donor')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: InkWell(
                    onTap: () => Get.to(() => const WalletDashboard()),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyColors.primary,
                            const Color(0xFF00C896),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: MyColors.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('track_my_fund'.tr,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('view_remaining_balance'.tr,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Profile Details ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _sectionTitle('account_information'.tr, textColor),
                  _infoCard(cardBg, [
                    _infoRow(Icons.email_outlined, 'email'.tr,
                        u.email ?? 'Not set', textColor, subColor, fieldBg,
                        accent: accent),
                    _infoRow(Icons.phone_android_rounded, 'mobile'.tr,
                        u.mobile ?? 'Not set', textColor, subColor, fieldBg),
                    _infoRow(
                        Icons.fingerprint_rounded,
                        'account_id'.tr,
                        u.sid ?? u.id?.toString() ?? 'N/A',
                        textColor,
                        subColor,
                        fieldBg),
                    _infoRow(Icons.verified_user_rounded, 'status'.tr,
                        u.status ?? 'Active', textColor, subColor, fieldBg),
                  ]),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  if ((userType == 'organization' ||
                          userType == 'corporate-donor') &&
                      u.licenseNo != null) ...[
                    _sectionTitle('organization_details'.tr, textColor),
                    _infoCard(cardBg, [
                      _infoRow(Icons.badge_rounded, 'license_no'.tr,
                          u.licenseNo!, textColor, subColor, fieldBg),
                      if (u.category != null && u.category!.isNotEmpty)
                        _infoRow(Icons.category_rounded, 'category'.tr,
                            u.category!, textColor, subColor, fieldBg),
                    ]),
                    const SizedBox(height: 20),
                  ],
                  if (userType == 'donor' || userType == 'corporate-donor') ...[
                    _sectionTitle('your_supported_campaigns'.tr, textColor),
                    Obx(() {
                      final ctrl = Get.find<HomeController>();
                      final list = ctrl.donationHistoryList;
                      if (list.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Column(children: [
                              Icon(Icons.volunteer_activism_outlined,
                                  size: 48, color: subColor.withOpacity(0.5)),
                              const SizedBox(height: 12),
                              Text('donate_to_track'.tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: subColor, fontSize: 13)),
                            ]),
                          ),
                        );
                      }
                      return Column(
                        children: list
                            .where((d) => d.campaign != null)
                            .take(5)
                            .map((d) {
                          final c = d.campaign!;
                          return _campaignTrackCard(
                              c.title ?? 'Campaign',
                              c.totalRaised ?? '0',
                              c.amount ?? '0',
                              accent,
                              cardBg,
                              textColor,
                              subColor,
                              fieldBg,
                              myDonation: d.amount ?? '0');
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                  if (userType == 'volunteer') ...[
                    _sectionTitle('task_history'.tr, textColor),
                    Obx(() {
                      final ctrl = Get.find<HomeController>();
                      if (ctrl.volunteerHistoryList.isEmpty) {
                        return _emptyCard('no_tasks_yet'.tr, cardBg, subColor);
                      }
                      return Column(
                        children: ctrl.volunteerHistoryList.take(5).map((h) {
                          final item = h.application;
                          return _miniHistoryCard(
                              item?.title ?? 'Task',
                              item?.status ?? 'N/A',
                              cardBg,
                              textColor,
                              subColor,
                              accent);
                        }).toList(),
                      );
                    }),
                  ],
                  if (userType == 'seeker') ...[
                    _sectionTitle('fund_requests'.tr, textColor),
                    Obx(() {
                      final ctrl = Get.find<HomeController>();
                      if (ctrl.seekerHistoryList.isEmpty) {
                        return _emptyCard(
                            'no_fund_requests_yet'.tr, cardBg, subColor);
                      }
                      return Column(
                        children: ctrl.seekerHistoryList.take(5).map((h) {
                          return _miniHistoryCard(
                              h.title ?? 'Request',
                              h.status ?? 'N/A',
                              cardBg,
                              textColor,
                              subColor,
                              accent);
                        }).toList(),
                      );
                    }),
                  ],
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────────────────

  Widget _emptyCard(String msg, Color cardBg, Color subColor) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: cardBg, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(msg,
              style: GoogleFonts.poppins(color: subColor, fontSize: 13)),
        ),
      );

  Widget _sectionTitle(String title, Color textColor) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(title,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 15, fontWeight: FontWeight.w700)),
      );

  Widget _infoCard(Color bg, List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(children: children),
      );

  Widget _infoRow(IconData icon, String label, String value, Color textColor,
      Color subColor, Color fieldBg,
      {Color? accent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (accent ?? MyColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent ?? MyColors.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        color: subColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color,
      Color cardBg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: GoogleFonts.poppins(
                          color: color,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  Text(label,
                      style: GoogleFonts.poppins(
                          color: textColor.withOpacity(0.6), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campaignTrackCard(
      String title,
      String raised,
      String goal,
      Color accent,
      Color cardBg,
      Color textColor,
      Color subColor,
      Color fieldBg,
      {String? myDonation}) {
    double pct = 0;
    try {
      final r = double.parse(raised);
      final g = double.parse(goal.isEmpty ? '1' : goal);
      pct = (r / g).clamp(0.0, 1.0);
    } catch (_) {}
    final isSuccess = pct >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isSuccess
                          ? const Color(0xFF00C896)
                          : const Color(0xFFFFA62B))
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isSuccess ? '✓ ${'successful'.tr}' : 'ongoing'.tr,
                    style: GoogleFonts.poppins(
                        color: isSuccess
                            ? const Color(0xFF00C896)
                            : const Color(0xFFFFA62B),
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                  myDonation != null
                      ? '${'you_donated'.tr}: ৳$myDonation'
                      : '${'raised'.tr}: ৳$raised',
                  style: GoogleFonts.poppins(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              Text('${'goal'.tr}: ৳$goal',
                  style: GoogleFonts.poppins(color: subColor, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: fieldBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isSuccess ? const Color(0xFF00C896) : accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniHistoryCard(String title, String status, Color cardBg,
      Color textColor, Color subColor, Color accent) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF00C896);
        break;
      case 'rejected':
      case 'declined':
        statusColor = const Color(0xFFFF5C7C);
        break;
      case 'investigating':
        statusColor = const Color(0xFF64B5F6);
        break;
      default:
        statusColor = const Color(0xFFFFA62B);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.task_alt_rounded, color: accent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status.toUpperCase(),
                style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Guest Profile View ────────────────────────────────────────────────────────
class _GuestProfileView extends StatelessWidget {
  final bool isDark;
  const _GuestProfileView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg =
        isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final textColor =
        isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final subColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // Hero gradient header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF78909C), Color(0xFF546E7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24,
                  bottom: 40,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  children: [
                    // Avatar placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.4), width: 3),
                      ),
                      child: const Icon(Icons.person_outline_rounded,
                          color: Colors.white70, size: 52),
                    ),
                    const SizedBox(height: 16),
                    Text('Guest User',
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Login to access your full profile',
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Login CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(SignIn()),
                      icon: const Icon(Icons.login_rounded, size: 20),
                      label: Text('Login to My Account',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Sign Up CTA
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.to(SignUpPage1()),
                      icon: const Icon(Icons.person_add_rounded, size: 20),
                      label: Text('Create New Account',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColors.primary,
                        side:
                            const BorderSide(color: MyColors.primary, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features list
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('With an account you can:',
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        _featureRow(
                            Icons.volunteer_activism_rounded,
                            'Donate to campaigns',
                            'Support people in need',
                            MyColors.primary,
                            subColor,
                            textColor),
                        _featureRow(
                            Icons.emoji_events_rounded,
                            'Track your impact',
                            'See campaigns you supported',
                            const Color(0xFF00C896),
                            subColor,
                            textColor),
                        _featureRow(
                            Icons.support_agent_rounded,
                            'Apply for help',
                            'Submit fund requests as a Seeker',
                            const Color(0xFF5C6BC0),
                            subColor,
                            textColor),
                        _featureRow(
                            Icons.handshake_rounded,
                            'Volunteer',
                            'Help investigate fund requests',
                            const Color(0xFFFF7043),
                            subColor,
                            textColor,
                            isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle, Color color,
      Color subColor, Color textColor,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: GoogleFonts.poppins(color: subColor, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Edit Profile Bottom Sheet ─────────────────────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final UserModel currentUser;
  final Color accentColor;
  final VoidCallback onSaved;

  const _EditProfileSheet({
    required this.currentUser,
    required this.accentColor,
    required this.onSaved,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _mobileCtrl;
  XFile? _pickedPhoto;
  final _picker = ImagePicker();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentUser.name ?? '');
    _mobileCtrl = TextEditingController(text: widget.currentUser.mobile ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text('Camera', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text('Gallery', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ]),
        ),
      ),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) setState(() => _pickedPhoto = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final authCtrl = Get.find<AuthController>();
    final success = await authCtrl.updateProfile(
      name: _nameCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      photoPath: _pickedPhoto?.path,
    );
    setState(() => _saving = false);
    if (success) {
      widget.onSaved();
      Get.back();
      Get.snackbar(
        '✅ Profile Updated',
        'Your changes have been saved.',
        backgroundColor: MyColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final fieldBg = isDark ? const Color(0xFF252840) : const Color(0xFFF7F9FC);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final accent = widget.accentColor;

    // Profile photo preview
    ImageProvider? photoProvider;
    if (_pickedPhoto != null) {
      photoProvider = FileImage(File(_pickedPhoto!.path));
    } else if (widget.currentUser.photo != null &&
        widget.currentUser.photo!.isNotEmpty &&
        widget.currentUser.photo!.startsWith('http')) {
      photoProvider = NetworkImage(widget.currentUser.photo!);
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),

            Text('Edit Profile',
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),

            // Photo picker
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: accent.withOpacity(0.15),
                      backgroundImage: photoProvider,
                      child: photoProvider == null
                          ? Text(
                              (widget.currentUser.name?.isNotEmpty == true)
                                  ? widget.currentUser.name![0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.playfairDisplay(
                                  color: accent,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700))
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Tap photo to change',
                  style: GoogleFonts.poppins(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 24),

            // Name field
            _inputField('Full Name', Icons.person_rounded, _nameCtrl, fieldBg,
                textColor, accent),
            const SizedBox(height: 14),

            // Mobile field
            _inputField('Mobile Number', Icons.phone_android_rounded,
                _mobileCtrl, fieldBg, textColor, accent,
                keyboard: TextInputType.phone),
            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                final loading =
                    Get.find<AuthController>().isUpdatingProfile.value ||
                        _saving;
                return ElevatedButton(
                  onPressed: loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text('Save Changes',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, IconData icon, TextEditingController ctrl,
      Color fieldBg, Color textColor, Color accent,
      {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            prefixIcon: Icon(icon, color: accent, size: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: accent, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
