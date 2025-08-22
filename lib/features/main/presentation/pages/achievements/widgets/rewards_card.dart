import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class RewardsCard extends StatelessWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      title: context.l10n.rewards,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rewards grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.0,
            children: [
              _buildRewardItem(
                icon: Icons.emoji_events,
                title: context.l10n.firstVictory,
                isUnlocked: true,
                color: Colors.amber,
              ),
              _buildRewardItem(
                icon: Icons.star,
                title: context.l10n.starStudent,
                isUnlocked: true,
                color: Colors.blue,
              ),
              _buildRewardItem(
                icon: Icons.eco,
                title: context.l10n.ecoHero,
                isUnlocked: true,
                color: Colors.green,
              ),
              _buildRewardItem(
                icon: Icons.diamond,
                title: context.l10n.diamondLevel,
                isUnlocked: false,
                color: Colors.purple,
              ),
              _buildRewardItem(
                icon: Icons.workspace_premium,
                title: context.l10n.premium,
                isUnlocked: false,
                color: Colors.orange,
              ),
              _buildRewardItem(
                icon: Icons.psychology,
                title: context.l10n.sage,
                isUnlocked: false,
                color: Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem({
    required IconData icon,
    required String title,
    required bool isUnlocked,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: isUnlocked
            ? Border.all(color: color, width: 2.w)
            : Border.all(color: Colors.grey[300]!, width: 1.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32.w,
            color: isUnlocked ? color : Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
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
        ],
      ),
    );
  }
}
