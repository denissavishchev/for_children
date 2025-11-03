import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/screens/kid_screens/save_money_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';

class AddSingleSaveMoneyScreen extends StatelessWidget {
  const AddSingleSaveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<KidProvider>(
        builder: (context, data, _){
          return Container(
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_money.png'),
                    fit: BoxFit.cover
                )
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const SaveMoneyScreen())),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: kWhite,
                                  size: 32,
                                )),
                            const Spacer(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => data.pickAnImage(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: size.width,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: kWhite.withValues(alpha: 0.3)
                            ),
                            child: data.fileName == ''
                                ? const Icon(Icons.camera_alt, size: 80, color: kWhite,)
                                : ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: Image.file(File(data.file!.path), fit: BoxFit.cover,)),
                          ),
                        ),
                        const SizedBox(height: 24,),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: kWhite.withValues(alpha: 0.8)
                          ),
                          child: Form(
                            key: data.saveMoneyKey,
                            child: Column(
                              spacing: 8,
                              children: [
                                TextFormField(
                                  controller: data.whatDoYoWantController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('whatDoYouWant'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: data.whatDoYoWantPriceController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('price'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: data.whyYouNeedThisController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('whyYouNeedThis'.tr(),)),
                                  maxLength: 64,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        ButtonWidget(
                          onTap: () => data.saveSaveMoneyItem(context),
                          text: 'add',
                        ),
                      ],
                    ),
                  ),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator(color: kBlue,),),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
