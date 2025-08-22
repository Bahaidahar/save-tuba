import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/features/main/domain/constants/base_user.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

import '../../../widgets/widget_wrapper.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return WidgetWrapper(
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
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
                      size: 40.w,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Имя и фамилия
          Text(
            baseUser.getFullName(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'InstrumentSans',
            ),
          ),

          SizedBox(height: 8.h),

          // Текущий уровень
          Text(
            l10n.levelNumber.replaceAll('{number}', '5'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
              fontFamily: 'InstrumentSans',
            ),
          ),

          SizedBox(height: 20.h),

          // Прогресс бар до следующего уровня
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.progressToNextLevel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                  Text(
                    '75%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Прогресс бар
              Container(
                width: double.infinity,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                l10n.xpFormat
                    .replaceAll('{current}', '3750')
                    .replaceAll('{total}', '5000'),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontFamily: 'InstrumentSans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
