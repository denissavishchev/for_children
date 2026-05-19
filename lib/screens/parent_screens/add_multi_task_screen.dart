import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/parents_widget/exp_widget.dart';
import '../../widgets/parents_widget/parent_button_widget.dart';
import '../../widgets/parents_widget/parent_round_button.dart';
import '../../widgets/parents_widget/select_task_type_widget.dart';

class AddMultiTaskScreen extends StatefulWidget {
  const AddMultiTaskScreen({super.key});

  @override
  State<AddMultiTaskScreen> createState() => _AddMultiTaskScreenState();
}

class _AddMultiTaskScreenState extends State<AddMultiTaskScreen> {

  @override
  void initState() {
    final data = Provider.of<ParentProvider>(context, listen: false);
    data.getKidsData();
    super.initState();
  }

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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              spacing: 12,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ParentRoundButton(
                                    onTap: () => data.showExitAddTaskDialog(context),
                                    icon: Icons.arrow_back_ios_new
                                ),
                                Expanded(child: Text('addTaskInfo'.tr(), style: kTextStyle,))
                              ],
                            ),
                          ),
                          Form(
                            key: data.taskKey,
                            child: Column(
                              spacing: 18,
                              children: [
                                SizedBox(
                                    width: size.width,
                                    height: data.kidsList.isEmpty ? null : 40.0 * (data.kidsList.length / 2).round(),
                                    child: FutureBuilder(
                                      future: data.getKid,
                                      builder: (context, snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Center(child: SpinKitSpinningLines(
                                            color: kBlue,
                                            size: 40,
                                          ),);
                                        }else{
                                          return data.kidsList.isEmpty
                                              ? Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: kBlue, width: 0.5),
                                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                                ),
                                                child: Text('noAddedKids'.tr(), style: kTextStyle, textAlign: TextAlign.center,),
                                              )
                                              : GridView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: data.kidsList.length,
                                            itemBuilder: (context, index){
                                              final isSelected = data.selectedKidName == data.kidsList[index].name;
                                              return data.kidsList[index].accept
                                                  ? GestureDetector(
                                                onTap: () => data.selectKid(data.kidsList[index].name, data.kidsList[index].email),
                                                child: Container(
                                                  width: size.width * 0.4,
                                                  margin: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: isSelected ? kDarkWhite : Colors.transparent,
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      border: Border.all(
                                                          width: isSelected ? 1 : 0.5,
                                                          color: isSelected ? kBlue : kDarkGrey),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kDarkGrey.withValues(alpha: 0.6),
                                                        ),
                                                        isSelected
                                                            ? BoxShadow(
                                                            color: kBlue.withValues(alpha: 0.1),
                                                            blurRadius: 1,
                                                            spreadRadius: 2,
                                                            offset: const Offset(1, 1))
                                                            : BoxShadow(
                                                            color: kWhite,
                                                            blurRadius: 2,
                                                            spreadRadius: -1,
                                                            offset: const Offset(0, 1)
                                                        )
                                                      ]
                                                  ),
                                                  child: Center(
                                                      child: Text(data.kidsList[index].name, style: kTextStyle,)),
                                                ),
                                              )
                                                  : Container(
                                                      width: size.width * 0.4,
                                                      margin: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: kDarkGrey.withValues(alpha: 0.3),
                                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      ),
                                                      child: Center(
                                                          child: Text('notConfirmed'.tr(args: [data.kidsList[index].name]), style: kTextStyle,)),
                                              );
                                            },
                                            gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisExtent: 40),);
                                        }
                                      },
                                    )
                                ),
                                Column(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        SelectTaskTypeWidget(width: 120,),
                                        Expanded(child: Text('taskTypeDescription'.tr(), style: kSmallTextStyle))
                                      ],
                                    ),
                                    Row(
                                      spacing: 8,
                                      children: [
                                        ExpWidget(count: 5, isSingle: false,),
                                        Expanded(child: Text('taskExpDescription'.tr(), style: kSmallTextStyle))
                                      ],
                                    )
                                  ],
                                ),
                                TextFormField(
                                  controller: data.addTaskNameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  cursorColor: kDarkGrey,
                                  decoration: textFieldDecoration.copyWith(
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
                                  decoration: textFieldDecoration.copyWith(
                                      label: Text('description'.tr(),)),
                                  maxLength: 256,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: data.addTaskPriceController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.multiline,
                                        cursorColor: kDarkGrey,
                                        decoration: textFieldDecoration.copyWith(
                                            label: Text('price'.tr(),)),
                                        maxLength: 64,
                                      ),
                                    ),
                                    Visibility(
                                      visible: data.selectedKidName != '',
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              data.showWishList(context, data),
                                          child: Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                border: Border.all(width: 0.8, color: kBlue),
                                                color: kWhite,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: kBlue.withValues(alpha: 0.3),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                      offset: const Offset(0, 2)
                                                  )
                                                ]
                                            ),
                                            child: const Icon(Icons.favorite_border_outlined, color: kBlue, size: 32,),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text('daysSliderDescription'.tr(), style: kTextStyle,),
                              Row(
                                children: [
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackShape: const RoundedRectSliderTrackShape(),
                                        overlayShape: SliderComponentShape.noOverlay,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Slider(
                                          divisions: 5,
                                          activeColor: kBlue,
                                          inactiveColor: kBlue.withValues(alpha: 0.2),
                                          thumbColor: kBlue,
                                          value: data.daySlider,
                                          onChanged: (v) => data.changeDaySlider(v),
                                          min: 5,
                                          max: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    spacing: 2,
                                    children: [
                                      Text(data.daySlider.toStringAsFixed(0), style: kTextStyle,),
                                      Text('days'.tr(), style: kTextStyle,),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              spacing: 12,
                              children: [
                                GestureDetector(
                                  onTap: () => data.isEdit ? null : data.pickAnImage(),
                                  child: Container(
                                    width: size.width * 0.4,
                                    height: size.width * 0.5,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kBlue, width: data.fileName == '' ? 2 : 0),
                                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                                    ),
                                    child: data.fileName == ''
                                        ? Icon(Icons.camera_alt, size: 80, color: kBlue.withValues(alpha: 0.8),)
                                        : ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        child: Image.file(File(data.file!.path), fit: BoxFit.cover,)),
                                  ),
                                ),
                                Expanded(child: Text('addPhotoDescription'.tr(), style: kTextStyle))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ParentButtonWidget(
                                onTap: () => data.isEdit
                                    ? data.editMultiTaskInBase(context, data.editDocId)
                                    : data.addMultiTaskToBase(context),
                                text: data.isEdit ? 'edit' : 'add'
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.viewInsetsOf(context).bottom == 0
                                ? size.height * 0.01 : size.height * 0.4,),
                        ],
                      ),
                    ),
                  ),
                  data.isLoading
                      ? Container(
                    width: size.width,
                    height: size.height,
                    color: kGrey.withValues(alpha: 0.3),
                    child: const Center(child: SpinKitSpinningLines(
                      color: kBlue,
                      size: 40,
                    ),),
                  ) : const SizedBox.shrink()
                ],
              );
            },
          )
      ),
    );
  }
}





