import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

enum ButtonVariant {
  primary, // Green background, white text
  secondary, // White background, colored text
  text, // No background, colored text
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;
  final bool isLoading;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.isLoading = false,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final defaultHeight = height ?? 50.h;
    final defaultBorderRadius = borderRadius ?? 40.r;
    final defaultFontSize = fontSize ?? 16.sp;
    final defaultFontWeight = fontWeight ?? FontWeight.w400;

    // Define colors based on variant
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;

      switch (variant) {
        case ButtonVariant.primary:
          return AppTheme.secondary; // Use secondary color from app theme
        case ButtonVariant.secondary:
          return Colors.white;
        case ButtonVariant.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;

      switch (variant) {
        case ButtonVariant.primary:
          return Colors.white;
        case ButtonVariant.secondary:
          return AppTheme.secondary;
        case ButtonVariant.text:
          return Colors.white;
      }
    }

    Color? getBorderColor() {
      if (borderColor != null) return borderColor!;

      switch (variant) {
        default:
          return null;
      }
    }

    double getElevation() {
      if (elevation != null) return elevation!;

      switch (variant) {
        case ButtonVariant.primary:
        case ButtonVariant.secondary:
          return 0;
        case ButtonVariant.text:
          return 0;
      }
    }

    Widget buildButtonContent() {
      if (isLoading) {
        return SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: getTextColor(),
          ),
        );
      }

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon!,
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                fontSize: defaultFontSize,
                fontWeight: defaultFontWeight,
                color: getTextColor(),
              ),
            ),
          ],
        );
      }

      return Text(
        text,
        style: TextStyle(
          fontSize: defaultFontSize,
          fontWeight: defaultFontWeight,
          color: getTextColor(),
        ),
      );
    }

    if (variant == ButtonVariant.text) {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w),
          minimumSize: Size(double.infinity, 50.h),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w),
          child: buildButtonContent(),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: defaultHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: getBorderColor() != null
                ? BorderSide(color: getBorderColor()!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: getElevation(),
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        child: buildButtonContent(),
      ),
    );
  }
}

// Convenience constructors for each button type
class PrimaryButton extends CustomButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.width,
    super.height,
    super.borderRadius,
    super.fontSize,
    super.fontWeight,
    super.icon,
    super.isLoading = false,
  }) : super(variant: ButtonVariant.primary);
}

class SecondaryButton extends CustomButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.width,
    super.height,
    super.borderRadius,
    super.fontSize,
    super.fontWeight,
    super.icon,
    super.isLoading = false,
  }) : super(variant: ButtonVariant.secondary);
}

class CustomTextButton extends CustomButton {
  const CustomTextButton({
    super.key,
    required super.text,
    super.onPressed,
    super.fontSize,
    super.fontWeight,
    super.icon,
    super.isLoading = false,
  }) : super(variant: ButtonVariant.text);
}
