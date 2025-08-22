import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomModalContent extends StatelessWidget {
  final Widget children;
  const BottomModalContent({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(9.w).copyWith(bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: children,
        ));
  }
}
