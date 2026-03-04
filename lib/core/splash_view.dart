import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/core/dashboard.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class SplashView extends StatefulWidget {
  SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _bgController;
  late AnimationController _taglineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _bgAnim;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Background animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_bgController);

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _logoController.forward().then((_) {
      _taglineController.forward();
    });

    // Navigate after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      Get.offAll(() => const Dashboard());
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF0D1F2D),
                    const Color(0xFF0A2E1E),
                    _bgAnim.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF0A2E1E),
                    MyColors.primary.withOpacity(0.8),
                    _bgAnim.value,
                  )!,
                  Color.lerp(
                    MyColors.primaryDark,
                    const Color(0xFF0D1F2D),
                    _bgAnim.value,
                  )!,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                _buildCircle(size.width * 0.7, -60, 200,
                    MyColors.primary.withOpacity(0.10)),
                _buildCircle(-80, size.height * 0.15, 250,
                    MyColors.primaryDark.withOpacity(0.12)),
                _buildCircle(size.width * 0.4, size.height * 0.75, 180,
                    MyColors.primary.withOpacity(0.08)),
                _buildCircle(-40, size.height * 0.65, 140,
                    Colors.white.withOpacity(0.04)),
                _buildCircle(size.width * 0.8, size.height * 0.5, 120,
                    MyColors.accent.withOpacity(0.07)),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) => Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: child,
                          ),
                        ),
                        child: Container(
                          width: 160,
                          height: 160,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.primary.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/log.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // App name
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, _) => Opacity(
                          opacity: _logoOpacity.value,
                          child: const Text(
                            'helpNhelper',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tagline with slide animation
                      SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineOpacity,
                          child: Text(
                            'Connecting Hearts, Changing Lives',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom powered by / loading indicator
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _taglineOpacity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircle(double left, double top, double size, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
