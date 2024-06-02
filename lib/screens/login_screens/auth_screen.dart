import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/login_screens/login_screen.dart';
import 'package:for_children/screens/parent_screens/main_parent_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const MainScreen();
          }else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}