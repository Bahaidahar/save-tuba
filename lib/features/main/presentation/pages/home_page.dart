import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/widgets/welcome_modal.dart';
import 'package:save_tuba/core/services/welcome_service.dart';
import 'achievements/achievements_page.dart';
import 'class/class_page.dart';
import 'tasks_page.dart';
import 'profile/profile_page.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AchievementsPage(),
    const ClassPage(),
    const TasksPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Check if welcome modal has been shown before
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWelcomeModal();
    });
  }

  Future<void> _checkAndShowWelcomeModal() async {
    try {
      final welcomeService = await WelcomeService.instance;
      final hasSeenWelcomeModal = await welcomeService.hasSeenWelcomeModal();

      if (!hasSeenWelcomeModal) {
        _showWelcomeModal();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking welcome modal status: $e');
      }
    }
  }

  void _showWelcomeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WelcomeModal(),
    ).then((_) {
      // Mark welcome modal as seen when it's closed
      _markWelcomeModalAsSeen();
    });
  }

  Future<void> _markWelcomeModalAsSeen() async {
    try {
      final welcomeService = await WelcomeService.instance;
      await welcomeService.markWelcomeModalAsSeen();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error marking welcome modal as seen: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/icons/achivments.svg'),
              _buildNavItem(1, 'assets/icons/class.svg'),
              _buildNavItem(2, 'assets/icons/tasks.svg'),
              _buildNavItem(3, 'assets/icons/profile.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24.w,
          height: 24.h,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.grey[400]!,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
