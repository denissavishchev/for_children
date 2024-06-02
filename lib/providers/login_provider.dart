import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {

  GlobalKey loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  PageController onboardingController = PageController();

  String role = '';

  void selectRole(String r){
    role = r;
    notifyListeners();
  }

}