import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {

  String role = '';

  void selectRole(String r){
    role = r;
    notifyListeners();
  }

}