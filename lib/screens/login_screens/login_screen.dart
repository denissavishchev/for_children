import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/screens/login_screens/select_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/login_provider.dart';
import '../../widgets/language_widget.dart';
import '../../widgets/parents_widget/parent_button_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<LoginProvider>(
            builder: (context, data, _){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    spacing: 12,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 12, top: 8),
                        child: Row(
                          children: [
                            Spacer(),
                            LanguageWidget(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Image.asset('assets/images/login.png'),),
                      Text('hello'.tr(), style: kBigTextStyle, textAlign: TextAlign.center,),
                      const SizedBox(height: 2,),
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
                            SizedBox(height: size.height * 0.075,),
                            ParentButtonWidget(
                                onTap: () => data.logIn(),
                                text: 'login'
                            ),
                            const SizedBox(height: 32,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () => data.resetPassword(context),
                                    child: Text('forgotPassword'.tr(),
                                      style: kTextStyle.copyWith(fontSize: 28.sp),)),
                                GestureDetector(
                                    onTap: () {
                                      data.emailController.clear();
                                      data.passwordController.clear();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) =>
                                          const SelectScreen()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(18),),
                                        border: Border.all(color: kBlue),
                                      ),
                                      child: Row(
                                        spacing: 4,
                                        children: [
                                          Text('createAccount'.tr(),
                                            style: kTextStyle.copyWith(fontSize: 28.sp),),
                                          Icon(Icons.arrow_forward_ios, color: kBlue, size: 14,)
                                        ],
                                      ),
                                    )),
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
