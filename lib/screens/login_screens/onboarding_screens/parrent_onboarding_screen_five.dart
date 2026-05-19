import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/parent_provider.dart';
import '../../../widgets/parents_widget/parent_button_widget.dart';


class ParentOnboardingScreenFive extends StatelessWidget {
  const ParentOnboardingScreenFive({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _one(context),
                    _two(context),
                    _three(context),
                    Align(
                      alignment: Alignment.center,
                      child: ParentButtonWidget(
                          onTap: (){},
                          text: 'add'
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
                Positioned(
                    right: 0,
                    top: 40,
                    child: Image.asset('assets/images/onboardingParent13.png', width: 200,)
                ),
              ],
            ),
          ),
        )
    );
  }

  Container _one(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.08,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/line.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              kOrange.withValues(alpha: 0.15),
              BlendMode.srcIn,
            ),
          ),
          gradient: LinearGradient(
              colors: [
                kDarkWhite,
                kDarkWhite.withValues(alpha: 0.1),
              ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
            BoxShadow(
              color: kWhite,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(-2, -2),
            )
          ]
      ),
      child: Center(
        child: Text('createFirstTask'.tr(),
          style: kTextStyle.copyWith(fontSize: 42.sp),),
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              kWhite.withValues(alpha: 0.2),
              kWhite.withValues(alpha: 0.2),
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: kDarkWhite, width: 1),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('itWillTakeLessThan30Seconds'.tr(),style: kTextStyle,),
          Text('childWillBeAble'.tr(),style: kTextStyle,),
          Column(
            spacing: 4,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('seeTheTask'.tr(), style: kTextStyleNormal,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('offerYourPrice'.tr(), style: kTextStyleNormal,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('completeAndReceiveReward'.tr(), style: kTextStyleNormal,)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Container _three(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kOrange.withValues(alpha: 0.2),
              kDarkWhite.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: kDarkWhite, width: 1),
      ),
      child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Column(
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: kWhite.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: kDarkWhite, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: kGrey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(2, 2),
                        )
                      ]
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      TaskButtonWidget(isSingle: true,),
                      TaskButtonWidget(isSingle: false,),
                    ],
                  ),
                ),
                const SizedBox(height: 2,),
                TextFormField(
                  controller: data.addTaskNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: kDarkGrey,
                  decoration: textFieldDecorationOnboarding.copyWith(
                      label: Text('task'.tr(),)),
                  maxLength: 64,
                  validator: (value){
                    if(value == null || value.isEmpty) {
                      return 'thisFieldCannotBeEmpty'.tr();
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: data.addTaskDescriptionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  cursorColor: kDarkGrey,
                  decoration: textFieldDecorationOnboarding.copyWith(
                      label: Text('description'.tr(),)),
                  maxLength: 256,
                ),
                TextFormField(
                  controller: data.addTaskPriceController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  cursorColor: kDarkGrey,
                  maxLength: 128,
                  decoration: textFieldDecorationOnboarding.copyWith(
                    label: Text('price'.tr()),
                    prefixIcon: Icon(Icons.star, color: kOrange),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down, color: kDarkGrey),
                      onSelected: (String value) {
                        data.addTaskPriceController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          'toy',
                          'videoGame',
                          'sweet',
                          'cinema',
                          'boardGame',
                        ].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice.tr(),
                            child: Text(choice.tr()),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                _four(context)
              ],
            );
          }
      )
    );
  }

  Container _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kDarkWhite.withValues(alpha: 0.2),
              Colors.transparent
            ]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('youCanAlwaysChangePriceOrNegotiate'.tr(),
        style: kTextStyle,
        textAlign: TextAlign.center,),
    );
  }

}

class TaskButtonWidget extends StatelessWidget {
  const TaskButtonWidget({
    super.key, required this.isSingle,
  });

  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Expanded(
              child: GestureDetector(
                onTap: () => data.isSingleTaskSwitch(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            data.isSingleTask == isSingle ? kOrange.withValues(alpha: 0.6) : kDarkWhite.withValues(alpha: 0.6),
                            data.isSingleTask == isSingle ? kOrange.withValues(alpha: 0.5) : kDarkWhite.withValues(alpha: 0.5),
                            data.isSingleTask == isSingle ? kOrange.withValues(alpha: 0.2) : kDarkWhite.withValues(alpha: 0.2),
                          ]
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: kGrey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        )
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16,),
                      Text(isSingle ? 'single'.tr() : 'multi'.tr(),
                        style: data.isSingleTask != isSingle ? kTextStyleNormal : kTextStyleNormal.copyWith(color: kDarkWhite),
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  data.isSingleTask == isSingle ? kOrange.withValues(alpha: 0.4) : kDarkWhite.withValues(alpha: 0.4),
                                  data.isSingleTask == isSingle ? kOrange.withValues(alpha: 0.7) : kDarkWhite.withValues(alpha: 0.7),
                                ]
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: kDarkWhite, width: 0.3),
                            boxShadow: [
                              BoxShadow(
                                color: kDarkWhite.withValues(alpha: 0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              )
                            ]
                        ),
                      )
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}
