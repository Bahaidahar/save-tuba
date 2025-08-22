import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:save_tuba/core/bloc/language/language_bloc.dart';
import 'package:save_tuba/core/services/language_service.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomModalContent(
      children: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language options
          _buildLanguageOption(
            flag: 'assets/icons/usa.svg',
            language: LanguageService.getLanguageName('en'),
            onTap: () => _selectLanguage(context, 'en'),
          ),
          SizedBox(height: 16.h),
          _buildLanguageOption(
            flag: 'assets/icons/rus.svg',
            language: LanguageService.getLanguageName('ru'),
            onTap: () => _selectLanguage(context, 'ru'),
          ),
          SizedBox(height: 16.h),
          _buildLanguageOption(
            flag: 'assets/icons/kz.svg',
            language: LanguageService.getLanguageName('kz'),
            onTap: () => _selectLanguage(context, 'kz'),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String language,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          overlayColor: AppTheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 20.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 26.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  flag,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              language,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLanguage(BuildContext context, String languageCode) {
    Navigator.pop(context);
    context.read<LanguageBloc>().add(ChangeLanguage(languageCode));
  }
}

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const LanguageBottomSheet(),
  );
}
