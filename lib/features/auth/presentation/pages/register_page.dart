import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/repositories/repositories.dart';

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
  final ApiRepository _apiRepository = ApiRepository();

  // Add state variables for validation and loading
  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;
  bool _isLoading = false;

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
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = "Password must be at least 6 characters";
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
        _firstNameError = "First name is required";
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
        _lastNameError = "Last name is required";
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
                    "Sign Up",
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
                          label: "Email",
                          hintText: "Enter your email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorMessage: _emailError,
                        ),

                        SizedBox(height: 20.h),

                        // Password field
                        CustomInputField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          obscureText: true,
                          errorMessage: _passwordError,
                        ),

                        SizedBox(height: 20.h),

                        // First name field
                        CustomInputField(
                          label: "First Name",
                          hintText: "Enter your first name",
                          controller: _firstNameController,
                          errorMessage: _firstNameError,
                        ),

                        SizedBox(height: 20.h),

                        // Last name field
                        CustomInputField(
                          label: "Last Name",
                          hintText: "Enter your last name",
                          controller: _lastNameController,
                          errorMessage: _lastNameError,
                        ),

                        SizedBox(height: 40.h),

                        // Sign up button
                        PrimaryButton(
                          text: "Sign Up",
                          onPressed: _isLoading ? null : _handleRegister,
                          isLoading: _isLoading,
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

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiRepository.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: 'STUDENT', // Default role for registration
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (mounted) {
        if (result.success) {
          // Registration successful, navigate to home (token is saved automatically in ApiRepository)
          context.go('/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Registration failed'),
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
