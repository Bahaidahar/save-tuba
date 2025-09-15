import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';

import 'widgets/leaderboard_card.dart';
import 'widgets/rewards_card.dart';
import 'widgets/user_profile_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            backgroundColor: AppTheme.primary,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (state is UserError) {
          return Scaffold(
            backgroundColor: AppTheme.primary,
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${context.l10n.error}: ${state.message}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(LoadUserProfile());
                      },
                      child: Text(context.l10n.go),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
      },
    );
  }
}
