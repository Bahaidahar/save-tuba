import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/repositories/repositories.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

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
  final ApiRepository _apiRepository = ApiRepository();

  // Add state variables for validation and loading
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

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
        _emailError = "Email is required";
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() {
        _emailError = "Please enter a valid email";
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
        _passwordError = "Password is required";
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
                    "Login",
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
                          label: "Email",
                          hintText: "Enter your email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorMessage: _emailError,
                        ),

                        SizedBox(height: 24.h),

                        // Password field
                        CustomInputField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          obscureText: true,
                          errorMessage: _passwordError,
                        ),

                        SizedBox(height: 16.h),

                        // Forgot password link
                        Center(
                          child: CustomTextButton(
                            text: "Forgot Password?",
                            onPressed: () {
                              context.push(ForgotPasswordPage.route);
                            },
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Go button
                        PrimaryButton(
                          text: "Login",
                          onPressed: _isLoading ? null : _handleLogin,
                          isLoading: _isLoading,
                        ),

                        SizedBox(height: 20.h),

                        // Sign up button
                        SecondaryButton(
                          text: "Sign Up",
                          onPressed: _isLoading
                              ? null
                              : () {
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
                  text: "Back",
                  onPressed: _isLoading
                      ? null
                      : () {
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

  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (result.success) {
          // Login successful, navigate to home (token is saved automatically in ApiRepository)
          context.go('/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorOccurred(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
