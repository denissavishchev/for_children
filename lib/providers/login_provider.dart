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
  String selectedLanguage = 'English - UK';
  bool isLoading = false;

  Future logIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text.trim());
  }

  Future logOut(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    emailController.clear();
    passwordController.clear();
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
        const LoginScreen()));
  }

  Future signUp(context) async{
    isLoading = true;
    notifyListeners();
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
      'time' : DateTime.now().toString()
    });
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    role = '';
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    surnameController.clear();
    resetPasswordController.clear();
    logOut(context).then((v) => successSighUp(context));
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
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.clear), color: kBlue,),
                    ),
                  ),
                ],
              )
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

  void setLanguage(Language value, context){
    selectedLanguage = value.toString();
    notifyListeners();
  }

}