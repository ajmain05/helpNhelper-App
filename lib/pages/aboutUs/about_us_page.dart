import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/controllers/about_controller.dart';
import 'package:helpnhelper/models/team_member_model.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AboutController aboutController = Get.put(AboutController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing Hero AppBar ─────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: MyColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/about-us.png', fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ABOUT US',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'We are here\nto help you!',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatsStrip(),
                _AboutSection(),
                Obx(() {
                  if (aboutController.isLoading.value) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return Column(
                    children: [
                      if (aboutController.teamMembers.isNotEmpty)
                        _TeamSection(
                          title: 'Meet Our Team',
                          subtitle: 'The people behind helpNhelper',
                          members: aboutController.teamMembers,
                          accentColor: MyColors.primary,
                        ),
                      const SizedBox(height: 8),
                      if (aboutController.shariahMembers.isNotEmpty)
                        _TeamSection(
                          title: 'Shariah Advisory Board',
                          subtitle: 'Our religious guidance council',
                          members: aboutController.shariahMembers,
                          accentColor: const Color(0xFF1565C0),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// STATS STRIP
// ══════════════════════════════════════════════
class _StatsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.primary, MyColors.primaryDark],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
              icon: Icons.calendar_today_outlined,
              value: '2018',
              label: 'Founded'),
          _VertDivider(),
          _StatItem(
              icon: Icons.volunteer_activism_outlined,
              value: '80+',
              label: 'Campaigns'),
          _VertDivider(),
          _StatItem(
              icon: Icons.location_on_outlined,
              value: 'All BD',
              label: 'Districts'),
          _VertDivider(),
          _StatItem(
              icon: Icons.verified_outlined, value: 'UN', label: 'ECOSOC'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem(
      {required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(height: 5),
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15)),
        Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7), fontSize: 10)),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.25));
}

// ══════════════════════════════════════════════
// ABOUT TEXT
// ══════════════════════════════════════════════
class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.primary, MyColors.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Who We Are',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Para(
            'Help N Helper (helpNhelper) is a humanitarian initiative operated by the Ash Foundation — a government-approved non-profit organization in Bangladesh (Reg. No: 3201; RJSC: CHS-620/2018; DNC: 01/2021-22) holding Special Consultative Status with the United Nations Economic and Social Council (ECOSOC).',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: MyColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: MyColors.primary, width: 3.5),
              ),
            ),
            child: _Para(
              'Through this initiative, medical assistance, financial grants for small businesses, support for orphans and widows, and food distribution programs are implemented. Its digital and transparent fundraising system enables donors to contribute online and monitor project progress.',
            ),
          ),
          const SizedBox(height: 16),
          _Para(
            'Since 2018, the organization has been serving poor and underprivileged communities across Bangladesh, acting as a bridge between help seekers and donors. Its mission is to build a hunger‑ and poverty‑free, healthy, and peaceful society.',
          ),
        ],
      ),
    );
  }
}

class _Para extends StatelessWidget {
  final String text;
  const _Para(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lora(
        fontSize: 15,
        height: 1.85,
        fontStyle: FontStyle.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TEAM SECTION — 2-column grid
// ══════════════════════════════════════════════
class _TeamSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<TeamMemberModel> members;
  final Color accentColor;

  const _TeamSection({
    required this.title,
    required this.subtitle,
    required this.members,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(theme.brightness == Brightness.dark ? 0.25 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ─────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.groups_2_outlined,
                    color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Member rows ─────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Column(
              children: members
                  .map((m) => _MemberRow(member: m, accent: accentColor))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// MEMBER ROW — horizontal profile row card
// ══════════════════════════════════════════════
class _MemberCard extends StatelessWidget {
  // kept for compatibility — delegates to _MemberRow
  final TeamMemberModel member;
  final Color accent;
  const _MemberCard({required this.member, required this.accent});
  @override
  Widget build(BuildContext ctx) => _MemberRow(member: member, accent: accent);
}

class _MemberRow extends StatelessWidget {
  final TeamMemberModel member;
  final Color accent;
  const _MemberRow({required this.member, required this.accent});

  String get _initials {
    final String name = member.name?.trim() ?? '';
    if (name.isEmpty) return 'U';

    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : accent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: ClipOval(
              child: Container(
                color: accent.withOpacity(0.15),
                child: (member.photo != null && member.photo!.isNotEmpty)
                    ? (member.photo!.startsWith('http')
                        ? Image.network(
                            member.photo!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: Text(_initials,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: accent))),
                          )
                        : Image.asset(
                            member.photo!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: Text(_initials,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: accent))),
                          ))
                    : Center(
                        child: Text(
                          _initials,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name + designation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (member.designation != null &&
                    member.designation!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    member.designation!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Accent dot
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// DATA
// ══════════════════════════════════════════════
// ══════════════════════════════════════════════
// Removed hardcoded _Member and lists
// ══════════════════════════════════════════════
