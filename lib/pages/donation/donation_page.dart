import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/models/campaign_model.dart';
import 'package:helpnhelper/pages/home/in_app_web_page.dart';
import 'package:helpnhelper/utils/design_system.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class DonationPage extends StatefulWidget {
  final CampaignModel campaign;
  const DonationPage({Key? key, required this.campaign}) : super(key: key);

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _amountController = TextEditingController();
  final _mobileController = TextEditingController();
  bool _isAnonymous = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  double? _selectedPreset;

  static const List<double> _presets = [500, 1000, 5000];

  @override
  void dispose() {
    _amountController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _selectPreset(double amount) {
    setState(() {
      _selectedPreset = amount;
      // Show as integer if whole number, else show decimal
      _amountController.text = amount == amount.truncate()
          ? amount.toInt().toString()
          : amount.toString();
    });
  }

  /// Extracts the CSRF _token from donation page HTML.
  String? _extractCsrfToken(String html) {
    final m = RegExp(r'<input[^>]+name="_token"[^>]+value="([^"]+)"')
        .firstMatch(html);
    return m?.group(1);
  }

  Future<void> _donate() async {
    final amountStr = _amountController.text.trim();
    final mobile = _mobileController.text.trim();

    if (amountStr.isEmpty || double.tryParse(amountStr) == null) {
      Get.snackbar('Error', 'Please enter a valid amount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }
    final double parsedAmount = double.parse(amountStr);
    if (parsedAmount <= 0) {
      Get.snackbar('Error', 'Amount must be greater than 0',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }
    if (parsedAmount < 10) {
      Get.snackbar('Minimum Amount', 'The amount must be at least ৳10',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }
    if (mobile.isEmpty) {
      Get.snackbar('Error', 'Please enter your mobile number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }
    if (!_agreedToTerms) {
      Get.snackbar('Error', 'Please agree to the Terms & Conditions',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    final ioClient = HttpClient();
    try {
      final campaignId = widget.campaign.id.toString();

      // ─── Step 1: GET donation page → grab CSRF token + session cookies ───
      final getReq = await ioClient
          .getUrl(Uri.parse('https://helpnhelper.com/donation/$campaignId'));
      getReq.headers.set('Accept', 'text/html');
      getReq.headers.set('User-Agent', 'Mozilla/5.0');
      final getResp = await getReq.close();
      final pageHtml = await getResp.transform(utf8.decoder).join();

      // Collect session cookies
      final cookieList = <String>[];
      getResp.headers.forEach((name, values) {
        if (name.toLowerCase() == 'set-cookie') {
          for (final v in values) {
            cookieList.add(v.split(';').first);
          }
        }
      });
      final cookieHeader = cookieList.join('; ');

      final token = _extractCsrfToken(pageHtml);
      if (token == null) throw Exception('CSRF token not found');

      // ─── Step 2: POST to donation-store — NO redirect follow ──────────────

      final body = [
        '_token=${Uri.encodeQueryComponent(token)}',
        'campaign_id=${Uri.encodeQueryComponent(campaignId)}',
        'amount=${Uri.encodeQueryComponent(amountStr)}',
        'selectedAmount=0',
        'donor_type=${_isAnonymous ? 'anonymous' : 'account'}',
        'phone=${Uri.encodeQueryComponent(mobile)}',
      ].join('&');

      final postReq = await ioClient
          .postUrl(Uri.parse('https://helpnhelper.com/donation-store'));
      postReq.followRedirects =
          false; // ← stops auto-follow of 302 to SSLCommerz
      postReq.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      postReq.headers.set('Accept', 'text/html,application/xhtml+xml');
      postReq.headers
          .set('Referer', 'https://helpnhelper.com/donation/$campaignId');
      postReq.headers.set('User-Agent', 'Mozilla/5.0');
      if (cookieHeader.isNotEmpty) {
        postReq.headers.set('Cookie', cookieHeader);
      }
      postReq.write(body);
      final postResp = await postReq.close();

      print('donation-store status: ${postResp.statusCode}');

      String? sslUrl;

      if (postResp.statusCode == 301 || postResp.statusCode == 302) {
        // ✅ Direct 302 → Location header is the SSLCommerz URL
        sslUrl = postResp.headers.value('location');
        print('SSLCommerz URL from 302: $sslUrl');
      } else if (postResp.statusCode == 200) {
        final respBody = await postResp.transform(utf8.decoder).join();
        final jsMatch = RegExp(r'window\.location(?:\.href)?\s*=\s*"([^"]+)"')
            .firstMatch(respBody);
        final metaMatch =
            RegExp(r'content="0;\s*url=([^"]+)"', caseSensitive: false)
                .firstMatch(respBody);
        sslUrl = jsMatch?.group(1) ?? metaMatch?.group(1);
        print('SSLCommerz URL from body: $sslUrl');
      }

      if (sslUrl != null && sslUrl.startsWith('http')) {
        // ✅ Open SSLCommerz directly — donation web form never shown
        Get.to(() => InAppWebPage(url: sslUrl!, title: 'Secure Payment'));
      } else {
        Get.snackbar(
            'Error', 'Payment gateway did not respond. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      print('--- DONATION FLOW ERROR: $e ---');
      Get.snackbar('Error', 'Could not initiate payment. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      ioClient.close();
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use pure native theme colors instead of hardcoded dark green
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Donate Now',
          style: DesignSystem.h3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image/Hero
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: widget.campaign.photo != null
                    ? DecorationImage(
                        image: NetworkImage(widget.campaign.photo!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken),
                      )
                    : null,
                color: MyColors.primary.withOpacity(0.2),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.campaign.title ?? 'Campaign',
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 10)
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Amount Card ──────────────────────────────
            Text(
              'Donate Amount',
              style: DesignSystem.h3.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: Column(
                children: [
                  // Amount Field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 24,
                                color: hintColor,
                                fontWeight: FontWeight.w700,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                            ),
                            onChanged: (v) {
                              setState(() => _selectedPreset = null);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: borderColor),
                            ),
                          ),
                          child: Text(
                            'BDT',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Preset Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _presets.map((amount) {
                      final isSelected = _selectedPreset == amount;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectPreset(amount),
                          child: Container(
                            margin: EdgeInsets.only(
                                right: amount != _presets.last ? 10 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? MyColors.primary
                                  : (isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected ? MyColors.primary : borderColor,
                              ),
                            ),
                            child: Text(
                              '৳ $amount',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Details Card ──────────────────────────────
            Text(
              'Personal Information',
              style: DesignSystem.h3.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle Setup
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAnonymous = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isAnonymous
                                    ? MyColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Anonymous',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: _isAnonymous
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAnonymous = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isAnonymous
                                    ? MyColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Account',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: !_isAnonymous
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Mobile Number',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 8),

                  // Phone Input
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter valid number',
                        hintStyle: GoogleFonts.poppins(color: hintColor),
                        prefixIcon: Icon(Icons.phone_android, color: hintColor),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Terms & Action ───────────────────────────
            GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return MyColors.primary;
                        }
                        return Colors.transparent;
                      }),
                      side: BorderSide(
                          color: isDark ? Colors.white54 : Colors.black45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'I have read & agree to the Terms & Conditions, Privacy Policy and Refund Policy',
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _donate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  disabledBackgroundColor: MyColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Donate Now',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
