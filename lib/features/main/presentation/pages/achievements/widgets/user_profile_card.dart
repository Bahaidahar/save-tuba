import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

import '../../../widgets/widget_wrapper.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String userName = 'Loading...';
        String userLevel = 'Loading...';
        String? avatarUrl;
        int experiencePoints = 0;
        double progressPercentage = 0.0;
        int currentXP = 0;
        int totalXP = 5000; // Default total XP for next level

        if (state is UserLoaded) {
          final user = state.user;
          userName = '${user.firstName} ${user.lastName}'.trim();
          avatarUrl = user.avatarUrl;
          experiencePoints = user.experiencePoints;

          // Calculate level and progress (simplified calculation)
          int level = (experiencePoints / 1000).floor() + 1;
          userLevel = l10n.levelNumber.replaceAll('{number}', level.toString());

          // Calculate progress to next level
          int xpForCurrentLevel = (level - 1) * 1000;
          int xpForNextLevel = level * 1000;
          currentXP = experiencePoints - xpForCurrentLevel;
          totalXP = xpForNextLevel - xpForCurrentLevel;
          progressPercentage = currentXP / totalXP;
        } else if (state is UserError) {
          userName = 'Error loading profile';
          userLevel = 'Please try again';
        }

        return WidgetWrapper(
          child: Column(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: 3.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatarUrl != null && avatarUrl.isNotEmpty
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : Image.asset(
                          'assets/images/mascot.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        ),
                ),
              ),

              SizedBox(height: 16.h),

              // Имя и фамилия
              Text(
                userName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'InstrumentSans',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              // Текущий уровень
              Text(
                userLevel,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  fontFamily: 'InstrumentSans',
                ),
              ),

              SizedBox(height: 20.h),

              // Прогресс бар до следующего уровня
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.progressToNextLevel,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          fontFamily: 'InstrumentSans',
                        ),
                      ),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          fontFamily: 'InstrumentSans',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Прогресс бар
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressPercentage.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    l10n.xpFormat
                        .replaceAll('{current}', currentXP.toString())
                        .replaceAll('{total}', totalXP.toString()),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 40.w,
        color: Colors.grey[400],
      ),
    );
  }
}
