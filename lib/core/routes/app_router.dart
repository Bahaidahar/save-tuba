import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/guest_loading_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/main/presentation/pages/home_page.dart';
import '../../features/main/presentation/pages/class/class_page.dart';
import '../widgets/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.route,
    routes: [
      GoRoute(
        path: SplashScreen.route,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingPage.route,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: GuestLoadingPage.route,
        builder: (context, state) => const GuestLoadingPage(),
      ),
      GoRoute(
        path: LoginPage.route,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.route,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.route,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: ChangePasswordPage.route,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: HomePage.route,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: ClassPage.route,
        name: 'classroom',
        builder: (context, state) => const ClassPage(),
      ),
    ],
  );
}
