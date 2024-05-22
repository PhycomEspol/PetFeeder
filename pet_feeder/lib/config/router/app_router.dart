import 'package:go_router/go_router.dart';
import 'package:pet_feeder/view/views.dart';

part 'app_pages.dart';

abstract class AppRouter {
  static final routes = [
    GoRoute(
      path: AppPages.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppPages.home,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: AppPages.settings,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: AppPages.profile,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: AppPages.notifications,
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: AppPages.addDispenser,
      builder: (context, state) => const AddDispenserView(),
    ),
    GoRoute(
      path: AppPages.dispenser,
      builder: (context, state) => DispenserView(
        id: state.pathParameters['id']!,
      ),
    ),
  ];

  static final router = GoRouter(
    initialLocation: AppPages.login,
    routes: routes,
  );
}
