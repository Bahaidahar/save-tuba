import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';

import 'widgets/leaderboard_card.dart';
import 'widgets/rewards_card.dart';
import 'widgets/user_profile_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Первый блок - Профиль пользователя
              const UserProfileCard(),

              SizedBox(height: 20.h),

              // Второй блок - Награды
              const RewardsCard(),

              SizedBox(height: 20.h),

              // Третий блок - Лидерборд
              const LeaderboardCard(),
            ],
          ),
        ),
      ),
    );
  }
}
