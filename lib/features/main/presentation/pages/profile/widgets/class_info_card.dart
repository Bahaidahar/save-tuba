import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class ClassInfoCard extends StatelessWidget {
  const ClassInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      title: context.l10n.classInformation,
      // actions: Container(
      //   padding: EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(8.r),
      //   ),
      //   child: Icon(
      //     Icons.edit,
      //     color: AppTheme.primary,
      //     size: 20.w,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class code
          _buildInfoRow(
            icon: Icons.class_,
            title: context.l10n.classCode,
            value: 'SAVE-2024-001',
            iconColor: AppTheme.primary,
          ),

          SizedBox(height: 16.h),

          // Teacher
          _buildInfoRow(
            icon: Icons.person,
            title: context.l10n.teacher,
            value: 'Алан Бургерсон',
            iconColor: AppTheme.secondary,
          ),

          SizedBox(height: 16.h),

          // Number of students
          _buildInfoRow(
            icon: Icons.people,
            title: context.l10n.studentsInClass,
            value: '24',
            iconColor: AppTheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20.w,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'InstrumentSans',
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'InstrumentSans',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
