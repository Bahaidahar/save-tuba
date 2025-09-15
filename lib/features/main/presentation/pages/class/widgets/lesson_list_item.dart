import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/models/class_models.dart';

class LessonListItem extends StatelessWidget {
  final LessonItem lesson;
  final int index;
  final VoidCallback onTap;

  const LessonListItem({
    super.key,
    required this.lesson,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: lesson.progress >= 100
              ? Border.all(
                  color: const Color.fromRGBO(116, 136, 21, 1),
                  width: 2.w,
                )
              : null,
        ),
        child: Row(
          children: [
            // Lesson Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: lesson.progress >= 100
                    ? const Color.fromRGBO(116, 136, 21, 1)
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: lesson.progress >= 100
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24.sp,
                      )
                    : Icon(
                        _getLessonIcon(index),
                        color: Colors.white,
                        size: 20.sp,
                      ),
              ),
            ),

            SizedBox(width: 16.w),

            // Lesson Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: lesson.progress / 100,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        lesson.progress >= 100
                            ? const Color.fromRGBO(116, 136, 21, 1)
                            : Colors.white,
                      ),
                      minHeight: 6.h,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Progress text
                  Text(
                    '${lesson.progress.toInt()}% завершено',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLessonIcon(int index) {
    switch (index % 8) {
      case 0:
        return Icons.lightbulb; // Идея/введение
      case 1:
        return Icons.code_outlined; // Код
      case 2:
        return Icons.psychology_outlined; // Понимание
      case 3:
        return Icons.engineering; // Практика
      case 4:
        return Icons.quiz; // Тест
      case 5:
        return Icons.build; // Построение
      case 6:
        return Icons.rocket_launch; // Запуск
      case 7:
        return Icons.school; // Обучение
      default:
        return Icons.assignment; // По умолчанию
    }
  }
}


