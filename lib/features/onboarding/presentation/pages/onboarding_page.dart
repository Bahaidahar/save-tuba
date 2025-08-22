import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import '../widgets/education_terms_slider.dart';
import '../../../auth/presentation/pages/register_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../core/widgets/widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const String route = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            _buildBgImage(),

            // Educational terms slider
            const EducationTermsSlider(),

            // Language selector
            Positioned(
              top: 20,
              right: 20,
              child: CompactLanguageButton(
                onLanguageChanged: () {
                  // Optional: Add any additional logic when language changes
                  print('Language changed in onboarding');
                },
              ),
            ),

            // Main content - Welcome or Actions with smooth animation
            AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                bottom: _showActions ? 240 : 140,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 340.h,
                      child: _showActions
                          ? // Actions content
                          Column(
                              key: const ValueKey('actions'),
                              children: [
                                Text(
                                  AppLocalizations.of(context).welcomeTitle,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                              ],
                            )
                          : // Welcome content
                          Column(
                              key: const ValueKey('welcome'),
                              children: [
                                Text(
                                  AppLocalizations.of(context).welcomeTitle,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .welcomeSubtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ))),

            // Bottom content - Button or Actions with smooth animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              bottom: 20,
              left: _showActions ? 54 : 0,
              right: _showActions ? 54 : 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: _showActions
                    ? // Bottom buttons for actions screen
                    Column(
                        key: const ValueKey('action-buttons'),
                        children: [
                          SecondaryButton(
                            text: AppLocalizations.of(context).signUp,
                            onPressed: () {
                              context.push(RegisterPage.route);
                            },
                          ),
                          SizedBox(height: 16),
                          // Sign in button
                          CustomButton(
                            text: AppLocalizations.of(context).signIn,
                            onPressed: () {
                              context.push(LoginPage.route);
                            },
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 20),
                          // Continue as guest button
                          CustomTextButton(
                            text: AppLocalizations.of(context).continueAsGuest,
                            onPressed: () {
                              // Navigate to guest loading page first
                              context.go('/guest-loading');
                            },
                          ),
                        ],
                      )
                    : // Bottom button for welcome screen
                    Center(
                        key: const ValueKey('welcome-button'),
                        child: Material(
                          color: AppTheme.primary,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showActions = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: SvgPicture.asset('assets/icons/slide.svg'),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgImage() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: SvgPicture.asset(
        'assets/icons/onboading_bg.svg',
        width: 390.w,
        height: 369.h,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
