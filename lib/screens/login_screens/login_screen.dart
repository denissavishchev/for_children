import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/login_screens/select_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/login_provider.dart';
import '../../widgets/language_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<LoginProvider>(
            builder: (context, data, _){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Row(
                          children: [
                            Spacer(),
                            LanguageWidget(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(
                            height: 250,
                            child: Image.asset('assets/images/login.png'),),
                          Expanded(child: Text('hello'.tr(),
                            style: kTextStyle,
                              textAlign: TextAlign.justify)),
                          const SizedBox(width: 12,)
                        ],
                      ),
                      const SizedBox(height: 50,),
                      Form(
                        key: data.loginKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: data.emailController,
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
                            const SizedBox(height: 18,),
                            TextFormField(
                              controller: data.passwordController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: kDarkGrey,
                              obscureText: !data.isPasswordVisible,
                              decoration: textFieldDecoration.copyWith(
                                  label: Text('password'.tr(),),
                                  suffixIcon: IconButton(
                                    onPressed: () => data.switchPasswordVisibility(),
                                    icon: Icon(data.isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility))),
                              maxLength: 64,
                              validator: (value){
                                if(value == null || value.isEmpty) {
                                  return 'thisFieldCannotBeEmpty'.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.15,),
                            ButtonWidget(
                                onTap: () => data.logIn(),
                                text: 'login'
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () => data.resetPassword(context),
                                    child: Text('forgotPassword'.tr())),
                                GestureDetector(
                                    onTap: () {
                                      data.emailController.clear();
                                      data.passwordController.clear();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) =>
                                          const SelectScreen()));
                                    },
                                    child: Text('createAccount'.tr())),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.viewInsetsOf(context).bottom == 0
                                  ? size.height * 0.05 : size.height * 0.4,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}
