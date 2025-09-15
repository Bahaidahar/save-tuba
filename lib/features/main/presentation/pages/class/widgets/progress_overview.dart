import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressOverview extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;

  const ProgressOverview({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Заголовок с иконкой
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getProgressIcon(progress),
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Прогресс бар с улучшенным дизайном
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 100
                    ? const Color.fromRGBO(116, 136, 21, 1)
                    : Colors.white,
              ),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),

          // Подзаголовок с эмодзи
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getProgressEmoji(progress),
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(width: 4.w),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getProgressIcon(double progress) {
    if (progress >= 100) {
      return Icons.emoji_events; // Трофей
    } else if (progress >= 75) {
      return Icons.trending_up; // Растущий тренд
    } else if (progress >= 50) {
      return Icons.timeline; // Прогресс
    } else if (progress >= 25) {
      return Icons.play_arrow; // Начало
    } else {
      return Icons.flag; // Старт
    }
  }

  String _getProgressEmoji(double progress) {
    if (progress >= 100) {
      return '🏆'; // Трофей
    } else if (progress >= 90) {
      return '🌟'; // Звезда
    } else if (progress >= 75) {
      return '🔥'; // Огонь
    } else if (progress >= 50) {
      return '💪'; // Сила
    } else if (progress >= 25) {
      return '🚀'; // Ракета
    } else {
      return '🌱'; // Росток
    }
  }
}
