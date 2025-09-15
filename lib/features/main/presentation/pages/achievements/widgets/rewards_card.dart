import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/models/api_models.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class RewardsCard extends StatelessWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BadgesBloc, BadgesState>(
      builder: (context, state) {
        if (state is BadgesLoading) {
          return WidgetWrapper(
            title: context.l10n.rewards,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is BadgesError) {
          return WidgetWrapper(
            title: context.l10n.rewards,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${context.l10n.error}: ${state.message}',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BadgesBloc>().add(LoadMyBadges());
                    },
                    child: Text(context.l10n.go),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is BadgesLoaded) {
          final badges = state.badgesResponse.allBadges;

          if (badges.isEmpty) {
            return WidgetWrapper(
              title: context.l10n.rewards,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.l10n.rewards,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.l10n.rewards,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return WidgetWrapper(
            title: context.l10n.rewards,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rewards grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return _buildBadgeItem(badge);
                  },
                ),
              ],
            ),
          );
        }

        return WidgetWrapper(
          title: context.l10n.rewards,
          child: Center(
            child: Text(context.l10n.noBadgesAvailable),
          ),
        );
      },
    );
  }

  Widget _buildBadgeItem(BadgeResponse badge) {
    final isUnlocked = badge.isUnlocked;
    final color = _getBadgeColor(badge.experiencePoints);

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? color.withValues(alpha: 0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: isUnlocked
            ? Border.all(color: color, width: 2.w)
            : Border.all(color: Colors.grey[300]!, width: 1.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getBadgeIcon(badge.name),
            size: 32.w,
            color: isUnlocked ? color : Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isUnlocked ? color : Colors.grey[400],
              fontFamily: 'InstrumentSans',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked) ...[
            SizedBox(height: 4.h),
            Text(
              '${badge.experiencePoints} XP',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'InstrumentSans',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBadgeColor(int experiencePoints) {
    if (experiencePoints >= 1000) return Colors.purple;
    if (experiencePoints >= 500) return Colors.orange;
    if (experiencePoints >= 250) return Colors.blue;
    if (experiencePoints >= 100) return Colors.green;
    return Colors.amber;
  }

  IconData _getBadgeIcon(String badgeName) {
    final name = badgeName.toLowerCase();
    if (name.contains('star') || name.contains('achievement'))
      return Icons.star;
    if (name.contains('eco') || name.contains('nature')) return Icons.eco;
    if (name.contains('diamond') || name.contains('premium'))
      return Icons.diamond;
    if (name.contains('psychology') || name.contains('mind'))
      return Icons.psychology;
    if (name.contains('workspace') || name.contains('premium'))
      return Icons.workspace_premium;
    if (name.contains('emoji') || name.contains('events'))
      return Icons.emoji_events;
    return Icons.emoji_events;
  }
}
