import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:save_tuba/core/bloc/bloc.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String userName = context.l10n.loading;
        String userEmail = context.l10n.loading;
        String? avatarUrl;

        if (state is UserLoaded) {
          final user = state.user;
          userName = '${user.firstName} ${user.lastName}'.trim();
          userEmail = user.email;
          avatarUrl = user.avatarUrl;
        } else if (state is UserError) {
          userName = context.l10n.errorLoadingProfile;
          userEmail = context.l10n.pleaseTryAgain;
        }

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
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatarUrl != null && avatarUrl.isNotEmpty
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : Image.asset(
                          'assets/images/mascot.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        ),
                ),
              ),

              SizedBox(height: 16.h),

              // Имя пользователя
              Text(
                userName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'InstrumentSans',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              // Email
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontFamily: 'InstrumentSans',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 50.w,
        color: Colors.grey[400],
      ),
    );
  }
}
