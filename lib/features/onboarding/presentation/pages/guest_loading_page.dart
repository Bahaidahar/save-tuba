import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:save_tuba/core/widgets/loading_page.dart';
import 'package:save_tuba/core/localization/app_localizations.dart';
import 'package:save_tuba/core/services/services.dart';
import 'package:save_tuba/features/main/presentation/pages/home_page.dart';

class GuestLoadingPage extends StatefulWidget {
  const GuestLoadingPage({super.key});

  static const String route = '/guest-loading';

  @override
  State<GuestLoadingPage> createState() => _GuestLoadingPageState();
}

class _GuestLoadingPageState extends State<GuestLoadingPage> {
  String _statusMessage = 'Setting up guest mode...';

  @override
  void initState() {
    super.initState();
    _performGuestLogin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the status message with proper localization once dependencies are available
    if (_statusMessage == 'Setting up guest mode...') {
      setState(() {
        _statusMessage = AppLocalizations.of(context).settingUpGuestMode;
      });
    }
  }

  Future<void> _performGuestLogin() async {
    try {
      // Perform guest login
      final authService = await AuthService.instance;
      final result = await authService.guestLogin();

      if (!mounted) return;

      if (result['success'] == true) {
        // Guest login successful
        setState(() {
          _statusMessage = 'Guest mode ready!';
        });

        // Wait a bit to show success message
        await Future.delayed(const Duration(milliseconds: 1000));

        if (!mounted) return;

        // Navigate to home page
        context.go(HomePage.route);
      } else {
        // Guest login failed
        setState(() {
          _statusMessage = result['message'] ?? 'Failed to setup guest mode';
        });

        // Wait a bit to show error message
        await Future.delayed(const Duration(milliseconds: 2000));

        if (!mounted) return;

        // Navigate back to onboarding on error
        context.go('/onboarding');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });

      // Wait a bit to show error message
      await Future.delayed(const Duration(milliseconds: 2000));

      if (!mounted) return;

      // Navigate back to onboarding on error
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      message: _statusMessage,
      showLogo: true,
      autoHideDuration: null, // We'll handle the timing manually
      onAutoHideComplete: null,
    );
  }
}
