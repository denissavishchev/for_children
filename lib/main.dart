import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/login_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/parent_provider.dart';
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await EasyLocalization.ensureInitialized();
  runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pl', 'PL'),
          Locale('ru', 'RU'),],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<ParentProvider>(create: (_) => ParentProvider()),
              ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
            ],
            builder: (context, child) {
              return ScreenUtilInit(
                designSize: const Size(720, 1560),
                builder: (_, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  home: prefs.getString('email') == null
                    ? const LoginScreen()
                    : const MainScreen(),
                ),
              );
            }
        )));
}



