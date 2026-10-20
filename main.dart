import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/customer/screens/customer_shell_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService().initialize();

  FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: PalJewellersApp()));
}

class PalJewellersApp extends ConsumerWidget {
  const PalJewellersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Pal Jewellers',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      locale: activeLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pa', 'IN'),
        Locale('hi', 'IN'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const CustomerShellScreen(),
    );
  }
}