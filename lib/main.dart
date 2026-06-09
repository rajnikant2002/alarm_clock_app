import 'package:alarm_clock_app/firebase_options.dart';
import 'package:alarm_clock_app/providers/alarm_provider.dart';
import 'package:alarm_clock_app/providers/auth_provider.dart';
import 'package:alarm_clock_app/screens/home_screen.dart';
import 'package:alarm_clock_app/screens/login_screen.dart';
import 'package:alarm_clock_app/services/firebase_service.dart';
import 'package:alarm_clock_app/services/local_storage_service.dart';
import 'package:alarm_clock_app/services/notification_service.dart';
import 'package:alarm_clock_app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.initialize();
  runApp(const AlarmClockApp());
}

class AlarmClockApp extends StatelessWidget {
  const AlarmClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final localStorageService = LocalStorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(firebaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => AlarmProvider(
            firebaseService,
            localStorageService,
            NotificationService.instance,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Alarm Clock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    return isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
