import 'package:flutter/material.dart';
import 'package:for_children/screens/login_screens/login_screen.dart';
import 'package:for_children/screens/login_screens/reset_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred while authenticating'));
          }

          if (snapshot.hasData) {
            final session = snapshot.data!.session;
            final event = snapshot.data!.event;
            if (event == AuthChangeEvent.passwordRecovery) {
              return const ResetPasswordScreen();
            }
            if (session != null) {
              return const MainScreen();
            }
          }
          return const LoginScreen();
        },
      ),
    );
  }
}