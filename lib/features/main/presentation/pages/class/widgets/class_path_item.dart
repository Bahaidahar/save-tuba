import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassPathItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final int totalItems;

  const ClassPathItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h,
        margin: EdgeInsets.only(bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Создаем равномерно распределенные позиции
            ...List.generate(totalItems, (i) {
              if (i == index) {
                // Текущий элемент - показываем круг
                return Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else {
                // Пустое место для других позиций
                return SizedBox(width: 80.w);
              }
            }),
          ],
        ),
      ),
    );
  }
}
