import 'package:go_router/go_router.dart';

// Import all screens
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/otp_verification_screen.dart';
import '../../presentation/screens/main/main_tab_container.dart';
import '../../presentation/screens/laundry/service_detail_screen.dart';
import '../../presentation/screens/laundry/cart_screen.dart';
import '../../presentation/screens/laundry/payment_screen.dart';
import '../../presentation/screens/extra/promo_list_screen.dart';
import '../../presentation/screens/extra/notification_screen.dart';
import '../../presentation/screens/extra/help_center_screen.dart';
import '../../presentation/screens/extra/settings_screen.dart';
import '../../presentation/screens/extra/success_screen.dart';
import '../../presentation/screens/extra/payment_failed_screen.dart';
import '../../presentation/screens/extra/no_internet_screen.dart';
import '../../presentation/screens/extra/error_state_screen.dart';
import '../../presentation/screens/extra/not_found_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpVerificationScreen(extraData: extra);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) {
          final tabStr = state.uri.queryParameters['tab'];
          final initialTab = tabStr != null ? int.tryParse(tabStr) ?? 0 : 0;
          return MainTabContainer(initialTab: initialTab);
        },
      ),
      GoRoute(
        path: '/service-detail',
        builder: (context, state) => const ServiceDetailScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/promo',
        builder: (context, state) => const PromoListScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'payment_success';
          final orderId = state.uri.queryParameters['orderId'];
          return SuccessScreen(type: type, orderId: orderId);
        },
      ),
      GoRoute(
        path: '/failed',
        builder: (context, state) => const PaymentFailedScreen(),
      ),
      GoRoute(
        path: '/offline',
        builder: (context, state) => const NoInternetScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => const ErrorStateScreen(),
      ),
    ],
  );
}
