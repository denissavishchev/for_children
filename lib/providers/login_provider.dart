import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:for_children/widgets/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../screens/login_screens/auth_screen.dart';
import '../screens/login_screens/login_screen.dart';
import '../widgets/language.dart';

enum Onboard{
  basic,
  advanced,
  none
}

Onboard selectedOnboard = Onboard.basic;

class LoginProvider with ChangeNotifier {

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
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

  void changeOnboard(Onboard onboard){
    selectedOnboard = onboard;
    notifyListeners();
  }

  Future logIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    }catch (e){
      sadToast('noUser');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text.trim());
  }

  Future logOut(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    emailController.clear();
    passwordController.clear();
    role = '';
    nameController.clear();
    surnameController.clear();
    resetPasswordController.clear();
    FirebaseAuth.instance.signOut().then((v) =>
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const AuthScreen()))
    );
  }

  void toLoginScreen(context){
    role = '';
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    surnameController.clear();
    resetPasswordController.clear();
    selectedOnboard = Onboard.basic;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const LoginScreen()));
  }

  Future signUp(context) async{
    isLoading = true;
    notifyListeners();
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(emailController.text.trim()).set({
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
        'time' : DateTime.now().toString(),
        'dayStart' : '06:00',
        'dayEnd' : '22:00'
      });
      successSighUp(context);
    }catch(e){
      if(e.toString().contains('Password should be at least 6 characters')){
        sadToast('weakPassword');
      }else if(e.toString().contains('The email address is already in use by another account')){
        sadToast('alreadyTaken');
      }
    }
    isLoading = false;
    notifyListeners();
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
                          }on FirebaseAuthException {
                            sadToast('noEmail');
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
                  color: kGrey,
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