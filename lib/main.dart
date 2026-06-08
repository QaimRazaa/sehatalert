import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import 'package:sehatalert/utils/device/responsive_size.dart';
import 'auth_wrapper.dart';
import 'data/repository/authentication/authentication_repository.dart';
import 'data/repository/medicine/medicine_repository.dart';
import 'data/services/notification/notification_service.dart';
import 'firebase_options.dart';

import 'package:sehatalert/core/shared_pref/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();
  _rescheduleRemindersIfLoggedIn();

  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

void _rescheduleRemindersIfLoggedIn() async {
  final auth = AuthRepository();
  if (!auth.isAuthenticated) return;
  try {
    final medicines = await MedicineRepository().getUserMedicines(
      auth.currentUserId,
    );
    await NotificationService().rescheduleAllReminders(medicines);
  } catch (_) {}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = SharedPreferencesService();
    final langCode = await prefs.getLocale();
    if (langCode != null) {
      setState(() {
        _locale = Locale(langCode);
      });
    }
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
    final prefs = SharedPreferencesService();
    prefs.saveLocale(newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sehat Alert',
      locale: _locale ?? DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: Builder(
        builder: (context) {
          ResponsiveSize.init(context);
          return const AuthenticationWrapper();
        },
      ),
    );
  }
}
