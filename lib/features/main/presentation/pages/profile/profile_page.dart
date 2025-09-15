import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/pages/profile/widgets/class_info_card.dart';
import 'package:save_tuba/features/main/presentation/pages/profile/widgets/logout_button.dart';
import 'widgets/actions_card.dart';
import 'widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            backgroundColor: AppTheme.primary,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (state is UserError) {
          return Scaffold(
            backgroundColor: AppTheme.primary,
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${context.l10n.error}: ${state.message}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(LoadUserProfile());
                      },
                      child: Text(context.l10n.go),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
      },
    );
  }
}
