import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/onboading_bg.svg',
            width: 390.w,
            height: 369.h,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7),
              BlendMode.srcIn,
            ),
            // Добавляем обработку ошибок если файл не найден
            placeholderBuilder: (context) => Container(
              width: 390.w,
              height: 369.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/onboading_bg.svg',
            width: 390.w,
            height: 369.h,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7),
              BlendMode.srcIn,
            ),
            // Добавляем обработку ошибок если файл не найден
            placeholderBuilder: (context) => Container(
              width: 390.w,
              height: 369.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






