import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/screens/kid_screens/save_money_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/kid_round_button.dart';

class AddSaveMoneyScreen extends StatelessWidget {
  const AddSaveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      body: Consumer<KidProvider>(
        builder: (context, data, _){
          return SafeArea(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KidRoundButton(
                                  onTap: () => Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const SaveMoneyScreen())),
                                  icon: Icons.close
                              ),
                              Text('addYourNewSaving'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                              const SizedBox(width: 40,)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('someAdvicesBelow'.tr(), style: kTextStyle),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                color: kWhite,
                                border: Border.all(color: kDarkWhite, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                      color: kGrey.withValues(alpha: 0.5),
                                      spreadRadius: 7,
                                      blurRadius: 16,
                                      offset: const Offset(0, 8)
                                  )
                                ]
                            ),
                          child: Column(
                            spacing: 12,
                            children: [
                              GestureDetector(
                                onTap: () => data.pickAnImage(),
                                child: Container(
                                  width: size.width * 0.5,
                                  height: size.width * 0.6,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kDarkGrey, width: data.fileName == '' ? 2 : 0),
                                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: data.fileName == ''
                                      ? const Icon(Icons.camera_alt, size: 80, color: kDarkGrey,)
                                      : ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      child: Image.file(File(data.file!.path), fit: BoxFit.cover,)),
                                ),
                              ),
                              Form(
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
                                      maxLength: 128,
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
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(data.saveMoneyKey.currentState!.validate()){
                              data.saveSaveMoneyItem(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.7,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    kOrange,
                                    kRed,
                                    kPurple,
                                    kBlue,
                                    kDarkBlue
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [
                                    0.1, 0.4, 0.6, 0.8, 0.9
                                  ]
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: kOrange.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(-4, 0)
                                ),
                                BoxShadow(
                                    color: kDarkBlue.withValues(alpha: 0.25),
                                    blurRadius: 7,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 7)
                                )
                              ],
                              border: Border.all(color: kDarkWhite.withValues(alpha: 0.8), width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Text('add'.tr(), style: kBigTextStyleWhite.copyWith(fontSize: 44.sp)),
                          ),
                        ),
                        const SizedBox(height: 12,),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: kGrey, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('howToEarnAdviceTitle1'.tr(), style: kTextStyle),
                              Text('howToEarnAdvice1'.tr(), style: kTextStyle),
                              const SizedBox(height: 12,),
                              Text('howToEarnAdviceTitle2'.tr(), style: kTextStyle),
                              Text('howToEarnAdvice2'.tr(), style: kTextStyle),
                              const SizedBox(height: 12,),
                              Text('howToEarnAdviceTitle3'.tr(), style: kTextStyle),
                              Text('howToEarnAdvice3'.tr(), style: kTextStyle),
                              const SizedBox(height: 12,),
                              Text('howToEarnAdviceTitle4'.tr(), style: kTextStyle),
                              Text('howToEarnAdvice4'.tr(), style: kTextStyle),
                              const SizedBox(height: 12,),
                              Text('howToEarnAdviceTitle5'.tr(), style: kTextStyle),
                              Text('howToEarnAdvice5'.tr(), style: kTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.5),
                    child: const Center(child: SpinKitSpinningLines(
                      color: kBlue,
                      size: 40,
                    ),),
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
