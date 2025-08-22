import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/services/services.dart';
import 'package:save_tuba/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:save_tuba/features/main/presentation/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String route = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();

    // Check auth status and navigate after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_hasNavigated) {
        _checkAuthStatusAndNavigate();
      }
    });
  }

  Future<void> _checkAuthStatusAndNavigate() async {
    if (_hasNavigated) return;

    try {
      // Wait a bit more for the animation to fully complete
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted || _hasNavigated) return;

      // Check authentication status
      final authService = await AuthService.instance;
      final isAuthenticated = await authService.isAuthenticated();

      if (!mounted || _hasNavigated) return;

      // Navigate based on authentication status
      if (isAuthenticated) {
        // User is authenticated, go to home page
        _hasNavigated = true;
        context.go(HomePage.route);
      } else {
        // User is not authenticated, go to onboarding
        _hasNavigated = true;
        context.go(OnboardingPage.route);
      }
    } catch (e) {
      // If there's an error checking auth status, default to onboarding
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        context.go(OnboardingPage.route);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Image.asset(
                            'assets/images/mascot.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'SAVE TUBA!',
                          style: TextStyle(
                            fontFamily: 'InstrumentSans',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary, // Olive green color
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
