import 'package:device_preview/device_preview.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_feeder/config/util/constants.dart';
import 'package:pet_feeder/config/util/methods.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate();

  dispensers = await retrieveDispensers();

  runApp(
    const MainApp(),
    /*DevicePreview(
      builder: (_) => const MainApp(),
      enabled: !kReleaseMode,
    ),*/
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.theme,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Pet Feeder',
    );
  }
}
