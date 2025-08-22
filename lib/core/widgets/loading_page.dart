import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';

class LoadingPage extends StatefulWidget {
  final String? message;
  final bool showLogo;
  final Duration? autoHideDuration;
  final VoidCallback? onAutoHideComplete;

  const LoadingPage({
    super.key,
    this.message,
    this.showLogo = true,
    this.autoHideDuration,
    this.onAutoHideComplete,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _animationController.repeat();

    // Auto-hide functionality
    if (widget.autoHideDuration != null) {
      Future.delayed(widget.autoHideDuration!, () {
        if (mounted) {
          widget.onAutoHideComplete?.call();
        }
      });
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.showLogo) ...[
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Image.asset(
                          'assets/images/mascot.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],

                    // Custom loading spinner
                    Container(
                      width: 60.w,
                      height: 60.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 3.w,
                              ),
                            ),
                          ),
                          // Animated progress arc
                          Transform.rotate(
                            angle: _rotationAnimation.value * 2 * 3.14159,
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              child: CircularProgressIndicator(
                                value: 0.3,
                                strokeWidth: 3.w,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primary,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.message != null) ...[
                      SizedBox(height: 24.h),
                      Text(
                        widget.message!,
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Convenience widget for simple loading with just spinner
class SimpleLoadingPage extends StatelessWidget {
  final String? message;

  const SimpleLoadingPage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      message: message,
      showLogo: false,
    );
  }
}

// Full loading page with logo and app name
class FullLoadingPage extends StatelessWidget {
  final String? message;

  const FullLoadingPage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      message: message,
      showLogo: true,
    );
  }
}
