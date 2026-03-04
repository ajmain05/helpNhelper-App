import 'package:flutter/material.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareButton extends StatelessWidget {
  final String shareUrl;
  final String shareTitle;

  const ShareButton({
    Key? key,
    required this.shareUrl,
    this.shareTitle = 'Check this out on helpNhelper!',
  }) : super(key: key);

  void _share(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareBottomSheet(
        shareUrl: shareUrl,
        shareTitle: shareTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _share(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: MyColors.primary.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share_outlined, color: MyColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Share',
              style: TextStyle(
                color: MyColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareBottomSheet extends StatelessWidget {
  final String shareUrl;
  final String shareTitle;

  const _ShareBottomSheet({
    required this.shareUrl,
    required this.shareTitle,
  });

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String get _encodedUrl => Uri.encodeComponent(shareUrl);
  String get _encodedTitle => Uri.encodeComponent(shareTitle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Share via',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShareOption(
                icon: 'f',
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => _openUrl(
                  'https://www.facebook.com/sharer/sharer.php?u=$_encodedUrl',
                ),
              ),
              _ShareOption(
                icon: 'x',
                label: 'Twitter / X',
                color: const Color(0xFF000000),
                onTap: () => _openUrl(
                  'https://twitter.com/intent/tweet?url=$_encodedUrl&text=$_encodedTitle',
                ),
              ),
              _ShareOption(
                icon: 'in',
                label: 'LinkedIn',
                color: const Color(0xFF0A66C2),
                onTap: () => _openUrl(
                  'https://www.linkedin.com/sharing/share-offsite/?url=$_encodedUrl',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
