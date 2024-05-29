import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'main_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'key',
          appId: '1:403074544562:android:929551b8a32e0cb42faaab',
          messagingSenderId: 'sendid',
          projectId: 'forkids-6f5ab',
          storageBucket: 'forkids-6f5ab.appspot.com',
    ));
  await EasyLocalization.ensureInitialized();
  runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pl', 'PL'),
          Locale('ru', 'RU'),],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MainProvider>(create: (_) => MainProvider()),
        ],
        builder: (context, child) {
          return ScreenUtilInit(
            designSize: const Size(720, 1560),
            builder: (_, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const MainScreen(),
            ),
          );
        }
    );
  }
}

