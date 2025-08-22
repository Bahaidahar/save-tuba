import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: Column(
        children: [
          // Фото профиля
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary,
                width: 3.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascot.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 50.w,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Имя пользователя
          Text(
            'Тюба Антилопов',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'InstrumentSans',
            ),
          ),

          SizedBox(height: 8.h),

          // Email
          Text(
            'tuba.antelope@save-tuba.kz',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontFamily: 'InstrumentSans',
            ),
          ),
        ],
      ),
    );
  }
}
