import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {

  GlobalKey loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  PageController onboardingController = PageController();

  String role = '';
  bool isPasswordVisible = false;

  Future signIn() async{
    // UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailController.text.trim(),
    //     password: passwordController.text.trim());
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
  }

  Future signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    emailController.clear();
    passwordController.clear();
    FirebaseAuth.instance.signOut();
  }

  void switchPasswordVisibility(){
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void selectRole(String r){
    role = r;
    notifyListeners();
  }

}