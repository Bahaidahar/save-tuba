import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';
import 'package:save_tuba/core/services/user_data_service.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class LeaderboardCard extends StatefulWidget {
  const LeaderboardCard({super.key});

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  @override
  void initState() {
    super.initState();
    // Load the user's classroom leaderboard
    context.read<LeaderboardBloc>().add(LoadMyClassroomLeaderboard());
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      title: context.l10n.leaderboard,
      child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LeaderboardError) {
            return _buildErrorState(state.message);
          } else if (state is LeaderboardLoaded) {
            return _buildLeaderboardContent(state.leaderboard, context);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load leaderboard',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'InstrumentSans',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
              fontFamily: 'InstrumentSans',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<LeaderboardBloc>().add(RefreshLeaderboard());
            },
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Icon(
            Icons.leaderboard_outlined,
            size: 48.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'No leaderboard data',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'InstrumentSans',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Join a classroom to see the leaderboard',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
              fontFamily: 'InstrumentSans',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent(
      LeaderboardResponse leaderboard, BuildContext context) {
    final currentUser = UserDataService.instance.getCurrentUser(context);
    final currentUserId = currentUser?.id;

    if (leaderboard.students.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeaderboardBloc>().add(RefreshLeaderboard());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show classroom name or global indicator
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              leaderboard.classroomName != null
                  ? leaderboard.classroomName!
                  : 'Global Leaderboard',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
                fontFamily: 'InstrumentSans',
              ),
            ),
          ),

          // Show top 5 students
          ...leaderboard.students.take(5).map((student) {
            final isCurrentUser = currentUserId == student.studentId;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildLeaderboardItem(
                rank: student.position,
                name: '${student.firstName} ${student.lastName}',
                xp: '${student.experiencePoints} XP',
                level: student.level,
                avatarUrl: student.avatarUrl,
                isCurrentUser: isCurrentUser,
                trophy: _getTrophyForRank(student.position),
                trophyColor: _getTrophyColorForRank(student.position),
                rankColor: _getRankColorForRank(student.position),
              ),
            );
          }).toList(),

          // Show "View More" button if there are more students
          if (leaderboard.students.length > 5) ...[
            SizedBox(height: 8.h),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to full leaderboard page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.fullLeaderboardComingSoon),
                    ),
                  );
                },
                child: Text(
                  'View All ${leaderboard.totalStudents} Students',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.primary,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData? _getTrophyForRank(int rank) {
    if (rank <= 3) {
      return Icons.emoji_events;
    }
    return null;
  }

  Color? _getTrophyColorForRank(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400];
      case 3:
        return Colors.orange;
      default:
        return null;
    }
  }

  Color _getRankColorForRank(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey[300]!;
    }
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required String xp,
    required int level,
    String? avatarUrl,
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
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 24.w,
                          color: Colors.grey[400],
                        );
                      },
                    )
                  : isCurrentUser
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
                Row(
                  children: [
                    Text(
                      xp,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontFamily: 'InstrumentSans',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Lv.$level',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'InstrumentSans',
                        ),
                      ),
                    ),
                  ],
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
