import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/login_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/info_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: Consumer<LoginProvider>(
            builder: (context, data, _){
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: Image.asset(
                                data.role == 'parent'
                                    ? 'assets/images/registerParent.png'
                                    : 'assets/images/registerKid.png'),),
                          const SizedBox(height: 20,),
                          Form(
                            key: data.registerKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: data.nameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('name'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: data.surnameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('surname'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
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
                                  obscureText: !data.isSignUpPasswordVisible,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('password'.tr(),),
                                      suffixIcon: IconButton(
                                          onPressed: () => data.switchSignUpPasswordVisibility(),
                                          icon: Icon(data.isSignUpPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility))),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }else if(data.passwordController.text != data.confirmPasswordController.text){
                                      return 'passwordsMustBeTheSame'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18,),
                                TextFormField(
                                  controller: data.confirmPasswordController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  obscureText: !data.isSignUpPasswordVisible,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('confirmPassword'.tr(),),
                                      suffixIcon: IconButton(
                                          onPressed: () => data.switchSignUpPasswordVisibility(),
                                          icon: Icon(data.isSignUpPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility))),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }else if(data.passwordController.text != data.confirmPasswordController.text){
                                      return 'passwordsMustBeTheSame'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 36,),
                                ButtonWidget(
                                    onTap: () {
                                      if(data.registerKey.currentState!.validate()){
                                        data.signUp(context);
                                      }
                                    },
                                    text: 'register'
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
                  ),
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      width: size.width,
                      height: 40,
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                              onPressed: () => data.toLoginScreen(context),
                              icon: const Icon(Icons.clear, size: 34,))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 20,
                      child: InfoWidget(
                        info: data.registerInfo,
                        onTap: () => data.switchRegisterInfo(),
                        text: 'registerInfo',
                        height: 0.2,)),
                  data.isLoading
                      ? Container(
                          width: size.width,
                          height: size.height,
                          color: kGrey.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator(color: kBlue,),),
                        ) : const SizedBox.shrink()
                ],
              );
            },
          )
      ),
    );
  }
}
