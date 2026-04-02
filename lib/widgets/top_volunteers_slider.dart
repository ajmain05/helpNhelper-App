import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/models/volunteer_leaderboard_model.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class TopVolunteersSlider extends StatelessWidget {
  final List<VolunteerLeaderboardModel> volunteers;
  final ScrollController _scrollController = ScrollController();

  TopVolunteersSlider({Key? key, required this.volunteers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (volunteers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
             children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Top Volunteers of the Month",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.titleLarge?.color),
                ),
             ]
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer = volunteers[index];
              return _buildVolunteerCard(context, volunteer, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteerCard(
      BuildContext context, VolunteerLeaderboardModel volunteer, int index) {
    bool isTopThree = index < 3;
    Color glowColor = isTopThree
        ? (index == 0
            ? Colors.amber
            : (index == 1 ? Colors.grey.shade400 : Colors.brown.shade400))
        : MyColors.primary;

    Color cardBgGradient1 = isTopThree
        ? glowColor.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.15)
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.white);
    Color cardBgGradient2 = isTopThree
        ? glowColor.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.05 : 0.02)
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.02) : Colors.white);

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Glow
          if (isTopThree)
            Positioned(
              top: 15,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: glowColor.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5)
                  ],
                ),
              ),
            ),
          
          // Glassmorphism Card
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardBgGradient1, cardBgGradient2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: isTopThree
                          ? glowColor.withOpacity(0.8)
                          : Colors.grey.withOpacity(0.2),
                      width: isTopThree ? 2 : 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: glowColor, width: 2.5),
                        image: volunteer.photo != null
                            ? DecorationImage(
                                image: NetworkImage(volunteer.photo!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey.shade200,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: volunteer.photo == null
                          ? Center(
                              child: Text(
                                volunteer.name?[0].toUpperCase() ?? 'V',
                                style: TextStyle(
                                  color: MyColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    // Name
                    Text(
                      volunteer.name ?? 'Volunteer',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Points Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: glowColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: glowColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, size: 14, color: isTopThree ? glowColor : glowColor.withOpacity(0.8)),
                          const SizedBox(width: 4),
                          Text(
                            '${volunteer.points} pts',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).brightness == Brightness.dark ? glowColor : glowColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Rank Badge
          Positioned(
            top: -5,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: glowColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(color: glowColor.withOpacity(0.6), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
