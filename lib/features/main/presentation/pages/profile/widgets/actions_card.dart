import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:save_tuba/core/bloc/language/language_bloc.dart';
import 'package:save_tuba/core/localization/localization_extension.dart';
import 'package:save_tuba/core/services/language_service.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/widgets/language_bottom_sheet.dart';
import 'package:save_tuba/features/main/presentation/widgets/widget_wrapper.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WidgetWrapper(
      title: l10n.settings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Кнопка смены языка
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              String currentLanguage = 'en';
              if (state is LanguageLoaded) {
                currentLanguage = state.languageCode;
              }

              return _buildActionButton(
                context: context,
                icon: Icons.language,
                title: l10n.changeLanguage,
                subtitle: LanguageService.getLanguageName(currentLanguage),
                onTap: () {
                  showLanguageBottomSheet(context);
                },
                child: _buildLanguageFlag(currentLanguage),
              );
            },
          ),

          SizedBox(height: 12.h),

          // Кнопка Classroom
          _buildActionButton(
            context: context,
            icon: Icons.school,
            title: l10n.classroom,
            subtitle: l10n.accessYourClasses,
            onTap: () {
              context.go('/classroom');
            },
          ),

          SizedBox(height: 12.h),

          // Кнопка поддержки
          _buildActionButton(
            context: context,
            icon: Icons.support_agent,
            title: l10n.support,
            subtitle: l10n.getHelp,
            onTap: () {
              // Открыть страницу поддержки
            },
          ),

          SizedBox(height: 12.h),

          // Кнопка "О нас"
          _buildActionButton(
            context: context,
            icon: Icons.info,
            title: l10n.aboutUs,
            subtitle: l10n.learnMoreAboutApp,
            onTap: () {
              // Открыть страницу "О нас"
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageFlag(String languageCode) {
    return Container(
      width: 24.w,
      height: 18.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.r),
        child: SvgPicture.asset(
          _getFlagAsset(languageCode),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _getFlagAsset(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'assets/icons/rus.svg';
      case 'kz':
        return 'assets/icons/kz.svg';
      default:
        return 'assets/icons/usa.svg';
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                ],
              ),
            ),
            if (child != null) ...[
              SizedBox(width: 8.w),
              child,
            ] else ...[
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
