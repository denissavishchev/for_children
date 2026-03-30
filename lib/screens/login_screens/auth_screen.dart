import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/login_screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return const Text('Błąd Supabase!');
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if(session != null){
            return const MainScreen();
          }else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}