import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens a URL inside the app using WebView (no external browser).
class InAppWebPage extends StatefulWidget {
  final String url;
  final String title;
  final String? javascriptInjection;

  const InAppWebPage(
      {Key? key,
      required this.url,
      required this.title,
      this.javascriptInjection})
      : super(key: key);

  @override
  State<InAppWebPage> createState() => _InAppWebPageState();
}

class _InAppWebPageState extends State<InAppWebPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _scriptInjected = false;
  double _loadingOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _isLoading = true;
          _loadingOpacity = 1.0;
        }),
        onPageFinished: (String url) async {
          if (widget.javascriptInjection != null &&
              widget.javascriptInjection!.isNotEmpty &&
              !_scriptInjected &&
              url.contains('helpnhelper.com')) {
            _scriptInjected = true;
            await _controller.runJavaScript(widget.javascriptInjection!);
          }
          // Always fade out and hide the loader after page finishes
          if (mounted) {
            setState(() => _loadingOpacity = 0.0);
            await Future.delayed(const Duration(milliseconds: 300));
            if (mounted) setState(() => _isLoading = false);
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            AnimatedOpacity(
              opacity: _loadingOpacity,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: MyColors.primary),
                      const SizedBox(height: 16),
                      Text('Loading...',
                          style: GoogleFonts.poppins(
                              color: MyColors.primary, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
