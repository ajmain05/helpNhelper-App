import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WalletDepositScreen extends StatefulWidget {
  final String uploadUrl;

  const WalletDepositScreen({Key? key, required this.uploadUrl})
      : super(key: key);

  @override
  State<WalletDepositScreen> createState() => _WalletDepositScreenState();
}

class _WalletDepositScreenState extends State<WalletDepositScreen> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading payment gateway')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('corporate/deposit/success')) {
              Get.back(result: true); // Return success
              Get.snackbar(
                'Success!',
                'Your deposit has been added to your wallet successfully.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('corporate/deposit/cancel')) {
              Get.back(result: false);
              Get.snackbar(
                'Cancelled',
                'Your deposit was cancelled.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('corporate/deposit/failed')) {
              Get.back(result: false);
              Get.snackbar(
                'Failed',
                'Your deposit failed. Please try again.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.uploadUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet Deposit',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: MyColors.primary),
            ),
        ],
      ),
    );
  }
}
