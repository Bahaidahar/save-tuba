import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutModal(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.logout,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      size: 24.w,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Content
              Text(
                l10n.logoutConfirmation,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'InstrumentSans',
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // Buttons
              Column(
                children: [
                  CustomButton(
                    text: l10n.cancel,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.grey[200],
                    textColor: Colors.grey[700],
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: l10n.logout,
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Навигация к onboarding
                      context.go('/onboarding');
                    },
                    backgroundColor: Colors.red[400],
                    textColor: Colors.white,
                    borderRadius: 12.r,
                  ),
                ],
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: l10n.logout,
        onPressed: () {
          _showLogoutModal(context);
        },
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        borderRadius: 12.r,
      ),
    );
  }
}
