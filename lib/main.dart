import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'main_provider.dart';

void main() {
  runApp(const MyApp());
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
            builder: (_, child) => const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MainScreen(),
            ),
          );
        }
    );
  }
}

