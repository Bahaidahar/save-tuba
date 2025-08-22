import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/localization/localization_extension.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add state variables for validation
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Custom validation method
  bool _validateForm() {
    bool isValid = true;

    // Validate email
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = context.l10n.pleaseEnterEmail;
      });
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        _emailError = context.l10n.pleaseEnterValidEmail;
      });
      isValid = false;
    } else {
      setState(() {
        _emailError = null;
      });
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = context.l10n.pleaseEnterPassword;
      });
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            children: [
              // Top section with title
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.signIn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // Form section
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email field
                        CustomInputField(
                          label: context.l10n.email,
                          hintText: context.l10n.email,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorMessage:
                              _emailError, // Pass error message directly
                        ),

                        SizedBox(height: 24.h),

                        // Password field
                        CustomInputField(
                          label: context.l10n.password,
                          hintText: context.l10n.password,
                          controller: _passwordController,
                          obscureText: true,
                          errorMessage:
                              _passwordError, // Pass error message directly
                        ),

                        SizedBox(height: 16.h),

                        // Forgot password link
                        Center(
                          child: CustomTextButton(
                            text: context.l10n.forgotPassword,
                            onPressed: () {
                              // Handle forgot password
                            },
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Go button
                        PrimaryButton(
                          text: context.l10n.go,
                          onPressed: () {
                            if (_validateForm()) {
                              // Handle login
                              context.go('/home');
                            }
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Sign up button
                        SecondaryButton(
                          text: context.l10n.signUp,
                          onPressed: () {
                            context.push(RegisterPage.route);
                          },
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Back button at the bottom
              Center(
                child: CustomTextButton(
                  text: context.l10n.back,
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
