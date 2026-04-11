import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/info_widget.dart';
import 'ads_list_screen.dart';

class AddAdsScreen extends StatelessWidget {
  const AddAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<ParentProvider>(
            builder: (context, data, _){
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 18,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                      const AdsListScreen())),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: kBlue,
                                    size: 32,
                                  )),
                              const Spacer(),
                            ],
                          ),
                          Text('kid name ${data.selectedKidName}'),
                          Text('kid email ${data.selectedKidEmail}'),
                          Form(
                            key: data.adsKey,
                            child: Column(
                              spacing: 18,
                              children: [
                                TextFormField(
                                  controller: data.addTaskNameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('title'.tr(),)),
                                  onChanged: (value) => data.changeAdTexts(value, true),
                                  maxLength: 32,
                                  validator: (value){
                                    if(value == null || value.isEmpty) {
                                      return 'thisFieldCannotBeEmpty'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: data.addTaskDescriptionController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        cursorColor: kDarkGrey,
                                        decoration: textFieldDecoration.copyWith(
                                            label: Text('description'.tr(),)),
                                        onChanged: (value) => data.changeAdTexts(value, false),
                                        maxLength: 128,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: GestureDetector(
                                        onTap: () => data.getSmartAdDescription(context),
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: kDarkGrey,
                                          ),
                                          child: const Icon(Icons.psychology, color: kWhite, size: 44),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  divisions: 5,
                                  activeColor: kBlue,
                                  inactiveColor: kWhite,
                                  thumbColor: kBlue,
                                  value: data.daySlider,
                                  onChanged: (v) => data.changeDaySlider(v),
                                  min: 5,
                                  max: 30,
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    spacing: 2,
                                    children: [
                                      Text(data.daySlider.toStringAsFixed(0), style: kTextStyle,),
                                      Text('days'.tr(), style: kTextStyle,),
                                    ],
                                  ),
                                  Row(
                                    spacing: 2,
                                    children: [
                                      Text(data.getPriceFromDays(data.daySlider), style: kTextStyle,),
                                      Text('\$', style: kTextStyle,),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: size.width,
                            height: size.height * 0.2,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                              border: Border.all(color: kGrey, width: 1),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => data.pickAnImage(),
                                    child: Container(
                                      width: 100,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: kBlue.withValues(alpha: 0.3),
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      ),
                                      child: data.image(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 12,
                                    left: 12,
                                    child: SizedBox(
                                      width: size.width * 0.6,
                                      child: Text(data.addTaskNameController.text,
                                        style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                                    )
                                ),
                                Positioned(
                                    top: size.height * 0.1,
                                    left: 12,
                                    child: SizedBox(
                                      width: size.width * 0.6,
                                      child: Text(data.addTaskDescriptionController.text,
                                        style: kTextStyleNormal,),
                                    )
                                )
                              ],
                            ),
                          ),
                          ButtonWidget(
                            onTap: () => data.addAdToBase(context),
                            text: 'add',
                          ),
                          SizedBox(
                            height: MediaQuery.viewInsetsOf(context).bottom == 0
                                ? size.height * 0.05 : size.height * 0.4,),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 20,
                      child: InfoWidget(
                        info: data.addTaskInfo,
                        onTap: () => data.switchAddTaskInfo(),
                        text: 'addTaskInfo',
                        height: 0.2,)),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.3),
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





