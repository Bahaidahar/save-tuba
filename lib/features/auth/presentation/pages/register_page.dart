import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/localization/localization_extension.dart';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Add state variables for validation
  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = context.l10n.passwordMinLength;
      });
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    // Validate first name
    if (_firstNameController.text.isEmpty) {
      setState(() {
        _firstNameError = context.l10n.pleaseEnterFirstName;
      });
      isValid = false;
    } else {
      setState(() {
        _firstNameError = null;
      });
    }

    // Validate last name
    if (_lastNameController.text.isEmpty) {
      setState(() {
        _lastNameError = context.l10n.pleaseEnterLastName;
      });
      isValid = false;
    } else {
      setState(() {
        _lastNameError = null;
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
                    context.l10n.signUp,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

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

                        SizedBox(height: 20.h),

                        // Password field
                        CustomInputField(
                          label: context.l10n.password,
                          hintText: context.l10n.password,
                          controller: _passwordController,
                          obscureText: true,
                          errorMessage:
                              _passwordError, // Pass error message directly
                        ),

                        SizedBox(height: 20.h),

                        // First name field
                        CustomInputField(
                          label: context.l10n.firstName,
                          hintText: context.l10n.firstName,
                          controller: _firstNameController,
                          errorMessage:
                              _firstNameError, // Pass error message directly
                        ),

                        SizedBox(height: 20.h),

                        // Last name field
                        CustomInputField(
                          label: context.l10n.lastName,
                          hintText: context.l10n.lastName,
                          controller: _lastNameController,
                          errorMessage:
                              _lastNameError, // Pass error message directly
                        ),

                        SizedBox(height: 40.h),

                        // Sign up button
                        PrimaryButton(
                          text: context.l10n.signUp,
                          onPressed: () {
                            if (_validateForm()) {
                              // Handle registration
                              context.go('/home');
                            }
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
