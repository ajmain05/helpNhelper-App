import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/pages/login/sign_in_page.dart';
import 'package:helpnhelper/pages/login/sign_up_page_1.dart';
import 'package:helpnhelper/utils/global_size.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0F1117) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Top image
          SizedBox(
            height: GlobalSize.height(240),
            width: double.infinity,
            child: Image.asset(
              "assets/bg1.png",
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Logo
                    SizedBox(
                      height: GlobalSize.height(110),
                      child: Center(child: Image.asset("assets/log.png")),
                    ),

                    // Welcome text
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "your home for help",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Create Account button
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpPage1());
                      },
                      child: Container(
                        height: GlobalSize.height(55),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: MyColors.appColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                          child: Text(
                            "Create an Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "OR",
                      style: TextStyle(
                          color: textColor.withOpacity(0.5), fontSize: 12),
                    ),

                    const SizedBox(height: 14),

                    // Sign In button
                    GestureDetector(
                      onTap: () {
                        Get.to(SignIn());
                      },
                      child: Container(
                        height: GlobalSize.height(55),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: MyColors.appColor, width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: MyColors.appColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "By continuing to use helpNhelper, you",
                      style: TextStyle(
                          color: textColor.withOpacity(0.6), fontSize: 13),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "agree to the helpNhelper",
                            style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 13),
                            children: [
                          TextSpan(
                            text: " terms",
                            style: TextStyle(
                                color: MyColors.appColor, fontSize: 13),
                          ),
                          TextSpan(
                            text: " and",
                            style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 13),
                          ),
                          TextSpan(
                            text: " privacy policy",
                            style: TextStyle(
                                color: MyColors.appColor, fontSize: 13),
                          )
                        ])),

                    const SizedBox(height: 30),
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
