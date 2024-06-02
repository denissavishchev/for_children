import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginProvider with ChangeNotifier {

  GlobalKey loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  PageController onboardingController = PageController();

  String role = '';
  bool isPasswordVisible = false;

  Future signIn() async{
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

  Future signUp() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  Future resetPassword(context) {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: const BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text('typeYourEmail'.tr(), style: kTextStyle,),
                    const SizedBox(height: 36,),
                    TextFormField(
                      controller: resetPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: kDarkGrey,
                      decoration: textFieldDecoration.copyWith(
                          label: Text('email'.tr(),)),
                      maxLength: 64,
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return 'thisFieldCannotBeEmpty'.tr();
                        }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)){
                          return 'wrongEmail'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 36,),
                    ButtonWidget(
                        onTap: () async{
                          try{
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: resetPasswordController.text.trim());
                          }on FirebaseAuthException catch (e){
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    content: Text('${e.message}'),
                                  );
                                });
                          }
                        },
                        text: 'resetPassword'),
                    const Spacer(),
                  ],
                ),
              ),
          );
        });
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