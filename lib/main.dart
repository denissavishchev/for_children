import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/auth_screen.dart';
import 'package:for_children/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/parent_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAQB9hcPJENDcNq6taQlMRRMNWoIlKQaGU',
          appId: '1:403074544562:android:929551b8a32e0cb42faaab',
          messagingSenderId: 'sendid',
          projectId: 'forkids-6f5ab',
          storageBucket: 'forkids-6f5ab.appspot.com',
          authDomain: 'forkids-6f5ab.firebaseapp.com'
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
              ChangeNotifierProvider<KidProvider>(create: (_) => KidProvider()),
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
                    ? const AuthScreen()
                    : const MainScreen(),
                ),
              );
            }
        )));
}



