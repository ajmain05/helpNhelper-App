import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/organization_controller.dart';
import 'package:helpnhelper/models/org_application_model.dart';
import 'package:helpnhelper/pages/organization/org_application_form.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({Key? key}) : super(key: key);

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  late final OrganizationController controller;
  final selectedFilter = 'all'.obs;

  final filters = [
    {'key': 'all', 'label': 'All'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'approved', 'label': 'Approved'},
    {'key': 'rejected', 'label': 'Rejected'},
  ];

  List<OrgApplicationModel> _getFilteredList() {
    var list = controller.applicationList.toList();
    // Sort newest first (by id descending as proxy for created_at)
    list.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    if (selectedFilter.value == 'all') return list;
    return list.where((app) =>
      (app.status ?? 'pending').toLowerCase() == selectedFilter.value).toList();
  }

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<OrganizationController>()) {
      Get.put(OrganizationController());
    }
    controller = Get.find<OrganizationController>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE8EAF0) : const Color(0xFF1A1C1E);
    final subColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final scaffoldBg = isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FA);
    final cardBg = isDark ? const Color(0xFF1E2235) : Colors.white;

    const primaryAccent = Color(0xFF8B5CF6); // Purple for Org module

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Obx(() {
        if (controller.isLoading.value && controller.applicationList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: primaryAccent));
        }

        return CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1A1D27), const Color(0xFF2D3147)]
                        : [primaryAccent, const Color(0xFF5B21B6)],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          GestureDetector(
                            onTap: () {
                              controller.getApplications();
                              controller.fetchSettings();
                            },
                            child: Obx(() => Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.refresh_rounded,
                                      color: Colors.white, size: 18),
                            )),
                          ),
                        ],
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
                            child: const Icon(Icons.business_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dashboard',
                                  style: GoogleFonts.playfairDisplay(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800)),
                              Text('Organization Hub',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Stat Row
                      Row(
                        children: [
                          _buildStatCard("Active Applications",
                              "${controller.activeApplicationsCount.value}", Icons.library_books),
                          const SizedBox(width: 12),
                          _buildStatCard("Total Raised",
                              "৳${controller.totalRaised.value.toStringAsFixed(0)}", Icons.attach_money),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Charge Notice
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildInfoBanner(isDark),
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((f) {
                      final isActive = selectedFilter.value == f['key'];
                      final chipColor = _getFilterChipColor(f['key']!);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => selectedFilter.value = f['key']!,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? chipColor
                                  : chipColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: chipColor.withOpacity(isActive ? 0 : 0.4)),
                            ),
                            child: Text(
                              f['label']!,
                              style: GoogleFonts.inter(
                                color: isActive
                                    ? Colors.white
                                    : chipColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
              ),
            ),

            // List Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Obx(() {
                  final filtered = _getFilteredList();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Applications',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${filtered.length} found',
                        style: GoogleFonts.inter(
                            color: subColor, fontSize: 12),
                      ),
                    ],
                  );
                }),
              ),
            ),

            // List Body
            Obx(() {
              final filtered = _getFilteredList();
              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_add,
                            size: 64, color: subColor.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text('No applications found',
                            style: GoogleFonts.poppins(
                                color: subColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final app = filtered[index];
                      return _buildApplicationCard(app, isDark, cardBg, textColor, subColor, primaryAccent);
                    },
                    childCount: filtered.length,
                  ),
                ),
              );
            }),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const OrgApplicationForm());
        },
        backgroundColor: primaryAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("New Request",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildApplicationCard(
      OrgApplicationModel app, bool isDark, Color cardBg, Color textColor, Color subColor, Color accent) {
    final statusColor = _getStatusColor(app.status ?? 'pending');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(app.title ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        (app.status ?? 'pending').toUpperCase(),
                        style: GoogleFonts.inter(
                            color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _miniInfo(Icons.location_on_outlined, app.seekerLocation ?? 'N/A', subColor),
                    const SizedBox(width: 16),
                    _miniInfo(Icons.category_outlined, app.category ?? 'N/A', subColor),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Raised: ৳${app.collectedAmount?.toStringAsFixed(0)}",
                        style: GoogleFonts.inter(color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Target: ৳${app.targetAmount?.toStringAsFixed(0)}",
                        style: GoogleFonts.inter(color: subColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (app.progress ?? 0) / 100,
                    backgroundColor: accent.withOpacity(0.1),
                    color: accent,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.inter(color: color, fontSize: 12)),
      ],
    );
  }

  Color _getFilterChipColor(String key) {
    switch (key) {
      case 'pending': return Colors.orange;
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return const Color(0xFF8B5CF6); // purple for All
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE68A).withOpacity(isDark ? 0.1 : 0.8), // Amber light
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Text(
              "Note: For every application, a ${controller.orgServiceCharge.value.toStringAsFixed(0)}% service charge will be automatically deducted from the total collected amount before payout.",
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFFFEF3C7) : const Color(0xFF92400E),
                fontSize: 12,
                height: 1.4,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
