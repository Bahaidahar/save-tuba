import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/models/class_models.dart';

class SectionCard extends StatelessWidget {
  final SectionItem section;
  final int index;
  final VoidCallback onTap;

  const SectionCard({
    super.key,
    required this.section,
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
        ),
        child: Row(
          children: [
            // Section Icon
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getSectionIcon(index),
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Section Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${section.lessons.length} уроков',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: section.progress / 100,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      section.progress >= 100
                          ? const Color.fromRGBO(116, 136, 21, 1)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

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

  IconData _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.play_circle_filled; // Введение
      case 1:
        return Icons.code; // Переменные и типы данных
      case 2:
        return Icons.functions; // Функции
      case 3:
        return Icons.class_; // Классы и объекты
      case 4:
        return Icons.storage; // Базы данных
      case 5:
        return Icons.web; // Веб-разработка
      case 6:
        return Icons.phone_android; // Мобильная разработка
      case 7:
        return Icons.psychology; // Машинное обучение
      case 8:
        return Icons.security; // Кибербезопасность
      case 9:
        return Icons.settings; // DevOps
      default:
        return Icons.book; // По умолчанию
    }
  }
}
