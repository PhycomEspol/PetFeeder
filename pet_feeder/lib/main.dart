import 'package:flutter/material.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.theme,
    );
  }
}
