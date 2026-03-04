import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late final WebViewController _mapController;

  // Chittagong helpNhelper office coordinates
  static const double _lat = 22.3475;
  static const double _lng = 91.8123;

  @override
  void initState() {
    super.initState();
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    html, body, #map { width:100%; height:100%; }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    var map = L.map("map", { zoomControl:false, attributionControl:false })
              .setView([$_lat, $_lng], 16);
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(map);
    var icon = L.divIcon({
      html: "<div style=\\"font-size:36px;line-height:1;\\">📍</div>",
      iconSize:[36,36], iconAnchor:[18,36], className:""
    });
    L.marker([$_lat, $_lng], {icon:icon}).addTo(map);
  </script>
</body>
</html>
''';

    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);
  }

  Future<void> _launch(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch \$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Contact',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address
            _SectionCard(
              icon: Icons.location_on_outlined,
              iconColor: MyColors.primary,
              title: 'Address',
              child: Text(
                'Golam Ali Nazir Para, Chandgaon,\nChittagong 4212, Bangladesh.',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            const SizedBox(height: 16),

            // Contact
            _SectionCard(
              icon: Icons.phone_outlined,
              iconColor: MyColors.primary,
              title: 'Contact',
              child: Column(
                children: [
                  _ContactRow(
                    icon: Icons.phone,
                    color: MyColors.primary,
                    label: '+880 1841-040543',
                    onTap: () => _launch('tel:+8801841040543'),
                  ),
                  const SizedBox(height: 10),
                  _ContactRow(
                    icon: Icons.email_outlined,
                    color: MyColors.primary,
                    label: 'shamsulhoquefoundation@gmail.com',
                    onTap: () =>
                        _launch('mailto:shamsulhoquefoundation@gmail.com'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Follow Us
            _SectionCard(
              icon: Icons.share_outlined,
              iconColor: MyColors.primary,
              title: 'Follow Us',
              child: Row(
                children: [
                  _SocialBtn(
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    icon: Icons.facebook,
                    onTap: () =>
                        _launch('https://www.facebook.com/helpnhelper'),
                  ),
                  const SizedBox(width: 12),
                  _SocialBtn(
                    label: 'Website',
                    color: MyColors.primary,
                    icon: Icons.language,
                    onTap: () => _launch('https://helpnhelper.com'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Location — Embedded Leaflet map
            _SectionCard(
              icon: Icons.map_outlined,
              iconColor: MyColors.primary,
              title: 'Location',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: WebViewWidget(controller: _mapController),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () =>
                            _launch('https://maps.google.com/?q=$_lat,$_lng'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          color: Colors.black.withOpacity(0.55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.open_in_new,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Open in Google Maps',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
// Section Card
// ════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  const _SectionCard(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.5,
                height: 20,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════
// Contact Row
// ════════════════════════════════════════════
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ContactRow(
      {required this.icon,
      required this.color,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: color,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: color.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════
// Social Button
// ════════════════════════════════════════════
class _SocialBtn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _SocialBtn(
      {required this.label,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
