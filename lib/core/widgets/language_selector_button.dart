import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:save_tuba/core/bloc/language/language_bloc.dart';
import 'package:save_tuba/core/services/language_service.dart';
import 'package:save_tuba/core/widgets/language_bottom_sheet.dart';

class LanguageSelectorButton extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool showText;
  final String? customText;
  final VoidCallback? onLanguageChanged;

  const LanguageSelectorButton({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.showText = true,
    this.customText,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageLoaded) {
          onLanguageChanged?.call();
        }
      },
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          String currentLanguage = 'en';
          if (state is LanguageLoaded) {
            currentLanguage = state.languageCode;
          }

          return GestureDetector(
            onTap: () {
              showLanguageBottomSheet(context);
            },
            child: Container(
              width: width,
              height: height,
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white.withOpacity(0.2),
                borderRadius: borderRadius ?? BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flag icon
                  Container(
                    width: 24.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: SvgPicture.asset(
                        _getFlagAsset(currentLanguage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  if (showText) ...[
                    SizedBox(width: 8.w),
                    // Language text
                    Text(
                      customText ??
                          LanguageService.getLanguageName(currentLanguage),
                      style: TextStyle(
                        fontSize: fontSize ?? 14.sp,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        color: textColor ?? Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    // Dropdown arrow
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: textColor ?? Colors.white,
                      size: 16.sp,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
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
}

// Compact version for small spaces
class CompactLanguageButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onLanguageChanged;

  const CompactLanguageButton({
    super.key,
    this.width,
    this.height,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageLoaded) {
          onLanguageChanged?.call();
        }
      },
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          String currentLanguage = 'en';
          if (state is LanguageLoaded) {
            currentLanguage = state.languageCode;
          }

          return GestureDetector(
            onTap: () {
              showLanguageBottomSheet(context);
            },
            child: Container(
              width: width ?? 32.w,
              height: height ?? 24.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: SvgPicture.asset(
                  _getFlagAsset(currentLanguage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
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
}
