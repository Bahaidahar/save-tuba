import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable error message widget that displays validation errors
/// with a consistent design across the app.
///
/// Features:
/// - Red background with transparency
/// - Red border
/// - Error icon
/// - Consistent typography
/// - Proper spacing and padding
///
/// Usage example:
/// ```dart
/// if (errorMessage != null)
///   CustomErrorMessage(message: errorMessage!)
/// ```
class CustomErrorMessage extends StatelessWidget {
  final String message;

  const CustomErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final Color? labelColor;
  final Color? fillColor;
  final double borderRadius;
  final double? height;
  final String? errorMessage; // Add error message parameter

  const CustomInputField({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.labelColor,
    this.fillColor,
    this.borderRadius = 40.0,
    this.height,
    this.errorMessage, // Add to constructor
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              color: widget.labelColor ?? Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: widget.height ?? 56,
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText ? _isObscured : false,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: widget.fillColor ?? Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      )
                    : widget.suffixIcon,
                // Completely disable built-in error display
                errorText: null,
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
        ),
        // Show custom error message if provided
        if (widget.errorMessage != null)
          CustomErrorMessage(message: widget.errorMessage!),
      ],
    );
  }
}
