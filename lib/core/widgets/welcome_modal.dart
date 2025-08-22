import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:save_tuba/core/theme/app_theme.dart';
import 'package:save_tuba/core/widgets/bottom_modal_content.dart';
import 'package:save_tuba/core/localization/app_localizations.dart';

class WelcomeModal extends StatelessWidget {
  final VoidCallback? onContinue;

  const WelcomeModal({
    super.key,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return BottomModalContent(
      children: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    padding: EdgeInsets.all(6.w),
                    minimumSize: Size(24.w, 24.h),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/close_modal.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Title
            Text(
              AppLocalizations.of(context).welcomeModalTitle,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'InstrumentSans',
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Introduction text
            Text(
              AppLocalizations.of(context).welcomeModalIntro,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                fontFamily: 'InstrumentSans',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            // Welcome image
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/welcome.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Mission text
            Text(
              AppLocalizations.of(context).welcomeModalMission,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                fontFamily: 'InstrumentSans',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onContinue?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context).welcomeModalContinue,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
