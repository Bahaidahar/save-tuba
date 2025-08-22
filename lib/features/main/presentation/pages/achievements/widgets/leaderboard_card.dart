import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      title: context.l10n.leaderboard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaderboardItem(
            rank: 1,
            name: 'Алиса Ким',
            xp: '8750 XP',
            isCurrentUser: false,
            trophy: Icons.emoji_events,
            trophyColor: Colors.amber,
            rankColor: Colors.amber,
          ),
          SizedBox(height: 12.h),
          _buildLeaderboardItem(
            rank: 2,
            name: 'Бекзат Нурланов',
            xp: '7200 XP',
            isCurrentUser: false,
            trophy: Icons.emoji_events,
            trophyColor: Colors.grey[400]!,
            rankColor: Colors.grey[400]!,
          ),
          SizedBox(height: 12.h),
          _buildLeaderboardItem(
            rank: 3,
            name: 'Тюба Антилопов',
            xp: '6750 XP',
            isCurrentUser: true,
            trophy: Icons.emoji_events,
            trophyColor: Colors.orange,
            rankColor: Colors.orange,
          ),
          SizedBox(height: 12.h),
          _buildLeaderboardItem(
            rank: 4,
            name: 'Дария Смагулова',
            xp: '6200 XP',
            isCurrentUser: false,
            trophy: null,
            trophyColor: null,
            rankColor: Colors.grey[300]!,
          ),
          SizedBox(height: 12.h),
          _buildLeaderboardItem(
            rank: 5,
            name: 'Максим Петров',
            xp: '5800 XP',
            isCurrentUser: false,
            trophy: null,
            trophyColor: null,
            rankColor: Colors.grey[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required String xp,
    required bool isCurrentUser,
    IconData? trophy,
    Color? trophyColor,
    required Color rankColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppTheme.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isCurrentUser
            ? Border.all(color: AppTheme.primary, width: 2.w)
            : Border.all(color: Colors.grey[200]!, width: 1.w),
      ),
      child: Row(
        children: [
          // Ранг
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: rankColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'InstrumentSans',
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Аватар
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: isCurrentUser
                  ? Border.all(color: AppTheme.primary, width: 2.w)
                  : null,
            ),
            child: ClipOval(
              child: isCurrentUser
                  ? Image.asset(
                      'assets/images/mascot.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 24.w,
                          color: Colors.grey[400],
                        );
                      },
                    )
                  : Icon(
                      Icons.person,
                      size: 24.w,
                      color: Colors.grey[400],
                    ),
            ),
          ),

          SizedBox(width: 16.w),

          // Имя и XP
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser ? AppTheme.primary : Colors.black87,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
                Text(
                  xp,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ],
            ),
          ),

          // Трофей
          if (trophy != null)
            Icon(
              trophy,
              color: trophyColor,
              size: 24.w,
            ),
        ],
      ),
    );
  }
}
