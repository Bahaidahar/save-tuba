import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/guest_loading_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/main/presentation/pages/home_page.dart';
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
        path: HomePage.route,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
