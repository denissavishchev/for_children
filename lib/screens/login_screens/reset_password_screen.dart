import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/login_screens/login_screen.dart';
import 'package:for_children/widgets/parents_widget/parent_round_button.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/login_provider.dart';
import '../../widgets/parents_widget/parent_button_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Spacer(),
                            ParentRoundButton(
                                onTap: () => data.logOut(context),
                                icon: Icons.close
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset('assets/images/newPassword.png'),),
                      Text('setNewPasswordDescription'.tr(), style: kBigTextStyle, textAlign: TextAlign.center,),
                      const SizedBox(height: 2,),
                      Form(
                        key: data.resetPasswordKey,
                        child: Column(
                          children: [
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
                                onTap: () async {
                                  if (data.resetPasswordKey.currentState!.validate()) {
                                    bool success = await data.updatePassword(data.passwordController.text);
                                    if (success && context.mounted) {
                                      data.passwordController.clear();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                                            (route) => false,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('passwordUpdatedSuccess'.tr())),
                                      );
                                    }
                                  }
                                },
                                text: 'ok'
                            ),
                            const SizedBox(height: 32,),
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
