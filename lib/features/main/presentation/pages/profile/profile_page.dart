import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/features/main/presentation/pages/profile/widgets/class_info_card.dart';
import 'package:save_tuba/features/main/presentation/pages/profile/widgets/logout_button.dart';
import 'widgets/actions_card.dart';
import 'widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Первый блок - Фото и почта
              const ProfileCard(),

              SizedBox(height: 20.h),

              // Второй блок - Информация о классе
              const ClassInfoCard(),

              SizedBox(height: 20.h),

              // Третий блок - Кнопки действий
              const ActionsCard(),

              SizedBox(height: 20.h),

              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
