import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/models/class_models.dart';

class LessonGridItem extends StatelessWidget {
  final LessonItem lesson;
  final int index;
  final VoidCallback onTap;

  const LessonGridItem({
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            SizedBox(height: 12.h),

            // Lesson Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                lesson.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 8.h),

            // Progress
            Text(
              '${lesson.progress.toInt()}%',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
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
