import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/models/faq_model.dart';
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:http/http.dart' as http;

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});
  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int? _openIndex;
  Future<List<FaqModel>>? _faqsFuture;

  @override
  void initState() {
    super.initState();
    _faqsFuture = fetchFaqs();
  }

  Future<List<FaqModel>> fetchFaqs() async {
    try {
      final response = await http.get(Uri.parse(getFaqApi));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((json) => FaqModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching FAQs: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // ── AppBar ─────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: MyColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'FAQ',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header strip ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.primaryDark, MyColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'FREQUENTLY ASKED QUESTIONS',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Got questions?\nWe\'ve got answers.',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Everything you need to know about helpNhelper.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // ── FAQ list ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: FutureBuilder<List<FaqModel>>(
                future: _faqsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: const CircularProgressIndicator(
                          color: Color(0xFF00BFA5),
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "No FAQs available at the moment.",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final faqs = snapshot.data!;

                  return Column(
                    children: List.generate(faqs.length, (i) {
                      final faq = faqs[i];
                      final isOpen = _openIndex == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _openIndex = isOpen ? null : i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isOpen
                                  ? MyColors.primary.withOpacity(0.5)
                                  : (isDark
                                      ? Colors.white.withOpacity(0.07)
                                      : Colors.grey.withOpacity(0.15)),
                              width: isOpen ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isOpen
                                    ? MyColors.primary.withOpacity(0.10)
                                    : Colors.black
                                        .withOpacity(isDark ? 0.2 : 0.05),
                                blurRadius: isOpen ? 16 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // ── Question row ──────────────
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Icon badge
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? MyColors.primary
                                            : MyColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.question_answer_outlined,
                                        color: isOpen
                                            ? Colors.white
                                            : MyColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Question text
                                    Expanded(
                                      child: Text(
                                        faq.question ?? "",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.5,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Chevron
                                    AnimatedRotation(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      turns: isOpen ? 0.5 : 0,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: isOpen
                                            ? MyColors.primary
                                            : theme.textTheme.bodySmall?.color,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ── Answer (expandable) ───────
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 250),
                                firstChild: const SizedBox.shrink(),
                                secondChild: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: Column(
                                    children: [
                                      Divider(
                                        color:
                                            MyColors.primary.withOpacity(0.2),
                                        height: 1,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        faq.answer ?? "",
                                        style: GoogleFonts.lora(
                                          fontSize: 13.5,
                                          height: 1.75,
                                          color: theme
                                              .textTheme.bodyMedium?.color
                                              ?.withOpacity(0.85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                crossFadeState: isOpen
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
