import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/widgets/parents_widget/parent_round_button.dart';
import 'package:for_children/widgets/toasts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';
import '../screens/login_screens/auth_screen.dart';
import '../screens/login_screens/login_screen.dart';
import '../widgets/kids_widgets/kid_button_widget.dart';
import '../widgets/kids_widgets/kid_round_button.dart';
import '../widgets/language.dart';
import '../widgets/parents_widget/parent_button_widget.dart';
import 'kid_provider.dart';

class LoginProvider with ChangeNotifier {

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  GlobalKey<FormState> resetPasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  PageController onboardingController = PageController();

  String role = '';
  bool isPasswordVisible = false;
  bool isSignUpPasswordVisible = false;
  String selectedLanguage = 'English - UK';
  bool isLoading = false;
  bool selectRightInfo = false;
  bool selectLeftInfo = false;
  bool registerInfo = false;

  void switchSelectRightInfo(){
    selectRightInfo = !selectRightInfo;
    notifyListeners();
  }

  void switchSelectLeftInfo(){
    selectLeftInfo = !selectLeftInfo;
    notifyListeners();
  }

  void switchRegisterInfo(){
    registerInfo = !registerInfo;
    notifyListeners();
  }

  Future logIn() async{
    try{
      await Supabase.instance.client.auth.signInWithPassword(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim()
      );
    }catch (e){
      sadToast('noUser');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text.trim().toLowerCase());
  }

  Future logOut(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final kidsData = Provider.of<KidProvider>(context, listen: false);
    prefs.remove('email');
    emailController.clear();
    passwordController.clear();
    role = '';
    nameController.clear();
    surnameController.clear();
    resetPasswordController.clear();
    kidsData.selectedRoute = Icons.home;
    Supabase.instance.client.auth.signOut().then((v) =>
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const AuthScreen()))
    );
  }

  Future toLoginScreen(context){
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: size.height * 0.3,
            width: size.width,
            margin: const EdgeInsets.only(bottom: 300),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 32,),
                      Text('areYouSure'.tr(), style: kTextStyle,),
                      role == 'child'
                        ? KidRoundButton(
                          onTap: () => Navigator.pop(context),
                          icon: Icons.clear,)
                        : ParentRoundButton(
                            onTap: () => Navigator.pop(context),
                            icon: Icons.clear)
                    ],
                  ),
                  Text('quitRegistrationDescription'.tr(), style: kTextStyle,),
                  role == 'child'
                    ? KidButtonWidget(
                      onTap: () {
                        role = '';
                        emailController.clear();
                        passwordController.clear();
                        nameController.clear();
                        surnameController.clear();
                        resetPasswordController.clear();
                        onboardingController.dispose();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                            const LoginScreen()));
                      },
                      text: 'yesExit')
                    : ParentButtonWidget(
                        onTap: () {
                          role = '';
                          emailController.clear();
                          passwordController.clear();
                          nameController.clear();
                          surnameController.clear();
                          resetPasswordController.clear();
                          onboardingController.dispose();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const LoginScreen()));
                        },
                        text: 'yesExit'),
                ],
              ),
            ),
          );
        });
  }

  Future signUp(context) async{
    isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );
      await Supabase.instance.client.from('users').insert({
        'id': Supabase.instance.client.auth.currentUser!.id,
        'kid0': '',
        'kid0Accept': false,
        'kid1': '',
        'kid1Accept': false,
        'kid2': '',
        'kid2Accept': false,
        'kid3': '',
        'kid3Accept': false,
        'kid4': '',
        'kid4Accept': false,
        'kid5': '',
        'kid5Accept': false,
        'name': nameController.text.trim(),
        'surName': surnameController.text.trim(),
        'role': role,
        'time': DateTime.now().toString(),
        'dayStart': '06:00:00',
        'dayEnd': '22:00:00',
        'email': emailController.text.trim().toLowerCase()
      });
      successSighUp(context);
    }catch(e){
      if(e.toString().contains('Password should be at least 6 characters')){
        sadToast('weakPassword');
      }else if(e.toString().contains('User already registered')){
        sadToast('alreadyTaken');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future resetPassword(context) async {
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
                color: kWhite,
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
                    ParentButtonWidget(
                        onTap: () async{
                          try {
                            await Supabase.instance.client.auth.resetPasswordForEmail(
                              resetPasswordController.text.trim(),
                              redirectTo: 'forkids://reset-hasla',
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('link wysłany')),);
                              Navigator.pop(context);
                            }
                          } catch (e) {
                           log('reset password error: $e');
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

  Future<bool> updatePassword(String newPassword) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      await Supabase.instance.client.auth.signOut();
      return true;
    } catch (e) {
      log("Error updating password: $e");
      return false;
    }
  }

  Future<void> successSighUp(context)async {
    Size size = MediaQuery.sizeOf(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () => logOut(context),
            child: Container(
                height: size.height * 0.2,
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(bottom: 300),
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset('assets/images/cat.png'),
                    ),
                    Expanded(child: Text('canUseAccount'.tr(), style: kTextStyle)),
                  ],
                )
            ),
          );
        });
  }


  void switchPasswordVisibility(){
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void switchSignUpPasswordVisibility(){
    isSignUpPasswordVisible = !isSignUpPasswordVisible;
    notifyListeners();
  }

  void selectRole(String r){
    role = r;
    selectRightInfo = false;
    selectLeftInfo = false;
    notifyListeners();
  }

  void setLanguage(Language value, context){
    selectedLanguage = value.toString();
    notifyListeners();
  }

}