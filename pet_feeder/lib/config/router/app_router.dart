import 'package:go_router/go_router.dart';
import 'package:pet_feeder/view/views.dart';
import 'package:pet_feeder/view/widgets/router_scaffold.dart';

part 'app_pages.dart';

abstract class AppRouter {
  static final routes = [
    GoRoute(
      path: AppPages.login,
      builder: (context, state) => const LoginView(),
    ),
    ShellRoute(
      routes: [
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
      ],
      builder: (context, state, child) {
        return RouterScaffold(child: child);
      },
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
        id: state.extra.toString(),
      ),
    ),
  ];

  static final router = GoRouter(
    initialLocation: AppPages.login,
    routes: routes,
  );
}
